import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'dart:html' as html; // Only for web

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

  Future<void> _uploadImage({File? imageFile, Uint8List? webImageBytes}) async {
    setState(() {
      isLoading = true;
      description = '';
      upcyclingIdea = '';
      audioFile = '';
    });

    final url = Uri.parse('http://192.168.178.96:5000/process-image');

    try {
      http.Response response;

      if (kIsWeb) {
        final base64Image = base64Encode(webImageBytes!);
        response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image': base64Image}),
        );
      } else {
        final bytes = await imageFile!.readAsBytes();
        final base64Image = base64Encode(bytes);
        response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'image': base64Image}),
        );
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

  Future<void> _generateUpcyclingIdea(String description) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.178.96:5000/generate-upcycling'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'description': description}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        upcyclingIdea = data['upcycling_idea'] ?? 'No idea found';
        await _generateSpeech(upcyclingIdea);
      } else {
        setState(() {
          upcyclingIdea = 'Failed to generate idea';
        });
      }
    } catch (e) {
      setState(() {
        upcyclingIdea = 'Error: $e';
      });
    }
  }

  Future<void> _generateSpeech(String text) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.178.96:5000/generate-speech'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'text': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String audioPath = data['audio_file'];

        if (audioPath.startsWith('/')) {
          audioPath = 'http://192.168.178.96:5000$audioPath';
        }

        setState(() {
          audioFile = audioPath;
        });

        await _playAudio();
      } else {
        setState(() {
          audioFile = 'Failed to generate audio';
        });
      }
    } catch (e) {
      setState(() {
        audioFile = 'Error: $e';
      });
    }
  }

  Future<void> _playAudio() async {
    if (audioFile.isNotEmpty &&
        !audioFile.startsWith('Error') &&
        !audioFile.startsWith('Failed')) {
      try {
        if (kIsWeb) {
          final audioElement = html.AudioElement(audioFile)
            ..autoplay = true
            ..controls = false;
          html.document.body!.append(audioElement);
        } else {
          await _audioPlayer.stop();
          await _audioPlayer.play(UrlSource(audioFile));
        }
      } catch (e) {
        setState(() {
          audioFile = 'Error playing audio: $e';
        });
      }
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
        title: const Text("AI Upcycling Idea Generator"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Pick Image"),
            ),
            const SizedBox(height: 20),
            if (isLoading) ...[
              const CircularProgressIndicator(),
              const Text("Processing..."),
            ],
            if (description.isNotEmpty) ...[
              Text("Description:\n$description"),
              const SizedBox(height: 10),
            ],
            if (upcyclingIdea.isNotEmpty) ...[
              Text("Upcycling Idea:\n$upcyclingIdea"),
              const SizedBox(height: 10),
            ],
            if (audioFile.isNotEmpty &&
                !audioFile.startsWith("Error") &&
                !audioFile.startsWith("Failed")) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: _playAudio),
                  IconButton(
                      icon: const Icon(Icons.pause), onPressed: _pauseAudio),
                  IconButton(
                      icon: const Icon(Icons.stop), onPressed: _stopAudio),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
