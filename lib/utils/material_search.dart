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
    return Container(
      height: 52.0,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Colors.grey.shade500, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: "Fregat",
                fontSize: 15.0,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
          Icon(Icons.north_west_rounded, size: 14, color: Colors.grey.shade400),
        ],
      ),
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
  String _criteria = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (mounted) {
        setState(() {
          _criteria = _controller.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredResults = widget.results.where((MaterialSearchResult result) {
      return widget.filter(result.value, _criteria);
    }).take(widget.limit).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: (widget.leading is SizedBox)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF1B4392)),
                onPressed: () => Navigator.of(context).pop(),
              )
            : widget.leading,
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Color(0xFF1B4392)),
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
              fontFamily: 'Fregat',
            ),
            border: InputBorder.none,
          ),
          style: const TextStyle(
            color: Color(0xFF1B4392),
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Fregat',
          ),
          onSubmitted: (String value) {
            final trimmed = value.trim();
            if (trimmed.isNotEmpty) {
              widget.onSubmit(trimmed);
            }
          },
        ),
        actions: [
          if (_criteria.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              tooltip: "Цэвэрлэх",
              onPressed: () {
                _controller.clear();
              },
            ),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF1B4392)),
            tooltip: "Хайх",
            onPressed: () {
              final trimmed = _controller.text.trim();
              if (trimmed.isNotEmpty) {
                widget.onSubmit(trimmed);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_criteria.trim().isNotEmpty)
              InkWell(
                onTap: () => widget.onSubmit(_criteria.trim()),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B4392).withOpacity(0.06),
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded,
                          color: Color(0xFF1B4392), size: 20),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          '"${_criteria.trim()}" гэж хайх',
                          style: const TextStyle(
                            color: Color(0xFF1B4392),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Fregat",
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 16, color: Color(0xFF1B4392)),
                    ],
                  ),
                ),
              ),
            ...filteredResults.map((MaterialSearchResult result) {
              return InkWell(
                onTap: () => widget.onSelect(result.value),
                child: result,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MaterialSearchPageRoute<T> extends MaterialPageRoute<T> {
  _MaterialSearchPageRoute({
    required WidgetBuilder builder,
    RouteSettings settings = const RouteSettings(),
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
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
                    widget.formatter(field.value as T),
                    style: valueStyle),
          );
        },
      ),
    );
  }
}
