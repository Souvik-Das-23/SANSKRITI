// lib/services/audio_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/heritage_place.dart';

class AudioGuideService extends ChangeNotifier {
  static final AudioGuideService _instance = AudioGuideService._internal();
  factory AudioGuideService() => _instance;
  AudioGuideService._internal();

  HeritagePlace? _currentPlace;
  bool _isPlaying = false;
  double _progress = 0.0; // 0.0 to 1.0
  int _currentSeconds = 0;
  int _totalSeconds = 180; // 3 minutes demo
  Timer? _timer;
  String _selectedLanguage = 'English';
  bool _ambientMusicEnabled = true;
  double _playbackSpeed = 1.0;

  HeritagePlace? get currentPlace => _currentPlace;
  bool get isPlaying => _isPlaying;
  double get progress => _progress;
  int get currentSeconds => _currentSeconds;
  int get totalSeconds => _totalSeconds;
  String get selectedLanguage => _selectedLanguage;
  bool get ambientMusicEnabled => _ambientMusicEnabled;
  double get playbackSpeed => _playbackSpeed;

  String get formattedCurrentTime {
    int m = _currentSeconds ~/ 60;
    int s = _currentSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get formattedTotalTime {
    int m = _totalSeconds ~/ 60;
    int s = _totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void loadPlace(HeritagePlace place) {
    if (_currentPlace?.id == place.id) return;
    _currentPlace = place;
    _progress = 0.0;
    _currentSeconds = 0;
    _totalSeconds = 180;
    _isPlaying = false;
    _timer?.cancel();
    notifyListeners();
  }

  void play() {
    if (_currentPlace == null) return;
    _isPlaying = true;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentSeconds >= _totalSeconds) {
        pause();
        _currentSeconds = 0;
        _progress = 0.0;
      } else {
        _currentSeconds++;
        _progress = _currentSeconds / _totalSeconds;
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _timer?.cancel();
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(double value) {
    _progress = value.clamp(0.0, 1.0);
    _currentSeconds = (_progress * _totalSeconds).round();
    notifyListeners();
  }

  void setLanguage(String lang) {
    _selectedLanguage = lang;
    notifyListeners();
  }

  void toggleAmbientMusic() {
    _ambientMusicEnabled = !_ambientMusicEnabled;
    notifyListeners();
  }

  void cyclePlaybackSpeed() {
    if (_playbackSpeed == 1.0) {
      _playbackSpeed = 1.25;
    } else if (_playbackSpeed == 1.25) {
      _playbackSpeed = 1.5;
    } else {
      _playbackSpeed = 1.0;
    }
    notifyListeners();
  }

  void stop() {
    _timer?.cancel();
    _isPlaying = false;
    _progress = 0.0;
    _currentSeconds = 0;
    _currentPlace = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
