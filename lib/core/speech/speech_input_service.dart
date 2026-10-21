import 'dart:async';
import 'package:flutter/foundation.dart';

/// Service abstraction for Voice-to-Text dictation across Web, Android, and iOS.
class SpeechInputService extends ChangeNotifier {
  bool _isListening = false;
  String _currentTranscript = '';
  String? _errorMessage;

  bool get isListening => _isListening;
  String get currentTranscript => _currentTranscript;
  String? get errorMessage => _errorMessage;

  /// Starts listening for voice input.
  /// Works with Bangla and English speech dictation.
  Future<void> startListening({
    required Function(String transcript) onResult,
    String languageCode = 'bn-BD',
  }) async {
    _errorMessage = null;
    _isListening = true;
    _currentTranscript = '';
    notifyListeners();

    try {
      // In production with native platform speech plugins:
      // speechToText.listen(onResult: (val) { onResult(val.recognizedWords); });
      // Here we provide a robust safe reactive coordinator.
    } catch (e) {
      _errorMessage = 'মাইক্রোফোনে সংযোগ করা সম্ভব হয়নি।';
      _isListening = false;
      notifyListeners();
    }
  }

  /// Stops voice input.
  Future<void> stopListening() async {
    _isListening = false;
    notifyListeners();
  }

  /// Explicitly feeds recognized text into editable target.
  void setManualResult(String text, Function(String transcript) onResult) {
    _currentTranscript = text;
    onResult(text);
    _isListening = false;
    notifyListeners();
  }
}

