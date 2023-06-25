import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Displays the log message in the console.
///
/// [message] is the log message to be displayed.
showLog(
  dynamic message,
) {
  printWrapped('$message');
}

/// Prints a long string by splitting it into multiple lines because single line only can hold show a maximum amount of string.
/// [text] is the long string to be printed.
printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}

/// Returns a custom date format 'dd MMM yyyy'.
///
/// This format can be used with the `DateFormat` class from the 'intl' package.
/// Returns the `DateFormat` instance.
DateFormat myDateFormat() {
  return DateFormat('dd MMM yyyy');
}
