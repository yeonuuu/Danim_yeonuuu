import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:danim/calendar_view.dart';
import 'package:danim/src/event_CalendarEventData_switch.dart';
import 'package:danim/src/viewPhoto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:danim/model/event.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import '../app_colors.dart';
import '../constants.dart';
import '../extension.dart';
import 'package:danim/src/place.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:danim/src/start_end_day.dart';
import 'package:danim/src/preset.dart';
import '../../map.dart' as map;
import 'loadingTimeTable.dart';
import 'viewPhoto.dart';

import '../map.dart';
import '../route_ai.dart';
import '../tourinfo.dart';
import '../widgets/custom_button.dart';
import '../widgets/date_time_selector.dart';
import 'courseSelected.dart';
import 'createMovingTimeList.dart';
import 'date_selectlist.dart';
import 'foodRecommend.dart';
import 'package:danim/route.dart';
import 'package:danim/nearby.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/login.dart';
import 'package:danim/src/user.dart';

List<CalendarEventData<Event>> createEventList(List<List<Place>> preset,
    DateTime startDay, DateTime endDay, List<List<int>> moving_time, int startDayTime, int endDayTime) {
  //int startDayTime = dayStartingTime.hour;
  //int endDayTime = dayEndingTime.hour;

  bool lunch = false;
  bool dinner = false;

  //int timeIndex = startDayTime;
  DateTime timeIndex = DateTime(startDay.year, startDay.month, startDay.day,
      startDayTime, 0); //?????? ??????????????? ???
  int minuteIndex = 0;
  DateTime dayIndex = startDay;
  //int moving_time = 0;

  List<CalendarEventData<Event>> events = [];


  for (int i = 0; i < preset.length; i++) {

    //??????, ?????? ?????? ??????????????? ????????????

    for(int j=0; j<preset[i].length; j++){

      if(preset[i][j].name.contains('??????')){
        lunch = true;
      }
      else if(preset[i][j].name.contains('??????')){
        dinner = true;
      }

    }

    if(i == 0){
      timeIndex =  DateTime(startDay.year, startDay.month, startDay.day,
          startDayTime, 0);
    }

    else{
      timeIndex =  DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
          10, 0);
    }

    for (int j = 0; j < preset[i].length; j++) {
      if (timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 11, 0)) >=
              0 &&
          timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 14, 0)) <
              0 &&
          !lunch) {
        lunch = true;

        DateTime mealEndTime = DateTime(dayIndex.year, dayIndex.month,
                dayIndex.day, timeIndex.hour, timeIndex.minute)
            .add(Duration(hours: 1));

        events.add(CalendarEventData(
            title: '????????????',
            date: dayIndex,
            event: Event(title: '????????????'),
            description: '',
            latitude: 0,
            longitude: 0,
            startTime: DateTime(
              dayIndex.year,
              dayIndex.month,
              dayIndex.day,
              timeIndex.hour,
              timeIndex.minute,
            ),
            endTime: mealEndTime,
            color: Colors.orangeAccent));

        timeIndex = mealEndTime;

        DateTime transitEndTime = DateTime(dayIndex.year, dayIndex.month,
            dayIndex.day, timeIndex.hour, timeIndex.minute + 30);
        DateTime transitEndTimeUpdated = transitEndTime;

        events.add(CalendarEventData(
            title: '??????',
            date: dayIndex,
            event: Event(title: '??????'),
            description: '',
            latitude: 0,
            longitude: 0,
            startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
                timeIndex.hour, timeIndex.minute),
            endTime: transitEndTime,
            color: Colors.grey));

        timeIndex = transitEndTime;
      }

      if (timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 17, 0)) >=
              0 &&
          timeIndex.compareTo(DateTime(
                  dayIndex.year, dayIndex.month, dayIndex.day, 22, 0)) <
              0 &&
          !dinner) {
        dinner = true;

        DateTime mealEndTime = DateTime(dayIndex.year, dayIndex.month,
                dayIndex.day, timeIndex.hour, timeIndex.minute)
            .add(Duration(hours: 1));

        events.add(CalendarEventData(
            title: '????????????',
            date: dayIndex,
            event: Event(title: '????????????'),
            description: '',
            latitude: 0,
            longitude: 0,
            startTime: DateTime(
              dayIndex.year,
              dayIndex.month,
              dayIndex.day,
              timeIndex.hour,
              timeIndex.minute,
            ),
            endTime: mealEndTime,
            color: Colors.orangeAccent));

        timeIndex = mealEndTime;

        DateTime transitEndTime = DateTime(dayIndex.year, dayIndex.month,
            dayIndex.day, timeIndex.hour, timeIndex.minute + 30);
        DateTime transitEndTimeUpdated = transitEndTime;

        events.add(CalendarEventData(
            title: '??????',
            date: dayIndex,
            event: Event(title: '??????'),
            description: '',
            latitude: 0,
            longitude: 0,
            startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
                timeIndex.hour, timeIndex.minute),
            endTime: transitEndTime,
            color: Colors.grey));

        timeIndex = transitEndTime;
      }

      if(i == preset.length-1){
        if (timeIndex.compareTo(DateTime(
            dayIndex.year, dayIndex.month, dayIndex.day, endDayTime)) >
            0) {


          break;
        }
      }

      else{
        if (timeIndex.compareTo(DateTime(
            dayIndex.year, dayIndex.month, dayIndex.day, 20)) >
            0) {
          break;
        }

      }


      DateTime tourEndTime = DateTime(
          dayIndex.year,
          dayIndex.month,
          dayIndex.day,
          timeIndex.hour,
          timeIndex.minute + preset[i][j].takenTime);
      DateTime tourEndTimeUpdated = tourEndTime;

      if(preset[i][j].name.contains('??????') || preset[i][j].name.contains('??????')){
        Color mealColor = Colors.orangeAccent;
      }
      //Color mealColor = Colors.orangeAccent;

      events.add(CalendarEventData(
          title: '${preset[i][j].name}',
          date: dayIndex,
          event: Event(title: '${preset[i][j].name}'),
          description: '',
          latitude: preset[i][j].latitude,
          longitude: preset[i][j].longitude,
          startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
              timeIndex.hour, timeIndex.minute),
          endTime: tourEndTimeUpdated));

      timeIndex = tourEndTimeUpdated;

      if(i == preset.length-1){
        if (timeIndex.compareTo(DateTime(
            dayIndex.year, dayIndex.month, dayIndex.day, endDayTime)) >
            0) {
          break;
        }
      }

      else{
        if (timeIndex.compareTo(DateTime(
            dayIndex.year, dayIndex.month, dayIndex.day, 20)) >
            0) {
          break;
        }

      }

      if (j < preset[i].length - 1) {
        DateTime transitEndTime = DateTime(dayIndex.year, dayIndex.month,
            dayIndex.day, timeIndex.hour, timeIndex.minute + moving_time[i][j]);
        DateTime transitEndTimeUpdated = transitEndTime;

        events.add(CalendarEventData(
            title: '??????',
            date: dayIndex,
            event: Event(title: '??????'),
            description: '',
            latitude: 0,
            longitude: 0,
            startTime: DateTime(dayIndex.year, dayIndex.month, dayIndex.day,
                timeIndex.hour, timeIndex.minute),
            endTime: transitEndTimeUpdated,
            color: Colors.grey));

        timeIndex = transitEndTimeUpdated;
      }
    }

    dayIndex = dayIndex.add(Duration(days: 1));
    timeIndex =
        DateTime(dayIndex.year, dayIndex.month, dayIndex.day, startDayTime, 0);

    lunch = false;
    dinner = false;
  }

  return events;
}

