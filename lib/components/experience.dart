import 'dart:math';

class Experience {
  int amount;
  int get level => ((25 + sqrt(625 + 100 * amount)) / 50).floor();
  double get progress => (amount - 25 * level * (level - 1)) / (50 * level);
  int get xpLeft => (25 * (level + 1) * ((level + 1) - 1)) - amount;
  Experience(this.amount);
}
