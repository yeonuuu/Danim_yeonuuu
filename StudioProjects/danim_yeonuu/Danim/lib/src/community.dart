import 'package:danim/calendar_view.dart';
import 'package:danim/firebase_read_write.dart';
import 'package:danim/src/writtenPost.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:danim/components/image_data.dart';
import 'package:flutter/services.dart';
import 'package:danim/src/preset.dart';
import 'package:intl/intl.dart';
//import 'package:danim/src/exampleResource.dart';
import 'package:danim/src/app.dart';
import 'package:danim/src/place.dart';
import 'package:danim/src/post.dart';
import '../model/event.dart';

import 'myJourney.dart';
import 'newPost.dart';

var posts; //List<Post>가 들어올 변수

Future readPostData() async {
  var read = ReadController();

  posts = await read.fb_read_all_post(); // List<Post>
}

// class Post {
//   String postTitle = ""; // 게시물 제목
//   int postNum = 0; // 게시물 넘버
//   String? postWriter = ""; // 작성자 이름
//   List<String> commentList = []; // 댓글 리스트
//   List<String?> commentWriterList = []; // 댓글 작성자 리스트
//   List<String?> recommendList = []; // 좋아요 누른 사람 리스트
//   int recommendNum = 0;
//   String postContent = '';

//   Post(
//       this.postTitle,
//       this.postNum,
//       this.postWriter,
//       this.commentList,
//       this.commentWriterList,
//       this.recommendList,
//       this.recommendNum,
//       this.postContent); // 좋아요 수
// }

//List<Post> posts = [];

/*
  //Post 객체 구성 - readData[0], readData[1] 이런식으로 쓰면 돼!
  String postTitle = ""; // 게시물 제목
  int postNum = 0; // 게시물 넘버
  String postWriter = ""; // 작성자 이름
  List<String> commentList = []; // 댓글 리스트
  List<String> commentWriterList = []; // 댓글 작성자 리스트
  List<String> recommendList = []; // 좋아요 누른 사람 리스트
  int recommendNum = 0; // 좋아요 수

  postNum는 length써서 추가할 것 -? 이게 무슨 말? -> fb_add_post로 게시물 추가할 때, 
  List<Post> posts의 크기를 length써서 센 다음, 거기서 +1 하면 추가될 게시물의 넘버가 되니까, 그거를 DB에 입력하라는 거임 ㅇㅇ


  //사용 가능한 함수

  fb_add_post(postTitle, postNum, postWriter, postContent) // 게시글 추가 - 게시글 제목, 게시글 넘버, 작성자, 게시글 내용

  fb_add_comment(postTitle, comment, commentWriterList) // 댓글 추가 - 게시글 제목, 댓글 내용, 댓글 작성자 리스트

  fb_add_recommend(postTitle, recommender, recommendNum)  // 좋아요 추가 - 게시글 제목, 누른사람, 기존 좋아요 개수

  삭제는 구현 안함 그냥!
*/

class Community extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popUntil(context, (route) => route.isFirst);
        //첫화면까지 팝해버리는거임
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true, // 앱바 가운데 정렬
          title: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            child: Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 40),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                    child: Text('커뮤니티 글 목록',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2.0,
                          fontFamily: 'Neo',
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ))),
                for (int i = 0; i < posts.length; i++)
                  GestureDetector(
                    child: Container(
                      width: double.infinity - 20,
                      // height: 200,
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 2,
                            blurRadius: 2,
                            offset: Offset(3, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 102, 202, 252),
                            child: Text(
                              '${posts[i].postNum + 1}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              '${posts[i].postTitle}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Icon(Icons.navigate_next),
                        ],
                      ),
                    ),
                    onTap: () {
                      print(posts.length);
                      print(i);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WrittenPost(posts[i], i)));
                    },
                  )
              ])),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 102, 202, 252),
          child: Icon(Icons.add),
          elevation: 0,
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewPost()));
          },
        ),
      ),
    );
  }
}
