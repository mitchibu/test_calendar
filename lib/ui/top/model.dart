import 'dart:async';

import '../../repo/sample.dart';
import '../../util/bloc.dart';
import '../../repo/model/model.dart';

class CalendarModel extends BlocModel {
  CalendarModel(this.repository) : super();

  final SampleRepository repository;

  final _navigationController = StreamController<int>();
  Stream<int> get navigation => _navigationController.stream;

  final _paletteController = StreamController<int>();
  Stream<int> get palette => _paletteController.stream;

  final _calendarController = StreamController<Map<DateTime, DayInfo>>();
  Stream<Map<DateTime, DayInfo>> get calendar => _calendarController.stream;

  final test = <DateTime, DayInfo>{
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day):
        DayInfo()..color = 0xffff0000
  };

  void dispose() {
    super.dispose();
    _calendarController.close();
    _navigationController.close();
    _paletteController.close();
  }

  @override
  void onEvent(Event event) {
    print('onEvent: $event');
    if (event is UpdateCalendarEvent) {
      test[event.date] = event.data;
      _calendarController.sink.add(test);
    } else if (event is UpdateNavigationEvent) {
      _navigationController.sink.add(event.position);
      _paletteController.sink.add(event.position);
    } else if (event is LoadCalendarEvent) {
      print('load: ${event.startDate} - ${event.endDate}');
      _calendarController.sink.add(test);
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
