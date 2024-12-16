import 'package:flutter/widgets.dart';
import 'package:remote/theme/app_theme.dart';
import 'package:remote/ui/remote_icons.dart';
import 'package:remote/ui/remote_tap.dart';

enum Pressed { lower, higher, none }

class RemoteRocker extends StatefulWidget {
  final void Function() onPressedVolumeUp;
  final void Function() onPressedVolumeDown;
  final void Function() onPressedVolumeMute;
  final void Function() onPressedChannelUp;
  final void Function() onPressedChannelDown;

  const RemoteRocker({
    Key? key,
    required this.onPressedVolumeUp,
    required this.onPressedVolumeDown,
    required this.onPressedVolumeMute,
    required this.onPressedChannelUp,
    required this.onPressedChannelDown,
  }) : super(key: key);

  @override
  State<RemoteRocker> createState() => _RemoteRockerState();
}

class _RemoteRockerState extends State<RemoteRocker> {
  late final double _width = 48;
  late final double _height = 40;
  // TODO: set muted from real TV state
  bool _isMuted = false;
  bool _isProgram = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final iconColor = theme.colors.onPrimary;
    final activeColor = theme.colors.active;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9999),
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RemoteTap(
            onPressed: () {
              if (_isProgram) {
                // TODO: channel switch
              } else {
                setState(() {
                  if (_isMuted) {
                    _isMuted = false;
                  }
                });

                widget.onPressedVolumeDown();
              }
            },
            width: _width,
            height: _height,
            child: _isProgram
                ? RemoteIcons.channelDown(iconColor)
                : RemoteIcons.lower(iconColor),
          ),
          RemoteTap(
            onPressed: () {
              setState(() {
                _isMuted = !_isMuted;
              });

              widget.onPressedVolumeMute();
            },
            width: _width,
            height: _height,
            child: RemoteIcons.mute(_isMuted ? activeColor : iconColor),
          ),
          RemoteTap(
            onPressed: () {
              setState(() {
                _isProgram = !_isProgram;
              });
            },
            width: _width,
            height: _height,
            child: RemoteIcons.program(_isProgram ? activeColor : iconColor),
          ),
          RemoteTap(
            onPressed: () {
              if (_isProgram) {
                // TODO: channel switch
              } else {
                setState(() {
                  if (_isMuted) {
                    _isMuted = false;
                  }
                });

                widget.onPressedVolumeUp();
              }
            },
            width: _width,
            height: _height,
            child: _isProgram
                ? RemoteIcons.channelUp(iconColor)
                : RemoteIcons.higher(iconColor),
          ),
        ],
      ),
    );
  }
}
