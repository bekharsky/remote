import 'package:flutter/widgets.dart';
import 'package:remote/theme/app_theme.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_tap.dart';

enum Pressed { lower, higher, none }

class RemoteVolume extends StatefulWidget {
  final double size;
  final void Function() onPressedLower;
  final void Function() onPressedHigher;
  final void Function() onPressedMute;

  const RemoteVolume({
    Key? key,
    this.size = 166,
    required this.onPressedLower,
    required this.onPressedHigher,
    required this.onPressedMute,
  }) : super(key: key);

  @override
  State<RemoteVolume> createState() => _RemoteVolumeState();
}

class _RemoteVolumeState extends State<RemoteVolume> {
  late final double _width = widget.size / 3;
  late final double _height = widget.size / 4;
  // TODO: set muted from real TV state
  bool _isMuted = false;
  final _decoration = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(9999)),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final iconColor = theme.colors.onPrimary;

    return Container(
      decoration: _decoration,
      clipBehavior: Clip.antiAlias,
      width: widget.size,
      height: widget.size / 4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RemoteTap(
            onPressed: () {
              setState(() {
                if (_isMuted) {
                  _isMuted = false;
                }
              });

              widget.onPressedLower();
            },
            width: _width,
            height: _height,
            child: RemoteIcons.lower(iconColor),
          ),
          RemoteTap(
            onPressed: () {
              setState(() {
                _isMuted = !_isMuted;
              });

              widget.onPressedMute();
            },
            width: _width,
            height: _height,
            child: _isMuted
                ? RemoteIcons.mute(iconColor)
                : RemoteIcons.volume(iconColor),
          ),
          RemoteTap(
            onPressed: () {
              setState(() {
                if (_isMuted) {
                  _isMuted = false;
                }
              });

              widget.onPressedHigher();
            },
            width: _width,
            height: _height,
            child: RemoteIcons.higher(iconColor),
          ),
        ],
      ),
    );
  }
}
