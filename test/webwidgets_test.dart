@TestOn('browser')
import 'dart:html';

import 'package:test/test.dart';
import 'package:webwidgets/basic_widgets.dart';

main() async {
  group('Simple Widget', () {
    TextBox textBox;
    setUp(() {
      textBox = TextBox()
        ..root.id = 'hello'
        ..text = 'Hey there'
        ..appendTo(querySelector('#output'), useShadowDom: false);
    });

    test('can be added to a HTML document, then removed', () {
      var helloEl = document.getElementById(textBox.root.id);
      expect(helloEl, isA<DivElement>());
      expect(helloEl.text, equals('Hey there'));

      textBox.removeFromDom();

      helloEl = document.getElementById(textBox.root.id);
      expect(helloEl, isNull);
    });
  });

  group('ContainerWidget', () {
    ContainerWidget container;
    setUp(() {
      container = ContainerWidget(children: [
        TextBox()
          ..root.id = 'hello'
          ..text = 'First child',
        TextBox()
          ..root.id = 'bye'
          ..text = 'Second child'
      ])
        ..root.id = 'container-element'
        ..appendTo(querySelector('#output'), useShadowDom: false);
    });

    test('can be added to a HTML document, then removed', () {
      var contEl = document.getElementById(container.root.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(2));

      final Widget firstChild = container[0];
      final Widget secondChild = container[1];

      expect(firstChild.root.id, equals('hello'));
      expect(secondChild.root.id, equals('bye'));

      expect(firstChild, isA<TextBox>());
      expect(secondChild, isA<TextBox>());

      expect(firstChild.root.attributes[idAttribute], isNotNull);
      expect(secondChild.root.attributes[idAttribute], isNotNull);

      container.removeFromDom();

      expect(document.getElementById(container.root.id), isNull);
      expect(document.getElementById(firstChild.root.id), isNull);
      expect(document.getElementById(secondChild.root.id), isNull);
    });

    test('allows widgets to be added and removed', () {
      container.add(TextBox()
        ..root.id = 'new-box'
        ..text = 'new box');

      var contEl = document.getElementById(container.root.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(3));

      final newChild = container[2];

      expect(newChild.root.id, equals('new-box'));
      expect(newChild.text, equals('new box'));
      expect(newChild.root.attributes[idAttribute], isNotNull);

      container.remove(newChild);

      expect(document.getElementById(newChild.root.id), isNull);
      expect(document.getElementById(container.root.id), isNotNull);

      container.removeFromDom();

      expect(document.getElementById(newChild.root.id), isNull);
      expect(document.getElementById(container.root.id), isNull);
    });

    test('allows widgets to be inserted at first index and removed', () {
      container[0] = TextBox()
        ..root.id = 'first-box'
        ..text = 'first box';

      var contEl = document.getElementById(container.root.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(2));

      final newChild = container[0];

      expect(newChild.root.id, equals('first-box'));
      expect(newChild.text, equals('first box'));
      expect(newChild.root.attributes[idAttribute], isNotNull);

      var secondChild = container[1];
      expect(secondChild.root.id, equals('bye'));

      container.removeAt(0);

      expect(document.getElementById(newChild.root.id), isNull);
      expect(document.getElementById(container.root.id), isNotNull);

      secondChild = container[0];
      expect(secondChild.root.id, equals('bye'));

      container.removeFromDom();

      expect(document.getElementById(newChild.root.id), isNull);
      expect(document.getElementById(container.root.id), isNull);
    });

    test('allows untyped objects to be inserted at any index and removed', () {
      container.addAll([
        'hello world',
        10,
        null,
        TextBox()..root.id = 'text-box-0',
        DivElement()..id = 'div-0'
      ]);

      var contEl = document.getElementById(container.root.id);
      expect(contEl, isA<DivElement>());
      expect(contEl.children, hasLength(7));

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'bye', '', '', '', 'text-box-0', 'div-0']));

      expect(container[0], isA<TextBox>());
      expect(container[1], isA<TextBox>());
      expect(container[2], equals('hello world'));
      expect(container[3], equals(10));
      expect(container[4], isNull);
      expect(container[5], isA<TextBox>());
      expect(container[6], isA<DivElement>());

      final box4 = TextBox()..root.id = 'text-box-4';
      container[4] = box4;

      expect(
          contEl.children.map((c) => c.id).toList(),
          equals(
              ['hello', 'bye', '', '', 'text-box-4', 'text-box-0', 'div-0']));

      expect(container[0], isA<TextBox>());
      expect(container[1], isA<TextBox>());
      expect(container[2], equals('hello world'));
      expect(container[3], equals(10));
      expect(container[4], isA<TextBox>());
      expect(container[5], isA<TextBox>());
      expect(container[6], isA<DivElement>());

      container.removeRange(1, 4);

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'text-box-4', 'text-box-0', 'div-0']));

      expect(container[0], isA<TextBox>());
      expect(container[1], isA<TextBox>());
      expect(container[2], isA<TextBox>());
      expect(container[3], isA<DivElement>());

      box4.removeFromDom();

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'text-box-0', 'div-0']));

      final box0 = container[1] as TextBox;

      container.remove(box0);

      expect(contEl.children.map((c) => c.id).toList(),
          equals(['hello', 'div-0']));

      container.removeFromDom();

      expect(document.getElementById(container.root.id), isNull);
    });
  });
}
