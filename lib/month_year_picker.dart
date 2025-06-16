// ignore_for_file: unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:month_year_picker/helpers.dart';

// MARK: - Positioned Picker Widget
class _PositionedMonthYearPicker extends StatefulWidget {
  final Offset buttonPosition;
  final Size buttonSize;
  final int? initialMonth;
  final int? initialYear;
  final bool allowFutureDate;
  final double itemExtent;
  final double? pickerWidth;
  final double? pickerHeight;
  final int? maxYear;
  final int? minYear;
  final Widget Function(DateTime selectedDate)? headerBuilder;
  final Color? selectionColor;
  final TextStyle? monthTextStyle;
  final TextStyle? yearTextStyle;
  final Color? backgroundColor;
  final bool barrierDismissible;
  final Color? headerBackgroundColor;
  final Function(DateTime)? onDateChanged;

  const _PositionedMonthYearPicker({
    required this.buttonPosition,
    required this.buttonSize,
    this.initialMonth,
    this.initialYear,
    this.allowFutureDate = false,
    this.itemExtent = PickerConstants.itemExtent,
    this.pickerWidth,
    this.pickerHeight,
    this.maxYear,
    this.minYear,
    this.headerBuilder,
    this.selectionColor,
    this.monthTextStyle,
    this.yearTextStyle,
    this.backgroundColor,
    required this.barrierDismissible,
    this.headerBackgroundColor,
    this.onDateChanged,
  });

  @override
  State<_PositionedMonthYearPicker> createState() =>
      _PositionedMonthYearPickerState();
}

