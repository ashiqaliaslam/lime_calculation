import 'package:flutter/material.dart';

/// [Text Styles]
class TextStyles {
  static const TextStyle small = TextStyle(
    fontSize: 14,
  );
  static const TextStyle medium = TextStyle(
    fontSize: 16,
  );
  static const TextStyle large = TextStyle(
    fontSize: 22,
  );
  static const TextStyle largeBold = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle error = TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const TextStyle largeError = TextStyle(
    color: Colors.red,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
}

/// Text Styles Widgets
Widget smallText(String text) {
  return Text(text, style: TextStyles.small, softWrap: true);
}

Widget mediumText(String text) {
  return Text(text, style: TextStyles.medium, softWrap: true);
}

Widget largeText(String text) {
  return Text(text, style: TextStyles.large, softWrap: true);
}

Widget largeBoldText(String text) {
  return Text(text, style: TextStyles.largeBold, softWrap: true);
}

Widget largeErrorText(String text) {
  return Text(text, style: TextStyles.largeError, softWrap: true);
}

Widget errorText(String text) {
  return Text(
    text,
    style: TextStyles.error,
    textAlign: TextAlign.center,
    softWrap: true,
  );
}
