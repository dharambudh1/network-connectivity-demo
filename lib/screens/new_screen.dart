import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({Key? key}) : super(key: key);

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Screen'),
      ),
      body: const SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Text(
              "You cannot see the text of the status of this device connection here because this is a different screen. But you can still see the snack bar at the bottom while changing your network connection.",
            ),
          ),
        ),
      ),
    );
  }
}
