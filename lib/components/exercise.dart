class WorkoutStep {
  String title;

  WorkoutStep(this.title);
}

class TimedSet extends WorkoutStep {
  Duration duration;

  TimedSet(String title, this.duration) : super(title);
}

class RepSet extends WorkoutStep {
  int reps;

  RepSet(String title, this.reps) : super(title);
}

class Rest extends WorkoutStep {
  Duration duration;

  Rest(this.duration) : super('Rest');
}
