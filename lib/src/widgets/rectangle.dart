import 'dart:html';

import '../widget.dart';

/// A Rectangle Widget.
class Rectangle with Widget {
  final root = DivElement()..style.position = 'relative';

  Rectangle(
      {String width = '100px',
      String height = '50px',
      String top = '0',
      String left = '0',
      String fill = 'white',
      String border = 'solid black 1px',
      List<String> classes = const []}) {
    this.classes.addAll(classes);

    root.style
      ..width = width
      ..height = height
      ..backgroundColor = fill
      ..border = border
      ..top = top
      ..left = left;
  }

  /// Create a square.
  Rectangle.square(
      {String size = '100px',
      String top = '0',
      String left = '0',
      String fill = 'white',
      String border = 'solid black 1px'}) {
    root.style
      ..width = size
      ..height = size
      ..backgroundColor = fill
      ..border = border
      ..top = top
      ..left = left;
  }
}
