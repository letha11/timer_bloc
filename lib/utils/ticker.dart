void main() {
  var ticker = const Ticker();
  ticker.tick(ticks: 5).listen(print);
}

class Ticker {
  const Ticker();

  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1).take(ticks);
  }
}
