import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late CameraController cameraController;
  bool isProcessing = false; // New flag to track processing status
  bool isWorking = false;
  late CameraImage imgCamera;
  String result = "";

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model/mobilenet.tflite",
        labels: "assets/model/mobilenet.txt",
      );
    } catch (e) {
      // Handle errors related to model loading
      print('Error loading the model: $e');
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();

    cameraController = CameraController(cameras[0], ResolutionPreset.high);
    try {
      await cameraController.initialize().then((value){
        if(!mounted){
          return;
        }
        setState(() {
          cameraController.startImageStream((imageFromStream) {
            if(!isWorking && !isProcessing){
              isWorking = true;
              imgCamera = imageFromStream;
              isProcessing = true; // Set isProcessing to true before running the model

              runModelOnStreamFrames().whenComplete(() {
                // Reset isWorking flag after processing
                isWorking = false;
                isProcessing = false;
              });
            }
          });
        });
      });
    } catch (e) {
      // Handle errors related to camera initialization
      print('Error initializing camera: $e');
    }
  }

  runModelOnStreamFrames() async {
    if (imgCamera != null) {
      try {
        var recognitions = await Tflite.runModelOnFrame(
          bytesList: imgCamera.planes.map((plane) {
            return plane.bytes;
          }).toList(),
          imageHeight: imgCamera.height,
          imageMean: 127.5,
          imageStd: 127.5,
          imageWidth: imgCamera.width,
          numResults: 1,
          rotation: 90,
          threshold: 0.1,
        );

        // Clear result before appending new recognitions
        setState(() {
          result = "";
        });

        recognitions!.forEach((response) {
          result +=
              response["label"] + "  " + (response["confidence"] as double).toStringAsFixed(2);
        });

        // This line is sufficient to trigger a rebuild with the updated result
        setState(() {});
      } finally {
        // Ensure that isProcessing is reset even if an exception occurs
        isProcessing = false;
      }
    }
  }

  @override
  void dispose() async{
    cameraController.dispose(); // Release camera resources
    super.dispose();
    await Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              // Add a space for potential image display in the future
              SizedBox(height: 200),
              Center(
                heightFactor: 0.5,
                child: GestureDetector(
                  onTap: () {}, // Handle tap actions if needed
                  child: CameraPreview(cameraController),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 55.0),
                  child: SingleChildScrollView(
                    child: Text(
                      result,
                      style: TextStyle(
                        backgroundColor: Colors.black,
                        color: Colors.white,
                        fontSize: 30.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
