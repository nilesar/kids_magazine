import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:kids_magazine/custom_transliterate.dart';

class AudioGenerateScreen extends StatefulWidget {
  final String storyID;

  AudioGenerateScreen({required this.storyID});

  @override
  _AudioGenerateScreenState createState() => _AudioGenerateScreenState();
}

class _AudioGenerateScreenState extends State<AudioGenerateScreen> {
  String? originalText;
  String? language;
  String? transliteratedText;
  bool isLoading = false;
  bool isSwitched2 = false;
  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  AudioPlayer player = AudioPlayer();

  String? audioPath;

  @override
  void initState() {
    super.initState();
    fetchStory();
  }

  Future<void> fetchStory() async {
    try {
      DocumentSnapshot storyDoc = await stry.doc(widget.storyID).get();

      if (storyDoc.exists) {
        setState(() {
          originalText = storyDoc['original_text'];
          language = storyDoc['language'];
        });
      } else {
        print("Story not found!");
      }
    } catch (e) {
      print("Error fetching story: $e");
    }
  }

  Future<void> generateSpeech() async {
    if (originalText == null) return;

    setState(() {
      isLoading = true;
    });
    String languageCode = 'bn';
    switch (language?.toLowerCase()) {
      case 'bengali':
        languageCode = 'bn';
        break;
      case 'hindi':
        languageCode = 'hi';
        break;
      case 'marathi':
        languageCode = 'mr';
        break;
      case 'gujarati':
        languageCode = 'gu';
        break;
      case 'telugu':
        languageCode = 'te';
        break;
      default:
        languageCode = 'bn';
    }
    try {
      var url =
          Uri.parse("https://flask-tts-backend-1.onrender.com/generate_speech");
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": originalText, "language": languageCode}),
      );

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        String filePath = '${tempDir.path}/output.mp3';
        File audioFile = File(filePath);

        if (!(await audioFile.exists())) {
          await audioFile.create(recursive: true);
        }

        await audioFile.writeAsBytes(response.bodyBytes);

        if (await audioFile.exists()) {
          setState(() {
            audioPath = audioFile.path;
          });

          await playAudio();
        } else {
          print("File was not created at \$filePath");
        }
      } else {
        print("Error generating speech: \${response.body}");
      }
    } catch (e) {
      print("Exception: \$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void transliterateText(String selectedLanguage, String o_text) {
    setState(() {
      switch (selectedLanguage.toLowerCase()) {
        case 'bengali':
          transliteratedText = transliterateBengali(o_text);
          break;
        case 'hindi':
          transliteratedText = transliterateHindi(o_text);
          break;
        case 'marathi':
          transliteratedText = transliterateMarathi(o_text);
          break;
        case 'gujarati':
          transliteratedText = transliterateGujarati(o_text);
          break;
        case 'telugu':
          transliteratedText = transliterateTelugu(o_text);
          break;
        default:
          transliteratedText = 'Language not supported';
      }
    });
  }

  Future<void> playAudio() async {
    if (audioPath != null && await File(audioPath!).exists()) {
      try {
        await player.play(DeviceFileSource(audioPath!));
      } catch (e) {
        print("Error playing audio: $e");
      }
    } else {
      print("Audio file does not exist at path: $audioPath");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_sharp,
              color: Color(0xFFFFC857), size: 25.0),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF00073e), // Deep Blue Title Bar
        title: Text(
          "Gtts Audio",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'JosefinSans',
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFC857),
          ),
        ),
      ),
      body: Container(
        color: Color(0xFFFFC857), // Warm Yellow Background
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: isLoading ? null : generateSpeech,
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Generate & Play Audio"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00073e), // Deep Blue Button
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    textStyle: TextStyle(
                      fontFamily: 'JosefinSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Switch(
                  value: isSwitched2,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched2 = value;

                      if (isSwitched2 && language != null) {
                        transliterateText(language!, originalText ?? "");
                      }
                    });
                  },
                  activeColor: Color(0xFF00073e), // Deep Blue for Switch
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: isSwitched2
                  ? Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFDF8E6), // Off-white Background
                              borderRadius:
                                  BorderRadius.circular(15.0), // Rounded Edges
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Original Text",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JosefinSans',
                                      color: Color(0xFF00073e),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    originalText ?? "Loading...",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFFDF8E6), // Off-white Background
                              borderRadius:
                                  BorderRadius.circular(15.0), // Rounded Edges
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6.0,
                                  spreadRadius: 2.0,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Transliterated Text",
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'JosefinSans',
                                      color: Color(0xFF00073e),
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Text(
                                    transliteratedText ?? "No Data",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFFDF8E6), // Off-white Background
                        borderRadius:
                            BorderRadius.circular(15.0), // Rounded Edges
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6.0,
                            spreadRadius: 2.0,
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        child: Text(
                          originalText ?? "Loading...",
                          style:
                              TextStyle(fontSize: 18.0, color: Colors.black87),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
