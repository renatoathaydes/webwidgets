import 'dart:html';

import '../widget.dart';

/// Button Widget.
class Button with Widget {
  final root = ButtonElement();

  Button(
      {String id,
      String text = '',
      Function(MouseEvent) onClick,
      List<String> classes = const []}) {
    this.classes.addAll(classes);
    if (id != null) {
      root.id = id;
    }
    root.text = text;
    if (onClick != null) {
      root.onClick.listen(onClick);
    }
  }
}
