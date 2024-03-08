import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = MethodChannel('com.example.flutter_project_launcher');

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    // Set up MethodChannel to receive data from native
    const platform = MethodChannel('com.example.flutter_project_launcher');
    platform.setMethodCallHandler((call) async {
      if (call.method == 'receiveDataFromNative') {
        String data = call.arguments;
        print('Received data from native: $data');
        setState(() {
          receivedData = data;
          // Update UI with received data
          // For example, you could set a variable here to display the data in the UI
        });
      }else if (call.method == 'channel'){
        String data = call.arguments;
        print('Received data from native: $data');
        setState(() {
          channel = call.arguments;
          // Update UI with received data
          // For example, you could set a variable here to display the data in the UI
        });
      }
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  String receivedData = 'Username';
  String channel = 'Select Channel';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, // Set the background color to blue
          title: Text('Social Post'),
          leading: IconButton(
            // Add a leading widget for the back button
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Implement your back button functionality here
              Navigator.pop(context); // Example: pop the current route
            },
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 10, 5, 5),
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                      // Set border radius to 20 for rounded corners
                      image: DecorationImage(
                        image: AssetImage('assets/profile_image.jpg'),
                        // Add your image path here
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receivedData,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap:() {
                            startSelectChannel();
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  channel,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'What\'s on your mind?',
                  border: InputBorder.none,
                ),
              ),
            )),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(20),
                child: TextButton(
                  onPressed: () {
                    startFlutterProject();
                  },
                  child: Text('Post',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void startSelectChannel() async {
    try {
      print("Flutter: select channel click");
      final String result = await platform.invokeMethod('startSelectChannel');
      print(result);
    } on PlatformException catch (e) {
      print("Failed to start Flutter project: '${e.message}'.");
    }
  }
  void startFlutterProject() async {
    try {
      print("Flutter: post click");
      final String result = await platform.invokeMethod('startFlutterProject');
      print(result);
    } on PlatformException catch (e) {
      print("Failed to start Flutter project: '${e.message}'.");
    }
  }

}
