import 'dart:async';

import 'package:flutter/material.dart';

typedef String FormFieldFormatter<T>(T v);
typedef bool MaterialSearchFilter<T>(T v, String c);
typedef int MaterialSearchSort<T>(T a, T b, String c);
typedef Future<List<MaterialSearchResult>> MaterialResultsFinder(String c);
typedef void OnSubmit(String value);

class MaterialSearchResult<T> extends StatelessWidget {
  const MaterialSearchResult({
    required this.value,
    required this.text,
    required this.icon,
  });

  final T value;
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(width: 70.0, child: new Icon(icon)),
          new Expanded(
              child: new Text(text,
                  style: Theme.of(context).textTheme.headlineSmall)),
        ],
      ),
      height: 56.0,
    );
  }
}

class MaterialSearch<T> extends StatefulWidget {
  MaterialSearch({
    required this.placeholder,
    required this.results,
    // required this.getResults,
    required this.filter,
    this.limit = 10,
    required this.onSelect,
    required this.onSubmit,
    this.barBackgroundColor = Colors.white,
    this.iconColor = Colors.black,
    required this.leading,
  }) : assert(() {
          // if (results == null && getResults == null ||
          //     results != null && getResults != null) {
          //   throw new AssertionError(
          //       'Either provide a function to get the results, or the results.');
          // }

          return true;
        }());

  final String placeholder;

  final List<MaterialSearchResult<T>> results;
  // final MaterialResultsFinder getResults;
  final MaterialSearchFilter<T> filter;
  final int limit;
  final ValueChanged<T> onSelect;
  final OnSubmit onSubmit;
  final Color barBackgroundColor;
  final Color iconColor;
  final Widget leading;

  @override
  _MaterialSearchState<T> createState() => new _MaterialSearchState<T>();
}

class _MaterialSearchState<T> extends State<MaterialSearch> {
  bool _loading = false;
  List<MaterialSearchResult<T>> _results = [];

  String _criteria = '';
  TextEditingController _controller = new TextEditingController();

  _filter(dynamic v, String c) {
    return v
        .toString()
        .toLowerCase()
        .trim()
        .contains(new RegExp(r'' + c.toLowerCase().trim() + ''));
  }

  @override
  void initState() {
    super.initState();

    // if (widget.getResults != null) {
    //   _getResultsDebounced();
    // }

    // _controller.addListener(() {
    //   setState(() {
    //     _criteria = _controller.value.text;
    //     if (widget.getResults != null) {
    //       _getResultsDebounced();
    //     }
    //   });
    // });
  }

