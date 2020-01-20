import 'package:flutter/material.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/models/termChild.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';

class AdditionDetailPage extends StatefulWidget {
  final TermOnlyModel term;

  AdditionDetailPage({Key key, this.term});

  _AdditionDetailPageState createState() => _AdditionDetailPageState();
}

class _AdditionDetailPageState extends State<AdditionDetailPage> {
  static const int PAGE_SIZE = 10;
  // List<TermModel> publishedTerms = [];
  TermChildModel publishedTerms;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();

    BackendService.getTermById(widget.term.id).then((terms) {
      setState(() {
        this.publishedTerms = terms;
        isLoad = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xff1b4392),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          (widget.term?.name ?? "") + " оны " + widget.term?.slug ?? "",
          style: TextStyle(
              color: Color(0xff1b4392),
              fontSize: 20,
              fontWeight: FontWeight.normal),
        ),
      ),
      body: isLoad
          ? Container(
              child: ListView(
                padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                children:
                    List.generate(publishedTerms.cntTerms.length, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: RawMaterialButton(
                      onPressed: () {},
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                publishedTerms.cntTerms[index].slug,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                    color: ColorLaw.blue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Text(
                                  "өөрчлөн найруулсан".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Улсын Их Хурлын чуулганы нэгдсэн болон Байнгын хорооны хуралдааныг гишүүдийн олонхи нь хүрэлцэн ирснээр хүчинтэйд үзэж, Үндсэн хуульд өөрөөр заагаагүй бол хуралдаанд оролцсон гишүүдийн олонхийн саналаар асуудлыг шийдвэрлэнэ. Үндсэн хуульд өөрөөр заагаагүй бол хуулийг Улсын Их Хурлын нийт гишүүний олонхийн саналаар батална.",
                            textAlign: TextAlign.justify,
                          ),
                          SizedBox(height: 15),
                          Divider(color: Colors.grey)
                        ],
                      ),
                    ),
                  );
                }),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
