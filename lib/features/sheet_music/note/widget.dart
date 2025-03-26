import 'package:drums/features/sheet_music/note/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const Map<NoteValue, double> notesPadding = {
  NoteValue.quarter: 40,
  NoteValue.eight: 20,
  NoteValue.eightTriplet: 10,
  NoteValue.sixteenth: 5,
  NoteValue.sixteenthTriplet: 2.5,
  NoteValue.thirtySecond: 0,
};

class NoteWidget extends StatelessWidget {
  const NoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteModel>(
      builder: (BuildContext context, NoteModel note, _) {
        return Padding(
          padding: EdgeInsets.only(right: notesPadding[note.value]!),
          child: GestureDetector(
            onTap: note.plainStroke,
            behavior: HitTestBehavior.translucent,
            child: _NoteBox(note: note),
          ),
        );
      },
    );
  }
}

class _NoteBox extends StatelessWidget {
  static const double outerSize = 35;
  static const double innerSize = 30;

  const _NoteBox({required this.note});

  final NoteModel note;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: note.key,
      width: outerSize,
      height: outerSize,
      child: Center(
        child: Container(
          width: innerSize,
          height: innerSize,
          decoration: BoxDecoration(
            color: note.type == StrokeType.off
                ? Theme.of(context).colorScheme.secondaryContainer
                : Theme.of(context).colorScheme.onSurface,
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
