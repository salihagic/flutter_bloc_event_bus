# flutter_bloc_event_bus

A lightweight Flutter package that adds event-driven communication capabilities to [flutter_bloc](https://pub.dev/packages/flutter_bloc). It enables decoupled, cross-component communication through a global event bus while maintaining the robustness of the BLoC pattern.

[![pub package](https://img.shields.io/pub/v/flutter_bloc_event_bus.svg)](https://pub.dev/packages/flutter_bloc_event_bus)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- **Decoupled Communication** - Components communicate through events without direct dependencies
- **Built on flutter_bloc** - Seamlessly integrates with your existing BLoC/Cubit architecture
- **Three Component Types** - Publisher, Observer, and Bridge patterns for different use cases
- **Automatic Lifecycle Management** - Subscriptions are properly cleaned up when components are closed
- **Works with Both Cubits and Blocs** - Full support for both state management approaches

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc_event_bus: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Define Your Event State

States that will be published to the event bus must implement the `Event` interface:

```dart
class CounterState implements Event {
  final int count;

  CounterState({required this.count});

  @override
  CounterState copyWith({int? count}) {
    return CounterState(count: count ?? this.count);
  }
}
```

### 2. Create a Publisher

A publisher broadcasts its state changes to the event bus:

```dart
class CounterCubit extends BusPublisherCubit<CounterState> {
  CounterCubit() : super(CounterState(count: 0));

  void increment() => emit(CounterState(count: state.count + 1));
}
```

### 3. Create an Observer

An observer listens to events from the bus and reacts to them:

```dart
class LoggerCubit extends BusObserverCubit<void> {
  LoggerCubit() : super(null);

  @override
  void observe(Object event) {
    if (event is CounterState) {
      print('Counter changed to: ${event.count}');
    }
  }
}
```

### 4. Use Them Together

```dart
void main() {
  final counter = CounterCubit();
  final logger = LoggerCubit();

  counter.increment(); // Logger prints: "Counter changed to: 1"
  counter.increment(); // Logger prints: "Counter changed to: 2"
}
```

## Component Types

### BusPublisherCubit / BusPublisherBloc

**Purpose:** Broadcasts state changes to the event bus.

Use when you have a component whose state should be observable by other components in your app.

```dart
class UserSessionCubit extends BusPublisherCubit<UserSessionState> {
  UserSessionCubit() : super(UserSessionState.guest());

  void login(User user) => emit(UserSessionState.authenticated(user));
  void logout() => emit(UserSessionState.guest());
}
```

### BusObserverCubit / BusObserverBloc

**Purpose:** Listens to events from the bus and reacts to them.

Use when a component needs to respond to state changes from other components without direct coupling.

```dart
class AnalyticsCubit extends BusObserverCubit<void> {
  final AnalyticsService _analytics;

  AnalyticsCubit(this._analytics) : super(null);

  @override
  void observe(Object event) {
    if (event is UserSessionState && event.isAuthenticated) {
      _analytics.trackLogin();
    }
  }
}
```

### BusBridgeCubit / BusBridgeBloc

**Purpose:** Both publishes its own state AND observes events from the bus.

Use for components that need two-way communication - they react to external events while also broadcasting their own state changes.

```dart
class CartState implements Event {
  final List<Product> items;

  CartState({required this.items});

  @override
  CartState copyWith({List<Product>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartCubit extends BusBridgeCubit<CartState> {
  CartCubit() : super(CartState(items: []));

  void addItem(Product product) {
    emit(CartState(items: [...state.items, product]));
  }

  @override
  void observe(Object event) {
    // Clear cart when user logs out
    if (event is UserSessionState && !event.isAuthenticated) {
      emit(CartState(items: []));
    }
  }
}
```

## Using with Blocs

The same patterns work with Blocs. The key difference is that Blocs use events to trigger state changes:

```dart
// Events
sealed class CounterEvent {}
class IncrementPressed extends CounterEvent {}

// State
class CounterState implements Event {
  final int count;
  CounterState({required this.count});

  @override
  CounterState copyWith({int? count}) => CounterState(count: count ?? this.count);
}

// Bloc
class CounterBloc extends BusPublisherBloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterState(count: 0)) {
    on<IncrementPressed>((event, emit) {
      emit(CounterState(count: state.count + 1));
    });
  }
}
```

## Real-World Example: Authentication Flow

Here's how you might use the event bus for a common authentication scenario:

```dart
// Auth states published to the bus
class AuthState implements Event {
  final User? user;
  bool get isLoggedIn => user != null;

  AuthState({this.user});

  @override
  AuthState copyWith({User? user}) => AuthState(user: user);
}

// Auth cubit publishes login/logout events
class AuthCubit extends BusPublisherCubit<AuthState> {
  AuthCubit() : super(AuthState());

  Future<void> login(String email, String password) async {
    final user = await authService.login(email, password);
    emit(AuthState(user: user));
  }

  void logout() => emit(AuthState());
}

// Profile cubit observes auth events and clears data on logout
class ProfileCubit extends BusObserverCubit<ProfileState> {
  ProfileCubit() : super(ProfileState.empty());

  @override
  void observe(Object event) {
    if (event is AuthState && !event.isLoggedIn) {
      emit(ProfileState.empty()); // Clear profile on logout
    }
  }
}

// Cart cubit is a bridge - publishes cart state AND observes auth
class CartCubit extends BusBridgeCubit<CartState> {
  CartCubit() : super(CartState.empty());

  void addItem(Product p) => emit(state.copyWith(items: [...state.items, p]));

  @override
  void observe(Object event) {
    if (event is AuthState && !event.isLoggedIn) {
      emit(CartState.empty()); // Clear cart on logout
    }
  }
}
```

## Architecture Diagram

```
┌─────────────────┐         ┌─────────────────┐
│  AuthCubit      │         │  CartCubit      │
│  (Publisher)    │────────>│  (Bridge)       │<────┐
└─────────────────┘         └─────────────────┘     │
        │                           │               │
        │                           │               │
        v                           v               │
   ┌─────────────────────────────────────────┐     │
   │              Event Bus                   │     │
   └─────────────────────────────────────────┘     │
        │                           │               │
        │                           │               │
        v                           v               │
┌─────────────────┐         ┌─────────────────┐    │
│  ProfileCubit   │         │  AnalyticsCubit │    │
│  (Observer)     │         │  (Observer)     │────┘
└─────────────────┘         └─────────────────┘
```

## API Reference

### Event Interface

All states published to the bus must implement `Event`:

```dart
abstract class Event {
  dynamic copyWith();
}
```

### Global Event Bus

Access the global event bus instance:

```dart
IEventBus eventBus; // Global singleton

// Send an event directly (rarely needed)
eventBus.send(MyEvent());

// Listen to events directly (rarely needed)
eventBus.stream.listen((event) { ... });
```

### Base Classes

| Class | Description |
|-------|-------------|
| `BusPublisherCubit<S>` | Cubit that publishes state to the bus |
| `BusObserverCubit<S>` | Cubit that observes events from the bus |
| `BusBridgeCubit<S>` | Cubit that both publishes and observes |
| `BusPublisherBloc<E, S>` | Bloc that publishes state to the bus |
| `BusObserverBloc<E, S>` | Bloc that observes events from the bus |
| `BusBridgeBloc<E, S>` | Bloc that both publishes and observes |

## Best Practices

1. **Keep events simple** - States published to the bus should be immutable data classes
2. **Use type checking** - In `observe()`, always check the event type before handling
3. **Don't overuse** - Not every cubit needs to be connected to the bus; use it for cross-cutting concerns
4. **Consider scope** - The event bus is global; for scoped communication, consider other patterns

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests on [GitHub](https://github.com/salihagic/flutter_bloc_event_bus).
