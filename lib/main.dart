import 'package:flutter/material.dart';
import 'package:law_app/screens/main_page.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/fade_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*void main() => runApp(MyApp());*/

void main() {
  runApp(new MaterialApp(
    title: 'Монгол Улсын Үндсэн хууль',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Color(0xff1b4392), fontFamily: 'RobotoMono'),
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  static const textColor = Color(0xff1b4392);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  _read(versionRest) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'isUpdate';
    final version = 'version';
    final value = prefs.getString(version) ?? "1";
    if (versionRest == value) {}
    //final isUpdate
  }

  @override
  void initState() {
    super.initState();
    BackendService.getContentId(6).then((content) {
      _read(content?.slug ?? "");
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Law',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: MyApp.textColor, fontFamily: 'Fregat'),
      home: MainPage(),
    );
  }
}
