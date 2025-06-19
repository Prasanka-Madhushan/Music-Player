import 'package:flutter/material.dart';
import '../models/song.dart';
import '../services/youtube_service.dart';

class YouTubePlaylistProvider extends ChangeNotifier {
  final YouTubeService _youtubeService = YouTubeService();

  List<Song> _playlist = [];
  int? _currentIndex;

  List<Song> get playlist => _playlist;
  int? get currentIndex => _currentIndex;
  Song? get currentSong => _currentIndex != null ? _playlist[_currentIndex!] : null;

  Future<void> fetchSongs(String query, String mood) async {
    try {
      _playlist = await _youtubeService.searchSongs(query, mood);
      _currentIndex = 0;
      notifyListeners();
    } catch (e) {
      print('Error fetching YouTube songs: $e');
    }
  }

  void selectSong(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