class Timetable extends StatefulWidget {
  Timetable(
      {Key? key,
      required this.preset,
      required this.transit,
      required this.movingTimeList,
      required this.startDayTime,
      required this.endDayTime,
      required this. movingStepsList})
      : super(key: key);

  int transit = 0; // ??????:0, ????????????:1

  List<List<Place>> preset = [[]];
  DateTime currentDate = startDay;
  List<List<int>> movingTimeList = [[]];
  int startDayTime = 0;
  int endDayTime = 0;
  List<List<String>> movingStepsList = [[]];

  @override
  _TimetableState createState() => _TimetableState();
}

class _TimetableState extends State<Timetable> {
  final _CourseNameController = TextEditingController();

  List<CalendarEventData<Event>> events =[];
  String isSaved = '';

  @override
  void initState() {
    super.initState();
    events =       createEventList(widget.preset, startDay, endDay, widget.movingTimeList, widget.startDayTime, widget.endDayTime);


    List<List<Place>> newPreset = [
      for (int i = 0;
      i <
          events[events.length -1].date
              .difference(events[0].date)
              .inDays +
              1;
      i++)
        []
    ]; // ????????? ?????????

    List<DateTime> dateList = [];


    for (int i = 0;
    i < events[events.length -1].date
        .difference(events[0].date)
        .inDays +
        1;
    i++) {
      dateList.add(DateTime(events[0].date.year,
          events[0].date.month, events[0].date.day + i));
    } // ?????? ?????????



    for (int i = 0; i < dateList.length; i++) {
      for (int j = 0; j < events.length; j++) {
        if ((dateList[i].year == events[j].date.year &&
            dateList[i].month ==
                events[j].date.month &&
            dateList[i].day ==
                events[j].date.day) &&
            (events[j].title != '??????') &&
            (events[j].title != '????????????')) {
          newPreset[i].add(Place(
              events[j].title,
              events[j].latitude,
              events[j].longitude,
              events[j]
                  .endTime
                  .difference(events[j].startTime)
                  .inMinutes,
              60,
              [0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0, 0, 0, 0, 0, 0],
              [0, 0, 0, 0]));
        }
      }
    }

    //??????????????? ?????? ??? ?????? ??????

    for (int i = 0; i < newPreset.length; i++) {
      for (int j = 0; j < newPreset[i].length; j++) {
        print(
            '${i}??? ??? ${j}??? ?????? : ${newPreset[i][j].name}');
      }
    }

    widget.preset = newPreset;

  }

