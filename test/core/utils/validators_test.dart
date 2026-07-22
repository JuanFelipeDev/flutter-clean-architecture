import 'package:affiliate_app/core/utils/validators.dart';
import 'package:affiliate_app/core/widgets/validated_text_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validators.required', () {
    final v = Validators.required();
    test('rejects empty / whitespace', () {
      expect(v(''), isNotNull);
      expect(v('   '), isNotNull);
    });
    test('accepts non-empty', () {
      expect(v('abc'), isNull);
    });
  });

  group('Validators.email', () {
    final v = Validators.email();
    test('accepts a valid email', () {
      expect(v('user@example.com'), isNull);
    });
    test('rejects an invalid email', () {
      expect(v('not-an-email'), isNotNull);
      expect(v('user@'), isNotNull);
    });
  });

  group('Validators.password', () {
    final v = Validators.password();
    test('accepts a strong password', () {
      expect(v('Abcdef1!'), isNull);
    });
    test('rejects too short', () {
      expect(v('Ab1!'), isNotNull);
    });
    test('rejects missing digit', () {
      expect(v('Abcdefg!'), isNotNull);
    });
    test('rejects missing uppercase', () {
      expect(v('abcdef1!'), isNotNull);
    });
    test('rejects missing lowercase', () {
      expect(v('ABCDEF1!'), isNotNull);
    });
    test('rejects missing special char', () {
      expect(v('Abcdef11'), isNotNull);
    });
    test('rejects whitespace', () {
      expect(v('Abc def1!'), isNotNull);
    });
  });

  group('Validators.match', () {
    final other = 'Secret1!';
    final v = Validators.match(() => other);
    test('passes when values are equal', () {
      expect(v('Secret1!'), isNull);
    });
    test('fails when values differ', () {
      expect(v('Other2?'), isNotNull);
    });
    test('re-evaluates the counterpart on each call', () {
      var current = 'one';
      final dyn = Validators.match(() => current);
      expect(dyn('one'), isNull);
      current = 'two';
      expect(dyn('one'), isNotNull);
      expect(dyn('two'), isNull);
    });
  });

  test('FieldValidator is the expected typedef shape', () {
    final FieldValidator v = Validators.required();
    expect(v('x'), isNull);
  });
}