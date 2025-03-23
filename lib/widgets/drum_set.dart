import 'package:drums/models/drum_set.dart';
import 'package:drums/shared/fix_height_row.dart';
import 'package:drums/shared/text_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class DrumSetWidget extends StatelessWidget {
  const DrumSetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DrumSetModel>(
      builder: (BuildContext context, DrumSetModel drumSet, _) {
        return IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ControlPanel(drumSet: drumSet),
              ...drumSet.selected.map(
                (Drums drum) => _SelectedDrumRow(drumSet: drumSet, drum: drum),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ControlPanel extends StatelessWidget {
  const _ControlPanel({required this.drumSet});

  final DrumSetModel drumSet;

  @override
  Widget build(BuildContext context) {
    final toggle = _HidingToggle(drumSet: drumSet);
    if (drumSet.isHidden) return toggle;

    final moreButton = _SelectNewDrumButton(drumSet: drumSet);
    return FixHeightRow(children: [moreButton, toggle]);
  }
}

class _SelectNewDrumButton extends StatelessWidget {
  const _SelectNewDrumButton({required this.drumSet});

  final DrumSetModel drumSet;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Drums>(
      child: TextWithIcon(
        icon: SizedBox(
          height: FixHeightRow.height,
          width: FixHeightRow.height,
          child: Icon(Icons.add_outlined),
        ),
        text: "More",
      ),
      onSelected: (Drums drum) => drumSet.add(drum),
      itemBuilder: (BuildContext context) {
        return drumSet.unselected
            .map(
              (drum) => PopupMenuItem(
                value: drum,
                child: TextWithIcon(
                  icon: _DrumIcon(asset: drum.icon),
                  text: drum.name,
                ),
              ),
            )
            .toList();
      },
    );
  }
}

class _HidingToggle extends StatelessWidget {
  const _HidingToggle({required this.drumSet});

  final DrumSetModel drumSet;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: drumSet.toggleHiding,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: FixHeightRow.height,
        width: FixHeightRow.height,
        child: drumSet.isHidden
            ? Icon(Icons.keyboard_double_arrow_right_outlined, size: 24)
            : Icon(Icons.keyboard_double_arrow_left_outlined, size: 18),
      ),
    );
  }
}

class _SelectedDrumRow extends StatelessWidget {
  const _SelectedDrumRow({required this.drumSet, required this.drum});

  final DrumSetModel drumSet;
  final Drums drum;

  @override
  Widget build(BuildContext context) {
    final icon = _DrumIcon(asset: drum.icon);
    if (drumSet.isHidden) return icon;

    return FixHeightRow(
      children: [
        TextWithIcon(icon: icon, text: drum.name),
        _RemoveDrumButton(drumSet: drumSet, drum: drum)
      ],
    );
  }
}

class _DrumIcon extends StatelessWidget {
  const _DrumIcon({required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).iconTheme.color!;
    final theme = ColorFilter.mode(color, BlendMode.srcIn);
    return SizedBox(
      height: FixHeightRow.height,
      width: FixHeightRow.height,
      child: SvgPicture.asset(asset, colorFilter: theme, fit: BoxFit.none),
    );
  }
}

class _RemoveDrumButton extends StatelessWidget {
  const _RemoveDrumButton({required this.drumSet, required this.drum});

  final DrumSetModel drumSet;
  final Drums drum;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => drumSet.remove(drum),
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        height: FixHeightRow.height,
        width: FixHeightRow.height,
        child: Icon(Icons.close_outlined, size: 15),
      ),
    );
  }
}
