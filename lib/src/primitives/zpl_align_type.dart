import 'package:flutter/material.dart';

enum ZplCrossAxisAlignment { start, center, end }

enum ZplMainAxisAlignment { start, center, end, spaceBetween, spaceAround }

enum ZplTextAlign {
  left,
  center,
  right,
  justified;

  TextAlign toFlutter() {
    switch (this) {
      case ZplTextAlign.left:
        return TextAlign.left;
      case ZplTextAlign.center:
        return TextAlign.center;
      case ZplTextAlign.right:
        return TextAlign.right;
      case ZplTextAlign.justified:
        return TextAlign.justify;
    }
  }

  String get command {
    switch (this) {
      case ZplTextAlign.left:
        return 'L';
      case ZplTextAlign.center:
        return 'C';
      case ZplTextAlign.right:
        return 'R';
      case ZplTextAlign.justified:
        return 'J';
    }
  }
}
