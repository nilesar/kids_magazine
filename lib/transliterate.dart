import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Transliterate extends StatefulWidget {
  final String _storyID;
  final String t_text;
  final FlutterTts flutterTts;

  Transliterate(this._storyID, this.flutterTts, String t_text)
      : t_text = t_text;

  @override
  _TransliterateState createState() => _TransliterateState();
}

enum TtsState { playing, stopped, paused, continued }

class _TransliterateState extends State<Transliterate> {
  CollectionReference stry = FirebaseFirestore.instance.collection('stories');
  String? txt;
  String? language;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  Future _speak() async {
    await widget.flutterTts.setVolume(volume);
    await widget.flutterTts.setSpeechRate(rate);
    await widget.flutterTts.setPitch(pitch);

    if (language == "Gujarati") widget.flutterTts.setLanguage("gu-IN");
    if (language == "Bengali") widget.flutterTts.setLanguage("bn-IN");
    if (language == "Telugu") widget.flutterTts.setLanguage("te-IN");
    if (language == "Marathi") widget.flutterTts.setLanguage("mr-IN");
    if (language == "Hindii") widget.flutterTts.setLanguage("hi-IN");

    print(language);
    await widget.flutterTts.awaitSpeakCompletion(true);
    var result = await widget.flutterTts.speak(txt!);
    if (result == 1) setState(() => ttsState = TtsState.playing);
  }

  Future _stop() async {
    var result = await widget.flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await widget.flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  Widget build(BuildContext context) {
    Widget _volume() {
      return Slider(
        value: volume,
        onChanged: (newVolume) {
          setState(() => volume = newVolume);
        },
        min: 0.0,
        max: 1.0,
        divisions: 10,
        label: "Volume: $volume",
        activeColor: Color(0xFF181621),
      );
    }

    Widget _pitch() {
      return Slider(
        value: pitch,
        onChanged: (newPitch) {
          setState(() => pitch = newPitch);
        },
        min: 0.5,
        max: 2.0,
        divisions: 10,
        label: "Pitch: $pitch",
        activeColor: Color(0xFF181621),
      );
    }

    Widget _rate() {
      return Slider(
        value: rate,
        onChanged: (newRate) {
          setState(() => rate = newRate);
        },
        min: 0.0,
        max: 2.0,
        divisions: 10,
        label: "Rate: $rate",
        activeColor: Color(0xFF181621),
      );
    }

    Widget _buildSliders() {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Volume 🔊"),
              _volume(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Pitch 〰️"),
              _pitch(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Speed 🚄"), _rate()],
          )
        ],
      );
    }

    return StreamBuilder<DocumentSnapshot>(
        stream: stry.doc(widget._storyID).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          txt = widget.t_text;
          language = snapshot.data!['language'];
          return Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                _buildSliders(),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    FloatingActionButton(
                      onPressed: () => _speak(),
                      child: Icon(Icons.play_arrow),
                      backgroundColor: Colors.green[500],
                    ),
                    FloatingActionButton(
                      onPressed: () => _pause(),
                      child: Icon(Icons.pause_outlined),
                      backgroundColor: Colors.blue,
                    ),
                    FloatingActionButton(
                      onPressed: () => _stop(),
                      backgroundColor: Colors.red,
                      child: Icon(Icons.stop),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
