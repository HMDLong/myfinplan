void main() {
  final x = <A>[A(1), A(1), A(1)];
  for (var a in x) {
    a.x = 5;
  }
  print(x);
}

class A {
  int x;

  A(this.x);

  @override
  String toString() {
    return "$x";
  }
}
