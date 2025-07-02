import 'package:flutter/material.dart';

extension SeparatedWidgetList on List<Widget> {
  List<Widget> separatedBy(Widget separator) {
    if (length < 2) return this;

    final separatedList = <Widget>[];
    for (var i = 0; i < length; i++) {
      separatedList.add(this[i]);
      if (i < length - 1) separatedList.add(separator);
    }
    return separatedList;
  }
}
