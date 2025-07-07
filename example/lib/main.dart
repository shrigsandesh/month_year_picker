import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ExampleUsage(),
    );
  }
}

// MARK: - Usage Example
class ExampleUsage extends StatefulWidget {
  const ExampleUsage({super.key});

  @override
  State<ExampleUsage> createState() => _ExampleUsageState();
}

class _ExampleUsageState extends State<ExampleUsage> {
  DateTime? _selectedDate;
  final GlobalKey _buttonKey = GlobalKey();

  Future<void> _showPickerAboveButton() async {
    final DateTime? result = await showMonthYearPicker(
      context: context,
      buttonKey: _buttonKey,
      initialMonth: _selectedDate?.month,
      allowFutureDate: true,
      initialYear: _selectedDate?.year,
      minYear: 1920,
      maxYear: 2025,
      onDateChanged: (p0) => {
        log(p0.toString()),
      },
    );

    if (result != null) {
      setState(() {
        _selectedDate = result;
      });
    }

    log('Selected Date: ${_selectedDate?.toIso8601String() ?? 'None'}');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Month Year Picker Demo'),
      ),
      child: Center(
        child: CupertinoButton.filled(
          key: _buttonKey, // Important: Attach the GlobalKey here
          onPressed: _showPickerAboveButton,

          child: const Text('Show Picker'),
        ),
      ),
    );
  }
}
