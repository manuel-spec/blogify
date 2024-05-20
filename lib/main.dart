import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:blogify/pages/Home/home.dart';
import 'package:blogify/pages/signin.dart';
import 'package:blogify/pages/signup.dart';
import 'package:blogify/pages/welcome.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    ShellRoute(
      builder: (context, state, child) => ScaffoldWithNavBar(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeWidget(),
        ),
        // Add other routes for other tabs if needed
      ],
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePageWidget(),
    ),
    GoRoute(
      path: '/signin',
      builder: (context, state) => const SignInWidget(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpWidget(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}

class ScaffoldWithNavBar extends StatefulWidget {
  final Widget child;

  const ScaffoldWithNavBar({required this.child, Key? key}) : super(key: key);

  @override
  _ScaffoldWithNavBarState createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<ScaffoldWithNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // context.go('/profile'); // Uncomment and add a GoRoute for /profile
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
