import 'package:connectivity_demo/connectivity_singleton/connectivity_manager.dart';
import 'package:connectivity_demo/screens/new_screen.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final labelSubject = BehaviorSubject<String>();

  Function(String) get labelFunction {
    return labelSubject.sink.add;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connectivity Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const NewScreen();
                    },
                  ),
                );
              },
              child: const Icon(Icons.arrow_forward),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ConnectivityManager().connectivityBuilder(
          onConnectionEstablishedCallBack: (value) {
            labelFunction('Connected via: $value');
          },
          onConnectionLostCallBack: () {
            labelFunction('Not connected, searching for connection...');
          },
          child: Center(
            child: StreamBuilder(
              stream: labelSubject.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "The text of this screen will update according to the device's internet connection. If this device has established an internet connection with mobile data/wifi/ethernet, It will show a Connected via <connection type> message. Else, it will show a Not connected, searching for a connection message. As well as, you may be able to see the snack bar at the bottom while changing your network connection. This example app won't work as expected in the iOS Simulator / it won't work like the Android emulator due to a lack of Settings in the iOS simulator. In an Android emulator, you can change internet settings from the emulator itself, but on the iOS side, you cannot change internet settings from the simulator itself. It is dependent on MacOS. Changing internet settings from MacOS could affect the simulator. It will provide the not connected to any network callback when you turn off the Wi-Fi network or disconnect the ethernet cable. But, when you turn on the Wi-Fi network or connect the ethernet at that moment, it will not provide a proper callback.",
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      Text(labelSubject.value),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
