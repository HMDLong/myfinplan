import 'dart:math' as math;

class A {
  int x;
  A(this.x);
  @override
  String toString() {
    return x.toString();
  }
}

void main() {
  final a = <A>[];
  var i = A(0);
  a.add(i);

  i = A(1);
  i.x = 2;
  a.add(i);

  i = A(10);
  i.x = 9;
  a.add(i);

  print(a);
}
