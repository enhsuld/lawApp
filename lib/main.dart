import 'package:flutter/material.dart';
import 'package:law_app/screens/main_page.dart';
import 'package:law_app/utils/fade_route.dart';
import 'package:splashscreen/splashscreen.dart';

/*void main() => runApp(MyApp());*/

void main() {

  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Color(0xff1b4392), fontFamily: 'RobotoMono'),
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static const textColor = Color(0xff1b4392);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mn Constitution',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: textColor, fontFamily: 'RobotoMono'),
      home: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: MainPage(),
        imageBackground:
        ExactAssetImage('assets/images/Default-896h@2x_iphone.png'),
        gradientBackground: new LinearGradient(
            colors: [Colors.cyan, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 100.0,
        onClick: () => Navigator.of(context)
            .push(FadeRoute(builder: (context) => MainPage())),
        loaderColor: Colors.red,
      ),
    );
  }
}

