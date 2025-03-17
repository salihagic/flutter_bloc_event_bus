import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_event_bus/bus/event_bus.dart';

/// A [Bloc] that observes events from an [EventBus].
///
/// This abstract class extends [Bloc] and listens to events from an [EventBus].
/// When an event is received, it calls the [observe] method, which must be
/// implemented by subclasses to handle specific events.
///
/// The [BusObserverBloc] automatically subscribes to the [EventBus] when
/// created and unsubscribes when closed.
///
/// [S] represents the state type of the Bloc.
/// [E] represents the event type of the Bloc.
abstract class BusObserverBloc<S, E> extends Bloc<S, E> {
  /// The subscription to the [EventBus] stream.
  ///
  /// This subscription is used to listen to events from the [EventBus] and
  /// forward them to the [observe] method for handling.
  StreamSubscription? _eventBusStreamSubscription;

  /// Creates a [BusObserverBloc] with an initial state.
  ///
  /// Upon creation, it subscribes to the [EventBus] stream and listens for events.
  /// When an event is received, the [observe] method is called.
  BusObserverBloc(super.initialState) {
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

  /// Closes the [BusObserverBloc] and cancels the [EventBus] subscription.
  ///
  /// This method ensures that the subscription to the [EventBus] is canceled
  /// before the Bloc is closed, preventing memory leaks.
  @override
  Future<void> close() async {
    // Cancel the EventBus subscription if it exists.
    _eventBusStreamSubscription?.cancel();

    // Close the Bloc.
    await super.close();
  }
}