class _PositionedMonthYearPickerState
    extends State<_PositionedMonthYearPicker> {
  late DateTime _currentSelection;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    int initialYear = widget.initialYear ?? now.year;
    int initialMonth = widget.initialMonth ?? now.month;

    // Apply min/max year constraints
    if (widget.minYear != null && initialYear < widget.minYear!) {
      initialYear = widget.minYear!;
    }
    if (widget.maxYear != null && initialYear > widget.maxYear!) {
      initialYear = widget.maxYear!;
    }

    // Clamp to present if future dates not allowed
    if (!widget.allowFutureDate) {
      if (initialYear > now.year ||
          (initialYear == now.year && initialMonth > now.month)) {
        initialYear = now.year;
        initialMonth = now.month;
      }
    }

    _currentSelection = DateTime(initialYear, initialMonth);
  }

  void _handleSelectionChanged(DateTime dateTime) {
    _currentSelection = dateTime;
    widget.onDateChanged?.call(dateTime);
    setState(() {});
  }

  void _handleCancel() {
    Navigator.of(context).pop(null);
  }

  void _handleDone() {
    Navigator.of(context).pop(_currentSelection);
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    // Default picker dimensions
    final double pickerWidth =
        widget.pickerWidth ?? PickerConstants.pickerWidth;
    final double pickerHeight =
        widget.pickerHeight ?? PickerConstants.pickerHeight;

    // Calculate position above the button
    double left = widget.buttonPosition.dx +
        (widget.buttonSize.width / 2) -
        (pickerWidth / 2);
    double top =
        widget.buttonPosition.dy - pickerHeight - 8; // 8px gap above button

    // Adjust horizontal position if picker goes off screen
    if (left < 16) {
      left = 16; // Minimum margin from left edge
    } else if (left + pickerWidth > screenWidth - 16) {
      left = screenWidth - pickerWidth - 16; // Minimum margin from right edge
    }

    // Adjust vertical position if picker goes off screen top
    if (top < mediaQuery.padding.top + 16) {
      // Show below the button instead
      top = widget.buttonPosition.dy + widget.buttonSize.height + 8;
    }

    // If still doesn't fit, adjust to fit screen
    if (top + pickerHeight > screenHeight - mediaQuery.padding.bottom - 16) {
      top = screenHeight - pickerHeight - mediaQuery.padding.bottom - 16;
    }

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Invisible barrier for dismissing
          Positioned.fill(
            child: GestureDetector(
              onTap: widget.barrierDismissible ? _handleCancel : null,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Positioned picker
          Positioned(
            left: left,
            top: top,
            child: Container(
              width: pickerWidth,
              height: pickerHeight,
              decoration: BoxDecoration(
                color:
                    widget.backgroundColor ?? CupertinoColors.systemBackground,
                borderRadius:
                    BorderRadius.circular(PickerConstants.borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: MonthYearPicker(
                initialMonth: _currentSelection.month,
                initialYear: _currentSelection.year,
                allowFutureDate: widget.allowFutureDate,
                itemExtent: widget.itemExtent,
                maxYear: widget.maxYear,
                minYear: widget.minYear,
                headerBuilder: widget.headerBuilder,
                selectionColor: widget.selectionColor,
                monthTextStyle: widget.monthTextStyle,
                yearTextStyle: widget.yearTextStyle,
                backgroundColor: widget.backgroundColor,
                headerBackgroundColor: widget.headerBackgroundColor,
                onSelectionChanged: _handleSelectionChanged,
                onDateChanged: widget.onDateChanged,
                onCancel: _handleCancel,
                onDone: _handleDone,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// MARK: - Main Picker Widget
class MonthYearPicker extends StatefulWidget {
  final int? initialMonth;
  final int? initialYear;
  final double itemExtent;
  final bool allowFutureDate;
  final int? maxYear;
  final int? minYear;
  final Widget Function(DateTime selectedDate)? headerBuilder;
  final Color? selectionColor;
  final TextStyle? monthTextStyle;
  final TextStyle? yearTextStyle;
  final Color? backgroundColor;
  final Function(DateTime)? onSelectionChanged;
  final Function(DateTime)? onDateChanged;
  final VoidCallback? onCancel;
  final VoidCallback? onDone;
  final Color? headerBackgroundColor;
  const MonthYearPicker({
    super.key,
    this.initialMonth,
    this.initialYear,
    this.itemExtent = PickerConstants.itemExtent,
    this.allowFutureDate = false,
    this.maxYear,
    this.minYear,
    this.headerBuilder,
    this.selectionColor,
    this.monthTextStyle,
    this.yearTextStyle,
    this.backgroundColor,
    this.onSelectionChanged,
    this.onDateChanged,
    this.onCancel,
    this.onDone,
    this.headerBackgroundColor,
  })  : assert(
          initialMonth == null || (initialMonth >= 1 && initialMonth <= 12),
          'initialMonth must be between 1 and 12 if provided',
        ),
        assert(
          minYear == null || maxYear == null || minYear <= maxYear,
          'minYear must be less than or equal to maxYear',
        );

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  late final DateTime _now;
  late final List<int> _yearList;
  late Month _selectedMonth;
  late int _selectedYear;
  late Month _scrolledMonth;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _yearList = _generateYearList();
    _initializeSelection();
  }

  List<int> _generateYearList() {
    final baseYear = widget.initialYear ?? _now.year;
    final defaultMinYear = widget.minYear ?? (baseYear - 100);
    final defaultMaxYear = widget.maxYear ?? (baseYear + 100);

    final startYear = widget.minYear ?? defaultMinYear;
    final endYear = widget.maxYear ?? defaultMaxYear;

    return List.generate(endYear - startYear + 1, (i) => startYear + i);
  }

  void _initializeSelection() {
    int initialYear = widget.initialYear ?? _now.year;
    int initialMonth = widget.initialMonth ?? _now.month;

    if (widget.minYear != null && initialYear < widget.minYear!) {
      initialYear = widget.minYear!;
    }
    if (widget.maxYear != null && initialYear > widget.maxYear!) {
      initialYear = widget.maxYear!;
    }

    if (!widget.allowFutureDate) {
      final clampedDate = _clampToPresent(initialYear, initialMonth);
      initialYear = clampedDate.year;
      initialMonth = clampedDate.month;
    }

    _selectedYear = initialYear;
    _selectedMonth = initialMonth.toMonth();
    _scrolledMonth = _selectedMonth;
  }

  DateTime _clampToPresent(int year, int month) {
    if (year > _now.year || (year == _now.year && month > _now.month)) {
      return DateTime(_now.year, _now.month);
    }
    return DateTime(year, month);
  }

  bool _isYearWithinBounds(int year) {
    if (widget.minYear != null && year < widget.minYear!) return false;
    if (widget.maxYear != null && year > widget.maxYear!) return false;
    return true;
  }

  void _handleYearChanged(int index) {
    final pickedYear = _yearList[index];

    // Don't proceed if year is out of bounds
    if (!_isYearWithinBounds(pickedYear)) return;

    Month newMonth = _selectedMonth;
    int newYear = pickedYear;

    // Handle future date constraints
    if (!widget.allowFutureDate) {
      if (pickedYear > _now.year) {
        // If picked year is in the future, clamp to current year and month
        newYear = _now.year;
        newMonth = _now.month.toMonth();
      } else if (pickedYear == _now.year &&
          _selectedMonth.number > _now.month) {
        // If picked year is current year but selected month is in the future, clamp month
        newMonth = _now.month.toMonth();
      } else if (_selectedMonth.name != _scrolledMonth.name) {
        // If picked year is in the past, keep current month selection
        newMonth = _scrolledMonth;
      }
      // If picked year is in the past, keep current month selection
    }

    // Always update the selection to ensure header updates
    _updateSelection(newMonth, newYear);
  }

// Also update _handleMonthChanged for consistency:
  void _handleMonthChanged(int index) {
    final pickedMonth = (index + 1).toMonth();
    int newYear = _selectedYear;
    Month newMonth = pickedMonth;
    _scrolledMonth = pickedMonth;

    // Handle future date constraints
    if (!widget.allowFutureDate &&
        _selectedYear == _now.year &&
        pickedMonth.number > _now.month) {
      // If trying to select future month in current year, clamp to current month
      newMonth = _now.month.toMonth();
    }

    _updateSelection(newMonth, newYear);
  }

  void _updateSelection(Month month, int year) {
    setState(() {
      _selectedMonth = month;
      _selectedYear = year;
    });

    final selectedDate = DateTime(year, month.number);
    widget.onSelectionChanged?.call(selectedDate);
    widget.onDateChanged?.call(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = DateTime(_selectedYear, _selectedMonth.number);

    return Container(
      constraints: BoxConstraints(maxWidth: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: widget.backgroundColor ?? CupertinoColors.systemBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget.headerBuilder?.call(selectedDate) ??
              _PickerHeader(
                backgroundColor: widget.headerBackgroundColor,
                selectedMonth: _selectedMonth.name,
                selectedYear: _selectedYear.toString(),
              ),
          const SizedBox(height: 10),
          _PickerBody(
            itemExtent: widget.itemExtent,
            selectedMonth: _selectedMonth,
            selectedYear: _selectedYear,
            yearList: _yearList,
            allowFutureDate: widget.allowFutureDate,
            nowYear: _now.year,
            nowMonth: _now.month,
            minYear: widget.minYear,
            maxYear: widget.maxYear,
            selectionColor: widget.selectionColor,
            monthTextStyle: widget.monthTextStyle,
            yearTextStyle: widget.yearTextStyle,
            onMonthChanged: _handleMonthChanged,
            onYearChanged: _handleYearChanged,
          ),
          Spacer(),
          _PickerActions(
            onCancel: widget.onCancel ?? () {},
            onDone: widget.onDone ?? () {},
          ),
        ],
      ),
    );
  }
}

// MARK: - Header Widget
class _PickerHeader extends StatefulWidget {
  final String selectedMonth;
  final String selectedYear;
  final Color? backgroundColor;

  const _PickerHeader({
    required this.selectedMonth,
    required this.selectedYear,
    this.backgroundColor,
  });

  @override
  State<_PickerHeader> createState() => _PickerHeaderState();
}

class _PickerHeaderState extends State<_PickerHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? CupertinoColors.link,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(PickerConstants.borderRadius),
          topRight: Radius.circular(PickerConstants.borderRadius),
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${widget.selectedMonth} ',
              style: PickerConstants.headerTextStyle),
          Text(
            widget.selectedYear,
            style: PickerConstants.headerTextStyle,
          ),
        ],
      ),
    );
  }
}

// MARK: - Actions Widget
class _PickerActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onDone;

  const _PickerActions({
    required this.onCancel,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: PickerConstants.actionButtonHeight,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 0.2, color: CupertinoColors.systemGrey),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: onCancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: CupertinoColors.destructiveRed),
                ),
              ),
            ),
            Container(
              width: 0.2,
              color: CupertinoColors.systemGrey,
            ),
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 12),
                onPressed: onDone,
                child: const Text(
                  'Done',
                  style: TextStyle(color: CupertinoColors.activeBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows a month-year picker positioned above a button widget.
///
/// [buttonKey] - GlobalKey of the button widget to position above
/// [context] - BuildContext for the overlay
/// [maxYear] - Maximum selectable year (optional)
/// [minYear] - Minimum selectable year (optional)
/// [headerBuilder] - Custom widget builder for header with selected date
/// [selectionColor] - Color for the selection overlay
/// [monthTextStyle] - Text style for month text
/// [yearTextStyle] - Text style for year text
/// [backgroundColor] - Background color of the picker
/// [onDateChanged] - Callback triggered when the selected date changes
///
/// Returns `Future<DateTime>?` where:
/// - `DateTime` if user selects a date and taps "Done"
/// - `null` if user cancels or dismisses the picker
///

/// Example usage:
///
/// ```dart
/// final GlobalKey buttonKey = GlobalKey();
///
/// // Inside your widget's build method:
/// ElevatedButton(
///   key: buttonKey,
///   onPressed: () async {
///     final pickedDate = await showMonthYearPicker(
///       context: context,
///       buttonKey: buttonKey,
///       initialYear: 2024,
///       allowFutureDate: false,
///       onDateChanged: (DateTime date) {
///         print('Date changed to: ${date.month}/${date.year}');
///       },
///     );
///     if (pickedDate != null) {
///       // Use pickedDate (DateTime)
///     }
///   },
///   child: Text('Pick Month/Year'),
/// )
/// ```
Future<DateTime?> showMonthYearPicker({
  required BuildContext context,
  required GlobalKey buttonKey,
  int? initialMonth,
  int? initialYear,
  bool allowFutureDate = false,
  double itemExtent = PickerConstants.itemExtent,
  Color? barrierColor,
  bool barrierDismissible = false,
  double? pickerWidth,
  double? pickerHeight,
  int? maxYear,
  int? minYear,
  Widget Function(DateTime selectedDate)? headerBuilder,
  Color? selectionColor,
  TextStyle? monthTextStyle,
  TextStyle? yearTextStyle,
  Color? backgroundColor,
  Color? headerBackgroundColor,
  Function(DateTime)? onDateChanged,
}) async {
  // Get button position and size
  final RenderBox? buttonRenderBox =
      buttonKey.currentContext?.findRenderObject() as RenderBox?;

  if (buttonRenderBox == null) {
    throw Exception(
        'Button not found. Make sure the GlobalKey is attached to the button widget.');
  }

  final Offset buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);
  final Size buttonSize = buttonRenderBox.size;

  return await showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor ?? CupertinoColors.black.withValues(alpha: 0.1),
    barrierLabel: 'Month Year Picker',
    pageBuilder: (context, animation, secondaryAnimation) {
      return _PositionedMonthYearPicker(
        buttonPosition: buttonPosition,
        buttonSize: buttonSize,
        initialMonth: initialMonth,
        initialYear: initialYear,
        allowFutureDate: allowFutureDate,
        itemExtent: itemExtent,
        pickerWidth: pickerWidth,
        pickerHeight: pickerHeight,
        maxYear: maxYear,
        minYear: minYear,
        headerBuilder: headerBuilder,
        selectionColor: selectionColor,
        monthTextStyle: monthTextStyle,
        yearTextStyle: yearTextStyle,
        backgroundColor: backgroundColor,
        barrierDismissible: barrierDismissible,
        headerBackgroundColor: headerBackgroundColor,
        onDateChanged: onDateChanged,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        ),
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

class _PickerBody extends StatefulWidget {
  final double itemExtent;
  final Month selectedMonth;
  final int selectedYear;
  final List<int> yearList;
  final bool allowFutureDate;
  final int nowYear;
  final int nowMonth;
  final int? minYear;
  final int? maxYear;
  final Color? selectionColor;
  final TextStyle? monthTextStyle;
  final TextStyle? yearTextStyle;
  final ValueChanged<int> onMonthChanged;
  final ValueChanged<int> onYearChanged;

  const _PickerBody({
    super.key,
    required this.itemExtent,
    required this.selectedMonth,
    required this.selectedYear,
    required this.yearList,
    required this.allowFutureDate,
    required this.nowYear,
    required this.nowMonth,
    this.minYear,
    this.maxYear,
    this.selectionColor,
    this.monthTextStyle,
    this.yearTextStyle,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  State<_PickerBody> createState() => _PickerBodyState();
}

class _PickerBodyState extends State<_PickerBody> {
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _yearController;
  bool _isInitialized = false;
  bool _isUserScrolling = false; // Track if user is actively scrolling

  @override
  void initState() {
    super.initState();
    _monthController = FixedExtentScrollController(
      initialItem: widget.selectedMonth.index,
    );
    _yearController = FixedExtentScrollController(
      initialItem: widget.yearList.indexOf(widget.selectedYear),
    );
    _isInitialized = true;
  }

  @override
  void didUpdateWidget(_PickerBody oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Only update controllers if the selection changed programmatically
    // and user is not actively scrolling
    if (_isInitialized && !_isUserScrolling) {
      // Update month controller
      if (oldWidget.selectedMonth != widget.selectedMonth &&
          _monthController.selectedItem != widget.selectedMonth.index) {
        _monthController.animateToItem(
          widget.selectedMonth.index,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }

      // Update year controller
      final newYearIndex = widget.yearList.indexOf(widget.selectedYear);
      if (oldWidget.selectedYear != widget.selectedYear &&
          _yearController.selectedItem != newYearIndex) {
        _yearController.animateToItem(
          newYearIndex,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _onMonthChanged(int index) {
    _isUserScrolling = true;
    widget.onMonthChanged(index);
    // Reset scrolling flag after a short delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _isUserScrolling = false;
      }
    });
  }

  void _onYearChanged(int index) {
    _isUserScrolling = true;
    widget.onYearChanged(index);
    // Reset scrolling flag after a short delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) {
        _isUserScrolling = false;
      }
    });
  }

  @override
  void dispose() {
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.itemExtent * 5,
      child: Stack(
        children: [
          _buildSelectionOverlay(),
          _buildPickerRow(),
        ],
      ),
    );
  }

  Widget _buildSelectionOverlay() {
    return Positioned.fill(
      child: Column(
        children: [
          Expanded(flex: 2, child: Container()),
          Container(
            height: widget.itemExtent,
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color:
                  widget.selectionColor ?? CupertinoColors.tertiarySystemFill,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          Expanded(flex: 2, child: Container()),
        ],
      ),
    );
  }

  Widget _buildPickerRow() {
    return Row(
      children: [
        Expanded(child: _buildMonthPicker()),
        Expanded(child: _buildYearPicker()),
      ],
    );
  }

  Widget _buildMonthPicker() {
    return CupertinoPicker(
      scrollController: _monthController,
      itemExtent: widget.itemExtent,
      looping: true,
      onSelectedItemChanged: _onMonthChanged,
      backgroundColor: CupertinoColors.transparent,
      selectionOverlay: Container(),
      children: monthNames.asMap().entries.map((entry) {
        final index = entry.key;
        final name = entry.value;
        final isDisabled = !widget.allowFutureDate &&
            widget.selectedYear == widget.nowYear &&
            index + 1 > widget.nowMonth;

        return Center(
          child: Text(
            name,
            style: (widget.monthTextStyle ?? const TextStyle(fontSize: 18))
                .copyWith(
              color: isDisabled
                  ? CupertinoColors.inactiveGray
                  : widget.monthTextStyle?.color ?? CupertinoColors.label,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildYearPicker() {
    return CupertinoPicker(
      scrollController: _yearController,
      itemExtent: widget.itemExtent,
      onSelectedItemChanged: _onYearChanged,
      backgroundColor: CupertinoColors.transparent,
      selectionOverlay: Container(),
      children: widget.yearList.map((year) {
        bool isDisabled = false;

        // Check future date constraint
        if (!widget.allowFutureDate && year > widget.nowYear) {
          isDisabled = true;
        }

        // Check min/max year constraints
        if (widget.minYear != null && year < widget.minYear!) {
          isDisabled = true;
        }
        if (widget.maxYear != null && year > widget.maxYear!) {
          isDisabled = true;
        }

        return Center(
          child: Text(
            year.toString(),
            style: (widget.yearTextStyle ?? const TextStyle(fontSize: 18))
                .copyWith(
              color: isDisabled
                  ? CupertinoColors.inactiveGray
                  : widget.yearTextStyle?.color ?? CupertinoColors.label,
            ),
          ),
        );
      }).toList(),
    );
  }
}
