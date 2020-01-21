import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const int PAGE_SIZE = 10;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  var publishedTerms = new List<TermOnlyModel>();
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'isMenu';
    final value = prefs.getBool(key) ?? false;
    print('read: $value');
    // if (value) {
    //   print("offline");
    //   BackendService.getTermOffline(0 + 1, PAGE_SIZE).then((terms) {
    //     setState(() {
    //       this.publishedTerms = terms;
    //       print(terms);
    //     });
    //   });
    // } else {
    //   print("online");
    //   BackendService.getTerm(0 + 1, PAGE_SIZE).then((terms) {
    //     setState(() {
    //       this.publishedTerms = terms;
    //       print(terms);
    //     });
    //   });
    // }
    BackendService.getTerm(0 + 1, PAGE_SIZE).then((terms) {
      setState(() {
        this.publishedTerms = terms;
        print(terms);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _read();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorLaw.blue,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/Home.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              //Text('Connection Status: $_connectionStatus'),
              Container(
                height: 220,
                padding:
                    EdgeInsets.only(top: 80, left: 50, right: 50, bottom: 10),
                child: Image.asset("assets/images/logo_large.png"),
              ),
              Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 10, left: 8, right: 8),
                child: Text(
                  'МОНГОЛ УЛСЫН ҮНДСЭН ХУУЛЬ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26.0,
                    fontFamily: "Fregat",
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/hee_home.png"),
                    // Image.asset("assets/images/hee_home.png"),
                    // Image.asset("assets/images/hee_home.png")
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                // color: Colors.black,
                // height: MediaQuery.of(context).size.height * 0.5,
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                child: ListView.builder(
                  padding:
                      EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: publishedTerms.length,
                  itemBuilder: (ctx, i) {
                    final item = publishedTerms[i];
                    return TermItem(item, i);
                  },
                ),
              ),
            ],
          ),
        ));
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
        setState(() {
          _connectionStatus = "Wifi";
        });
        break;
      case ConnectivityResult.mobile:
        setState(() => _connectionStatus = result.toString());
        break;
      case ConnectivityResult.none:
        setState(() => _connectionStatus = "false");
        break;
      default:
        setState(() => _connectionStatus = 'false');
        break;
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
