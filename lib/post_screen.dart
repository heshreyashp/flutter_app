import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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
  TextEditingController _textController = TextEditingController();


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  String receivedData = 'Shreyash ';
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
                      color: const Color(0xFFC97777),
                      border: Border.all(color: Colors.red, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                      // Set border radius to 20 for rounded corners
                    ),
                    child: Center(
                      child: Text(
                        "HA",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
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
                controller: _textController,
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
      await fetchData();
      print("Flutter: post click");
      //final String inputText = _textController.text;
     // final String result = await platform.invokeMethod('startFlutterProject', {"description": inputText});
     // print(result);
    } on PlatformException catch (e) {
      print("Failed to start Flutter project: '${e.message}'.");
    }
  }

  Future<void> fetchData() async {

    var headers = {
      'Authorization': 'Bearer eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJmaXJzdE5hbWUiOiJTaHJleWFzaCBGb3VyU2V2ZW4iLCJsYXN0TmFtZSI6IlBhZGR5IHBhZGR5IHBhZGR5IHB4IiwiaWQiOjExMjYsImVtYWlsIjoic2hyZXlhc2gucEBodWJlbmdhZ2UuY29tIiwic3ViIjoiQlZyOFBnaE1xIiwiYWRtaW5fdHlwZSI6MSwibGFuZ0NvZGUiOiJlbiIsImlzQWRtaW4iOnRydWUsImlzRmlyc3RMb2dpbiI6ZmFsc2UsInByZWZlcnJlZE5hbWUiOiJTaHJleWFzaCBGb3VyU2V2ZW4iLCJleHAiOjE3MTE2MjE1NTh9.ZwjYjx9W7kB4P1-wxrDQYWJ8QwVD3gCbl9PWB8XRSVsshPso46HbvvSqW-cMZ9IlLMJr3Tms0NGbAskkiHGzWQ',
      'deviceType': 'a',
      'timezone': 'Asia/Kolkata',
      'appVersion': '2.12.2_2011200141',
      'tenant': 'client0',
      'Content-Type': 'application/json',
      'app': 'android',
      'device': 'mobile',
      'Accept': 'application/json',
      'sessionId': 'a-6691d6fa-4022-411d-8a66-f889250a4ace-1709890371'
    };
    var request = http.Request('POST', Uri.parse('https://apiv2.demo-hubengage.com/app/social/posts'));
   var body = json.encode({
      "langCode": "en",
      "postText": _textController.text,
      "rawPostText": _textController.text,
      "urlPreview": ""
    });
   request.body = body;
    request.headers.addAll(headers);
    var response = await http.post(
      Uri.parse('https://apiv2.demo-hubengage.com/app/social/posts'),
      headers: headers,
      body: body,
    );

    print("statusCode");
    // Check the response status code
    if (response.statusCode == 200 || response.statusCode == 201) {
      // Successful request
      print('POST request successful');
      print('Successful Response body: ${response.body}  ${response.statusCode}  ');
      final String result = await platform.invokeMethod('SuccessfulResponse');
      print(result);

    } else {
      // Error handling
      print('POST request failed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

  }

}