  late Timer _resultsTimer;
  Future _getResultsDebounced() async {
    if (_results.length == 0) {
      setState(() {
        _loading = true;
      });
    }

    if (_resultsTimer != null && _resultsTimer.isActive) {
      _resultsTimer.cancel();
    }

    _resultsTimer = new Timer(new Duration(milliseconds: 400), () async {
      if (!mounted) {
        return;
      }

      setState(() {
        _loading = true;
      });

      // var results = await widget.getResults(_criteria);

      if (!mounted) {
        return;
      }

      setState(() {
        _loading = false;
        // _results = results;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var results = widget.results.where((MaterialSearchResult result) {
      if (widget.filter != null) {
        return widget.filter(result.value, _criteria);
      }
      //only apply default filter if used the `results` option
      //because getResults may already have applied some filter if `filter` option was omited.
      else if (widget.results != null) {
        return _filter(result.value, _criteria);
      }

      return true;
    }).toList();

    // if (widget.sort != null) {
    //   results.sort((a, b) => widget.sort(a.value, b.value, _criteria));
    // }

    results = results.take(widget.limit).toList();

    IconThemeData iconTheme =
        Theme.of(context).iconTheme.copyWith(color: widget.iconColor);

    return new Scaffold(
      appBar: new AppBar(
        leading: widget.leading,
        backgroundColor: widget.barBackgroundColor,
        iconTheme: iconTheme,
        title: new TextField(
          controller: _controller,
          autofocus: true,
          decoration:
              new InputDecoration.collapsed(hintText: widget.placeholder),
          style: Theme.of(context).textTheme.titleSmall,
          onSubmitted: (String value) {
            if (widget.onSubmit != null) {
              widget.onSubmit(value);
            }
          },
        ),
        actions: _criteria.length == 0
            ? []
            : [
                new IconButton(
                    icon: new Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _controller.text = _criteria = '';
                      });
                    }),
              ],
      ),
      body: _loading
          ? new Center(
              child: new Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: new CircularProgressIndicator()),
            )
          : new SingleChildScrollView(
              child: new Column(
                children: results.map((MaterialSearchResult result) {
                  return new InkWell(
                    onTap: () => widget.onSelect(result.value),
                    child: result,
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class _MaterialSearchPageRoute<T> extends MaterialPageRoute<T> {
  _MaterialSearchPageRoute({
    required WidgetBuilder builder,
    RouteSettings settings: const RouteSettings(),
    maintainState: true,
    bool fullscreenDialog: false,
  })  : assert(builder != null),
        super(
            builder: builder,
            settings: settings,
            maintainState: maintainState,
            fullscreenDialog: fullscreenDialog);
}

class MaterialSearchInput<T> extends StatefulWidget {
  MaterialSearchInput({
    required this.onSaved,
    required this.validator,
    required this.autovalidate,
    required this.placeholder,
    required this.formatter,
    required this.results,
    // required this.getResults,
    required this.filter,
    required this.sort,
    required this.onSelect,
  });

  final FormFieldSetter<T> onSaved;
  final FormFieldValidator<T> validator;
  final bool autovalidate;
  final String placeholder;
  final FormFieldFormatter<T> formatter;

  final List<MaterialSearchResult<T>> results;
  // final MaterialResultsFinder getResults;
  final MaterialSearchFilter<T> filter;
  final MaterialSearchSort<T> sort;
  final ValueChanged<T> onSelect;

  @override
  _MaterialSearchInputState<T> createState() =>
      new _MaterialSearchInputState<T>();
}

class _MaterialSearchInputState<T> extends State<MaterialSearchInput<T>> {
  GlobalKey<FormFieldState<T>> _formFieldKey =
      new GlobalKey<FormFieldState<T>>();

  _buildMaterialSearchPage(BuildContext context) {
    return new _MaterialSearchPageRoute<T>(
        settings: new RouteSettings(
          name: 'material_search',
          // isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<T>(
              placeholder: widget.placeholder,
              results: widget.results,
              // getResults: widget.getResults,
              filter: widget.filter,
              // sort: widget.sort,
              leading: SizedBox(),
              onSubmit: (value) {},
              onSelect: (dynamic value) => Navigator.of(context).pop(value),
            ),
          );
        });
  }

  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      if (value != null) {
        _formFieldKey.currentState?.didChange(value);
        widget.onSelect(value);
      }
    });
  }

  bool _isEmpty(field) {
    return field.value == null;
  }

  Widget build(BuildContext context) {
    final TextStyle? valueStyle = Theme.of(context).textTheme.headlineSmall;

    return new InkWell(
      onTap: () => _showMaterialSearch(context),
      child: new FormField<T>(
        key: _formFieldKey,
        validator: widget.validator,
        onSaved: widget.onSaved,
        builder: (FormFieldState<T> field) {
          return new InputDecorator(
            baseStyle: valueStyle,
            isEmpty: _isEmpty(field),
            decoration: new InputDecoration(
              labelStyle: _isEmpty(field) ? null : valueStyle,
              labelText: widget.placeholder,
              errorText: field.errorText,
            ),
            child: _isEmpty(field)
                ? null
                : new Text(
                    widget.formatter != null
                        ? widget.formatter(field.value as T)
                        : field.value.toString(),
                    style: valueStyle),
          );
        },
      ),
    );
  }
}
