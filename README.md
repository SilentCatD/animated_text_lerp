<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Simple widgets to animate between number or string text. Useful for number increase/decrease 
animation, currency value animation or string content changing animation.

## Features

- Similar to a simple Text widget.
- Animating between number (int or double) with AnimatedNumberText.
- Animating between string, with will lerp each character respectively with AnimatedText.
- TextStyle animation supported.
- Think of Flutter's pre-built animated widget like AnimatedOpacity, AnimatedAlign, ..., 
but with text.

## Getting started

- First import it:

```dart
import 'package:animated_text_lerp/animated_text_lerp.dart';
```

## Usage

# AnimatedNumberText

![](https://github.com/SilentCatD/animated_text/blob/main/assets/animated_number_text.gif)

The widget support lerping between number values. Just setState with the current value and the 
widget will start animating to it.

```dart
AnimatedNumberText(
  value, // int or double
  curve: Curves.easeIn,
  duration: const Duration(seconds: 1),
  style: const TextStyle(fontSize: 30),
  formatter: (value) {
    final formatted =
    intl.NumberFormat.currency(locale: "en").format(value);
    return formatted;
  },
)
```

# AnimatedStringText

![](https://github.com/SilentCatD/animated_text/blob/main/assets/animated_text.gif)

The widget support lerping between string values. Just setState with the current value and the 
widget will start animating to it. Each character will lerp to the new corresponding one 
respectively.

```dart
AnimatedStringText(
  value, // string
  curve: Curves.easeIn,
  duration: const Duration(seconds: 1),
  style: const TextStyle(fontSize: 30),
)
```