  @override
  void dispose() {
    _CourseNameController.dispose();
    super.dispose();
  }

  int getTransit() {
    return widget.transit;
  }

  List<List<Place>> getPreset() {
    return widget.preset;
  }

  List<CalendarEventData<Event>> getEvents() {
    return events;
  }

  List<List<int>> getMovingTimeList() {
    return widget.movingTimeList;
  }

  List<List<String>> getMovingStepsList(){
    return widget.movingStepsList;
  }

  void deletePlace(Place place) {
    setState(() {
      widget.preset.remove(place);
    });
  }



  void setEventList() {
    events =
        createEventList(widget.preset, startDay, endDay, widget.movingTimeList, dayStartingTime.hour, dayEndingTime.hour)
            as List<CalendarEventData<Event>>;
  }

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider<Event>(
        controller: EventController<Event>()..addAll(events),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: true, // ?????? ????????? ??????
              title: InkWell(
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Center(
                  child: Image.asset(IconsPath.logo,
                      fit: BoxFit.contain, height: 40),
                ),
                // child: Transform(
                //   transform: Matrix4.translationValues(0, 0.0, 0.0),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: [
                //         Image.asset(IconsPath.logo,
                //             fit: BoxFit.contain, height: 40)
                //       ]),
                // ),
              ),
              actions: [
                //action??? ????????? ?????????, ???????????? ???????????? ??????, AppBar????????? ??????
                //????????? ?????? ????????? ???????????? ?????????.

                TextButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                  width: 300,
                                  height: 200,
                                  child: Column(children: [
                                    Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text('????????? ?????????????????????????',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "Neo",
                                                letterSpacing: 2.0,
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.bold,
                                              ))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: 120,
                                          height: 80,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 30, 0, 0),
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                //List<CalendarEventData<Event>> ?????? List<CalendarEventData> ??? ?????? !!
                                                List<CalendarEventData>
                                                    eventsForDB = [];
                                                eventsForDB =
                                                    eventsToCalendarEventData(
                                                        events);

                                                //????????? DB ?????? !!!
                                                // ?????? events ??????
                                                //print('$eventsForDB');

                                                for (int i = 0;
                                                    i < events.length;
                                                    i++) {
                                                  print(
                                                      '???????????? ??? ????????? ?????? ?????? ?????? ${i} : ${events[i].latitude} , ${events[i].longitude}');
                                                }

                                                for (int i = 0;
                                                    i < eventsForDB.length;
                                                    i++) {
                                                  print(
                                                      '???????????? ??? db????????? ?????? ?????? ?????? ${i} : ${eventsForDB[i].latitude} , ${eventsForDB[i].longitude}');
                                                }

                                                //?????? ??????!
                                                if (token == '') {
                                                  //int ???????????? ??? 21???
                                                  token = (Random().nextInt(
                                                              2100000000) +
                                                          1)
                                                      .toString();
                                                }
                                                print(token);
                                                print(token as String);

                                                ReadController read =
                                                    ReadController();
                                                User userData;
                                                try {
                                                  userData = await read
                                                      .fb_read_user(token);
                                                } catch (e) {
                                                  print(token);
                                                  print(token as String);
                                                  userData = User(
                                                    token as String,
                                                    token as String,
                                                    [],
                                                    [],
                                                    [],
                                                    [],
                                                    [],
                                                    [],
                                                  );
                                                }
                                                print(userData.docCode);

                                                userData.travelList
                                                    .add("?????????"); //?????? city ??????
                                                //1??????, 2?????? ????????? ??????
                                                int placeSum = 0;
                                                List<String> placeLi = [];
                                                for (int p = 0;
                                                    p < getPreset().length;
                                                    p++) {
                                                  placeSum +=
                                                      getPreset()[p].length;
                                                  for (int q = 0;
                                                      q < getPreset()[p].length;
                                                      q++) {
                                                    placeLi.add(
                                                        getPreset()[p][q].name);
                                                  }
                                                }
                                                userData.placeNumList
                                                    .add(placeSum);
                                                userData.traveledPlaceList =
                                                    List.from(userData
                                                        .traveledPlaceList)
                                                      ..addAll(placeLi);
                                                userData.eventNumList
                                                    .add(eventsForDB.length);
                                                userData.eventList = List.from(
                                                    userData.eventList)
                                                  ..addAll(eventsForDB);
                                                userData.diaryList.add("null");
                                                fb_write_user(
                                                    userData.docCode,
                                                    userData.name,
                                                    userData.travelList,
                                                    userData.placeNumList,
                                                    userData.traveledPlaceList,
                                                    userData.eventNumList,
                                                    selectedList, //??????????????????, ????????? ??????????????????
                                                    userData.eventList,
                                                    userData.diaryList);

                                                print('pathlist saved');

                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                          content: SizedBox(
                                                              width: 250,
                                                              height: 200,
                                                              child: Column(
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Container(
                                                                        child: Text('Saved as : ' +
                                                                            userData.docCode.toString())),
                                                                  ),
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Container(
                                                                        child: Text('?????? ???????????? ???????????????.',
                                                                            style: TextStyle(
                                                                              fontFamily: "Neo",
                                                                            ))),
                                                                  ),
                                                                ],
                                                              )));
                                                    });
                                                //sleep(Duration(seconds: 3));
                                                Navigator.popUntil(context,
                                                    (route) => route.isFirst);
                                                //??????????????? ?????????????????????
                                              },
                                              child: Text("?????? ??????",
                                                  style: TextStyle(
                                                    fontFamily: "Neo",
                                                    //letterSpacing: 2.0,
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  )))),
                                    )
                                  ])),
                            );
                          });
                    },
                    child: Icon(Icons.save)),
                // TextButton(
                //     onPressed: () {
                //       Navigator.popUntil(context, (route) => route.isFirst);
                //       //??????????????? ?????????????????????
                //     },
                //     child: Image.asset(IconsPath.house,
                //         fit: BoxFit.contain, height: 30)),
              ],
            ),
            floatingActionButton: Stack(children: [
              Align(
                  alignment: Alignment(
                      Alignment.bottomRight.x, Alignment.bottomRight.y - 0.1),
                  child: FloatingActionButton(
                    backgroundColor: Color.fromARGB(255, 102, 202, 252),
                    child: Icon(Icons.add),
                    elevation: 8,
                    onPressed: () async {
                      final event = await context
                          .pushRoute<CalendarEventData<Event>>(CreateEventPage(
                        getPreset: getPreset,
                        transit: widget.transit,
                        getEvents: getEvents,
                        currentDate: widget.currentDate,
                        getMovingTimeList: getMovingTimeList,
                        withDuration: true,
                      ));
                      if (event == null) return;
                      CalendarControllerProvider.of<Event>(context)
                          .controller
                          .add(event);
                    },
                  )),
            ]),
            body:  DayViewWidget(
              transit: widget.transit,
              getPreset: getPreset,
              getEvents: getEvents,
              getMovingTimeList: getMovingTimeList,
              getMovingStepsList: getMovingStepsList,
            )));
  }
}

