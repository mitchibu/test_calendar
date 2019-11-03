import 'package:flutter/widgets.dart';

import '../../util/month_display_helper.dart';
import 'calendar_view.dart';

const int _kRowCount = 6;
typedef OnPageShow = void Function(
    BuildContext context, DateTime startDateTime, DateTime endDateTime);

class CalendarCarouselView<T> extends StatefulWidget {
  CalendarCarouselView({
    DateTime date,
    this.dayHeaderWidgetBuilder,
    this.weekDayBuilder,
    @required this.dayBuilder,
    this.onPageShow,
    this.data,
  }) : this.date = date ?? DateTime.now();
  final DateTime date;
  final DayHeaderWidgetBuilder dayHeaderWidgetBuilder;
  final WeekDayWidgetBuilder weekDayBuilder;
  final DayWidgetBuilder<T> dayBuilder;
  final OnPageShow onPageShow;
  final Map<DateTime, T> data;
  @override
  State<StatefulWidget> createState() => _CalendarCarouselViewState<T>();
}

class _CalendarCarouselViewState<T> extends State<CalendarCarouselView<T>> {
  PageController _pageController;

  @override
  Widget build(BuildContext context) {
    final base = DateTime(2000, 1);
    final position =
        (widget.date.year * DateTime.monthsPerYear + widget.date.month) -
            (base.year * DateTime.monthsPerYear + base.month);
    if (_pageController == null) {
      final helper =
          MonthDisplayHelper(base.year, base.month + position, _kRowCount);
      widget.onPageShow(context, helper.start, helper.end);
    }
    return PageView.builder(
      onPageChanged: (position) {
        if (widget.onPageShow != null) {
          final helper =
              MonthDisplayHelper(base.year, base.month + position, _kRowCount);
          widget.onPageShow(context, helper.start, helper.end);
        }
      },
      controller: _pageController =
          _pageController ?? PageController(initialPage: position),
      itemCount: 100 * DateTime.monthsPerYear,
      itemBuilder: (context, position) => CalendarView<T>(
        year: base.year,
        month: base.month + position,
        dayHeaderWidgetBuilder: widget.dayHeaderWidgetBuilder,
        weekDayBuilder: widget.weekDayBuilder,
        dayBuilder: widget.dayBuilder,
        data: widget.data,
        rowCount: _kRowCount,
      ),
    );
  }

  @override
  void dispose() {
    if (_pageController != null) {
      _pageController.dispose();
    }
    super.dispose();
  }
}
