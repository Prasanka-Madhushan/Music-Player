import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/services/deezer_service.dart';

class PlaylistProvider extends ChangeNotifier {
  List<Song> _currentPlaylist = [];
  int? _currentSongIndex;
  bool _isShuffle = false;
  bool _isRepeat = false;
  bool _isPlaying = false;
  bool _showMiniPlayer = false;
  bool get showMiniPlayer => _showMiniPlayer;

  void toggleMiniPlayer(bool show) {
    _showMiniPlayer = show;
    notifyListeners();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  final DeezerService _deezerService = DeezerService();

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  PlaylistProvider() {
    fetchSongsFromDeezer();

    // Listen to duration updates
    _audioPlayer.onDurationChanged.listen((duration) {
      _totalDuration = duration;
      notifyListeners();
    });

    // Listen to position updates
    _audioPlayer.onPositionChanged.listen((position) {
      _currentPosition = position;
      notifyListeners();
    });

    // Auto play next or repeat
    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isRepeat) {
        seek(Duration.zero);
        resume();
      } else {
        playNextSong();
      }
    });
  }

  /// Fetch songs from a default Deezer album
  Future<void> fetchSongsFromDeezer() async {
    // Changed to Deezer Chart API
    const String chartUrl = 'https://api.deezer.com/chart/0/tracks';

    final chartResponse = await http.get(Uri.parse(chartUrl));
    if (chartResponse.statusCode != 200) return;

    final chartData = json.decode(chartResponse.body);
    final List<dynamic> tracks = chartData['data'];

    if (tracks.isNotEmpty) {
      _currentPlaylist = tracks.map<Song>((item) => Song(
        songName: item['title'] ?? 'Unknown Title',
        artistName: item['artist']?['name'] ?? 'Unknown Artist',
        albumArtImagePath: item['album']?['cover_big'] ?? 'assets/images/default_cover.jpg',
        audioPath: item['preview'] ?? '',
        mood: 'Popular',
      )).toList();

      _currentSongIndex = 0;
      notifyListeners();
    }
  }


  // Add this method to PlaylistProvider class
  Future<void> fetchSongsByTimeVibe(String vibe) async {
    try {
      final songs = await _deezerService.searchSongs(vibe, vibe);
      _currentPlaylist = songs;
      _currentSongIndex = 0;
      notifyListeners();
      // play();
    } catch (e) {
      print('Error fetching time vibe songs: $e');
    }
  }

  /// Fetch songs based on mood
  Future<void> fetchSongsByMood(String mood) async {
    try {
      final songs = await _deezerService.searchSongs(mood, mood);
      _currentPlaylist = songs;
      _currentSongIndex = 0;
      notifyListeners();
      // play();
    } catch (e) {
      print('Error fetching mood songs: $e');
    }
  }

  /// Play current song
  void play() async {
    if (_currentSongIndex != null) {
      final String path = _currentPlaylist[_currentSongIndex!].audioPath;
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(path));
      _isPlaying = true;
      _showMiniPlayer = true;
      notifyListeners();
    }
  }

  /// Pause playback
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  /// Resume playback
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  /// Toggle pause/resume
  void pauseOrResume() {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
  }

  /// Play next song
  void playNextSong() {
    if (_currentPlaylist.isEmpty || _currentSongIndex == null) return;

    if (_isShuffle) {
      final randomIndex = Random().nextInt(_currentPlaylist.length);
      _currentSongIndex = randomIndex == _currentSongIndex
          ? (randomIndex + 1) % _currentPlaylist.length
          : randomIndex;
    } else {
      _currentSongIndex = (_currentSongIndex! + 1) % _currentPlaylist.length;
    }

    play();
  }

  /// Play previous song
  void playPreviousSong() {
    if (_currentPlaylist.isEmpty || _currentSongIndex == null) return;

    if (_isShuffle) {
      final randomIndex = Random().nextInt(_currentPlaylist.length);
      _currentSongIndex = randomIndex;
    } else if (_currentSongIndex! > 0) {
      _currentSongIndex = _currentSongIndex! - 1;
    } else {
      _currentSongIndex = _currentPlaylist.length - 1;
    }

    play();
  }

  /// Seek to specific position
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void setPlaylistFromChat(List<Song> songs) {
    _currentPlaylist = songs;
    _currentSongIndex = 0;
    notifyListeners();
    play();
  }

  /// Getters
  List<Song> get playlist => _currentPlaylist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isShuffle => _isShuffle;
  bool get isRepeat => _isRepeat;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentPosition;
  Duration get totalDuration => _totalDuration;

  /// Set current song index and play
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) {
      play();
    }
    notifyListeners();
  }

  /// Toggle shuffle
  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  /// Toggle repeat
  void toggleRepeat() {
    _isRepeat = !_isRepeat;
    notifyListeners();
  }
}
