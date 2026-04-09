import 'dart:math';

import 'package:batmankey/password_generator.dart';

class PinPasswordGenerator implements PasswordGenerator {
  @override
  String generate(int lenght) {
    const digits = '0123456789';

    final random = Random();

    return List.generate(
      lenght,
      (_) => digits[random.nextInt(digits.length)],
    ).join();
  }
}
