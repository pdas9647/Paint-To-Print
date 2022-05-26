import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

Widget ModalListTile(
    BuildContext context, {
      @required String title,
      @required IconData iconData,
      Color color = Colors.black54,
      @required Function() onTap,
    }) {
  return ListTile(
    title: Text(
      title,
      style: GoogleFonts.arimo(
        color: color,
        fontWeight: FontWeight.w600,
      ),
    ),
    leading: Icon(iconData, color: color),
    onTap: onTap,
  );
}

typedef SearchTapCallback = void Function(Object item);

class SearchToolbar extends StatefulWidget {
  ///it describe the search toolbar constructor
  SearchToolbar({
    this.controller,
    this.onTap,
    this.showTooltip = true,
    Key key,
  }) : super(key: key);

  /// Indicates whether the tooltip for the search toolbar items need to be shown or not.
  final bool showTooltip;

  /// An object that is used to control the [SfPdfViewer].
  final PdfViewerController controller;

  /// Called when the search toolbar item is selected.
  final SearchTapCallback onTap;

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

/// State for the SearchToolbar widget
class SearchToolbarState extends State<SearchToolbar> {
  int _searchTextLength = 0;

  /// Indicates whether search toolbar items need to be shown or not.
  bool _showItem = false;

  /// Indicates whether search toast need to be shown or not.
  bool showToast = false;

  ///An object that is used to retrieve the current value of the TextField.
  final TextEditingController _editingController = TextEditingController();

  /// An object that is used to retrieve the text search result.
  PdfTextSearchResult _pdfTextSearchResult = PdfTextSearchResult();

  ///An object that is used to obtain keyboard focus and to handle keyboard events.
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();
    focusNode?.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode?.dispose();
    super.dispose();
  }

  ///Clear the text search result
  void clearSearch() {
    _pdfTextSearchResult.clear();
  }

  ///Display the Alert dialog to search from the beginning
  void _showSearchAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(0),
          title: Text('Search Result'),
          content: Container(
              width: 328.0,
              child: Text(
                  'No more occurrences found. Would you like to continue to search from the beginning?')),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.nextInstance();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'YES',
                style: TextStyle(
                    color: Color(0x00000000).withOpacity(0.87),
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _pdfTextSearchResult.clear();
                  _editingController.clear();
                  _showItem = false;
                  focusNode?.requestFocus();
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'NO',
                style: TextStyle(
                    color: Color(0x00000000).withOpacity(0.87),
                    fontFamily: 'Roboto',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0x00000000).withOpacity(0.54),
              size: 24,
            ),
            onPressed: () {
              widget.onTap?.call('Cancel Search');
              _editingController.clear();
              _pdfTextSearchResult.clear();
            },
          ),
        ),
        Flexible(
          child: TextFormField(
            style: TextStyle(
                color: Color(0x00000000).withOpacity(0.87), fontSize: 16),
            enableInteractiveSelection: false,
            focusNode: focusNode,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            controller: _editingController,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search...',
              hintStyle: TextStyle(color: Color(0x00000000).withOpacity(0.34)),
            ),
            onChanged: (text) {
              if (_searchTextLength < _editingController.value.text.length) {
                setState(() {});
                _searchTextLength = _editingController.value.text.length;
              }
              if (_editingController.value.text.length < _searchTextLength) {
                setState(() {
                  _showItem = false;
                });
              }
            },
            onFieldSubmitted: (String value) async {
              _pdfTextSearchResult =
              await widget.controller.searchText(_editingController.text);
              if (_pdfTextSearchResult.totalInstanceCount == 0) {
                widget.onTap?.call('noResultFound');
              } else {
                setState(() {
                  _showItem = true;
                });
              }
            },
          ),
        ),
        Visibility(
          visible: _editingController.text.isNotEmpty,
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Color.fromRGBO(0, 0, 0, 0.54),
                size: 24,
              ),
              onPressed: () {
                setState(() {
                  _editingController.clear();
                  _pdfTextSearchResult.clear();
                  widget.controller.clearSelection();
                  _showItem = false;
                  focusNode.requestFocus();
                });
                widget.onTap.call('Clear Text');
              },
              tooltip: widget.showTooltip ? 'Clear Text' : null,
            ),
          ),
        ),
        Visibility(
          visible: _showItem,
          child: Row(
            children: [
              Text(
                '${_pdfTextSearchResult.currentInstanceIndex}',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Text(
                ' of ',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Text(
                '${_pdfTextSearchResult.totalInstanceCount}',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.54).withOpacity(0.87),
                    fontSize: 16),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_before,
                    color: Color.fromRGBO(0, 0, 0, 0.54),
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      _pdfTextSearchResult.previousInstance();
                    });
                    widget.onTap.call('Previous Instance');
                  },
                  tooltip: widget.showTooltip ? 'Previous' : null,
                ),
              ),
              Material(
                color: Colors.transparent,
                child: IconButton(
                  icon: Icon(
                    Icons.navigate_next,
                    color: Color.fromRGBO(0, 0, 0, 0.54),
                    size: 24,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_pdfTextSearchResult.currentInstanceIndex ==
                          _pdfTextSearchResult.totalInstanceCount &&
                          _pdfTextSearchResult.currentInstanceIndex != 0 &&
                          _pdfTextSearchResult.totalInstanceCount != 0) {
                        _showSearchAlertDialog(context);
                      } else {
                        widget.controller.clearSelection();
                        _pdfTextSearchResult.nextInstance();
                      }
                    });
                    widget.onTap.call('Next Instance');
                  },
                  tooltip: widget.showTooltip ? 'Next' : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
