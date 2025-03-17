# flutter_bloc_event_bus

`flutter_bloc_event_bus` is a powerful package that combines the benefits of the `bloc` state management pattern with an event bus system. It allows Flutter applications to efficiently manage state, facilitate event-driven communication between components, and improve maintainability.

## 📌 Why Use flutter_bloc_event_bus?

- ✅ **Seamless Event-Driven Architecture** – Enhances modularity by allowing different components to communicate via an event bus.
- ✅ **Built on top of BLoC** – Leverages the robustness of `bloc` for state management while providing an event-driven extension.
- ✅ **Decoupled Communication** – Enables event-driven communication between widgets, cubits, and blocs without tight coupling.
- ✅ **Easy to Implement** – Offers simple APIs for publishing, observing, and mediating events.

## 🚀 Getting Started

### 1️⃣ Install the Package

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc_event_bus: latest_version
  flutter_bloc: latest_version
```

Run:
```sh
flutter pub get
```

### 2️⃣ Usage Examples

## 🟢 Using Cubits

### Example: `BusPublisherCubit` (Emitting Events)

```dart
import 'package:flutter_bloc_event_bus/flutter_bloc_event_bus.dart';

class ExampleBusPublisherState implements Event {
  final int value;

  ExampleBusPublisherState({required this.value});

  @override
  ExampleBusPublisherState copyWith({int? value}) {
    return ExampleBusPublisherState(value: value ?? this.value);
  }
}

class ExampleBusPublisherCubit extends BusPublisherCubit<ExampleBusPublisherState> {
  ExampleBusPublisherCubit(super.initialState);

  void update(int value) => emit(ExampleBusPublisherState(value: value));
}
```

### Example: `BusObserverCubit` (Observing Events)

```dart
class ExampleBusObserverCubit extends BusObserverCubit<int> {
  ExampleBusObserverCubit(super.initialState);

  @override
  void observe(Object event) {
    if (event is ExampleBusPublisherState) {
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusObserverCubit])');
    }

    if (event is ExampleBusBridgeState) {
      debugPrint('New ExampleBusBridgeState with value: ${event.value} (detected in [ExampleBusObserverCubit])');
    }
  }
}
```

### Example: `BusBridgeCubit` (Reacting to Events)

```dart
class ExampleBusBridgeState implements Event {
  final int value;

  ExampleBusBridgeState({required this.value});

  @override
  ExampleBusBridgeState copyWith({int? value}) {
    return ExampleBusBridgeState(value: value ?? this.value);
  }
}

class ExampleBusBridgeCubit extends BusBridgeCubit<ExampleBusBridgeState> {
  ExampleBusBridgeCubit(super.initialState);

  void update(int value) => emit(ExampleBusBridgeState(value: value));

  @override
  void observe(Object event) {
    if (event is ExampleBusPublisherState) {
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusBridgeCubit])');
    }
  }
}
```

### Example: Running Cubits

```dart
void exampleWithCubits() {
  final exampleBusPublisherCubit = ExampleBusPublisherCubit(ExampleBusPublisherState(value: 0));
  final exampleBusObserverCubit = ExampleBusObserverCubit(0);
  final exampleBusBridgeCubit = ExampleBusBridgeCubit(ExampleBusBridgeState(value: 0));

  exampleBusPublisherCubit.update(1);
  exampleBusBridgeCubit.update(1);
  exampleBusBridgeCubit.update(2);
}
```

---

## 🔵 Using Blocs

### Example: `BusPublisherBloc` (Dispatching Events)

```dart
class ExampleBusPublisherEvent {
  final int value;

  ExampleBusPublisherEvent({required this.value});
}

class ExampleBusPublisherBloc extends BusPublisherBloc<ExampleBusPublisherEvent, ExampleBusPublisherState> {
  ExampleBusPublisherBloc(super.initialState) {
    on<ExampleBusPublisherEvent>(_update);
  }

  Future<void> _update(ExampleBusPublisherEvent event, Emitter<ExampleBusPublisherState> emit) async => 
      emit(ExampleBusPublisherState(value: event.value));
}
```

### Example: `BusObserverBloc` (Observing Events)

```dart
class ExampleBusObserverEvent {}

class ExampleBusObserverBloc extends BusObserverBloc<ExampleBusObserverEvent, int> {
  ExampleBusObserverBloc(super.initialState);

  @override
  void observe(Object event) {
    if (event is ExampleBusPublisherState) {
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusObserverBloc])');
    }

    if (event is ExampleBusBridgeState) {
      debugPrint('New ExampleBusBridgeState with value: ${event.value} (detected in [ExampleBusObserverBloc])');
    }
  }
}
```

### Example: `BusBridgeBloc` (Handling Events)

```dart
class ExampleBusBridgeEvent {
  final int value;

  ExampleBusBridgeEvent({required this.value});
}

class ExampleBusBridgeBloc extends BusBridgeBloc<ExampleBusBridgeEvent, ExampleBusBridgeState> {
  ExampleBusBridgeBloc(super.initialState) {
    on<ExampleBusBridgeEvent>(_update);
  }

  Future<void> _update(ExampleBusBridgeEvent event, Emitter<ExampleBusBridgeState> emit) async =>
      emit(ExampleBusBridgeState(value: event.value));

  @override
  void observe(Object event) {
    if (event is ExampleBusPublisherState) {
      debugPrint('New ExampleBusPublisherState with value: ${event.value} (detected in [ExampleBusBridgeBloc])');
    }
  }
}
```

### Example: Running Blocs

```dart
void exampleWithBlocs() {
  final exampleBusPublisherBloc = ExampleBusPublisherBloc(ExampleBusPublisherState(value: 0));
  final exampleBusObserverBloc = ExampleBusObserverBloc(0);
  final exampleBusBridgeBloc = ExampleBusBridgeBloc(ExampleBusBridgeState(value: 0));

  exampleBusPublisherBloc.add(ExampleBusPublisherEvent(value: 1));
  exampleBusBridgeBloc.add(ExampleBusBridgeEvent(value: 1));
  exampleBusBridgeBloc.add(ExampleBusBridgeEvent(value: 2));
}
```

---

## 🛠️ Advanced Use Cases

- Using `BusPublisherBloc` for event-driven state management with Blocs.
- Implementing a global event bus for communication between independent UI elements.
- Creating a centralized mediator for managing multiple event sources.

## 🏆 Conclusion

`flutter_bloc_event_bus` simplifies event-driven state management, making it easier to decouple components in Flutter applications. Whether you're working with Cubits or Blocs, this package provides a structured way to handle application-wide events.

---

### 📜 License

MIT License

---

Happy coding! 🚀
