void main() {
  final a = DateTime(2000, 1, 1).hashCode;
  final b = DateTime(2000, 1, 1).hashCode;
  print("a=$a, b=$b, b==a? ${b == a}");
}

class A {
  int x;

  A(this.x);

  @override
  String toString() {
    return "$x";
  }
}
