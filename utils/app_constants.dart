

import 'dart:convert';

void superPrint(var content, {var title = 'Super Print'}) {
  String callerFrame = '';


  try {
    final stackTrace = StackTrace.current;
    final frames = stackTrace.toString().split("\n");
    callerFrame = frames[1];
  } catch (e) {
    print(e);
  }


  DateTime dateTime = DateTime.now();
  String dateTimeString =
      '${dateTime.hour} : ${dateTime.minute} : ${dateTime.second}.${dateTime.millisecond}';
  print('');
  print(
      '- ${title.toString()} - ${callerFrame.split('(').last.replaceAll(')', '')}');
  print('____________________________');
  print(content);
  print('____________________________ $dateTimeString');}


class AppConstants{

}