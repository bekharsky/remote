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
    super.key,
    required this.onPressedVolumeUp,
    required this.onPressedVolumeDown,
    required this.onPressedVolumeMute,
    required this.onPressedChannelUp,
    required this.onPressedChannelDown,
  });

  @override
  State<RemoteRocker> createState() => _RemoteRockerState();
}

class _RemoteRockerState extends State<RemoteRocker> {
  late final double _width = 48;
  late final double _height = 40;
  // TODO: set muted from real TV state
  bool _isMuted = false;
  bool _isChannel = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final iconColor = theme.colors.onPrimary;
    final activeColor = theme.colors.active;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(9999),
            bottomLeft: Radius.circular(9999),
          ),
          child: RemoteTap(
            onPressed: () {
              if (_isChannel) {
                widget.onPressedChannelDown();
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
            child: _isChannel
                ? RemoteIcons.channelDown(iconColor)
                : RemoteIcons.lower(iconColor),
          ),
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
              _isChannel = !_isChannel;
            });
          },
          width: _width,
          height: _height,
          child: RemoteIcons.program(_isChannel ? activeColor : iconColor),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(9999),
            bottomRight: Radius.circular(9999),
          ),
          child: RemoteTap(
            onPressed: () {
              if (_isChannel) {
                widget.onPressedChannelUp();
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
            child: _isChannel
                ? RemoteIcons.channelUp(iconColor)
                : RemoteIcons.higher(iconColor),
          ),
        ),
      ],
    );
  }
}
