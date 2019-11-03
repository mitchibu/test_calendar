class MonthDisplayHelper {
  factory MonthDisplayHelper(int year, int month, int rowCount) {
    final date = DateTime(year, month);
    final start = DateTime(
        year, month, 1 - (date.weekday == DateTime.sunday ? 0 : date.weekday));
    final end = DateTime(start.year, start.month,
        start.day + DateTime.daysPerWeek * rowCount - 1);
    return MonthDisplayHelper._(date, start, end, rowCount);
  }

  MonthDisplayHelper._(this.date, this.start, this.end, this.rowCount);
  final DateTime date;
  final DateTime start;
  final DateTime end;
  final int rowCount;

  DateTime getDateAt(int row, int column) {
    return DateTime(start.year, start.month,
        start.day + DateTime.daysPerWeek * row + column);
  }
}
