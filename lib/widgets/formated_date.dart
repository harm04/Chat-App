import 'package:flutter/material.dart';

class formatedDate {
  static String getFormattedTime(
      {required BuildContext context, required String time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(
      {required BuildContext context, required String time,bool year=false}) {
    final DateTime sentTime = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if(now.day==sentTime.day&&now.month==sentTime.month&&now.year==sentTime.year){
      return TimeOfDay.fromDateTime(sentTime).format(context);
    }
    return year?'${sentTime.day} ${_getMonth(sentTime)} ${sentTime.year}': '${sentTime.day} ${_getMonth(sentTime)}';
}

static String getlastActiveTime(
    {
      required BuildContext context,required String lastActive
    }
  ){
final int i=int.tryParse(lastActive)??-1;
if(lastActive==-1)
  return 'last active not available';
DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
DateTime now = DateTime.now();

String formattedTime =TimeOfDay.fromDateTime(time).format(context);
if(time.day==now.day && time.month==now.month&&time.year==now.year){
  return 'last seen today at ${formattedTime}';
}
if((now.difference(time).inHours / 24).round()==1){
  return 'last seen yesterday at ${formattedTime}';
}
  String month=_getMonth(time);
  return 'last seen on ${time.day} ${month} on ${formattedTime}';

  }

static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
