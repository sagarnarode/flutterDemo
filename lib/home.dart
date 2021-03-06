import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './bar_chart_graph.dart';
import './bar_chart_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';
  String _steps = '?';
  double _height;
  double _width;
  int segmentedControlGroupValue = 0;
  double percent = 0.0;
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('EEE d MMM').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    initPlatformState();
    Timer timer;
    timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      print('Percent Update');
      setState(() {
        percent += 1;
        if (percent >= 100) {
          timer.cancel();
          // percent=0;
        }
      });
    });
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        formattedDate = DateFormat('EEE d MMM').format(selectedDate);
      });
  }
   final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Step"),
    1: Text("Food"),
    2: Text("Sleep")
  };
  var createbutton = [
    {"name": "Km", "count": "25 km"},
    {"name": "Cal", "count": "25 Kcal"},
    {"name": "Speed", "count": "25 km/hr"},
  ];
  final List<BarChartModel> data = [
    BarChartModel(
      month:'1',
      year: "2014",
      financial: 250,
      color: charts.ColorUtil.fromDartColor(Colors.yellow[600]),
    ),
    BarChartModel(
       month:'1',
      year: "2015",
      financial: 300,
      color: charts.ColorUtil.fromDartColor(Colors.yellow[600]),
    ),
    BarChartModel(
       month:'1',
      year: "2016",
      financial: 100,
      color: charts.ColorUtil.fromDartColor(Colors.yellow[600]),
    ),
    BarChartModel(
       month:'1',
      year: "2017",
      financial: 450,
      color: charts.ColorUtil.fromDartColor(Colors.yellow[600]),
    ),
    BarChartModel(
       month:'1',
      year: "2018",
      financial: 630,
      color: charts.ColorUtil.fromDartColor(Colors.yellow[600]),
    ),
    BarChartModel(
       month:'1',
      year: "2019",
      financial: 8000,
      color: charts.ColorUtil.fromDartColor(Colors.yellow[700]),
    ),
    BarChartModel(
       month:'1',
      year: "2020",
      financial: 400,
      color: charts.ColorUtil.fromDartColor(Colors.yellow[600]),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    formattedDate,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  iconSize: 30.0,
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            CupertinoSlidingSegmentedControl(
                padding: EdgeInsets.all(20.0),
                groupValue: segmentedControlGroupValue,
                children: myTabs,
                backgroundColor: Colors.transparent,
                onValueChanged: (i) {
                  setState(() {
                    segmentedControlGroupValue = i;
                  });
                }),
               Row(
                
                children: [
                  Padding(
                    padding: EdgeInsets.all(
                      0.0,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(
                      20.0,
                    ),
                    height: 200,
                    width: 80,
                    child: LiquidLinearProgressIndicator(
                      value: percent / 100,
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                      backgroundColor: Colors.yellow[600],
                      borderColor: Colors.yellow,
                      borderWidth: 0.0,
                      borderRadius: 12.0,
                      direction: Axis.vertical,
                      //  center:Text(percent.toString() +"%",style: TextStyle(fontSize:12.0,fontWeight: FontWeight.w600,color: Colors.black),),
                    ),
                  ),
                  Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 30),
                              children: [
                            TextSpan(
                                text: '100000',
                                style: TextStyle(color: Colors.black)),
                          ])),
                      RichText(
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 10),
                              children: [
                            TextSpan(
                                text: 'Steps',
                                style: TextStyle(color: Colors.blue)),
                          ])),
                    ],
                  ),
                ],
                //container
              ),
            
           Card(
               margin: EdgeInsets.only(left: 20, top:10, right: 20, bottom:0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              child: Row(
                children: <Widget>[
                  for (var i in createbutton)
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            i['name'],
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                             style:TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: RichText(
                          text: TextSpan(
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(fontSize: 10),
                              children: [
                            TextSpan(
                                text: i['count'],
                                style: TextStyle(color: Colors.blue)),
                          ])),
                        ),
                      ],
                    )),
                  // Expanded(
                  //     child: Column(
                  //   children: [
                  //     IconButton(
                  //       icon: Icon(Icons.volume_up),
                  //       tooltip: 'Increase volume by 10',
                  //       onPressed: () {
                  //         setState(() {});
                  //       },
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.all(7.0),
                  //       child: Text('1000'),
                  //     ),
                  //   ],
                  // )),
                  // Expanded(
                  //     child: Column(
                  //   children: [
                  //     IconButton(
                  //       icon: Icon(Icons.volume_up),
                  //       tooltip: 'Increase volume by 10',
                  //       onPressed: () {
                  //         setState(() {});
                  //       },
                  //     ),
                  //     Padding(
                  //       padding: EdgeInsets.all(7.0),
                  //       child: Text('1000'),
                  //     ),
                  //   ],
                  // )),
                ],
              ),
            ),
            
              Center(
        child: Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              BarChartGraph(
                data: data,
              ),

            ],
          ),

        ),
      ),
          ],
        ),
      ),
    );
  }

  /// Returns segmented line style circular progress bar.

}
