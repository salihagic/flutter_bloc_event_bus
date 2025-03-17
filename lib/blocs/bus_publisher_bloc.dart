import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_event_bus/bus/event_but_stream_extensions.dart';

/// A [Bloc] that publishes its state changes to an [EventBus].
///
/// This abstract class extends [Bloc] and automatically publishes its state
/// changes to an [EventBus]. It subscribes to its own state stream and attaches
/// it to the [EventBus] when created.
///
/// The [BusPublisherBloc] ensures that the subscription to the state stream
/// is canceled when the Bloc is closed, preventing memory leaks.
///
/// [S] represents the state type of the Bloc.
/// [E] represents the event type of the Bloc.
abstract class BusPublisherBloc<S, E> extends Bloc<S, E> {
  /// The subscription to the Bloc's state stream.
  ///
  /// This subscription is used to listen to state changes and publish them
  /// to the [EventBus].
  StreamSubscription? _stateStreamSubscription;

  /// Creates a [BusPublisherBloc] with an initial state.
  ///
  /// Upon creation, it subscribes to the Bloc's state stream and attaches it
  /// to the [EventBus]. This ensures that all state changes are published
  /// to the [EventBus].
  BusPublisherBloc(super.initialState) {
    // Subscribe to the Bloc's state stream and attach it to the EventBus.
    // This allows other parts of the application to listen to state changes
    // via the EventBus.
    _stateStreamSubscription = stream.attachToEventBus();
  }

  /// Closes the [BusPublisherBloc] and cancels the state stream subscription.
  ///
  /// This method ensures that the subscription to the state stream is canceled
  /// before the Bloc is closed, preventing memory leaks.
  @override
  Future<void> close() async {
    // Cancel the state stream subscription if it exists.
    _stateStreamSubscription?.cancel();

    // Close the Bloc.
    await super.close();
  }
}
