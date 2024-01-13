import 'package:flutter/material.dart';
import 'package:alaram_clock/homepage.dart';
import 'package:alaram_clock/clock_view.dart';
import 'package:provider/provider.dart';
import 'package:alaram_clock/menu_info.dart';
import 'package:alaram_clock/enum.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'alarm_helper.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AlarmHelper().initializeDatabase();

  var initializationSettingsAndroid =
  AndroidInitializationSettings('playstore');

  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id, String? title, String? body,
        String? payload) async {
      // Handle received notification on iOS
    },
  );

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
    },
  );

  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider<Menuinfo>(
        create:(context) => Menuinfo(MenuType.clock,),
        child:HomePage(),
    ));
  }

}
