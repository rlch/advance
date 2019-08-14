import 'dart:math';

class Experience {
  double amount;
  int get level => (log(amount / 100) / log(1.3) + 1).floor();
  double get progress =>
      (amount - xpFor(level)) / (xpFor(level + 1) - xpFor(level));
  double get xpLeft => xpFor(level + 1) - amount;

  double xpFor(int n) {
    return pow(1.3, n - 1) * 100;
  }

  double calcAddedProgress(double xp) {
    return (amount + xp - xpFor(level)) / (xpFor(level + 1) - xpFor(level));
  }

  Experience(this.amount);
}
