import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/song.dart';

class YouTubeService {
  final String apiKey = 'AIzaSyDDt9FsHMBE6MceE5ltPA0LLkF2QGfWEKc';

  Future<List<Song>> searchSongs(String query, String mood) async {
    final searchQuery = query.isEmpty
        ? '$mood music'
        : '$query $mood music video'; // Inject mood if user types something

    final response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/youtube/v3/search'
            '?part=snippet'
            '&q=$searchQuery'
            '&maxResults=10'
            '&type=video'
            '&videoCategoryId=10'
            '&key=$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> items = data['items'];

      return items.map((item) {
        final id = item['id']['videoId'];
        final snippet = item['snippet'];

        return Song(
          songName: snippet['title'] ?? 'Unknown Title',
          artistName: snippet['channelTitle'] ?? 'Unknown Artist',
          albumArtImagePath: snippet['thumbnails']['high']['url'] ?? '',
          audioPath: id,
          mood: mood,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch songs from YouTube: ${response.statusCode}');
    }
  }

}
