import 'package:flutter_bloc/flutter_bloc.dart';

IEventBus eventBus = EventBus();

abstract class IEventBus {
  Stream<Event> get stream;

  void send(Event event);
}

class EventBus extends Cubit<Event> implements IEventBus {
  EventBus() : super(InitialEvent());

  @override
  void send(Event event) => emit(event);
}

abstract class Event {
  dynamic copyWith();
}

class InitialEvent implements Event {
  @override
  dynamic copyWith() {}
}
