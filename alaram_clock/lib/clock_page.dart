import 'package:alaram_clock/clock_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({Key? key}) : super(key: key);

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formattedTime = DateFormat('hh:mm').format(now);
    var formattedDate = DateFormat('EEE,d MMM').format(now);
    var timeZonestring = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timeZonestring.startsWith('-')) offsetSign = '+';
    print(timeZonestring);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                'Clock',
                style: TextStyle(color: Colors.white, fontSize: 24),
              )),

          //formattedTime,
          Flexible(
              flex: 2,
              child: Text(
                formattedTime,
                style: TextStyle(color: Colors.white, fontSize: 64),
              )),
          Text(
            formattedDate,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          SizedBox(height: 30,),
          Flexible(
            flex: 4,
            fit: FlexFit.tight,
            child: Align(
              alignment: Alignment.center,
              child: ClockView(
                size: MediaQuery.of(context).size.height / 4,
              ),
            ),
          ),
          //ClockView(),
          SizedBox(
            height: 16,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Timezone',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),

                //SizedBox(height: 16,),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    Text(
                      'UTC' + offsetSign + timeZonestring,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    )
                  ],
                ),
              ],
            ),
          ), //SizedBox(
          //height: 50,
          //),
        ],
      ),
    );
  }
}
