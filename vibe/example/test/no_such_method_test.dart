int main() {
  return 0;
}

class Vibe {}

class NotObservable {
  const NotObservable();
}

class B extends Vibe {
  B(this.i);
  @NotObservable()
  final int i;
}

class A extends Vibe {}

class Observable {}

extension on A {}
