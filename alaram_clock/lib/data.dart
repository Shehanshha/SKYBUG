import 'package:alaram_clock/enum.dart';
import 'package:alaram_clock/theme_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:alaram_clock/alarm_info.dart';
import 'menu_info.dart';

List<Menuinfo> menuItems = [
  Menuinfo(MenuType.clock,
  titile: 'Clock',imageSource: 'images/clock_icon.png'),

  //SizedBox(width: 70.0,),
  Menuinfo(MenuType.alarm,
  titile: 'Alarm',imageSource: 'images/alarm_icon.png')
];
List<AlarmInfo> alarms = [
  AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 1)), title: 'Office', gradientColorIndex: 0),
  AlarmInfo(alarmDateTime: DateTime.now().add(Duration(hours: 2)), title: 'Sport', gradientColorIndex: 1),
];