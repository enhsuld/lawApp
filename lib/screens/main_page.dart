import 'package:app_version_update/app_version_update.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:law_app/items/TermItem.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  static const int PAGE_SIZE = 10;

  var publishedTerms = <TermOnlyModel>[];
  bool _isLoading = true;

  _read() async {
    try {
      final terms = await BackendService.getTerm(1, PAGE_SIZE);
      if (mounted) {
        setState(() {
          publishedTerms = terms;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _verifyVersion() async {
    if (kDebugMode) return;
    try {
      await AppVersionUpdate.checkForUpdates(
              appleId: '1507881332',
              playStoreId: 'mn.law.constitution',
              country: 'mn')
          .then((data) async {
        if (data.canUpdate == true && mounted) {
          // await AppVersionUpdate.showBottomSheetUpdate(context: context, appVersionResult: appVersionResult)
          // await AppVersionUpdate.showPageUpdate(context: context, appVersionResult: appVersionResult)
          await AppVersionUpdate.showAlertUpdate(
            appVersionResult: data,
            context: context,
            backgroundColor: Colors.grey[200],
            title: 'Мэдэгдэл',
            mandatory: false,
            content: 'Шинэ хувилбар гарсан байна. Шинэчилнэ үү',
            updateButtonText: 'Татах',
            cancelButtonText: 'Үгүй',
            titleTextStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 24.0),
            contentTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          );
        }
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    _read();
    _verifyVersion();
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
                child: _isLoading && publishedTerms.isEmpty
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                            left: 25, right: 25, top: 10, bottom: 10),
                        physics: BouncingScrollPhysics(),
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

  @override
  void dispose() {
    super.dispose();
  }
}
