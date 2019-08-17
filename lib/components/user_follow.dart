class UserFollow {
  String uid;
  String nickname;
  String email;
  int streak;

  UserFollow(this.uid, this.email, this.streak);

  factory UserFollow.fromMap(String uid, Map data) {
    print(data);
    return UserFollow(
        data['uid'], data['email'], data['streak']['current']);
  }
}
