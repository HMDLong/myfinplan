import 'dart:io';
import 'dart:math';

const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";

String getRandomKey() {
  var rng = Random();
  return List<String>.generate(20, (index) => chars[rng.nextInt(61)]).join("");
}

void main() {
  for (int i = 0; i < 100; i++) {
    File('ids.txt').writeAsStringSync(
      '${getRandomKey()}\n',
      mode: FileMode.append,
    );
  }
}
