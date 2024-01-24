import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:object_detection/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Object Detection Application',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Real-time Object Detection App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.to(
                      () => HomePage(),
                  transition: Transition.circularReveal,
                  duration: Duration(seconds: 2),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text('Tap to Detect an Object'),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.to(() => AboutPage());
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(16),
                child: Text('About My Application'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About My Application'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image at the top
            Container(
              width: double.infinity,
              height: 200, // Adjust the height as needed
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/harsh.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Container with light blue background and text
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.lightBlue[100],
              child: Text(
                'Absolutely thrilled to witness the transformative journey of edge computing! 🌐💻 From being deemed limited on edge devices, it has evolved into a game-changer, empowering robust on-device computations that were once unimaginable.\n\n'
                    '🚀 In the latest stride of this evolution, I proudly present my Object Detection Flutter App. Powered by MobileNet.tflite, it brings the marvel of real-time object detection right to your fingertips. 📱🔍 Embracing the full potential of edge computing has truly reshaped the mobile app development landscape.\n\n'
                    'Dive into the code on GitHub: Object Detection Flutter App. 🛠️ Join me in this exciting era as we unlock the capabilities of edge computing! 🤖💡\n'
                    '#EdgeComputing #MobileDevelopment #Flutter #TensorFlowLite #OpenSource.',
                style: TextStyle(fontSize: 16.0, color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
