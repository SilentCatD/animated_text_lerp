import 'dart:math';

import 'package:flutter/material.dart';

/// Widget that show a [Text] widget, which will animate between
/// [AnimatedStringText.data]. Each character in the old [AnimatedStringText.data] and new
/// [AnimatedStringText.data] will animate to each other respectively.
class AnimatedStringText extends ImplicitlyAnimatedWidget {
  /// Create an [AnimatedStringText] widget. The property [data] and [duration]
  /// need to be specified. To view the meaning of all other properties, see
  /// [Text] and [ImplicitlyAnimatedWidget].
  const AnimatedStringText(
    this.data, {
    Key? key,
    Curve curve = Curves.linear,
    VoidCallback? onEnd,
    this.style,
    this.textScaler,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    required Duration duration,
  }) : super(
          key: key,
          duration: duration,
          curve: curve,
          onEnd: onEnd,
        );

  /// Current value of this widget.
  final String data;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  ///
  /// If this is null [TextStyle.overflow] will be used, otherwise the value
  /// from the nearest [DefaultTextStyle] ancestor will be used.
  final TextOverflow? overflow;

  /// An optional maximum number of lines for the text to span, wrapping if necessary.
  /// If the text exceeds the given number of lines, it will be truncated according
  /// to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  ///
  /// If this is null, but there is an ambient [DefaultTextStyle] that specifies
  /// an explicit number for its [DefaultTextStyle.maxLines], then the
  /// [DefaultTextStyle] value will take precedence. You can use a [RichText]
  /// widget directly to entirely override the [DefaultTextStyle].
  final int? maxLines;

  /// {@macro flutter.widgets.Text.semanticsLabel}
  final String? semanticsLabel;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro dart.ui.textHeightBehavior}
  final TextHeightBehavior? textHeightBehavior;

  /// The color to use when painting the selection.
  ///
  /// This is ignored if [SelectionContainer.maybeOf] returns null
  /// in the [BuildContext] of the [Text] widget.
  ///
  /// If null, the ambient [DefaultSelectionStyle] is used (if any); failing
  /// that, the selection color defaults to [DefaultSelectionStyle.defaultColor]
  /// (semi-transparent grey).
  final Color? selectionColor;

  /// {@macro flutter.painting.textPainter.textScaler}
  final TextScaler? textScaler;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() {
    return _AnimatedTextState();
  }
}

class _AnimatedTextState extends AnimatedWidgetBaseState<AnimatedStringText> {
  final Map<int, IntTween?> _tween = {};
  late String _data;
  String? _oldData;
  TextStyle? _style;
  TextStyleTween? _styleTween;

  int get emptyCodeUnit => " ".codeUnits[0];

  void _updateValues() {
    _style = _styleTween?.evaluate(animation);
    if (_oldData == null) {
      _data = widget.data.toString();
      return;
    }
    StringBuffer result = StringBuffer();
    for (int i = 0; i < _tween.length; i++) {
      result.writeCharCode(_tween[i]?.evaluate(animation) ?? emptyCodeUnit);
    }
    _data = result.toString();
  }

  @override
  void initState() {
    super.initState();
    controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.completed:
          if (mounted) {
            setState(() {
              _data = widget.data;
              _oldData = _data;
              final tweenLength = _tween.length;
              for (int i = _data.length; i < tweenLength; i++) {
                _tween.remove(i);
              }
            });
          }
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.forward:
        case AnimationStatus.reverse:
          break;
      }
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedStringText oldWidget) {
    if (oldWidget.data != widget.data) {
      _oldData = oldWidget.data;
    }
    super.didUpdateWidget(oldWidget);
  }

  int get length {
    int length = max(widget.data.length, oldDataLength);
    return length;
  }

  int get oldDataLength => _oldData?.length ?? 0;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _styleTween = visitor(_styleTween, widget.style,
            (dynamic value) => TextStyleTween(begin: value as TextStyle))
        as TextStyleTween?;
    if (_oldData == null) {
      for (int i = 0; i < widget.data.length; i++) {
        _tween[i] = visitor(_tween[i], widget.data.codeUnitAt(i),
            (value) => IntTween(begin: value)) as IntTween?;
      }
      return;
    }
    for (int i = 0; i < length; i++) {
      if (i < oldDataLength && i < widget.data.length) {
        _tween[i] = visitor(_tween[i], widget.data.codeUnitAt(i),
            (value) => IntTween(begin: value)) as IntTween?;
      } else if (i > oldDataLength - 1) {
        _tween[i] = visitor(
            IntTween(
              begin: emptyCodeUnit,
              end: emptyCodeUnit,
            ),
            widget.data.codeUnitAt(i),
            (value) => IntTween(begin: value)) as IntTween?;
      } else if (i > widget.data.length - 1) {
        _tween[i] =
            visitor(_tween[i], emptyCodeUnit, (value) => IntTween(begin: value))
                as IntTween?;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateValues();
    return Text(
      _data,
      style: _style,
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textDirection: widget.textDirection,
      locale: widget.locale,
      softWrap: widget.softWrap,
      overflow: widget.overflow,
      textHeightBehavior: widget.textHeightBehavior,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      selectionColor: widget.selectionColor,
      textScaler: widget.textScaler,
    );
  }
}
