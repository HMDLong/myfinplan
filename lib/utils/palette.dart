import 'dart:math';

import 'package:flutter/material.dart';

final lightPalletes = <Color>[
  Colors.blue.shade100,
  Colors.green.shade100,
  Colors.amber.shade100,
  Colors.red.shade100,
  Colors.indigo.shade100,
  Colors.brown.shade100,
  Colors.pink.shade100,
  Colors.orange.shade100,
  Colors.yellow.shade100,
];

final mediumtPalletes = <Color>[
  Colors.blue,
  Colors.green,
  Colors.amber,
  Colors.red,
  Colors.indigo,
  Colors.brown,
  Colors.pink,
  Colors.orange,
  Colors.yellow,
];

final hardPalletes = <Color>[
  Colors.blue.shade700,
  Colors.green.shade700,
  Colors.amber.shade700,
  Colors.red.shade700,
  Colors.indigo.shade700,
  Colors.brown.shade700,
  Colors.pink.shade700,
  Colors.orange.shade700,
  Colors.yellow.shade700,
];

class Palletes {
  static Color ramdomLight() {
    return lightPalletes[Random().nextInt(lightPalletes.length)];
  }
}
