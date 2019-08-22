import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_recognition/speech_recognition.dart';

class SpeechListenerButton extends StatefulWidget {

  TextField _textField;

  SpeechListenerButton (TextField textHolder):super() {
    this._textField = textHolder;
  }

  @override
  _ButtonState createState() => new _ButtonState(_textField);


}

class _ButtonState extends State<SpeechListenerButton> {

  TextField _textField;
  IconButton iconButton;

  _ButtonState(TextField textHolder):super() {
    this._textField = textHolder;
  }

  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;

  String transcription = '';

  //String _currentLocale = 'en_US';
  String selectedLang = languages['Espanol'];

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  @override
  Widget build(BuildContext context) {
    iconButton = new IconButton(
        icon: new Icon(
            Icons.mic,color:(_isListening)?Colors.red:Colors.green
        ),
        onPressed: () => _handlePressed('')
    );
    return iconButton;
  }

  activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    //_speech.setErrorHandler(errorHandler);
    _speech.activate().then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  void start() => _speech
      .listen(locale: "es_ES")
      .then((result) => print('_MyAppState.start => result $result'));

  void cancel() =>
      _speech.cancel().then((result) => setState(() => _isListening = result));

  void stop() => _speech.stop().then((result) {
    setState(() => _isListening = result);
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(() => selectedLang );
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() {
    transcription = text;
  });

  void onRecognitionComplete() => setState(() {
    _isListening = false;
    _textField.controller.text=transcription;
    _textField.onSubmitted(transcription);
  });

  void errorHandler() => activateSpeechRecognizer();

  _handlePressed(String s) {
    if(!_isListening)
      start();
    else
      stop();
  }


}

const languages = {
  'Francais': 'fr_FR',
  'English': 'en_US',
  'Italiano': 'it_IT',
  'Espanol': 'es_ES'
};

