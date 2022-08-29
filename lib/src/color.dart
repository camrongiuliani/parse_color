import 'package:flutter/material.dart';

import 'manager.dart';

class UIColor extends Color {
  UIColor( dynamic value, { Color fallback = Colors.transparent } ) : super
      (
      UIColorManager().parse(
        value,
        fallback: Colors.transparent,
      ).value,
    );
}