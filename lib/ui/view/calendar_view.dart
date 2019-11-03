import 'package:flutter/widgets.dart';

import '../../util/month_display_helper.dart';

typedef DayHeaderWidgetBuilder = Widget Function(
    BuildContext context, DateTime date);
typedef WeekDayWidgetBuilder = Widget Function(
    BuildContext context, int weekday);
typedef DayWidgetBuilder<T> = Widget Function(
    BuildContext context, bool isInside, DateTime date, T data);

class CalendarView<T> extends StatelessWidget {
  CalendarView({
    @required int year,
    @required int month,
    this.dayHeaderWidgetBuilder,
    this.weekDayBuilder,
    @required this.dayBuilder,
    this.data,
    int rowCount = 6,
  })  : date = DateTime(year, month),
        helper = MonthDisplayHelper(year, month, rowCount);
  final DateTime date;
  final MonthDisplayHelper helper;
  final DayHeaderWidgetBuilder dayHeaderWidgetBuilder;
  final WeekDayWidgetBuilder weekDayBuilder;
  final DayWidgetBuilder<T> dayBuilder;
  final Map<DateTime, T> data;

  @override
  Widget build(BuildContext context) {
    final widgets = List<Widget>();
    if (dayHeaderWidgetBuilder != null) {
      widgets.add(dayHeaderWidgetBuilder(context, date));
    }
    if (weekDayBuilder != null) {
      widgets.add(_buildHeader(context, helper.start));
    }
    return Column(
      children: widgets..add(_buildDay(helper.rowCount)),
    );
  }

  Widget _buildHeader(BuildContext context, DateTime date) => Row(
        children: List<Widget>.generate(
          DateTime.daysPerWeek,
          (i) => Expanded(
            child: weekDayBuilder(context, date.add(Duration(days: i)).weekday),
          ),
        ),
      );

  Widget _buildDay(int rowCount) => Expanded(
        child: SizedBox.expand(
          child: LayoutBuilder(
            builder: (context, constraint) => Column(
              children: List<Widget>.generate(
                rowCount,
                (row) => Row(
                  children: List<Widget>.generate(
                    DateTime.daysPerWeek,
                    (column) {
                      final cur = helper.getDateAt(row, column);
                      return Expanded(
                        child: AspectRatio(
                          aspectRatio:
                              (constraint.maxWidth / DateTime.daysPerWeek) /
                                  (constraint.maxHeight / rowCount),
                          child: dayBuilder(context, cur.month == date.month,
                              cur, data == null ? null : data[cur]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
