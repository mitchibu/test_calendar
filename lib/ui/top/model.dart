import 'dart:async';

import '../../repo/db.dart';
import '../../util/bloc.dart';
import '../../repo/model/model.dart';

class CalendarModel extends BlocModel {
  CalendarModel(this.repository) : super();

  final DatabaseRepository repository;

  final _navigationController = StreamController<int>();
  Stream<int> get navigation => _navigationController.stream;

  final _paletteController = StreamController<int>();
  Stream<int> get palette => _paletteController.stream;

  final _calendarController = StreamController<Map<DateTime, DayInfo>>();
  Stream<Map<DateTime, DayInfo>> get calendar => _calendarController.stream;

  final data = Map<DateTime, DayInfo>();

  void dispose() {
    super.dispose();
    _calendarController.close();
    _navigationController.close();
    _paletteController.close();
  }

  @override
  void onEvent(Event event) async {
    print('onEvent: $event');
    if (event is UpdateCalendarEvent) {
      data[event.date] = event.data;
      final calendar = Calendar(
        id: event.data.id,
        date: event.date.millisecondsSinceEpoch,
        color: event.data.color,
        icons: event.data.icons,
        memo: event.data.memo,
      );
      repository.putCalendar(calendar);
      _calendarController.sink.add(data);
    } else if (event is UpdateNavigationEvent) {
      _navigationController.sink.add(event.position);
      _paletteController.sink.add(event.position);
    } else if (event is LoadCalendarEvent) {
      data.clear();
      print('load: ${event.startDate} - ${event.endDate}');
      final calendar =
          await repository.findCalendar(event.startDate, event.endDate);
      calendar.forEach((item) {
        final day = DayInfo();
        day.color = item.color;
        day.icons.addAll(item.icons);
        day.memo = item.memo;
        data[DateTime.fromMillisecondsSinceEpoch(item.date)] = day;
      });
      _calendarController.sink.add(data);
    }
  }
}

class UpdateNavigationEvent extends Event {
  const UpdateNavigationEvent(this.position);
  final int position;
}

class UpdateCalendarEvent extends Event {
  const UpdateCalendarEvent(this.date, this.data);
  final DateTime date;
  final DayInfo data;
}

class LoadCalendarEvent extends Event {
  const LoadCalendarEvent(this.startDate, this.endDate);
  final DateTime startDate;
  final DateTime endDate;
}
