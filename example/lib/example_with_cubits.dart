import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc_event_bus/flutter_bloc_event_bus.dart';

void exampleWithCubits() {
  // Create an instance of ExampleBusPublisherCubit with an initial state (value = 0).
  final exampleBusPublisherCubit = ExampleBusPublisherCubit(
    ExampleBusPublisherState(value: 0),
  );

  // Create an instance of ExampleBusObserverCubit with an initial state of 0.
  final exampleBusObserverCubit = ExampleBusObserverCubit(0);

  // Create an instance of ExampleBusBridgeCubit with an initial state (value = 0).
  final exampleBusBridgeCubit = ExampleBusBridgeCubit(
    ExampleBusBridgeState(value: 0),
  );

  // Emit a new event with value = 1 from ExampleBusPublisherCubit.
  exampleBusPublisherCubit.update(1);

  // The ExampleBusObserverCubit listens to events and prints:
  // "New worker state with value: 1 (detected in [ExampleBusObserverCubit])" to console.
  // The ExampleBusBridgeCubit listens to events and prints:
  // "New worker state with value: 1 (detected in [ExampleBusBridgeCubit])" to console.

  exampleBusBridgeCubit.update(1);

  // The ExampleBusObserverCubit listens to the event from ExampleBusBridgeCubit
  // and prints: "New worker-listener state with value: 1 (detected in [ExampleBusObserverCubit])" to console.

  exampleBusBridgeCubit.update(2);

  // The ExampleBusObserverCubit listens to the event from ExampleBusBridgeCubit
  // and prints: "New worker-listener state with value: 2 (detected in [ExampleBusObserverCubit])" to console.
}

// Defines a custom event type that will be emitted by ExampleBusPublisherCubit.
class ExampleBusPublisherState implements Event {
  final int value;

  ExampleBusPublisherState({required this.value});
}

// A cubit that acts as an event provider, emitting ExampleBusPublisherState events.
class ExampleBusPublisherCubit
    extends BusPublisherCubit<ExampleBusPublisherState> {
  ExampleBusPublisherCubit(super.initialState);

  // Method to update the state by emitting a new event with a given value.
  void update(int value) => emit(ExampleBusPublisherState(value: value));
}

// A cubit that listens to events from event providers and reacts accordingly.
class ExampleBusObserverCubit extends BusObserverCubit<int> {
  ExampleBusObserverCubit(super.initialState);

  @override
  void observe(Object event) {
    // If the event is of type ExampleBusPublisherState, print a message to the console.
    if (event is ExampleBusPublisherState) {
      debugPrint(
        'New worker state with value: ${event.value} (detected in [ExampleBusObserverCubit])',
      );
    }

    // If the event is of type ExampleBusBridgeState, print a different message.
    if (event is ExampleBusBridgeState) {
      debugPrint(
        'New worker-listener state with value: ${event.value} (detected in [ExampleBusObserverCubit])',
      );
    }
  }
}

// Defines a different event type that will be emitted by ExampleBusBridgeCubit.
class ExampleBusBridgeState implements Event {
  final int value;

  ExampleBusBridgeState({required this.value});
}

// A cubit that emits ExampleBusBridgeState events.
class ExampleBusBridgeCubit extends BusBridgeCubit<ExampleBusBridgeState> {
  ExampleBusBridgeCubit(super.initialState);

  // Method to update the state by emitting a new ExampleBusBridgeState event.
  void update(int value) => emit(ExampleBusBridgeState(value: value));

  @override
  void observe(Object event) {
    // If the event is of type ExampleBusPublisherState, print a message.
    if (event is ExampleBusPublisherState) {
      debugPrint(
        'New worker state with value: ${event.value} (detected in [ExampleBusBridgeCubit])',
      );
    }
  }
}

// Can you document this code bellow in the same way that the code above was documented
void exampleWithBlocs() {
  final exampleBusPublisherBloc = ExampleBusPublisherBloc(
    ExampleBusPublisherState(value: 0),
  );
  final exampleBusObserverBloc = ExampleBusObserverBloc(0);
  final exampleBusBridgeBloc = ExampleBusBridgeBloc(
    ExampleBusBridgeState(value: 0),
  );

  exampleBusPublisherBloc.add(ExampleBusPublisherEvent(value: 1));
  exampleBusBridgeBloc.add(ExampleBusBridgeEvent(value: 1));
  exampleBusBridgeBloc.add(ExampleBusBridgeEvent(value: 2));
}

class ExampleBusPublisherEvent {
  final int value;

  ExampleBusPublisherEvent({required this.value});
}

class ExampleBusPublisherBloc
    extends
        BusPublisherBloc<ExampleBusPublisherEvent, ExampleBusPublisherState> {
  ExampleBusPublisherBloc(super.initialState) {
    on<ExampleBusPublisherEvent>(_update);
  }

  Future<void> _update(
    ExampleBusPublisherEvent event,
    Emitter<ExampleBusPublisherState> emit,
  ) async => emit(ExampleBusPublisherState(value: event.value));
}

class ExampleBusObserverEvent {}

class ExampleBusObserverBloc
    extends BusObserverBloc<ExampleBusObserverEvent, int> {
  ExampleBusObserverBloc(super.initialState);

  @override
  void observe(Object event) {
    if (event is ExampleBusPublisherState) {
      debugPrint(
        'New worker state with value: ${event.value} (detected in [ExampleBusObserverBloc])',
      );
    }

    if (event is ExampleBusBridgeState) {
      debugPrint(
        'New worker-listener state with value: ${event.value} (detected in [ExampleBusObserverBloc])',
      );
    }
  }
}

class ExampleBusBridgeEvent {
  final int value;

  ExampleBusBridgeEvent({required this.value});
}

class ExampleBusBridgeBloc
    extends BusBridgeBloc<ExampleBusBridgeEvent, ExampleBusBridgeState> {
  ExampleBusBridgeBloc(super.initialState) {
    on<ExampleBusBridgeEvent>(_update);
  }

  Future<void> _update(
    ExampleBusBridgeEvent event,
    Emitter<ExampleBusBridgeState> emit,
  ) async => emit(ExampleBusBridgeState(value: event.value));

  @override
  void observe(Object event) {
    if (event is ExampleBusPublisherState) {
      debugPrint(
        'New worker state with value: ${event.value} (detected in [ExampleBusBridgeBloc])',
      );
    }
  }
}
