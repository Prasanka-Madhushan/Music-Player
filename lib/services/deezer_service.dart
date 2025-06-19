import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class DeezerService {
  Future<List<Song>> searchSongs(String query, String mood) async {
    final response = await http.get(
      Uri.parse('https://api.deezer.com/search?q=${query.split(',').first}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> tracks = data['data'];

      return tracks.map((track) {
        return Song(
          songName: track['title'] ?? 'Unknown Title',
          artistName: track['artist']?['name'] ?? 'Unknown Artist',
          albumArtImagePath: track['album']?['cover_big'] ?? 'assets/images/weeknd.jpg',
          audioPath: track['preview'] ?? '',
          mood: mood,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch songs from Deezer');
    }
  }
}