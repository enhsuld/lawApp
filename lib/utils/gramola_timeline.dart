// library gramola_timeline;

// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';

// import 'package:flutter_flux/flutter_flux.dart';

// import 'package:law_app/utils/stores.dart';
// import 'package:law_app/utils/timeline_entry_row.dart';

// /// A Calculator.
// class Calculator {
//   /// Returns [value] plus 1.
//   int addOne(int value) => value + 1;
// }

// class EventTimelineComponent extends StatefulWidget {
//   EventTimelineComponent(TimelineConfiguration configuration)
//       : this._configuration = configuration;

//   final TimelineConfiguration _configuration;

//   @override
//   _EventsComponentState createState() =>
//       new _EventsComponentState(this._configuration);
// }

// class _EventsComponentState extends State<EventTimelineComponent>
//     with StoreWatcherMixin<EventTimelineComponent> {
//   final scaffoldKey = new GlobalKey<ScaffoldState>();

//   final GlobalKey<AnimatedListState> _listKey =
//       new GlobalKey<AnimatedListState>();

//   _EventsComponentState(TimelineConfiguration configuration)
//       : this._configuration = configuration;

//   final TimelineConfiguration _configuration;

//   // Never write to these stores directly. Use Actions.
//   TimelineStore timelineStore;

//   @override
//   void initState() {
//     super.initState();

//     // Demonstrates using a custom change handler.
//     timelineStore =
//         listenToStore(timelineStoreToken, handleTimelineStoreChanged);

//     _fetchTimeline();
//   }

//   void handleTimelineStoreChanged(Store value) {
//     setState(() {});
//   }

//   void _fetchTimeline() async {
//     assert(timelineStore != null);
//     try {
//       //setConfiguration(this._configuration);
//       fetchTimelineEntriesRequestAction('');
//       Map<String, dynamic> options = {
//         "path": "/timeline/" +
//             this._configuration.eventId +
//             "/" +
//             this._configuration.userId,
//         "method": "GET",
//         "contentType": "application/json",
//         "timeout":
//             25000 // timeout value specified in milliseconds. Default: 60000 (60s)
//       };
//     } on PlatformException catch (e) {
//       fetchTimelineEntriesFailureAction(e.message);
//       print('PlatformException e: ' + e.toString());
//       _showSnackbar('Error retrieving timeline!');
//     }
//   }

//   void _showSnackbar(String message) {
//     // This is just a demo, so no actual login here.
//     final snackbar = new SnackBar(
//       content: new Text(message),
//     );

//     scaffoldKey.currentState.showSnackBar(snackbar);
//   }

//   void _showAddEntryDialog() {
//     final TextEditingController _titleFieldController =
//         new TextEditingController();
//     final TextEditingController _descriptionFieldController =
//         new TextEditingController();
//     Container formSection = new Container(
//         padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
//         child: new Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             new ListTile(
//               leading: const Icon(Icons.title),
//               title: new TextField(
//                 controller: _titleFieldController,
//                 autocorrect: false,
//                 decoration: new InputDecoration(
//                   hintText: "Title",
//                 ),
//               ),
//             ),
//             new ListTile(
//               leading: const Icon(Icons.description),
//               title: new TextField(
//                 controller: _descriptionFieldController,
//                 autocorrect: false,
//                 decoration: new InputDecoration(
//                   hintText: "Description",
//                 ),
//               ),
//             )
//           ],
//         ));

//     showModalBottomSheet<void>(
//         context: context,
//         builder: (BuildContext context) {
//           return new Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 formSection,
//                 new Container(
//                     padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
//                     child: new RaisedButton(
//                         child: new Text('Add'),
//                         color: Theme.of(context).primaryColor,
//                         textColor: Colors.white,
//                         onPressed: null))
//               ]);
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         key: scaffoldKey,
//         appBar: new AppBar(
//           title: new Text('Timeline'),
//           leading: new IconButton(
//             tooltip: 'Go back',
//             icon: const Icon(Icons.arrow_back),
//             onPressed: () {
//               Navigator.pop(scaffoldKey.currentContext);
//             },
//           ),
//           centerTitle: true,
//         ),
//         body: new Column(children: <Widget>[
//           new Flexible(
//             child: new Container(
//               child: new ListView.builder(
//                   itemCount: timelineStore.timelineEntries.length > 0
//                       ? timelineStore.timelineEntries.length + 1
//                       : 0,
//                   itemBuilder: (_, index) {
//                     if (index < timelineStore.timelineEntries.length) {
//                       return new TimelineEntryRow(
//                           lineColor: Theme.of(context).accentColor,
//                           backgroundColor: Theme.of(context).canvasColor,
//                           imagesBaseUrl: timelineStore.imagesBaseUrl,
//                           entry: timelineStore.timelineEntries[index]);
//                     }
//                     return new TimelineEntryEnding(
//                         color: Theme.of(context).accentColor,
//                         backgroundColor: Theme.of(context).canvasColor);
//                   }),
//             ),
//           )
//         ]),
//         floatingActionButton: new FloatingActionButton(
//             tooltip: 'Add', // used by assistive technologies
//             child: new Icon(Icons.add),
//             onPressed: _showAddEntryDialog));
//   }
// }
