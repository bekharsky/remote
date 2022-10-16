import 'dart:io';
import 'package:flutter/material.dart';

class RemoteIcons {
  RemoteIcons._();

  static final double _size = Platform.isMacOS ? 20 : 24;
  static const Color _lightText = Colors.white60;

  static Icon power = Icon(
    Icons.power_settings_new_rounded,
    size: _size,
    color: Colors.red[900],
  );

  static Icon settings = Icon(
    Icons.settings,
    size: _size,
    color: Colors.white10,
  );

  static Icon home = Icon(
    Icons.home_outlined,
    size: _size,
    color: _lightText,
  );

  static Icon arrowUp = Icon(
    Icons.keyboard_arrow_up_rounded,
    size: _size,
    color: _lightText,
  );

  static Icon arrowRight = Icon(
    Icons.keyboard_arrow_right_rounded,
    size: _size,
    color: _lightText,
  );

  static Icon arrowBottom = Icon(
    Icons.keyboard_arrow_down,
    size: _size,
    color: _lightText,
  );

  static Icon arrowLeft = Icon(
    Icons.keyboard_arrow_left_rounded,
    size: _size,
    color: _lightText,
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
