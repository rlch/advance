import 'package:advance/components/achievement.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout_area.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final Firestore _db = Firestore.instance;

  Stream<User> streamUser(FirebaseUser firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return _db
        .collection('users')
        .document(firebaseUser.uid)
        .snapshots()
        .map((snap) => User.fromMap(firebaseUser, snap.data));
  }

  Future<void> createUser(String uid) async {
    await Firestore.instance.collection('users').document(uid).setData({
      'achievements': Map<String, dynamic>.fromIterable(achievements,
          key: (item) => item.id.toString(),
          value: (_) => {'level': 0, 'progress': 0}),
      'energy': 0,
      'streak': {'current': 0, 'history': {}, 'record': 0},
      'workouts': Map<String, dynamic>.fromIterable(workoutAreas,
          key: (area) => area.id.toString(),
          value: (area) => {
                'exercises': Map<String, dynamic>.fromIterable(area.workouts,
                    key: (workout) => workout.id.toString(),
                    value: (workout) =>
                        {'times_completed': 0}),
                'experience': 0
              }),
      'color': 0,
    });
  }

  Future<void> changeThemeColor(String uid, int colorIndex) async {
    await Firestore.instance.collection('users').document(uid).updateData({
      'color': colorIndex
    });
  }
}
