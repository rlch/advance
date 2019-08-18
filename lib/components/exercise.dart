class WorkoutStep {
  String title;
  String videoId;

  factory WorkoutStep.fromConfig(Map data) {
    if (data.containsKey('video_id')) {
      return WorkoutStep(data['title'], videoId: data['video_id']);
    }
    return WorkoutStep(data['title'], videoId: null);
  }

  WorkoutStep(this.title, {this.videoId});
}

class TimedSet extends WorkoutStep {
  Duration duration;

  factory TimedSet.fromConfig(Map data, WorkoutStep workoutStep) {
    print(workoutStep.title);
    print(workoutStep.videoId);
    return TimedSet(workoutStep.title, Duration(seconds: data['duration']), videoId: workoutStep.videoId);
  }

  Map<String, dynamic> toJson() {
    return {
      "type": "timed_set",
      "title": title,
      "duration": duration.inSeconds
    };
  }

  TimedSet(String title, this.duration, {videoId}) : super(title, videoId: videoId);
}

class RepSet extends WorkoutStep {
  int reps;

  factory RepSet.fromConfig(Map data, WorkoutStep workoutStep) {
    return RepSet(workoutStep.title, data['reps'], videoId: workoutStep.videoId);
  }

  Map<String, dynamic> toJson() {
    return {"type": "rep_set", "title": title, "reps": reps};
  }

  RepSet(String title, this.reps, {videoId}) : super(title, videoId: videoId);
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
