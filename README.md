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

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

- Similar to a simple Text widget.
- Animating between number (int or double) with AnimatedNumberText.
- Animating between string, with will lerp each character respectively with AnimatedText.
- TextStyle animation supported.
- Think of Flutter's built-int animated widget, but with text.

## Getting started

- First import it:

```dart
import 'package:animated_text/animated_text.dart';
```

## Usage

### AnimatedNumberText

![](https://github.com/SilentCatD/animated_text/blob/main/assets/animated_number_text.gif)


The widget support lerping between number values. Just setState with the current value and the 
widget will start animating to it.

```dart
AnimatedNumberText(
  value,
  curve: Curves.easeIn,
  duration: const Duration(seconds: 1),
  style: const TextStyle(fontSize: 30),
  formatter: (value) {
    final format =
    intl.NumberFormat.currency(locale: "en").format(value);
  return format;
  },
)
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