class DayViewWidget extends StatefulWidget {
  final GlobalKey<DayViewState>? state;
  final double? width;

  final Function() getPreset;
  final Function() getEvents;
  final Function() getMovingTimeList;
  final Function() getMovingStepsList;

  int transit = 0;

  DayViewWidget({
    Key? key,
    this.state,
    this.width,
    required this.transit,
    required this.getPreset,
    required this.getEvents,
    required this.getMovingTimeList,
    required this.getMovingStepsList,
  }) : super(key: key);

  @override
  _DayViewWidgetState createState() => _DayViewWidgetState();
}




class _DayViewWidgetState extends State<DayViewWidget> {
  late List<CalendarEventData<Event>> events = widget.getEvents();
  late List<List<String>> movingSteps = widget.getMovingStepsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: DayView<Event>(
      minDay: startDay,
      maxDay: endDay,
      key: widget.state,
      width: widget.width,
      onEventTap: (event, date) async {
        if (event[0].title == '????????????') {
          //????????? ?????? ??????

          int mealIndex = 0;

          for (int i = 0; i < events.length; i++) {
            if (event[0].startTime.compareTo(events[i].startTime) == 0) {
              mealIndex = i;
            }
          }

          if ((mealIndex - 2) >= 0 && (mealIndex + 2) < events.length) {
            double lat1 = events[mealIndex - 2].latitude;
            double lon1 = events[mealIndex - 2].longitude;
            double lat2 = events[mealIndex + 2].latitude;
            double lon2 = events[mealIndex + 2].longitude;

            List<Restaurant> restList =
                await getRestaurant(lat1, lon1, lat2, lon2);
            for (int i = 0; i < restList.length; i++) {
              print('${restList[i].restName}\n');
            }
            //map.addRestMarker(restList);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => FoodRecommend(restList, mealIndex, events, widget.transit)));
          } else {
            print("?????? ???????????? ????????????.");
          }
        } else if (event[0].title == '??????') {


          /*
          for(int i=0; i<movingSteps.length; i++){
            for(int j=0; j<movingSteps[i].length; j++){
              print("???????????? ${i},${j} : ${movingSteps[i][j]} ");
            }
          }*/

          String movingStep = '';
          int movingIndex = 0;
          int movingDayIndex = 0;
          int movingIndexInDay = 0; //?????? ????????? ???????????????
          int numPlaces = 0; //?????? ???????????? ????????? ??????
          int numMeals = 0; //?????? ???????????? ???????????? ??????
          bool afterMeal = false;

          //??? ??????????????? ????????????????????? ????????? ?????????????????? ????????????
          for(int i=0; i<events.length; i++){
            if(events[i].startTime.compareTo(event[0].startTime)==0){
              movingIndex = i; //??? ??????????????? ????????????????????? ????????? ?????????????????? ????????????
            }
          }

          //??? ??????????????? ???????????? ?????????????????? ???????????? ?????? = 0
          movingDayIndex = event[0].date.difference(events[0].date).inDays;
          print('movingDayIndex = ${movingDayIndex}');

          //??? ??? ????????? ??????????????? ????????????
          for(int i=0;i<movingIndex; i++){
            if(events[i].date.day == event[0].date.day){
              movingIndexInDay = movingIndexInDay + 1;

            }
          }

          //??? ??? ????????? ?????? ??????
          for(int i=0; i<movingIndex; i++){
            if(events[i].title != '????????????' && events[i].title != '??????' && events[i].date.compareTo(event[0].date) == 0){
              numPlaces = numPlaces + 1;
            }
          }

          //???????????? ?????? ??????
          for(int i=0; i<movingIndex; i++){
            if(events[i].title == '????????????' && events[i].date.compareTo(event[0].date) == 0){
              numMeals = numMeals + 1;
            }
          }

          //?????? ?????? ??????????????????
          if(events[movingIndex-1].title == '????????????'){
            afterMeal = true;
          }

          print("??? ??? ????????? ????????? ? ${movingIndexInDay}");
          print("??? ??? ????????? ?????? ??????? ${numPlaces}");
          print("??? ??? ???????????? ?????? ??????? ${numMeals}");

          //????????? ???????????? ?????? ?????????

          if(afterMeal){
            movingStep = '?????? ????????? ???????????? ?????? ?????? ????????? ????????? ??? ????????????.';
          }
          else{
          movingStep = movingSteps[movingDayIndex][movingIndexInDay - numPlaces - 2*(numMeals)];
          print(movingStep);}

          if(widget.transit == 1){
          showDialog(context: context,
              barrierDismissible: true,
              builder: (BuildContext context){
            return AlertDialog(
              content: SizedBox(
                height: 350,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(child:Text(movingStep))
                )
              )
            );
              });}


        } else {
          String tourInformation = '';
          tourInformation = await getTourInfo(event[0].title);

          showDialog(
              context: context,
              barrierDismissible: true,
              builder: (BuildContext context) {
                return AlertDialog(
                    content: SizedBox(
                        height: 350,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(children: [
                              Container(child: Text(tourInformation)),
                              Container(

                                  child: ElevatedButton(
                                    child: Text("?????? ??????"),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewPhoto(
                                              )));
                                    },

                                  )

                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 240, 0, 0),
                                  child: ElevatedButton(
                                      child: Text("???????????? ??????"),
                                      onPressed: () async {
                                        //pathlist?????? ???????????? ???????????? ?????????

                                        List<List<Place>> presetToBeUpdated =
                                            widget.getPreset();
                                        List<CalendarEventData<Event>>
                                            eventsToBeUpdated =
                                            widget.getEvents();
                                        List<List<Place>> presetUpdated = [
                                          for (int i = 0;
                                              i < presetToBeUpdated.length;
                                              i++)
                                            []
                                        ];

                                        int indexPreset = 0;
                                        int indexEvents = 0;
                                        int indexPath = 0;

                                        for (int i = 0;
                                            i < eventsToBeUpdated.length;
                                            i++) {
                                          if (eventsToBeUpdated[i].title ==
                                              event[0].title) {
                                            eventsToBeUpdated.removeAt(i);
                                          }
                                        }

                                        while (indexEvents <
                                                eventsToBeUpdated.length &&
                                            indexPreset <
                                                presetToBeUpdated.length) {
                                          print("while");
                                          if (eventsToBeUpdated[indexEvents]
                                                  .title ==
                                              '????????????') {
                                            indexEvents++;
                                          } else if (eventsToBeUpdated[
                                                      indexEvents]
                                                  .title ==
                                              '??????') {
                                            indexEvents++;
                                          } else {
                                            if (eventsToBeUpdated[indexEvents]
                                                    .title !=
                                                presetToBeUpdated[indexPreset]
                                                        [indexPath]
                                                    .name) {
                                              indexPath++;

                                              if (indexPath >=
                                                  presetToBeUpdated[indexPreset]
                                                      .length) {
                                                indexPreset++;
                                                indexPath = 0;
                                              }
                                            } else {
                                              presetUpdated[indexPreset].add(
                                                  presetToBeUpdated[indexPreset]
                                                      [indexPath]);
                                              indexEvents++;
                                              indexPath++;

                                              print("???????????????");

                                              if (indexPath >=
                                                  presetToBeUpdated[indexPreset]
                                                      .length) {
                                                indexPreset++;
                                                indexPath = 0;
                                              }
                                            }
                                          }
                                        }


                                        setState(() {
                                          course_selected = presetUpdated;
                                          //map.addMarker(presetUpdated[course_selected_day_index]);
                                          //map.addPoly(presetUpdated[course_selected_day_index]);
                                        });

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => LoadingTimeTable(
                                                      presetUpdated,

                                                     widget.transit,
                                                  eventsToBeUpdated[0].startTime.hour,
                                                eventsToBeUpdated[eventsToBeUpdated.length-1].endTime.hour,

                                                    )));

                                        print("pathlist updated");
                                        print(event);
                                      })),
                            ]))));
              });
        }
      },
      showLiveTimeLineInAllDays: false,
    ));
  }
}

