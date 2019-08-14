class WorkoutStep {
  String title;

  factory WorkoutStep.fromConfig(Map data) {
    return WorkoutStep(data['title']);
  }

  WorkoutStep(this.title);
}

class TimedSet extends WorkoutStep {
  Duration duration;

  factory TimedSet.fromConfig(Map data, WorkoutStep workoutStep) {
    return TimedSet(workoutStep.title, Duration(seconds: data['duration']));
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "timed_set",
      "title": title,
      "duration": duration.inSeconds
    };
  }

  TimedSet(String title, this.duration) : super(title);
}

class RepSet extends WorkoutStep {
  int reps;

  factory RepSet.fromConfig(Map data, WorkoutStep workoutStep) {
    return RepSet(workoutStep.title, data['reps']);
  }

  Map<String, dynamic> toJson() {
    return {"type": "rep_set", "title": title, "reps": reps};
  }

  RepSet(String title, this.reps) : super(title);
}

class Rest extends WorkoutStep {
  Duration duration;

  factory Rest.fromConfig(Map data) {
    return Rest(Duration(seconds: data['duration']));
  }

  Map<String, dynamic> toJson() {
    return {"type": "rest", "duration": duration.inSeconds};
  }

  Rest(this.duration) : super('Rest');
}
