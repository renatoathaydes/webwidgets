import 'package:flattery/src/util/util.dart';
import 'package:test/test.dart';

main() async {
  group('Random Strings', () {
    test('generated as expected', () async {
      final strings = <String>{};
      for (int i = 0; i < 1000; i++) {
        final string = randomString();
        // default length is 12
        expect(string, hasLength(12), reason: "index: $i - wrong length");
        expect(strings.add(string), isTrue, reason: "index: $i - already seen");
      }
    });
  });
}

Future<void> nextEventLoopCycle() async {
  await Future(() {});
}
