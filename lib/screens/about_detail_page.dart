import 'package:flutter/material.dart';
import 'package:law_app/models/term.dart';
import 'package:law_app/models/term1.dart';
import 'package:law_app/models/termChild.dart';
import 'package:law_app/screens/photo_wrapper.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/fade_route.dart';

class AboutDetailPage extends StatefulWidget {
  final TermOnlyModel term;

  AboutDetailPage({Key key, this.term});

  _AboutDetailPageState createState() => _AboutDetailPageState();
}

class _AboutDetailPageState extends State<AboutDetailPage> {
  static const int PAGE_SIZE = 10;
  // List<TermModel> publishedTerms = [];
  List<TermModel> publishedTerms = [];
  TermChildModel term;
  bool verticalGallery = false;
  bool isLoad = false;

  @override
  void initState() {
    super.initState();

    BackendService.getTermById(widget.term.id).then((terms) {
      setState(() {
        this.term = terms;
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
          widget.term.name + " оны " + widget.term.slug,
          style: TextStyle(
              color: Color(0xff1b4392),
              fontSize: 20,
              fontWeight: FontWeight.normal),
        ),
      ),
      body: isLoad
          ? Container(
              padding: EdgeInsets.only(top: 10, left: 15, right: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text(
                      term.cntTerms[0].slug,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18),
                    ),
                    Container(
                      height: 250,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(term.cntTerms[0].medias.length,
                            (index) {
                          TermChildModel _term = term.cntTerms[0];
                          return Card(
                            //height: 250,
                            color: ColorLaw.blue,

                            margin: EdgeInsets.all(10),
                            child: RawMaterialButton(
                              onPressed: () {
                                open(context, index, _term.medias);
                              },
                              child: FadeInImage.assetNetwork(
                                //fadeInCurve: Curves.bounceIn,
                                placeholder: "assets/images/no_image.png",
                                //fit: BoxFit.fitWidth,
                                image:
                                    BackendService.link + _term.medias[index],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void open(BuildContext context, final int index, List<dynamic> _list) {
    print(_list.length);
    Navigator.push(
      context,
      FadeRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: _list,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: verticalGallery ? Axis.vertical : Axis.horizontal,
        ),
      ),
    );
  }
}
