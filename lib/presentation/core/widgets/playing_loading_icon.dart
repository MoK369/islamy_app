import 'package:flutter/material.dart';

class PlayingLoadingIcon extends StatelessWidget {
  final double? iconSize;

  const PlayingLoadingIcon({super.key, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.play_arrow,
          size: iconSize,
        ),
        const CircularProgressIndicator()
      ],
    );
  }
}
