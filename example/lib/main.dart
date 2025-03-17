// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc_event_bus/flutter_bloc_event_bus.dart';

// Can you make a nice README.MD documentation that showcases value of this "flutter_bloc_event_bus" package and that showcases how to use it
// Please make this as a downloadable file

void main() {
  exampleWithCubits();
  exampleWithBlocs();
}

void exampleWithCubits() {
  // Create an instance of ExampleBusPublisherCubit with an initial state (value = 0).
  final exampleBusPublisherCubit = ExampleBusPublisherCubit(ExampleBusPublisherState(value: 0));

  // Create an instance of ExampleBusObserverCubit with an initial state of 0.
  final exampleBusObserverCubit = ExampleBusObserverCubit(0);

  // Create an instance of ExampleBusBridgeCubit with an initial state (value = 0).
  final exampleBusBridgeCubit = ExampleBusBridgeCubit(ExampleBusBridgeState(value: 0));

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

  @override
  ExampleBusPublisherState copyWith({int? value}) {
    return ExampleBusPublisherState(value: value ?? this.value);
  }
}

// A cubit that acts as an event provider, emitting ExampleBusPublisherState events.
class ExampleBusPublisherCubit extends BusPublisherCubit<ExampleBusPublisherState> {
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
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusObserverCubit])');
    }

    // If the event is of type ExampleBusBridgeState, print a different message.
    if (event is ExampleBusBridgeState) {
      debugPrint('New ExampleBusBridgeState state with value: ${event.value} (detected in [ExampleBusObserverCubit])');
    }
  }
}

// Defines a different event type that will be emitted by ExampleBusBridgeCubit.
class ExampleBusBridgeState implements Event {
  final int value;

  ExampleBusBridgeState({required this.value});

  @override
  ExampleBusBridgeState copyWith({int? value}) {
    return ExampleBusBridgeState(value: value ?? this.value);
  }
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
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusBridgeCubit])');
    }
  }
}

void exampleWithBlocs() {
  // Create an instance of ExampleBusPublisherBloc with an initial state (value = 0).
  final exampleBusPublisherBloc = ExampleBusPublisherBloc(ExampleBusPublisherState(value: 0));

  // Create an instance of ExampleBusObserverBloc with an initial state of 0.
  final exampleBusObserverBloc = ExampleBusObserverBloc(0);

  // Create an instance of ExampleBusBridgeBloc with an initial state (value = 0).
  final exampleBusBridgeBloc = ExampleBusBridgeBloc(ExampleBusBridgeState(value: 0));

  // Dispatch a new event with value = 1 to ExampleBusPublisherBloc.
  exampleBusPublisherBloc.add(ExampleBusPublisherEvent(value: 1));

  // The ExampleBusObserverBloc listens to this event and prints:
  // "New worker state with value: 1 (detected in [ExampleBusObserverBloc])" to console.
  // The ExampleBusBridgeBloc also listens to this event and prints:
  // "New worker state with value: 1 (detected in [ExampleBusBridgeBloc])" to console.

  exampleBusBridgeBloc.add(ExampleBusBridgeEvent(value: 1));

  // The ExampleBusObserverBloc listens to this event from ExampleBusBridgeBloc
  // and prints: "New worker-listener state with value: 1 (detected in [ExampleBusObserverBloc])" to console.

  exampleBusBridgeBloc.add(ExampleBusBridgeEvent(value: 2));

  // The ExampleBusObserverBloc listens to this event from ExampleBusBridgeBloc
  // and prints: "New worker-listener state with value: 2 (detected in [ExampleBusObserverBloc])" to console.
}

// Defines a custom event type that will be dispatched to ExampleBusPublisherBloc.
class ExampleBusPublisherEvent {
  final int value;

  ExampleBusPublisherEvent({required this.value});
}

// A Bloc that acts as an event provider, emitting ExampleBusPublisherState states.
class ExampleBusPublisherBloc extends BusPublisherBloc<ExampleBusPublisherEvent, ExampleBusPublisherState> {
  ExampleBusPublisherBloc(super.initialState) {
    on<ExampleBusPublisherEvent>(_update);
  }

  // Method to update the state by emitting a new state with a given value.
  Future<void> _update(ExampleBusPublisherEvent event, Emitter<ExampleBusPublisherState> emit) async => emit(ExampleBusPublisherState(value: event.value));
}

// Defines a generic event type that ExampleBusObserverBloc will observe.
class ExampleBusObserverEvent {}

// A Bloc that listens to events from event providers and reacts accordingly.
class ExampleBusObserverBloc extends BusObserverBloc<ExampleBusObserverEvent, int> {
  ExampleBusObserverBloc(super.initialState);

  @override
  void observe(Object event) {
    // If the event is of type ExampleBusPublisherState, print a message to the console.
    if (event is ExampleBusPublisherState) {
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusObserverBloc])');
    }

    // If the event is of type ExampleBusBridgeState, print a different message.
    if (event is ExampleBusBridgeState) {
      debugPrint('New ExampleBusBridgeState state with value: ${event.value} (detected in [ExampleBusObserverBloc])');
    }
  }
}

// Defines a different event type that will be dispatched to ExampleBusBridgeBloc.
class ExampleBusBridgeEvent {
  final int value;

  ExampleBusBridgeEvent({required this.value});
}

// A Bloc that emits ExampleBusBridgeState states.
class ExampleBusBridgeBloc extends BusBridgeBloc<ExampleBusBridgeEvent, ExampleBusBridgeState> {
  ExampleBusBridgeBloc(super.initialState) {
    on<ExampleBusBridgeEvent>(_update);
  }

  // Method to update the state by emitting a new ExampleBusBridgeState.
  Future<void> _update(ExampleBusBridgeEvent event, Emitter<ExampleBusBridgeState> emit) async => emit(ExampleBusBridgeState(value: event.value));

  @override
  void observe(Object event) {
    // If the event is of type ExampleBusPublisherState, print a message.
    if (event is ExampleBusPublisherState) {
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusBridgeBloc])');
    }
  }
}
