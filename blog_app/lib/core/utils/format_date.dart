import 'package:intl/intl.dart';

String formatDateByd(DateTime dateTime){
  return  DateFormat("d MMM, yyyy").format(dateTime);
}