// MARK: - Constants
import 'package:flutter/cupertino.dart';

class PickerConstants {
  static const double itemExtent = 32.0;
  static const double pickerWidth = 216.0;
  static const double pickerHeight = 260.0;
  static const double borderRadius = 14.0; // iOS standard radius
  static const double actionButtonHeight = 44.0; // iOS standard button height

  static const TextStyle pickerTextStyle = TextStyle(
    fontSize: 20.0, // iOS standard picker text size
    fontWeight: FontWeight.w400,
  );

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: CupertinoColors.white,
  );
}

// MARK: - Month Enum & Extensions
enum Month {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december,
}

extension MonthExtension on Month {
  String get name => toString().split('.').last._capitalize();
  int get number => index + 1;
}

extension _StringExtension on String {
  String _capitalize() => '${this[0].toUpperCase()}${substring(1)}';
}

extension IntToMonth on int {
  Month toMonth() {
    if (this < 1 || this > 12) {
      throw RangeError('Month must be between 1 and 12. Found: $this');
    }
    return Month.values[this - 1];
  }
}

// MARK: - Utility Functions
List<String> get monthNames => Month.values.map((e) => e.name).toList();