class CreateEventPage extends StatefulWidget {
  final bool withDuration;
  final void Function(CalendarEventData<Event>)? onEventAdd;

  DateTime currentDate;

  final Function() getPreset;
  final Function() getEvents;
  final Function() getMovingTimeList;

  int transit = 0;

  CreateEventPage(
      {Key? key,
      this.withDuration = false,
      required this.getPreset,
      required this.transit,
      required this.getMovingTimeList,
      required this.getEvents,
      required this.currentDate,
      this.onEventAdd})
      : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  DateTime _startDate = startDay.add(Duration(days: course_selected_day_index));
  //late DateTime _endDate;

  List<CalendarEventData<Event>> events = [];
  List<List<Place>> preset = [];

  String newPlaceName = '';
  double newPlaceLat = 0;
  double newPlaceLon = 0;

  late DateTime _startTime;

  late DateTime _endTime;

  int placeNum = 0; //???????????? ?????????

  Duration spendingTime = Duration(hours:1); //????????????

  String _title = "";

  double _latitude = 0;

  double _longitude = 0;

  String _description = "";

  Color _color = Colors.blue;

  String _titleNode = '';

  int numPlaces = 0; // ??? ??? ???????????? ????????? ???

  late FocusNode _descriptionNode;

  late FocusNode _dateNode;

