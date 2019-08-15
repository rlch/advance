import 'package:advance/components/user.dart';

class UserFollow {
  String uid;
  String nickname;
  String email;
  Map<String, UserAchievement> achievements;
  UserStreak streak;

  UserFollow(this.uid, this.email, this.achievements, this.streak);
}
