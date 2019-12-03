import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:law_app/screens/home_page.dart';
import 'package:law_app/screens/main_page.dart';
import 'package:law_app/utils/fade_route.dart';

Color bgColor = Color(0xFFF3F3F3);
Color textColor = Color(0xFF83838A);
List<String> imagePath = [
  "assets/images/logo@3x.png",
];
List<String> title = ["МОНГОЛ УЛСЫН ҮНДСЭН ХУУЛЬ"];
List<String> description = [
  "Монголын ард түмэн бид улсынхаа тусгаар тогтнол, бүрэн эрхт байдлыг бататган бэхжүүлж, хүний эрх, эрх чөлөө, шударга ёс, үндэснийхээ эв нэгдлийг эрхэмлэн дээдэлж, төрт ёс, түүх, соёлынхоо уламжлалыг нандигнан өвлөж, хүн төрөлхтөний соёл иргэншлийн ололтыг хүндэтгэн үзэж эх орондоо хүмүүнлэг, иргэний ардчилсан нийгэм цогцлуулан хөгжүүлэхийг эрхэм зорилго болгоно.",
];

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ContentPage(),
    );
  }
  @override
  void initState() {
    super.initState();
    startTime();
  }
  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, navigationPage);
  }
  void navigationPage() {
    Navigator.of(context).push(FadeRoute(builder: (context) => MainPage()));
  }
}

class ContentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        CarouselSlider(
          autoPlay: false,
          enableInfiniteScroll: false,
          initialPage: 0,
          reverse: false,
          viewportFraction: 1.0,
          aspectRatio: MediaQuery.of(context).size.aspectRatio,
          height: MediaQuery.of(context).size.height,
          items: [0].map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    child: AppItro(i));
              },
            );
          }).toList(),
        ),
      ],
    ));
  }
}

class AppItro extends StatefulWidget {
  int index;

  AppItro(this.index);

  @override
  _AppItroState createState() => _AppItroState();
}

class _AppItroState extends State<AppItro> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
          //  color: const Color(0xff7c94b6),
            image: DecorationImage(
              image: ExactAssetImage('assets/images/Default-896h@2x_iphone.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
       /*       Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 24),
                height: 50,
                child: Stack(
                  children: <Widget>[
                    Dots(widget.index),
                    Center(
                      child: new Text("Дараах",
                          style: TextStyle(fontFamily: "Avenir", fontSize: 10)),
                    ),
                    Positioned(
                        right: 0,
                        top: widget.index != 0 ? 20 : 0,
                        child: widget.index != 0
                            ? Image.asset(
                                'assets/images/arrow.png',
                                width: 36,
                              )
                            : LetsGo())
                  ],
                ),
              )*/
            ],
          ),
        ),
      ],
    );
  }
}

class Dots extends StatefulWidget {
  int index;

  Dots(this.index);

  @override
  _DotsState createState() => _DotsState();
}

class _DotsState extends State<Dots> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("deneme" + currentPage.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 1,
      itemBuilder: (context, int index) {
        return Container(
            margin: EdgeInsets.only(right: index != 2 ? 4 : 0),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == widget.index ? Colors.black : Colors.white,
                border: Border.all(color: Colors.black)));
      },
    );
  }
}

class LetsGo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: 100,
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 16,
              left: 12,
              child: InkWell(
                child: Text(
                  "Нэвтрэх!",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(FadeRoute(builder: (context) => MainPage()));
                },
              ))
        ],
      ),
    );
  }
}
