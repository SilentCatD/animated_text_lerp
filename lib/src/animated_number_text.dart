import 'package:flutter/material.dart';

typedef ValueFormatter<T extends num> = String Function(T value);

class AnimatedNumberText<T extends num> extends ImplicitlyAnimatedWidget {
  const AnimatedNumberText(
    this.data, {
    Key? key,
    this.formatter,
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

  final T data;
  final ValueFormatter<T>? formatter;
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
  ImplicitlyAnimatedWidgetState<AnimatedNumberText<T>> createState() {
    return _AnimatedNumberTextState();
  }
}

class _AnimatedNumberTextState<T extends num>
    extends AnimatedWidgetBaseState<AnimatedNumberText<T>> {
  Tween<T>? _numTween;
  late String _data;
  TextStyle? _style;
  TextStyleTween? _styleTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _numTween = visitor(_numTween, widget.data, (value) => _createTween(value))
        as Tween<T>?;
    _styleTween = visitor(_styleTween, widget.style,
            (dynamic value) => TextStyleTween(begin: value as TextStyle))
        as TextStyleTween?;
  }

  Tween<T> _createTween(T value) {
    if (value is int) {
      return IntTween(begin: value) as Tween<T>;
    }
    return Tween<double>(begin: value as double) as Tween<T>;
  }

  String _toStringFormatted(T? value) {
    value = value ?? widget.data;
    return widget.formatter?.call(value) ?? value.toString();
  }

  void _updateValues() {
    _data = _toStringFormatted(_numTween?.evaluate(animation));
    _style = _styleTween?.evaluate(animation);
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
