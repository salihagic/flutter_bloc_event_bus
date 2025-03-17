import 'dart:async';

import 'package:flutter_bloc_event_bus/bus/event_bus.dart';

extension EventBusStreamExtensions on Stream {
  StreamSubscription attachToEventBus() => where(
        (event) => event is Event,
      ).listen((event) => eventBus.send((event as Event).copyWith()));
}
