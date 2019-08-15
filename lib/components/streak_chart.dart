import 'dart:async';

import 'package:advance/components/user.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StreakChart extends StatefulWidget {
  final Map<String, UserStreakHistory> history;
  final Color themeColor;
  StreakChart({this.history, this.themeColor});

  @override
  State<StatefulWidget> createState() => _StreakChartState();
}

class _StreakChartState extends State<StreakChart> {
  DateTime now = DateTime.now();
  DateTime date;
  DateFormat format = DateFormat('dd-MM-yyyy');

  List<DateTime> days;
  List<String> daysFormatted;

  List<DateTime> calculateDaysInterval(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  double _max = 0;
  double _height = 16;

  final Color barColor = Colors.white;
  final Color barBackgroundColor = Colors.transparent;
  final double width = 18;

  List<BarChartGroupData> rawBarGroups;
  List<BarChartGroupData> showingBarGroups;

  StreamController<BarTouchResponse> barTouchedResultStreamController;

  int touchedGroupIndex;

  @override
  void initState() {
    date = DateTime(now.year, now.month, now.day);
    days = calculateDaysInterval(date.subtract(Duration(days: 6)), date);
    daysFormatted =
        calculateDaysInterval(date.subtract(Duration(days: 6)), date)
            .map((datetime) => format.format(datetime))
            .toList();

    for (final key in daysFormatted) {
      if (widget.history.containsKey(key)) {
        final item = widget.history[key];
        if (item.experience > _max) {
          _max = item.experience;
        }
      }
    }
    if (_max == 0) {
      _max = 1;
    }

    super.initState();

    final items = List<BarChartGroupData>.generate(
        7,
        (index) => makeGroupData(
            days[index].weekday - 1,
            (widget.history.containsKey(daysFormatted[index]))
                ? _height *
                    widget.history[daysFormatted[index]].experience /
                    _max
                : 0));

    rawBarGroups = items;
    showingBarGroups = rawBarGroups;

    barTouchedResultStreamController = StreamController();
    barTouchedResultStreamController.stream
        .distinct()
        .listen((BarTouchResponse response) {
      if (response == null) {
        return;
      }

      if (response.spot == null) {
        setState(() {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        });
        return;
      }

      touchedGroupIndex =
          showingBarGroups.indexOf(response.spot.touchedBarGroup);

      setState(() {
        if (response.touchInput is FlLongPressEnd) {
          touchedGroupIndex = -1;
          showingBarGroups = List.of(rawBarGroups);
        } else {
          showingBarGroups = List.of(rawBarGroups);
          if (touchedGroupIndex != -1) {
            showingBarGroups[touchedGroupIndex] =
                showingBarGroups[touchedGroupIndex].copyWith(
              barRods: showingBarGroups[touchedGroupIndex].barRods.map((rod) {
                return rod.copyWith(color: Colors.black38, y: rod.y + 1);
              }).toList(),
            );
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: FlChart(
                    chart: BarChart(BarChartData(
                      barTouchData: BarTouchData(
                        touchTooltipData: TouchTooltipData(
                            tooltipBgColor: Colors.blueGrey,
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((touchedSpot) {
                                if (touchedSpot != null) {
                                  String weekDay;
                                  switch (touchedSpot.spot.x.toInt()) {
                                    case 0:
                                      weekDay = 'Monday';
                                      break;
                                    case 1:
                                      weekDay = 'Tuesday';
                                      break;
                                    case 2:
                                      weekDay = 'Wednesday';
                                      break;
                                    case 3:
                                      weekDay = 'Thursday';
                                      break;
                                    case 4:
                                      weekDay = 'Friday';
                                      break;
                                    case 5:
                                      weekDay = 'Saturday';
                                      break;
                                    case 6:
                                      weekDay = 'Sunday';
                                      break;
                                  }
                                  return TooltipItem(
                                      weekDay +
                                          '\n' +
                                          touchedSpot.spot.y.toString(),
                                      TextStyle(color: Colors.white));
                                } else {
                                  return null;
                                }
                              }).toList();
                            }),
                        touchResponseSink:
                            barTouchedResultStreamController.sink,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: SideTitles(
                            showTitles: true,
                            textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                            margin: 16,
                            getTitles: (double value) {
                              List<String> dates = [
                                'M',
                                'T',
                                'W',
                                'T',
                                'F',
                                'S',
                                'S'
                              ];
                              List<Object> rotate(List<Object> list, int v) {
                                if (list == null || list.isEmpty) return list;
                                var i = v % list.length;
                                return list.sublist(i)
                                  ..addAll(list.sublist(0, i));
                              }

                              dates = rotate(dates, 4 - date.weekday);
                              return dates[value.floor()];
                            }),
                        leftTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        y: y,
        color: barColor,
        width: width,
        isRound: true,
        backDrawRodData: BackgroundBarChartRodData(
          show: true,
          y: _height,
          color: Colors.black.withOpacity(0.2),
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    barTouchedResultStreamController.close();
  }
}
