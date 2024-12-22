import 'dart:io';
import 'package:flutter/material.dart';

class RemoteIcons {
  RemoteIcons._();

  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final double _size = _isMobile ? 24 : 20;
  static const Color _lightText = Color.fromRGBO(255, 255, 255, 0.6);

  static Icon power([Color? color]) => Icon(
        Icons.power_settings_new_rounded,
        size: _size * 1.2,
        color: color ?? const Color.fromRGBO(183, 28, 28, 1),
      );

  static Icon settings([Color? color]) => Icon(
        Icons.settings,
        size: _size,
        color: color ?? const Color.fromRGBO(255, 255, 255, 0.102),
      );

  static Icon tv([Color? color]) => Icon(
        Icons.connected_tv,
        size: _size * 1.2,
        color: color ?? const Color.fromRGBO(255, 255, 255, 0.102),
      );

  static Icon home([Color? color]) => Icon(
        Icons.home_outlined,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon arrowUp([Color? color]) => Icon(
        Icons.keyboard_arrow_up,
        size: _size * 1.5,
        color: color ?? _lightText,
      );

  static Icon arrowRight([Color? color]) => Icon(
        Icons.keyboard_arrow_right,
        size: _size * 1.5,
        color: color ?? _lightText,
      );

  static Icon arrowBottom([Color? color]) => Icon(
        Icons.keyboard_arrow_down,
        size: _size * 1.5,
        color: color ?? _lightText,
      );

  static Icon arrowLeft([Color? color]) => Icon(
        Icons.keyboard_arrow_left,
        size: _size * 1.5,
        color: color ?? _lightText,
      );

  static Icon play([Color? color]) => Icon(
        Icons.play_arrow,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon pause([Color? color]) => Icon(
        Icons.pause,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon rewind([Color? color]) => Icon(
        Icons.fast_rewind,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon ff([Color? color]) => Icon(
        Icons.fast_forward,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon back([Color? color]) => Icon(
        Icons.arrow_back,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon lower([Color? color]) => Icon(
        Icons.remove,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon higher([Color? color]) => Icon(
        Icons.add,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon mute([Color? color]) => Icon(
        Icons.volume_off,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon unmute([Color? color]) => Icon(
        Icons.volume_up,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon channelUp([Color? color]) => Icon(
        Icons.keyboard_arrow_up,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon channelDown([Color? color]) => Icon(
        Icons.keyboard_arrow_down,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon program([Color? color]) => Icon(
        Icons.dvr,
        size: _size,
        color: color ?? _lightText,
      );

  static Icon num([Color? color]) => Icon(
        Icons.onetwothree,
        size: _size * 1.4,
        color: color ?? _lightText,
      );

  static Icon abc([Color? color]) => Icon(
        Icons.abc,
        size: _size * 1.4,
        color: color ?? _lightText,
      );
}
