import 'dart:async';

class Event {
  const Event();
}

abstract class BlocModel {
  final _eventController = StreamController<Event>();

  BlocModel() {
    _eventController.stream.listen(onEvent);
  }

  void dispose() {
    _eventController.close();
  }

  void post(Event event) {
    _eventController.sink.add(event);
  }

  void onEvent(Event event);
}