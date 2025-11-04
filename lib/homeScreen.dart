import 'dart:io';

import 'package:flutter/material.dart';
import 'package:money_clasification/getStartupScreen.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _capturedImage;

  Future<void> _openCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _capturedImage = File(pickedFile.path);
        });
      }    } catch (e) {
      debugPrint('error camera: $e');

    }
  } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              //Header gambar koin
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Scan Your Coin',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 40),
                      //Dua koin di tengah
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //koin kiri
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.monetization_on,
                                size: 80,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          const SizedBox(width: 40),
                          //koin kanan
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.monetization_on,
                                size: 80,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
      //Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //Home button
                IconButton(
                  tooltip: 'Beranda',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const GetStartedScreen()),
                    );
                  },
                  icon: Icon(
                    Icons.home,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
                
                //Kamera button
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF4ECDC4),
                      width: 3,
                    ),
                  ),
                  child: IconButton(
                    tooltip: 'Ambil Gambar Uang',
                    onPressed: _openCamera,
                    icon: const Icon(Icons.camera_alt),
                  ),
                ),
                
                //Library button
                IconButton(
                  tooltip: 'Gallery Uang',
                  onPressed: () {
                  },
                  icon: Icon(
                    Icons.library_books,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}