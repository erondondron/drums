import 'dart:collection';

import 'package:drums/features/sheet_music/beat/model.dart';
import 'package:drums/features/sheet_music/drum_set/model.dart';
import 'package:drums/features/sheet_music/time_signature/model.dart';
import 'package:flutter/material.dart';

class BarModel extends ChangeNotifier {
  BarModel({required this.drum, required List<BeatModel> beats})
      : _beats = beats;

  factory BarModel.generate({
    required Drums drum,
    required TimeSignature timeSignature,
  }) {
    return BarModel(
      drum: drum,
      beats: timeSignature.measures
          .map(
            (int measure) => BeatModel.generate(
              measure: measure,
              value: timeSignature.noteValue,
            ),
          )
          .toList(),
    );
  }

  final Drums drum;
  final List<BeatModel> _beats;

  UnmodifiableListView<BeatModel> get beats => UnmodifiableListView(_beats);
}

class SheetMusicBarModel extends ChangeNotifier {
  SheetMusicBarModel({
    TimeSignature? timeSignature,
    List<BarModel>? drumBars,
  })  : _timeSignature = timeSignature ?? sixteenSixteenths,
        _bars = drumBars ?? [];

  TimeSignature _timeSignature;
  List<BarModel> _bars;

  TimeSignature get timeSignature => _timeSignature;

  UnmodifiableListView<BarModel> get drumBars => UnmodifiableListView(_bars);

  void updateDrums(List<Drums> drums) {
    _bars.removeWhere((BarModel bar) => !drums.contains(bar.drum));

    final barsDrums = _bars.map((BarModel bar) => bar.drum).toSet();
    final newDrums = drums.toSet().difference(barsDrums);
    _bars.addAll(newDrums.map((Drums drum) =>
        BarModel.generate(drum: drum, timeSignature: timeSignature)));

    _bars.sort((a, b) => a.drum.order.compareTo(b.drum.order));
    notifyListeners();
  }

  void updateTimeSignature(TimeSignature timeSignature) {
    final barsDrums = _bars.map((BarModel bar) => bar.drum).toSet();
    _bars = barsDrums
        .map((Drums drum) =>
            BarModel.generate(drum: drum, timeSignature: timeSignature))
        .toList();

    _timeSignature = timeSignature;
    notifyListeners();
  }
}
