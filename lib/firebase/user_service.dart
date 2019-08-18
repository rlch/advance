import 'package:advance/components/user.dart';
import 'package:advance/components/workout.dart';
import 'package:advance/components/workout_area.dart';
import 'package:advance/firebase/remote_config.dart';
import 'package:advance/screens/welcome/get_started.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserService {
  final Firestore _db = Firestore.instance;

  Stream<User> streamUser(FirebaseUser firebaseUser) {
    return _db
        .collection('users')
        .document(firebaseUser.uid)
        .snapshots()
        .map((snap) => User.fromMap(firebaseUser, snap.data));
  }

  Future<void> createUser(FirebaseUser firebaseUser, SignUpDetails signUpDetails,
      RemoteConfigSetup remoteConfigSetup) async {
    await Firestore.instance.collection('users').document(firebaseUser.uid).setData({
      "email": firebaseUser.email,
      'gender': signUpDetails.gender,
      'weight': signUpDetails.weight,
      'height': signUpDetails.height,
      'achievements': Map<String, dynamic>.fromIterable(
          remoteConfigSetup.achievements,
          key: (item) => item.slug,
          value: (_) => {'level': 0, 'progress': 0}),
      'energy': 0,
      'streak': {
        'current': 0,
        'history': {},
        'record': 0,
        'target': signUpDetails.streakGoal
      },
      'workouts':
          Map<String, dynamic>.fromIterable(remoteConfigSetup.permittedWorkouts,
              key: (slug) => remoteConfigSetup.workoutAreas[slug].slug,
              value: (slug) => {
                    'exercises': Map<String, dynamic>.fromIterable(
                        remoteConfigSetup.workoutAreas[slug].workouts,
                        key: (workout) => workout.slug,
                        value: (workout) => {'times_completed': 0}),
                    'experience': 100.0
                  }),
      'color': 0,
      'permitted_workouts': remoteConfigSetup.permittedWorkouts,
    });
  }

  Future<void> changeThemeColor(String uid, int colorIndex) async {
    await Firestore.instance
        .collection('users')
        .document(uid)
        .updateData({'color': colorIndex});
  }

  Future<void> updateWorkoutResults(
      String uid, Workout workout, WorkoutArea workoutArea) async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    DateFormat format = DateFormat('dd-MM-yyyy');
    String formattedDate = format.format(date);

    final DocumentSnapshot doc =
        await Firestore.instance.collection('users').document(uid).get();

    int _workoutsCompleted = 1;
    double _experience = workout.experience;
    int _timestamp = date.millisecondsSinceEpoch;
    int _currentStreak = doc.data['streak']['current'];
    if ((doc.data['streak']['history'] as Map<dynamic, dynamic>)
        .containsKey(formattedDate)) {
      _workoutsCompleted = doc.data['streak']['history'][formattedDate]
              ['workouts_completed'] +
          1;
      _experience = doc.data['streak']['history'][formattedDate]['experience'] +
          workout.experience;
      _timestamp = doc.data['streak']['history'][formattedDate]['timestamp'];
    }
    if (_workoutsCompleted == doc.data['streak']['target']) {
      _currentStreak += 1;
    }

    await Firestore.instance.collection('users').document(uid).setData({
      'streak': {
        'current': _currentStreak,
        'record': (_currentStreak > doc.data['streak']['record'])
            ? _currentStreak
            : doc.data['streak']['record'],
        'history': {
          formattedDate: {
            'workouts_completed': _workoutsCompleted,
            'experience': _experience,
            'timestamp': _timestamp
          }
        },
      },
      'workouts': {
        workoutArea.slug: {
          'exercises': {
            workout.slug: {
              'times_completed': doc.data['workouts'][workoutArea.slug]
                      ['exercises'][workout.slug]['times_completed'] +
                  1
            }
          },
          "experience": doc.data['workouts'][workoutArea.slug]['experience'] +
              workout.experience
        }
      }
    }, merge: true);
  }

  Future<void> createCustomWorkout(
      String uid, Map<String, dynamic> workout) async {
    await Firestore.instance.collection('users').document(uid).setData({
      'custom_workouts': workout,
    }, merge: true);
  }

  Future<void> follow(String friendUid, String userUid) async {
    await Firestore.instance.collection('users').document(userUid).setData({
      'following': {friendUid: true}
    }, merge: true);
  }
}
