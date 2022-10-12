import 'package:flutter/material.dart';
import 'package:danim/src/components/image_data.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Image.asset(IconsPath.logo, fit: BoxFit.contain, height: 60)
              ]),
            ),
            endDrawer: Drawer(
                child: ListView(padding: EdgeInsets.zero, children: [
              UserAccountsDrawerHeader(
                  accountName: Text('yeonuuu'),
                  accountEmail: Text('dysqkddnf@gmail.com')),
              ListTile(
                  leading: Icon(Icons.settings, color: Colors.grey),
                  title: Text("설정"),
                  onTap: () => {print("Setting")}),
            ])),
            body: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                  child: ButtonBar(
                      alignment: MainAxisAlignment.center,
                      buttonPadding: EdgeInsets.all(20),
                      children: [
                        ElevatedButton(
                            onPressed: () => {print('new course')},
                            child: Text('새 코스'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(100, 100))),
                        ElevatedButton(
                            onPressed: () => {print('my trip')},
                            child: Text('내 여행'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(100, 100))),
                        ElevatedButton(
                            onPressed: () => {print('community')},
                            child: Text('커뮤니티'),
                            style: ElevatedButton.styleFrom(
                                primary: Colors.lightBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                minimumSize: Size(100, 100)))
                      ])),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                width: 400,
                child: Divider(color: Colors.grey, thickness: 2.0)
              ),

              Column(
                children:[
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Text('# 지금, 당신 근처에',
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 2.0,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,


                        )
                  )

              ),

                  Row(
                    children:[
                      Image.asset(
                          'assets/images/jenu1.jpeg',
                      width: 300, height: 200),
                      Image.asset(
                          'assets/images/jeju2.jpeg',
                          width: 300, height: 200)
                    ]
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      width: 400,
                      child: Divider(color: Colors.grey, thickness: 2.0)
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text('# 만연한 가을, 단풍 속으로',
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,


                          )
                      )

                  ),
                  Row(
                      children:[
                        Image.asset(
                            'assets/images/jeju3.jpeg',
                            width: 300, height: 200),
                        Image.asset(
                            'assets/images/jeju2.jpeg',
                            width: 300, height: 200)
                      ]
                  ),


    ])



            ])),
        onWillPop: () async {
          return false;
        });
  }
}
