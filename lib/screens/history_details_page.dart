import 'package:flutter/material.dart';
import 'package:law_app/models/taxonomy.dart';
import 'package:law_app/services/BackendService.dart';
import 'package:law_app/utils/colorlaw.dart';
import 'package:law_app/utils/timeline_entry_row.dart';

class HistoryDetailsPage extends StatefulWidget {
  final int term;
  HistoryDetailsPage({required this.term});
  _HistoryDetailsPageState createState() => _HistoryDetailsPageState();
}

class _HistoryDetailsPageState extends State<HistoryDetailsPage> {
  static const int PAGE_SIZE = 10;
  final List<TaxonomyModel> _items = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPage();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoading &&
          _hasMore) {
        _loadPage();
      }
    });
  }

  Future<void> _loadPage() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final newItems =
          await BackendService.getHistoryList(widget.term, _page, PAGE_SIZE);
      if (mounted) {
        setState(() {
          _items.addAll(newItems);
          _page++;
          if (newItems.length < PAGE_SIZE) {
            _hasMore = false;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          "Монгол улсын түүх".toUpperCase(),
          style:
              TextStyle(color: Color(0xff1b4392), fontWeight: FontWeight.w700),
        ),
      ),
      body: _items.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : _items.isEmpty && !_hasMore
              ? Center(
                  child: Text(
                    "Мэдээлэл олдсонгүй",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.only(top: 15, bottom: 20),
                  itemCount: _items.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _items.length) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return TimelineEntryRow(
                      lineColor: ColorLaw.blue,
                      backgroundColor: Theme.of(context).canvasColor,
                      imagesBaseUrl: "",
                      entry: _items[index],
                    );
                  },
                ),
    );
  }
}
