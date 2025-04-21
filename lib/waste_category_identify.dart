import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';

class IdentifyWasteCategoryPage extends StatefulWidget {
  @override
  _IdentifyWasteCategoryPageState createState() =>
      _IdentifyWasteCategoryPageState();
}

class _IdentifyWasteCategoryPageState extends State<IdentifyWasteCategoryPage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile; // For mobile platforms
  Uint8List? webImage; // For Flutter Web

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        // For Flutter Web
        final bytes =
            await pickedFile.readAsBytes(); // Read bytes asynchronously
        setState(() {
          webImage = bytes; // Update the state with the image bytes
        });
      } else {
        // For Mobile (iOS/Android)
        setState(() {
          _imageFile = File(pickedFile.path); // Update the state with the file
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
        title: const Text(
          "Identify Your Waste Category",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Handle profile icon click
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _pickImage,
              icon: const Icon(Icons.upload_file, color: Colors.white),
              label: const Text(
                "Upload Your Picture",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Display the image if uploaded
            if (webImage != null || _imageFile != null)
              Center(
                child: kIsWeb
                    ? Image.memory(
                        webImage!,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _imageFile!,
                        height: 300,
                        width: 300,
                        fit: BoxFit.cover,
                      ),
              ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Add your logic for the Identify button here
              },
              child: const Text(
                "Identify",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
