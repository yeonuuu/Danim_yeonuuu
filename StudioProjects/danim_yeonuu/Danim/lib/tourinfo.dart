import 'package:danim/route.dart';
import "package:http/http.dart" as http;
import 'dart:convert';

String tourIDURL='http://apis.data.go.kr/B551011/KorService/searchKeyword?serviceKey=';
String tourAPIKey='cpdbSNlDtCFQ3vwzm3k4z7MGFhllBYrChw7LONQgQL%2BV69GVfExYYQgM0%2BRapks5ABcZSke4TeBbmN%2FCINcfLQ%3D%3D';
String tourInfoURL='http://apis.data.go.kr/B551011/KorService/detailCommon?serviceKey=';
String placesURL='https://maps.googleapis.com/maps/api/place/details/json?';
String placesKey='AIzaSyD0em7tm03lJXoj4TK47TcunmqfjDwHGcI';
String findURL='https://maps.googleapis.com/maps/api/place/findplacefromtext/json?';


List<String> photoList=[];

Future<String> getPlaceID(String placeName) async {
  String placeID='';
  http.Response response = await http.get(Uri.parse(
      '${findURL}input=제주도 $placeName&inputtype=textquery&fields=place_id&key=$placesKey'
  ),
  );
  if (response.statusCode < 200 || response.statusCode > 400) {
    placeID = ''; // Error 반환
  } else {
    String responseData = utf8.decode(response.bodyBytes);
    var responseBody = jsonDecode(responseData);
    String status=responseBody['status'];
    if (status.compareTo('OK')==0) {
      placeID=responseBody['candidates'][0]['place_id'];
    }
    else {
      placeID='';
    }
  }
  return placeID;
}

Future<String> getTourInfo(String placeName) async {
  String placeID=await getPlaceID(placeName);
  String contentOverview='';
  if (placeID=='') {
    contentOverview='정보가 없습니다.';
  }
  else {
    http.Response response = await http.get(Uri.parse(
        '${placesURL}place_id=$placeID&fields=editorial_summary,current_opening_hours,reviews,rating,photo&language=ko&key=$placesKey'
    ),
    );
    if (response.statusCode < 200 || response.statusCode > 400) {
      contentOverview='정보가 없습니다.'; // Error 반환
    } else {
      String responseData = utf8.decode(response.bodyBytes);
      var responseBody = jsonDecode(responseData);
      String status=responseBody['status'];
      String summary='요약정보 : ';
      String rating='\n별점 : ';
      String openingHours='\n운영 시간\n';
      String reviews='\n\n';
      if (status.compareTo('OK')==0) {
        var list=responseBody["result"];
        try {
          summary+=list["editorial_summary"]["overview"];
          summary+='\n';
        } catch(e) {
          summary='';
        }
        try {
          if (list["rating"].toString().compareTo('null')==0) {
            rating='';
          }
          else {
            rating +=list["rating"].toString();
            rating +=' / 5\n';
          }
        }catch(e) {
          rating='';
        }


        try {
          for (int i=0;i<list["current_opening_hours"]["weekday_text"].length;i++) {
            openingHours += list["current_opening_hours"]["weekday_text"][i].toString();
            openingHours += '\n';
          }
        } catch (e) {
          openingHours='';
        }
        try {
          for (int i=0;i<list["reviews"].length;i++) {
            reviews += '리뷰 ${i+1}\n';
            reviews += list["reviews"][i]["text"].toString();
            reviews += '\n\n\n';/*리뷰 2\n';
            reviews += list["reviews"][1]["text"].toString();
            reviews += '\n\n\n리뷰 3\n';
            reviews += list["reviews"][2]["text"].toString();*/
          }
        }catch(e) {
          reviews='';
        }
        contentOverview=summary+rating+openingHours+reviews;
        photoList.clear();
        try {
          for (int i=0;i<list["photos"].length;i++) {
            photoList.add(list["photos"][i]["photo_reference"]);
          }
        }catch(e) {
          photoList.clear();
        }
      }
      else {
        contentOverview='정보가 없습니다.';
      }
    }
  }

  return contentOverview;
}