import 'package:connectivity_demo/connectivity_singleton/connectivity_manager.dart';
import 'package:connectivity_demo/navigation_singleton/navigator_service.dart';
import 'package:connectivity_demo/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    ConnectivityManager().initConnectivity();
    ConnectivityManager().onConnectivityChangedListener();
  }

  @override
  void dispose() {
    ConnectivityManager().disposeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigatorService().navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
