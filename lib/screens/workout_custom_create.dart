import 'dart:convert';

import 'package:advance/components/exercise.dart';
import 'package:advance/components/user.dart';
import 'package:advance/components/workout.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:provider/provider.dart';
import 'package:slugify/slugify.dart';

class WorkoutCustomCreateScreen extends StatefulWidget {
  WorkoutCustomCreateScreen({Key key}) : super(key: key);

  @override
  _WorkoutCustomCreateScreenState createState() =>
      _WorkoutCustomCreateScreenState();
}

class _WorkoutCustomCreateScreenState extends State<WorkoutCustomCreateScreen> {
  List<Map<String, dynamic>> addedWorkoutSteps = [];
  bool addStepClicked = false;
  String selected;
  TextEditingController _titleController;
  final _titleKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final workoutSteps = Provider.of<Map<String, WorkoutStep>>(context);

    Widget _buildRepSet(RepSet repSet, int index) {
      return ListTile(
          key: ObjectKey(repSet),
          title: AutoSizeText(
            repSet.title,
            maxFontSize: 16,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: () {
                  Picker(
                      adapter: NumberPickerAdapter(
                          data: [NumberPickerColumn(begin: 1, end: 300)]),
                      title: Text("Repetitions"),
                      onConfirm: (picker, _) {
                        setState(() {
                          addedWorkoutSteps[index]['reps'] =
                              picker.getSelectedValues()[0];
                        });
                      }).showModal(context);
                },
                color: Colors.white,
                elevation: 0,
                icon: Icon(
                  Icons.repeat,
                  color: user.appTheme.themeColor.primary,
                ),
                label: Text(
                  repSet.reps.toString(),
                  style: TextStyle(
                      color: user.appTheme.themeColor.primary,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.fade,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  addedWorkoutSteps.removeAt(index);
                },
              )
            ],
          ));
    }

    Widget _buildTimedSet(TimedSet timedSet, int index) {
      int total = addedWorkoutSteps[index]["duration"];
      String minutes = Duration(seconds: total).inMinutes.toString();
      String seconds = (Duration(seconds: total).inSeconds % 60).toString();

      return ListTile(
          key: ObjectKey(timedSet),
          title: AutoSizeText(
            timedSet.title,
            maxFontSize: 16,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(
                  Icons.timer,
                  color: user.appTheme.themeColor.primary,
                ),
                label: Text(
                  '$minutes:' +
                      ((seconds).toString().length > 1 ? '' : '0') +
                      '$seconds',
                  style: TextStyle(
                      color: user.appTheme.themeColor.primary,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.fade,
                ),
                color: Colors.white,
                elevation: 0,
                onPressed: () {
                  Picker(
                    adapter: NumberPickerAdapter(
                      data: [
                        NumberPickerColumn(begin: 0, end: 60),
                        NumberPickerColumn(begin: 0, end: 60)
                      ],
                    ),
                    onConfirm: (picker, _) {
                      setState(() {
                        Duration duration = Duration(
                                minutes: picker.getSelectedValues()[0]) +
                            Duration(seconds: picker.getSelectedValues()[1]);
                        addedWorkoutSteps[index]['duration'] =
                            duration.inSeconds;
                      });
                    },
                    footer: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'mins',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: screenWidth * 0.4,
                        ),
                        Text(
                          'secs',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    title: Text('Duration'),
                  ).showModal(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  addedWorkoutSteps.removeAt(index);
                },
              )
            ],
          ));
    }

    Widget _buildRest(Rest rest, int index) {
      int total = addedWorkoutSteps[index]["duration"];
      String minutes = Duration(seconds: total).inMinutes.toString();
      String seconds = (Duration(seconds: total).inSeconds % 60).toString();

      return ListTile(
          key: ObjectKey(rest),
          title: AutoSizeText(
            "Rest",
            maxFontSize: 16,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton.icon(
                icon: Icon(
                  Icons.favorite_border,
                  color: user.appTheme.themeColor.primary,
                ),
                label: Text(
                  '$minutes:' +
                      ((seconds).toString().length > 1 ? '' : '0') +
                      '$seconds',
                  style: TextStyle(
                      color: user.appTheme.themeColor.primary,
                      fontWeight: FontWeight.w600),
                  overflow: TextOverflow.fade,
                ),
                color: Colors.white,
                elevation: 0,
                onPressed: () {
                  Picker(
                    adapter: NumberPickerAdapter(
                      data: [
                        NumberPickerColumn(begin: 0, end: 60),
                        NumberPickerColumn(begin: 0, end: 60)
                      ],
                    ),
                    onConfirm: (picker, _) {
                      setState(() {
                        Duration duration = Duration(
                                minutes: picker.getSelectedValues()[0]) +
                            Duration(seconds: picker.getSelectedValues()[1]);
                        addedWorkoutSteps[index]['duration'] =
                            duration.inSeconds;
                      });
                    },
                    footer: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'mins',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          width: screenWidth * 0.4,
                        ),
                        Text(
                          'secs',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                    title: Text('Duration'),
                  ).showModal(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  addedWorkoutSteps.removeAt(index);
                },
              )
            ],
          ));
    }

    T cast<T>(x) => x is T ? x : null;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'workout-create',
        label: Text(
          'Create',
          style: TextStyle(color: user.appTheme.themeColor.primary),
        ),
        icon: Icon(
          Icons.add,
          color: user.appTheme.themeColor.primary,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          if (_titleKey.currentState.validate() &&
              addedWorkoutSteps.length > 0) {
            user.customWorkouts.add(Workout.custom(
                Slugify(_titleController.text.trim(), delimiter: '_'),
                _titleController.text.trim(),
                addedWorkoutSteps));
          }
        },
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: user.appTheme.gradientColors,
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
          ),
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 40,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Flexible(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(right: 60, left: 20, top: 10),
                        child: Form(
                          key: _titleKey,
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                            controller: _titleController,
                            cursorColor: Colors.white,
                            style: TextStyle(
                                color: Colors.white,
                                decorationColor: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                focusColor: Colors.white,
                                labelText: "Title of workout",
                                errorStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                labelStyle: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 4)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 20))),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.75,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: addStepClicked
                          ? Column(
                              children: <Widget>[
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text('Timed'),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text('Reps'),
                                    SizedBox(
                                      width: 20,
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: workoutSteps.length,
                                    itemBuilder: (_, i) {
                                      return ListTile(
                                        title: AutoSizeText(
                                          workoutSteps.values.toList()[i].title,
                                          maxFontSize: 16,
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Radio(
                                              activeColor: user
                                                  .appTheme.themeColor.primary,
                                              onChanged: (value) {
                                                setState(() {
                                                  selected = value;
                                                });
                                              },
                                              value: json.encode({
                                                "type": "timed_set",
                                                "title": workoutSteps.values
                                                    .toList()[i]
                                                    .title,
                                                "duration": 0
                                              }),
                                              groupValue: selected,
                                            ),
                                            Radio(
                                              activeColor: user
                                                  .appTheme.themeColor.primary,
                                              onChanged: (value) {
                                                setState(() {
                                                  selected = value;
                                                });
                                              },
                                              value: json.encode({
                                                "type": "rep_set",
                                                "title": workoutSteps.values
                                                    .toList()[i]
                                                    .title,
                                                "reps": 1
                                              }),
                                              groupValue: selected,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: user.appTheme.themeColor.primary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          addStepClicked = false;
                                        });
                                      },
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          color:
                                              user.appTheme.themeColor.primary,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            addedWorkoutSteps
                                                .add(json.decode(selected));
                                            addStepClicked = false;
                                          });
                                        })
                                  ],
                                )
                              ],
                            )
                          : Column(
                              children: <Widget>[
                                Expanded(
                                  child: ReorderableListView(
                                    onReorder: (oldIndex, newIndex) {
                                      print((addedWorkoutSteps
                                          .map((f) => f["title"])
                                          .toList()));
                                      print(newIndex);
                                      if (newIndex < addedWorkoutSteps.length) {
                                        var tmp = addedWorkoutSteps[oldIndex];
                                        setState(() {
                                          addedWorkoutSteps[oldIndex] =
                                              addedWorkoutSteps[newIndex];
                                          addedWorkoutSteps[newIndex] = tmp;
                                        });
                                      }
                                      print((addedWorkoutSteps
                                          .map((f) => f["title"])
                                          .toList()));
                                    },
                                    children: List.generate(
                                        addedWorkoutSteps.length, (index) {
                                      final step = addedWorkoutSteps[index];
                                      switch (step['type']) {
                                        case 'timed_set':
                                          return _buildTimedSet(
                                              TimedSet(
                                                  step['title'],
                                                  Duration(
                                                      seconds:
                                                          step['duration'])),
                                              index);
                                        case 'rest':
                                          return _buildRest(
                                              Rest(Duration(
                                                  seconds: step['duration'])),
                                              index);
                                        case 'rep_set':
                                          return _buildRepSet(
                                              RepSet(
                                                  step['title'], step['reps']),
                                              index);
                                        default:
                                          return null;
                                      }
                                    }),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    RaisedButton.icon(
                                        color: Colors.white,
                                        elevation: 0,
                                        highlightElevation: 0,
                                        label: Text(
                                          'Exercise',
                                          style: TextStyle(
                                              color: user
                                                  .appTheme.themeColor.primary),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            addStepClicked = true;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color:
                                              user.appTheme.themeColor.primary,
                                        )),
                                    RaisedButton.icon(
                                        color: Colors.white,
                                        elevation: 0,
                                        highlightElevation: 0,
                                        label: Text(
                                          'Rest',
                                          style: TextStyle(
                                              color: user
                                                  .appTheme.themeColor.primary),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            addedWorkoutSteps.add({
                                              "type": "rest",
                                              "duration": 0
                                            });
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add,
                                          color:
                                              user.appTheme.themeColor.primary,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}