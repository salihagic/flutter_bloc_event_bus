import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_event_bus/bus/event_bus.dart';

/// A [Cubit] that observes events from an [EventBus].
///
/// This abstract class extends [Cubit] and listens to events from an [EventBus].
/// When an event is received, it calls the [observe] method, which must be
/// implemented by subclasses to handle specific events.
///
/// The [BusObserverCubit] automatically subscribes to the [EventBus] when
/// created and unsubscribes when closed.
///
/// [S] represents the state type of the Cubit.
abstract class BusObserverCubit<S> extends Cubit<S> {
  /// The subscription to the [EventBus] stream.
  StreamSubscription? _eventBusStreamSubscription;

  /// Creates a [BusObserverCubit] with an initial state.
  ///
  /// Upon creation, it subscribes to the [EventBus] stream and listens for events.
  /// When an event is received, the [observe] method is called.
  BusObserverCubit(super.initialState) {
    // Subscribe to the EventBus stream and listen for events.
    // When an event is received, the [observe] method is invoked.
    _eventBusStreamSubscription = eventBus.stream.listen(observe);
  }

  /// Handles events received from the [EventBus].
  ///
  /// This method must be implemented by subclasses to define how specific
  /// events should be handled.
  ///
  /// [event] is the event object received from the [EventBus].
  void observe(Object event);

  /// Closes the [BusObserverCubit] and cancels the [EventBus] subscription.
  ///
  /// This method ensures that the subscription to the [EventBus] is canceled
  /// before the Cubit is closed, preventing memory leaks.
  @override
  Future<void> close() async {
    // Cancel the EventBus subscription if it exists.
    _eventBusStreamSubscription?.cancel();

    // Close the Cubit.
    await super.close();
  }
}
