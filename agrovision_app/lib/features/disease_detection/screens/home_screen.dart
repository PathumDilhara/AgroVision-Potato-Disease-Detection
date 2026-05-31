import 'dart:io';

import 'package:agrovision_app/features/disease_detection/screens/camera_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<String> _imgPath = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AgroVision"),
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.red.withValues(alpha: 0.5),
                ),
                child: Column(
                  children: [
                    Text(
                      "Capture or upload a potato leaf image and let the "
                      "AI model detect potential diseases with confidence "
                      "scores.",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.orange,
                            ),
                          ),
                          onPressed: () async {
                            print("Capture");

                            _imgPath.value = "";

                            final cameras = await availableCameras();
                            String result = "";

                            if (context.mounted) {
                              result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => CameraScreen(camera: cameras[0]),
                                ),
                              );
                            }

                            if (result.isNotEmpty) {
                              // result is image path
                              print("### Captured image: $result");
                              _imgPath.value = result;
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Capture",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),

                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              Colors.blue,
                            ),
                          ),
                          onPressed: () {
                            print("import");
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_circle,
                                size: 20,
                                color: Colors.black,
                              ),
                              SizedBox(width: 5),
                              Text(
                                "Import",
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),

              ValueListenableBuilder(
                valueListenable: _imgPath,
                builder: (context, value, child) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue.withValues(alpha: 0.3),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.width * 0.8,
                          child:
                              value.isEmpty
                                  ? Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 200,
                                    color: Colors.grey,
                                  )
                                  : Image.file(
                                    File(value),
                                    fit: BoxFit.fitWidth,
                                  ),
                        ),

                        SizedBox(height: 20),

                        Text(
                          "Early__Blight\nConfidence : 100%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
