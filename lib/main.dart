import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/post_screen.dart';

const platform = MethodChannel('com.example.flutter_project_launcher');

void main() {
  runApp(PostScreen());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Project Launcher'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              startFlutterProject();
            },
            child: Text('Start Flutter Project'),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {


  }

  void startFlutterProject() async {
    try {
      final String result = await platform.invokeMethod('startFlutterProject');
      print(result);
    } on PlatformException catch (e) {
      print("Failed to start Flutter project: '${e.message}'.");
    }
  }
}
