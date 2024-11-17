import 'dart:io';
import 'package:flutter/material.dart';

class RemoteIcons {
  RemoteIcons._();

  static final bool _isMobile = Platform.isIOS || Platform.isAndroid;
  static final double _size = _isMobile ? 24 : 20;
  static const Color _lightText = Color.fromRGBO(255, 255, 255, 0.6);

  static Icon power = Icon(
    Icons.power_settings_new_rounded,
    size: _size,
    color: const Color.fromRGBO(183, 28, 28, 1),
  );

  static Icon settings = Icon(
    Icons.settings,
    size: _size,
    color: const Color.fromRGBO(255, 255, 255, 0.102),
  );

  static Icon tv = Icon(
    Icons.tv,
    size: _size,
    color: const Color.fromRGBO(255, 255, 255, 0.102),
  );

  static Icon home = Icon(
    Icons.home_outlined,
    size: _size,
    color: _lightText,
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

  static Icon play = Icon(
    Icons.play_arrow,
    size: _size,
    color: _lightText,
  );

  static Icon pause = Icon(
    Icons.pause,
    size: _size,
    color: _lightText,
  );

  static Icon back = Icon(
    Icons.arrow_back,
    size: _size,
    color: _lightText,
  );

  static Icon lower = Icon(
    Icons.remove,
    size: _size,
    color: _lightText,
  );

  static Icon higher = Icon(
    Icons.add,
    size: _size,
    color: _lightText,
  );

  static Icon num = Icon(
    Icons.onetwothree,
    size: _size * 1.4,
    color: _lightText,
  );

  static Icon abc = Icon(
    Icons.abc,
    size: _size * 1.4,
    color: _lightText,
  );
}