  final  _form = GlobalKey<FormState>();

  //late TextEditingController _startDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  //late TextEditingController _endDateController;

  TextEditingController placeNumController = TextEditingController();
  TextEditingController spendingTimeController = TextEditingController();

  String _when = '';
  String _whenResult = '';

  /*
  void _createEvent() {
    if (!(_form.currentState?.validate() ?? true)) return;

    _form.currentState?.save();

    final event = CalendarEventData<Event>(
      date: widget.currentDate,
      color: _color,
      endTime: _endTime,
      startTime: _startTime,
      description: _description,
      endDate: widget.currentDate,
      title: _title,
      event: Event(
        title: _title,
      ),
    );

    widget.onEventAdd?.call(event);
    _resetForm();
  }*/

  /*

  void _resetForm() {
    _form.currentState?.reset();
    //_startDateController.text = "";
    _endTimeController.text = "";
    _startTimeController.text = "";
  }
*/

  void _displayColorPicker() {
    var color = _color;
    showDialog(
      context: context,
      useSafeArea: true,
      barrierColor: Colors.black26,
      builder: (_) => SimpleDialog(
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(
            color: AppColors.bluishGrey,
            width: 2,
          ),
        ),
        contentPadding: EdgeInsets.all(20.0),
        children: [
          Text(
            "Event Color",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 25.0,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0),
            height: 1.0,
            color: AppColors.bluishGrey,
          ),
          ColorPicker(
            displayThumbColor: true,
            enableAlpha: false,
            pickerColor: _color,
            onColorChanged: (c) {
              color = c;
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
              child: CustomButton(
                title: "Select",
                onTap: () {
                  if (mounted)
                    setState(() {
                      _color = color;
                    });
                  context.pop();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    events = widget.getEvents();
    preset = widget.getPreset();

    numPlaces = preset[course_selected_day_index].length ;




    _descriptionNode = FocusNode();
    _dateNode = FocusNode();

    //_startDateController = TextEditingController();
    //_endDateController = TextEditingController();
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    placeNumController = TextEditingController();
    spendingTimeController = TextEditingController();
  }

  _saveForm() {


      _form.currentState?.save();
      setState(() {
        _whenResult = _when;
      });

  }

  @override
  void dispose() {
    _descriptionNode.dispose();
    _dateNode.dispose();

    //_startDateController.dispose();
    //_endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();

    super.dispose();
  }

  String location3 = "????????? ??????????????????";
  @override
  Widget build(BuildContext context) {
    _TimetableState? parent =
        context.findAncestorStateOfType<_TimetableState>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true, // ?????? ????????? ??????
        title: InkWell(
          onTap: () {
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                  onTap: () async {
                    var place = await PlacesAutocomplete.show(
                      context: context,
                      apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                      mode: Mode.overlay,
                      language: "kr",
                      //types: [],
                      //strictbounds: false,
                      components: [Component(Component.country, 'kr')],
                      //google_map_webservice package
                      //onError: (err){
                      //  print(err);
                      //},
                    );

                    if (place != null) {
                      setState(() {
                        location3 = place.description.toString();
                      });

                      //form google_maps_webservice package
                      final plist = GoogleMapsPlaces(
                        apiKey: 'AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI',
                        apiHeaders: await GoogleApiHeaders().getHeaders(),
                        //from google_api_headers package
                      );

                      String placeid = place.placeId ?? "0";
                      final detail = await plist.getDetailsByPlaceId(placeid);
                      final geometry = detail.result.geometry!;
                      final lat = geometry.location.lat;
                      final lang = geometry.location.lng;
                      var newlatlang = LatLng(lat, lang);
                      //latLen.add(newlatlang);

                      //move map camera to selected place with animation
                      //mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                      var places = location3.split(', ');
                      String placeName = places[places.length - 1];

                      //????????? ???????????? ?????????, ??????, ??????
                      _title = placeName;
                      _latitude = lat;
                      _longitude = lang;

                      //newPlace??? ??????
                      newPlaceLat = lat;
                      newPlaceLon = lang;

                      print(_title);

                      placeList.add(Place(
                          placeName,
                          lat,
                          lang,
                          60,
                          20,
                          selectedList[0],
                          selectedList[1],
                          selectedList[2],
                          selectedList[3],
                          selectedList[4]));
                      setState(() {});
                      setState(() {});
                    } else {
                      setState(() {
                        location3 = "????????? ??????????????????";
                      });
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.all(0),
                          width: MediaQuery.of(context).size.width - 40,
                          child: ListTile(
                            title: Text(
                              location3,
                              style: TextStyle(fontSize: 18),
                            ),
                            trailing: Icon(Icons.search),
                            dense: true,
                          )),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text('?????? : ' +
                          '${_startDate.year}' +
                          '-' +
                          '${_startDate.month}' +
                          '-' +
                          '${_startDate.day}')),
                  SizedBox(width: 20.0),
                ],
              ),
              SizedBox(
                height: 15,
              ),


                  Container(
                    width:300,
                    height: 80,

                    child: DropDownFormField(

                      titleText: '???????????? ???????????? ?????????????',
                      hintText: '??????????????????',
                      value: _when,
                      onSaved: (value){
                        setState(() {
                          _when = value;
                        });
                      },
                        onChanged: (value){
                        setState(() {
                          _when = value;
                        });
                        },
                      dataSource: [
                        for(int i=0; i<numPlaces+1; i++)
                          {
                            "display" : "${i+1}",
                            "value" : '${i}' // 0????????? ?????????
                          }
                      ],
                      textField: "display",
                      valueField: "value"




                    )

                  )

                  /*
                  Expanded(
                    child: DateTimeSelectorFormField(
                      controller: _startTimeController,
                      decoration: AppConstants.inputDecoration.copyWith(
                        labelText: "?????? ??????",
                      ),
                      validator: (value) {
                        if (value == null || value == "")
                          return "Please select start time.";

                        return null;
                      },
                      onSave: (date) => _startTime = date,
                      textStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: 17.0,
                      ),
                      type: DateTimeSelectionType.time,
                    ),
                  )

                   */


                  ,SizedBox(width: 20.0),

              TextFormField(

                  controller: spendingTimeController,

                  decoration: InputDecoration(

                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      hintText: '???????????? ????????? ????????????????',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ))

              )

        /*
        Expanded(
                    child: DateTimeSelectorFormField(
                      controller: _endTimeController,
                      decoration: AppConstants.inputDecoration.copyWith(
                        labelText: "?????? ??????",
                      ),
                      validator: (value) {
                        if (value == null || value == "")
                          return "Please select end time.";

                        return null;
                      },
                      onSave: (date) => _endTime = date,
                      textStyle: TextStyle(
                        color: AppColors.black,
                        fontSize: 17.0,
                      ),
                      type: DateTimeSelectionType.time,
                    ),
                  )
              */
              ,



              SizedBox(
                height: 15,
              )

              /*
          TextFormField(
            focusNode: _descriptionNode,
            style: TextStyle(
              color: AppColors.black,
              fontSize: 17.0,
            ),
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            selectionControls: MaterialTextSelectionControls(),
            minLines: 1,
            maxLines: 10,
            maxLength: 1000,
            validator: (value) {
              if (value == null || value.trim() == "")
                return "Please enter event description.";

              return null;
            },
            onSaved: (value) => _description = value?.trim() ?? "",
            decoration: AppConstants.inputDecoration.copyWith(
              hintText: "Event Description",
            ),
          )
          */
              ,
              SizedBox(
                height: 15.0,
              ),
              Row(
                children: [
                  Text(
                    "??????: ",
                    style: TextStyle(
                      color: AppColors.black,
                      fontSize: 17,
                    ),
                  ),
                  GestureDetector(
                    onTap: _displayColorPicker,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: _color,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Container(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                      child: Text('????????? ??????',
                          style: TextStyle(
                            fontFamily: "Neo",
                            //letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: () async {
                        _form.currentState?.save();
                        _saveForm();

                        print(_whenResult);
                        print(spendingTimeController.text);

/*

                        final newEvent = CalendarEventData<Event>(
                          date: _startDate,
                          color: _color,
                          endTime: _endTime,
                          startTime: _startTime,
                          description: _description,
                          title: _title,
                          latitude: _latitude,
                          longitude: _longitude,
                          event: Event(
                            title: _title,
                          ),
                        );

                        print('${newEvent.date}');
                        print(newEvent.title);
                        print("${newEvent.startTime}");
                        print("${newEvent.endTime}");

                        //newEvent ???????????? ??????.

                        List<List<Place>> presetToBeUpdated =
                            widget.getPreset();
                        print(presetToBeUpdated);
                        //?????? ?????? ?????? ??????

                        List<CalendarEventData<Event>> eventsToBeUpdated =
                            widget.getEvents();
                        print(eventsToBeUpdated);
                        //?????? ?????????????????? ?????? ??????

                        CalendarEventData<Event> eventBefore =
                            CalendarEventData(
                                title: 'dummy',
                                date: DateTime.now(),
                                latitude: 0,
                                longitude: 0,
                                startTime: DateTime.now(),
                                endTime:
                                    DateTime.now().add(Duration(hours: 1)));
                        CalendarEventData<Event> eventAfter = CalendarEventData(
                            title: 'dummy',
                            latitude: 0,
                            longitude: 0,
                            date: DateTime.now(),
                            startTime: DateTime.now(),
                            endTime: DateTime.now().add(Duration(hours: 1)));

                        Place newPlace = Place(
                            '${newEvent.title}',
                            newPlaceLat,
                            newPlaceLon,
                            _endTime.difference(_startTime).inMinutes,
                            30,
                            [10, 20, 30, 40, 50, 60, 70],
                            [10, 20, 30, 40, 50],
                            [10, 20, 30, 40, 50, 60],
                            [10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110],
                            [10, 20, 30, 40]);

                        print(newPlace);
                        //newPlace ?????? ??????

                        /*
                        //eventAfter ??????
                    for(int i=0; i< eventsToBeUpdated.length; i++){

                      if(newEvent.date.year == eventsToBeUpdated[i].date.year && newEvent.date.month == eventsToBeUpdated[i].date.month && newEvent.date.day == eventsToBeUpdated[i].date.day ){

                        if(newEvent.startTime.hour > eventsToBeUpdated[i].startTime.hour && newEvent.startTime.hour < eventsToBeUpdated[i+1].startTime.hour){

                          eventBefore = eventsToBeUpdated[i];
                          eventAfter = eventsToBeUpdated[i+1];

                          print(eventBefore);
                          print(eventAfter);

                        }

                      }

                    }*/



                        //eventBefore ??????

                        for (int i = 0; i < eventsToBeUpdated.length; i++) {
                          if (newEvent.date.year ==
                                  eventsToBeUpdated[i].date.year &&
                              newEvent.date.month ==
                                  eventsToBeUpdated[i].date.month &&
                              newEvent.date.day ==
                                  eventsToBeUpdated[i].date.day) {
                            if (eventsToBeUpdated[i].title != '????????????' &&
                                eventsToBeUpdated[i].title != '??????') {
                              if (eventsToBeUpdated[i].startTime.hour <
                                  newEvent.startTime.hour) {
                                eventBefore = eventsToBeUpdated[i];
                                print(eventBefore.title);
                                //eventBefore ?????? ??????
                              }
                            }
                          }
                        }

                        if(eventBefore.title == 'dummy'){

                          // ????????? ???????????????..

                        }

                        if (presetToBeUpdated[course_selected_day_index]
                                .length ==
                            0) {
                          presetToBeUpdated[course_selected_day_index]
                              .add(newPlace);
                          print("path created");
                          print(presetToBeUpdated);
                        } else {
                          for (int i = 0; i < presetToBeUpdated.length; i++) {
                            for (int j = 0;
                                j < presetToBeUpdated[i].length;
                                j++) {
                              if (presetToBeUpdated[i][j].name ==
                                  eventBefore.title) {
                                presetToBeUpdated[i].insert(j + 1, newPlace);

                                print("path updated");
                                print(presetToBeUpdated);
                              }
                            }
                          }
                        }
                        */

                        int newPlaceIndex = int.parse(_when); //???????????? ???????????????
                        int newTakenTime = int.parse(spendingTimeController.text);
                        List<List<Place>> presetToBeUpdated = preset;

                        Place newPlace = Place(
                          _title,
                          _latitude,
                          _longitude,
                          newTakenTime,
                            30,
                            [0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                            [0, 0, 0, 0]


                        );

                        //???????????? ????????? ????????? ??????
                        presetToBeUpdated[course_selected_day_index].insert(newPlaceIndex,newPlace);


                        //print(movingTimeList);


                        setState(() {
                          course_selected = presetToBeUpdated;
                          //map.addMarker(presetToBeUpdated[course_selected_day_index]);
                          //map.addPoly(presetToBeUpdated[course_selected_day_index]);
                        });



                        int startT = 0;
                        int endT = 0;

                        if(events.length == 0){
                          startT = dayStartingTime.hour;
                          endT = dayEndingTime.hour;
                        }

                        else{
                          startT = events[0].startTime.hour;
                          endT = events[events.length-1].startTime.hour;

                        }

                        print(startT);
                        print(endT);



                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoadingTimeTable(
                                      presetToBeUpdated,

                                     widget.transit,
                                 startT,
                                endT,

                                    )));
                      }),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
