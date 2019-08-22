import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped }

class TTSEngine {

  FlutterTts flutterTts;
  dynamic languages;
  dynamic voices;
  String language;
  String voice;
  int silencems;

  String _newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  TTSEngine(String language, String voice) {
    this.language = language;
    this.voice = voice;
    _initTts();
  }

  void play (String text) {
    if(text !=null) {
      _newVoiceText = text;
      _speak();
    }
  }

  _initTts() {
    flutterTts = FlutterTts();

    if (Platform.isAndroid) {
      flutterTts.ttsInitHandler(() {
        _getLanguages();
        _getVoices();
      });
    } else if (Platform.isIOS) {
      _getLanguages();
      _getVoices();
    }

    flutterTts.setStartHandler(() {
        ttsState = TtsState.playing;
      }
    );

    flutterTts.setCompletionHandler(() {
        print("Complete");
        ttsState = TtsState.stopped;
      }
    );

    flutterTts.setErrorHandler((msg) {
        ttsState = TtsState.stopped;
      }
    );

    flutterTts.setLanguage(language);
    flutterTts.setVoice(voice);
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    print("Languages \n$languages");
  }

  Future _getVoices() async {
    voices = await flutterTts.getVoices;
    print("Voices \n$voices");
  }

  Future _speak() async {
    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1)
          ttsState = TtsState.playing;
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1)
      ttsState = TtsState.stopped;
  }

  @override
  void dispose() {
    flutterTts.stop();
  }
}