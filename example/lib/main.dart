// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_event_bus/flutter_bloc_event_bus.dart';

/// This example demonstrates a real-world authentication flow using
/// flutter_bloc_event_bus. It shows how different parts of an app can
/// communicate without direct dependencies.
///
/// Components:
/// - AuthCubit (Publisher): Broadcasts login/logout events
/// - CartCubit (Bridge): Manages cart AND listens for logout to clear items
/// - NotificationCubit (Observer): Shows notifications based on events
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()),
        BlocProvider(create: (_) => CartCubit()),
        BlocProvider(create: (_) => NotificationCubit()),
      ],
      child: MaterialApp(
        title: 'Event Bus Example',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Bus Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocListener<NotificationCubit, String?>(
        listener: (context, message) {
          if (message != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Auth Status Card
              BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            state.isLoggedIn
                                ? Icons.person
                                : Icons.person_outline,
                            size: 48,
                            color:
                                state.isLoggedIn ? Colors.green : Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.isLoggedIn
                                ? 'Welcome, ${state.userName}!'
                                : 'Not logged in',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (state.isLoggedIn) {
                                context.read<AuthCubit>().logout();
                              } else {
                                context.read<AuthCubit>().login('John Doe');
                              }
                            },
                            child: Text(state.isLoggedIn ? 'Logout' : 'Login'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Cart Card
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.shopping_cart),
                              const SizedBox(width: 8),
                              Text(
                                'Cart (${state.items.length} items)',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (state.items.isEmpty)
                            const Text('Your cart is empty')
                          else
                            ...state.items.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                child: Text('- $item'),
                              ),
                            ),
                          const SizedBox(height: 16),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, authState) {
                              return ElevatedButton.icon(
                                onPressed:
                                    authState.isLoggedIn
                                        ? () =>
                                            context.read<CartCubit>().addItem(
                                              'Item ${state.items.length + 1}',
                                            )
                                        : null,
                                icon: const Icon(Icons.add),
                                label: Text(
                                  authState.isLoggedIn
                                      ? 'Add Item'
                                      : 'Login to add items',
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Info Card
              Card(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text('- AuthCubit publishes login/logout events'),
                      Text(
                        '- CartCubit observes auth events and clears on logout',
                      ),
                      Text(
                        '- NotificationCubit observes all events for alerts',
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try logging in, adding items, then logging out!',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// AUTH CUBIT (Publisher)
// Publishes authentication state changes to the event bus
// =============================================================================

class AuthState implements Event {
  final String? userName;

  bool get isLoggedIn => userName != null;

  const AuthState({this.userName});

  @override
  AuthState copyWith({String? userName}) {
    return AuthState(userName: userName ?? this.userName);
  }
}

class AuthCubit extends BusPublisherCubit<AuthState> {
  AuthCubit() : super(const AuthState());

  void login(String name) => emit(AuthState(userName: name));

  void logout() => emit(const AuthState());
}

// =============================================================================
// CART CUBIT (Bridge)
// Publishes cart state AND observes auth events to clear cart on logout
// =============================================================================

class CartState implements Event {
  final List<String> items;

  const CartState({this.items = const []});

  @override
  CartState copyWith({List<String>? items}) {
    return CartState(items: items ?? this.items);
  }
}

class CartCubit extends BusBridgeCubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(String item) {
    emit(CartState(items: [...state.items, item]));
  }

  void clear() => emit(const CartState());

  @override
  void observe(Object event) {
    // When user logs out, clear the cart
    if (event is AuthState && !event.isLoggedIn) {
      clear();
    }
  }
}

// =============================================================================
// NOTIFICATION CUBIT (Observer)
// Observes events from the bus and shows notifications
// =============================================================================

class NotificationCubit extends BusObserverCubit<String?> {
  NotificationCubit() : super(null);

  @override
  void observe(Object event) {
    if (event is AuthState) {
      if (event.isLoggedIn) {
        emit('Welcome back, ${event.userName}!');
      } else {
        emit('You have been logged out');
      }
    } else if (event is CartState && event.items.isNotEmpty) {
      emit('Cart updated: ${event.items.length} items');
    }
  }
}
