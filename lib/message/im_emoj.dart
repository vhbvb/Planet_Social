
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';

class FTIMEmoj extends StatefulWidget {

  final Function(String) onSelected;

  const FTIMEmoj({Key key, this.onSelected}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmojState();
}

class _EmojState extends State<FTIMEmoj> {
  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      // recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        widget.onSelected(emoji.emoji);
      },
    );
  }
}