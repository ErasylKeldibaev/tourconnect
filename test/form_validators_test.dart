import 'package:flutter_test/flutter_test.dart';
import 'package:tourconnect/core/utils/form_validators.dart';

void main() {
  group('FormValidators', () {
    test('validates email values', () {
      expect(FormValidators.email('traveler@example.com'), isNull);
      expect(FormValidators.email(' traveler@example.com '), isNull);
      expect(FormValidators.email(''), 'Enter your email');
      expect(FormValidators.email('traveler'), 'Enter a valid email');
      expect(FormValidators.email('traveler@example'), 'Enter a valid email');
    });

    test('validates password values', () {
      expect(FormValidators.password('secret1'), isNull);
      expect(FormValidators.password(''), 'Enter your password');
      expect(FormValidators.password('12345'), 'Use at least 6 characters');
    });

    test('validates password confirmation values', () {
      expect(FormValidators.passwordConfirmation('secret1', 'secret1'), isNull);
      expect(
        FormValidators.passwordConfirmation('', 'secret1'),
        'Repeat your password',
      );
      expect(
        FormValidators.passwordConfirmation('secret2', 'secret1'),
        'Passwords do not match',
      );
    });
  });
}
