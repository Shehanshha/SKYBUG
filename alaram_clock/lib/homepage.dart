import 'package:alaram_clock/clock_view.dart';
import 'package:alaram_clock/enum.dart';
import 'package:alaram_clock/menu_info.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:alaram_clock/data.dart';
import 'package:alaram_clock/alarm_page.dart';
import 'package:alaram_clock/clock_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('hh:mm').format(now);
    var formattedDate = DateFormat('EEE,d MMM').format(now);
    var timeZonestring = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timeZonestring.startsWith('-')) offsetSign = '+';
    print(timeZonestring);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(children: <Widget>[

       Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: menuItems
              .map((currentMenuInfo) =>
              buildMenuButton(currentMenuInfo))
              .toList(),
        ),
        VerticalDivider(
          color: Colors.white,
          //color: CustomColors.dividerColor,
          width: 1,
        ),
        Expanded(
            child: Consumer<Menuinfo>(
          builder: (BuildContext context, Menuinfo value, Widget? child) {

              if (value.menuType == MenuType.clock)
                 return ClockPage();
             else if(value.menuType == MenuType.alarm)
                return AlarmPage();
             else
            return Container(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 20),
                  children: <TextSpan>[
                    TextSpan(text: 'Upcoming Tutorial\n'),
                    TextSpan(
                      text: value.titile,
                      style: TextStyle(fontSize: 48),
                    ),
                  ],
                ),
              ),

              );
          },
        ))
      ]),
    );
  }

  Widget buildMenuButton(Menuinfo currentMenuInfo) {
    return Consumer<Menuinfo>(
        builder: (BuildContext context, Menuinfo value, Widget? child) {
          return Padding(
              padding: const EdgeInsets.only(top: 190.0, ),
          child:TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.white; // Color when button is pressed
                      }
                      return Colors.transparent; // Default color
                    },
                  )),
              onPressed: () {
                var meninfo = Provider.of<Menuinfo>(context, listen: false);
                meninfo.updateMenu(currentMenuInfo);
              },
              child: Column(
                children: <Widget>[
                  Image.asset(
                    currentMenuInfo.imageSource,
                    scale: 1.5,
                  ),
                  Text(
                    currentMenuInfo.titile ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              )));
        }
    );
  }
  // TextButton buildMenuButton2(){
  //   return TextButton(onPressed:(){},
  //       child:Column(
  //         children: <Widget>[
  //           Image.asset('images/alarm_icon.png',height: 40,width: 40,),
  //
  //           Text('Alaram',style: TextStyle(color: Colors.white,fontSize: 16),
  //           )
  //         ],
  //       )
  //   );
  //}
}
