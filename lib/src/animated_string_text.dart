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
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
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

  final String data;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;
  final TextWidthBasis? textWidthBasis;
  final TextHeightBehavior? textHeightBehavior;
  final Color? selectionColor;

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
      textScaleFactor: widget.textScaleFactor,
      textHeightBehavior: widget.textHeightBehavior,
      maxLines: widget.maxLines,
      semanticsLabel: widget.semanticsLabel,
      textWidthBasis: widget.textWidthBasis,
      selectionColor: widget.selectionColor,
    );
  }
}
