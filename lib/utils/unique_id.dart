import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String guidGenerator() {
  String guid = "";
  final now = DateTime.now();
  final timeFormater = DateFormat('hhmmss');
  final dateFormater = DateFormat('ddMMyyyy');
  var date = dateFormater.format(now);
  var time = timeFormater.format(now);
  String uniqueCode = UniqueKey().hashCode.toString();
  guid = "$time$uniqueCode$date";
  return guid;
}
