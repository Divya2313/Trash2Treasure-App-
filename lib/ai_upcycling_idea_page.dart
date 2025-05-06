import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:html' as html;

class AIUpcyclingIdeaPage extends StatefulWidget {
  const AIUpcyclingIdeaPage({super.key});

  @override
  State<AIUpcyclingIdeaPage> createState() => _AIUpcyclingIdeaPageState();
}

class _AIUpcyclingIdeaPageState extends State<AIUpcyclingIdeaPage> {
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer _audioPlayer = AudioPlayer();

  String description = '';
  String upcyclingIdea = '';
  String audioFile = '';
  bool isLoading = false;

  File? _imageFile;
  Uint8List? _webImageBytes;

  // Pick image (gallery)
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
        });
        await _uploadImage(webImageBytes: _webImageBytes);
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
        await _uploadImage(imageFile: _imageFile);
      }
    }
  }

  // Upload image to backend
  Future<void> _uploadImage({File? imageFile, Uint8List? webImageBytes}) async {
    setState(() {
      isLoading = true;
      description = '';
      upcyclingIdea = '';
      audioFile = '';
    });

    final url = Uri.parse('http://192.168.29.102:5000/process-image');

    try {
      late http.Response response;

      if (kIsWeb) {
        final base64Image = base64Encode(webImageBytes!);
        response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image': base64Image}),
        );
      } else {
        final request = http.MultipartRequest('POST', url)
          ..files
              .add(await http.MultipartFile.fromPath('image', imageFile!.path));
        final streamedResponse = await request.send();
        final responseData = await streamedResponse.stream.bytesToString();
        response = http.Response(responseData, streamedResponse.statusCode);
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        description = data['description'] ?? 'No description found';
        await _generateUpcyclingIdea(description);
      } else {
        setState(() {
          description = 'Failed to upload image';
        });
      }
    } catch (e) {
      setState(() {
        description = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Generate upcycling idea
  Future<void> _generateUpcyclingIdea(String description) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.29.102:5000/generate-upcycling'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'description': description}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        upcyclingIdea = data['upcycling_idea'] ?? 'No upcycling idea found';
        await _generateSpeech(upcyclingIdea);
      } else {
        setState(() {
          upcyclingIdea = 'Failed to generate upcycling idea';
        });
      }
    } catch (e) {
      setState(() {
        upcyclingIdea = 'Error: $e';
      });
    }
  }

  // Generate speech for upcycling idea
  Future<void> _generateSpeech(String text) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.29.102:5000/generate-speech'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String audioPath = data['audio_file'];

        if (audioPath.startsWith('/')) {
          audioPath = 'http://192.168.29.102:5000$audioPath';
        }

        setState(() {
          audioFile = audioPath;
        });

        await _playAudio(); // Play audio after generating it
      } else {
        setState(() {
          audioFile = 'Failed to generate speech';
        });
      }
    } catch (e) {
      setState(() {
        audioFile = 'Error: $e';
      });
    }
  }

  // Play the generated audio
  Future<void> _playAudio() async {
    if (audioFile.isNotEmpty &&
        !audioFile.startsWith('Error') &&
        !audioFile.startsWith('Failed')) {
      try {
        if (kIsWeb) {
          // For web, use a simpler HTML AudioElement to play the sound.
          _playAudioWeb(
              audioFile); // Call the web-specific audio player function
        } else {
          // For mobile, use the AudioPlayer plugin.
          await _audioPlayer.stop();
          await _audioPlayer.play(UrlSource(audioFile));
        }
      } catch (e) {
        setState(() {
          audioFile = 'Error: $e';
        });
      }
    }
  }

  // Web-specific audio play method

  Future<void> _playAudioWeb(String audioUrl) async {
    print("Audio URL: $audioUrl"); // Log the URL to ensure it's correct.

    try {
      final audioElement = html.AudioElement(audioUrl)
        ..autoplay = true
        ..loop = false;

      audioElement.onError.listen((event) {
        print("Error loading audio: ${event.toString()}");
      });

      await audioElement.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _pauseAudio() async => await _audioPlayer.pause();
  Future<void> _stopAudio() async => await _audioPlayer.stop();

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Upcycling Idea'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Upload an image to get AI-generated upcycling ideas.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Pick Image'),
            ),
            const SizedBox(height: 20),
            if (isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Processing...'),
            ],
            if (description.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Description:\n$description',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
            if (upcyclingIdea.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Upcycling Idea:\n$upcyclingIdea',
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
            if (audioFile.isNotEmpty &&
                !audioFile.startsWith('Error') &&
                !audioFile.startsWith('Failed')) ...[
              const SizedBox(height: 20),
              const Text(
                'Audio Controls',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: _playAudio,
                    tooltip: 'Play',
                  ),
                  IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: _pauseAudio,
                    tooltip: 'Pause',
                  ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: _stopAudio,
                    tooltip: 'Stop',
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
