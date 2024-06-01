void main() {
  print("${int.parse("008")}");
}

class A {
  int x;

  A(this.x);

  @override
  String toString() {
    return "$x";
  }
}
