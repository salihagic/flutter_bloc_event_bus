import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_event_bus/bus/event_bus.dart';
import 'package:flutter_bloc_event_bus/bus/event_but_stream_extensions.dart';

/// A [Cubit] that acts as a mediator between its state changes and an [EventBus].
///
/// This abstract class extends [Cubit] and performs two key roles:
/// 1. Publishes its state changes to an [EventBus].
/// 2. Listens to events from the [EventBus] and handles them via the [observe] method.
///
/// The [BusBridgeCubit] automatically subscribes to its own state stream and
/// the [EventBus] stream when created. It also ensures that all subscriptions
/// are canceled when the Cubit is closed, preventing memory leaks.
///
/// [S] represents the state type of the Cubit.
abstract class BusBridgeCubit<S> extends Cubit<S> {
  /// The subscription to the Cubit's state stream.
  ///
  /// This subscription is used to listen to state changes and publish them
  /// to the [EventBus].
  StreamSubscription? _stateStreamSubscription;

  /// The subscription to the [EventBus] stream.
  ///
  /// This subscription is used to listen to events from the [EventBus] and
  /// handle them via the [observe] method.
  StreamSubscription? _eventBusStreamSubscription;

  /// Creates a [BusBridgeCubit] with an initial state.
  ///
  /// Upon creation, it performs the following:
  /// 1. Subscribes to its own state stream and attaches it to the [EventBus],
  ///    allowing state changes to be published to the bus.
  /// 2. Subscribes to the [EventBus] stream to listen for events and handle
  ///    them via the [observe] method.
  BusBridgeCubit(super.initialState) {
    // Attach the Cubit's state stream to the EventBus to publish state changes.
    _stateStreamSubscription = stream.attachToEventBus();

    // Subscribe to the EventBus stream to listen for events.
    _eventBusStreamSubscription = eventBus.stream.listen(observe);
  }

  /// Handles events received from the [EventBus].
  ///
  /// This method must be implemented by subclasses to define how specific
  /// events should be handled.
  ///
  /// [event] is the event object received from the [EventBus].
  void observe(Object event);

  /// Closes the [BusBridgeCubit] and cancels all active subscriptions.
  ///
  /// This method ensures that both the state stream subscription and the
  /// [EventBus] subscription are canceled before the Cubit is closed,
  /// preventing memory leaks.
  @override
  Future<void> close() async {
    // Cancel the state stream subscription if it exists.
    _stateStreamSubscription?.cancel();

    // Cancel the EventBus subscription if it exists.
    _eventBusStreamSubscription?.cancel();

    // Close the Cubit.
    await super.close();
  }
}
