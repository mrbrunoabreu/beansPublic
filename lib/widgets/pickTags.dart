import 'package:flutter/material.dart';

class PickTags extends StatefulWidget {

  final void Function(String tag)? onTag;
  final void Function(String tag)? onDelete;
  final List<String>? initialTags;

  const PickTags({
    Key? key,
    this.onTag,
    this.onDelete,
    this.initialTags
  }) : super(key: key);

  @override
  _TextFieldTagsState createState() => _TextFieldTagsState();
}

class _TextFieldTagsState extends State<PickTags> {
  List<String>? _tagsStringContent = [];
  final TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showPrefixIcon = false;
  late double _deviceWidth;

  @override
  void initState() {
    super.initState();
    if (widget.initialTags != null && widget.initialTags!.isNotEmpty) {
      _showPrefixIcon = true;
      _tagsStringContent = widget.initialTags;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _deviceWidth = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _scrollController.dispose();
  }

  List<Widget> get _getTags {
    List<Widget> _tags = [];
    for (var i = 0; i < _tagsStringContent!.length; i++) {
      final String tagText = _tagsStringContent![i];
      var tag = Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                tagText,
                style: Theme.of(context).textTheme.bodyText1
            ),
            GestureDetector(
                onTap: () {
                  if (widget.onDelete != null) {
                    widget.onDelete!(_tagsStringContent![i]);
                  }
                  if (_tagsStringContent!.length == 1 && _showPrefixIcon) {
                    setState(() {
                      _tagsStringContent!.remove(_tagsStringContent![i]);
                      _showPrefixIcon = false;
                    });
                  } else {
                    setState(() {
                      _tagsStringContent!.remove(_tagsStringContent![i]);
                    });
                  }
                },
                child: const Icon(Icons.cancel),
            ),
          ],
        ),
      );
      _tags.add(tag);
    }
    return _tags;
  }

  void _animateTransition() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      autocorrect: false,
      style: Theme.of(context).textTheme.bodyText1,
      decoration: InputDecoration(
        hintText: 'Got tags?',
        prefixIcon: _showPrefixIcon
            ? ConstrainedBox(
                constraints: BoxConstraints(maxWidth: _deviceWidth * 0.725),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _getTags,
                    ),
                  ),
                ),
              )
            : null,
      ),
      onSubmitted: (value) {
        var val = value.trim().toLowerCase();
        if (value.isEmpty) {
          _textEditingController.clear();
          if (!_tagsStringContent!.contains(val)) {
            widget.onTag!(val);
            if (!_showPrefixIcon) {
              setState(() {
                _tagsStringContent!.add(val);
                _showPrefixIcon = true;
              });
            } else {
              setState(() {
                _tagsStringContent!.add(val);
              });
            }
            this._animateTransition();
          }
        }
      },
      onChanged: (value) {
        var splitedTagsList = value.split(" ");
        var indexer = splitedTagsList.length > 1
            ? splitedTagsList.length - 2
            : splitedTagsList.length - 1;
        var lastLastTag = splitedTagsList[indexer].trim().toLowerCase();

        if (value.contains(" ")) {
          if (lastLastTag.length > 0) {
            _textEditingController.clear();

            if (!_tagsStringContent!.contains(lastLastTag)) {
              widget.onTag!(lastLastTag);

              if (!_showPrefixIcon) {
                setState(() {
                  _tagsStringContent!.add(lastLastTag);
                  _showPrefixIcon = true;
                });
              } else {
                setState(() {
                  _tagsStringContent!.add(lastLastTag);
                });
              }
              this._animateTransition();
            }
          }
        }
      },
    );
  }
}
