import 'package:danim/src/createMovingTimeList.dart';
import 'package:danim/src/loadingTimeTable.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/src/timetable.dart';
import 'package:danim/src/place.dart';
import 'package:danim/map.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

import '../route.dart';
import 'courseSelected.dart';
//import 'exampleResource.dart';\

class Preset extends StatefulWidget {
  List<List<List<Place>>> pathList;
  int transit = 0;

  //Preset(pathList, this.transit);
  Preset(this.pathList, this.transit, {super.key});

  @override
  State<Preset> createState() => _PresetState();
}

class _PresetState extends State<Preset> {
  int presetIndex = -1;

  // String str = '';
  // void setState(VoidCallback fn) {
  //   str += "in SetState\n";
  //   super.setState(fn);
  // }

  static Color getColor(Set<MaterialState> states) {
    if (states.contains(MaterialState.pressed) ||
        states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    }
    if (states.contains(MaterialState.focused)) {
      return Colors.lightBlue;
    } else
      return Colors.white;
  }

  List<MaterialStateProperty<Color>> presetButtonColorList = [
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor),
    MaterialStateProperty.resolveWith(getColor)
  ];

  // List<TextStyle> presetButtonTextColorList = [
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   ),
  //   TextStyle(
  //     color: Colors.black,
  //   )
  // ];

  void switchPresetButtonColor(int index, int type) {
    if (type == 1) {
      setState(() {
        presetButtonColorList[index] = MaterialStateProperty.resolveWith(
            (states) => Color.fromARGB(255, 78, 194, 252));
      });
    } else if (type == 0) {
      setState(() {
        presetButtonColorList[index] =
            MaterialStateProperty.resolveWith(getColor);
      });
    }
  }

  NaverMapController? mapController;
  MapType _mapType = MapType.Basic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('?????? ?????? ??????(4/4)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        actions: [
          //action??? ????????? ?????????, ???????????? ???????????? ??????, AppBar????????? ??????
          //????????? ?????? ????????? ???????????? ?????????.

          // TextButton(
          //     onPressed: () {
          //       //Navigator.popUntil(context, (route) => route.isFirst);
          //       //??????????????? ?????????????????????
          //     },
          //     child: Image.asset(
          //       IconsPath.count2,
          //       fit: BoxFit.contain,
          //       width: 60,
          //       height: 40,
          //     )),
          IconButton(
            icon: Icon(Icons.home),
            tooltip: 'Hi!',
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              //??????????????? ?????????????????????
            },
          ),
          // TextButton(
          //     onPressed: () {
          //       Navigator.popUntil(context, (route) => route.isFirst);
          //       //??????????????? ?????????????????????
          //     },
          //     child: Image.asset(
          //       IconsPath.house,
          //       fit: BoxFit.contain,
          //       height: 20,
          //     )),
        ],
      ),
      body: Column(children: [
        // Padding(
        //   padding: EdgeInsets.all(10.0),
        //   child: Container(
        //       padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        //       child: Text('?????? ????????? ??? ????????? ???????????????!',
        //           style: TextStyle(
        //             color: Colors.black,
        //             letterSpacing: 2.0,
        //             fontSize: 18.0,
        //             fontFamily: "Neo",
        //             fontWeight: FontWeight.bold,
        //           ))),
        // ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text('????????? ?????? ?????? ??? ????????? ???????????????!',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Neo",
                    letterSpacing: 2.0,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ))),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Text('????????? ?????? ???????????? ??????????????????',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Neo",
                  //letterSpacing: 2.0,
                  fontSize: 11.0,
                  //fontWeight: FontWeight.bold,
                ))),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: 7,
          decoration: BoxDecoration(
            color: Color(0xffF4F4F4),
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xffD4D4D4)),
            ),
          ),
        ),
        Container(
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
            ),
            child: NaverMap(
              onMapCreated: (mcontroller) {
                setState(() {
                  mapController = mcontroller;
                });
              },
              initialCameraPosition: CameraPosition(
                  bearing: 0.0,
                  target: LatLng(33.371964, 126.543512),
                  tilt: 0.0,
                  zoom: 8.0),
              mapType: _mapType,
              markers: markers,
              pathOverlays: pathOverlays,
            ) // ????????? ?????? ????????? ???!! ???????????? ????????? ???????????? ????????? ??????
            ),
        Container(
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          height: 7,
          decoration: BoxDecoration(
            color: Color(0xffF4F4F4),
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xffD4D4D4)),
            ),
          ),
        ),
        SizedBox(
          width: 200, // ?????? ??????
          height: 30, // ?????? ??????
          // child: Container(
          //   color: Colors.blue,
          //   child: Text("Container"),
          // ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          for (int i = 0; i < widget.pathList.length; i++)
            Stack(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(11, 0, 0, 0),
                  child: Container(
                    height: 40.0,
                    child: ElevatedButton(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        //?????? ????????? ????????? ????????? ?????? ????????? ???! ????????? ????????? ?????????..
                        style: ButtonStyle(
                            backgroundColor: presetButtonColorList[i]),
                        onPressed: () {
                          setState(() {
                            presetIndex = i;
                            print('presetIndex $presetIndex');
                            addPresetPoly(widget.pathList[presetIndex]);
                            print('preset ${widget.pathList[presetIndex]}');
                            addPresetMarker(widget.pathList[presetIndex]);

                            //?????? ??? ??????
                            switchPresetButtonColor(i, 1);
                            for (int b = 0; b < widget.pathList.length; b++) {
                              if (b != i) {
                                switchPresetButtonColor(b, 0);
                              }
                            }
                          });

                          print("selected preset: ${i + 1}");
                        }),
                  )),
              // Positioned(
              //     right: -20,
              //     child: Container(
              //         child: TextButton(
              //             child: Icon(Icons.arrow_forward, color: Colors.red),
              //             onPressed: () => {print(widget.pathList[i])})))
            ]),
        ]),
        SizedBox(
          width: 200, // ?????? ??????
          height: 50, // ?????? ??????
          // child: Container(
          //   color: Colors.blue,
          //   child: Text("Container"),
          // ),
        ),
        // Center(
        //     child: Container(
        //   width: 120.0,
        //   height: 50.0,
        //   child: ElevatedButton(
        //       child: Text('?????? ?????? ??????',
        //           style: TextStyle(
        //             fontFamily: "Neo",
        //             //letterSpacing: 2.0,
        //             fontSize: 11.0,
        //             fontWeight: FontWeight.bold,
        //           )),
        //       onPressed: () async {

        //       }),
        // )),
      ]),
      bottomSheet: (true)
          ? GestureDetector(
              onTap: () async {
                if (presetIndex != -1) {
                  //????????? ?????? ??????????????? ??????
                  course_selected = widget.pathList[presetIndex];


                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoadingTimeTable(
                                widget.pathList[presetIndex],
                                widget.transit,

                            dayStartingTime.hour,
                                dayEndingTime.hour,

                              )));
                } else {
                  showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                            content: SizedBox(
                                width: 300,
                                height: 100,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                          child: Text("Warning!",
                                              style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                          child: Text("?????? ????????? ???????????? ???????????????.",
                                              style: TextStyle(
                                                fontFamily: "Neo",
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ),
                                  ],
                                )));
                      });
                }
              },
              child: Container(
                width: Get.width,
                height: 60,
                color: Color.fromARGB(255, 102, 202, 252),
                child: const Center(
                  child: Text(
                    '?????? ?????? ??????',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: "Neo",
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: Get.width,
              height: 60,
              color: Color(0xffE9E9E9),
              child: const Center(
                child: Text(
                  '??????',
                  style: TextStyle(color: Color(0xffB0B0B0), fontSize: 16),
                ),
              ),
            ),
    );
  }
}
