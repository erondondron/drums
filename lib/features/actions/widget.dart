import 'package:drums/features/actions/editing/widget.dart';
import 'package:drums/features/actions/playback/widget.dart';
import 'package:flutter/material.dart';

import 'metronome/widget.dart';

class ActionsPanel extends StatelessWidget {
  const ActionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        NotesEditingPanel(),
        SizedBox(width: 10),
        PlayButton(),
        SizedBox(width: 10),
        MetronomePanel(),
      ],
    );
  }
}
