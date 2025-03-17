import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_event_bus/bus/event_but_stream_extensions.dart';

/// A [Cubit] that publishes its state changes to an [EventBus].
///
/// This abstract class extends [Cubit] and automatically publishes its state
/// changes to an [EventBus]. It subscribes to its own state stream and attaches
/// it to the [EventBus] when created.
///
/// The [BusPublisherCubit] automatically cancels the subscription when closed,
/// ensuring no memory leaks.
///
/// [S] represents the state type of the Cubit.
abstract class BusPublisherCubit<S> extends Cubit<S> {
  /// The subscription to the Cubit's state stream.
  ///
  /// This subscription is used to listen to state changes and publish them
  /// to the [EventBus].
  StreamSubscription? _stateStreamSubscription;

  /// Creates a [BusPublisherCubit] with an initial state.
  ///
  /// Upon creation, it subscribes to the Cubit's state stream and attaches it
  /// to the [EventBus]. This ensures that all state changes are published
  /// to the [EventBus].
  BusPublisherCubit(super.initialState) {
    // Subscribe to the Cubit's state stream and attach it to the EventBus.
    // This allows other parts of the application to listen to state changes
    // via the EventBus.
    _stateStreamSubscription = stream.attachToEventBus();
  }

  /// Closes the [BusPublisherCubit] and cancels the state stream subscription.
  ///
  /// This method ensures that the subscription to the state stream is canceled
  /// before the Cubit is closed, preventing memory leaks.
  @override
  Future<void> close() async {
    // Cancel the state stream subscription if it exists.
    _stateStreamSubscription?.cancel();

    // Close the Cubit.
    await super.close();
  }
}
