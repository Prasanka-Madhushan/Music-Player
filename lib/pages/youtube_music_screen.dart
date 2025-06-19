import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/song.dart';
import '../models/youtube_playlist_provider.dart';
import 'youtube_player_widget.dart';

class YouTubeMusicScreen extends StatefulWidget {
  const YouTubeMusicScreen({super.key});

  @override
  State<YouTubeMusicScreen> createState() => _YouTubeMusicScreenState();
}

class _YouTubeMusicScreenState extends State<YouTubeMusicScreen> {
  final TextEditingController _searchController = TextEditingController(text: '');
  String selectedMood = 'happy';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<YouTubePlaylistProvider>(context, listen: false);
    provider.fetchSongs(_searchController.text, selectedMood);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Music',style: TextStyle(fontWeight: FontWeight.bold),),

        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<YouTubePlaylistProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Mood Selection Chips
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      MoodChip(label: 'Happy', mood: 'happy', selected: selectedMood == 'happy'),
                      const SizedBox(width: 8),
                      MoodChip(label: 'Sad', mood: 'sad', selected: selectedMood == 'sad'),
                      const SizedBox(width: 8),
                      MoodChip(label: 'Relaxed', mood: 'relaxed', selected: selectedMood == 'relaxed'),
                      const SizedBox(width: 8),
                      MoodChip(label: 'Energetic', mood: 'energetic', selected: selectedMood == 'energetic'),
                    ],
                  ),
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: SearchBar(
                  controller: _searchController,
                  hintText: 'Search songs...',
                  trailing: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        provider.fetchSongs(_searchController.text, selectedMood);
                      },
                    ),
                  ],
                  onSubmitted: (_) => provider.fetchSongs(_searchController.text, selectedMood),
                ),
              ),

              // YouTube Player
              if (provider.currentSong != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: YouTubePlayerWidget(videoId: provider.currentSong!.audioPath),
                  ),
                ),

              // Song List
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.playlist.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final song = provider.playlist[index];
                    return SongCard(
                      song: song,
                      isPlaying: index == provider.currentIndex,
                      onTap: () => provider.selectSong(index),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void updateMood(String mood) {
    setState(() => selectedMood = mood);
    final provider = Provider.of<YouTubePlaylistProvider>(context, listen: false);
    provider.fetchSongs(_searchController.text, selectedMood);
  }
}

class MoodChip extends StatelessWidget {
  final String label;
  final String mood;
  final bool selected;

  const MoodChip({
    super.key,
    required this.label,
    required this.mood,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final screenState = context.findAncestorStateOfType<_YouTubeMusicScreenState>();
        screenState?.updateMood(mood);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : null,
          color: selected ? null : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected
              ? [
            BoxShadow(
              color: Colors.purple.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : Colors.grey.shade800,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),

    );
  }
}

class SongCard extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final VoidCallback onTap;

  const SongCard({
    super.key,
    required this.song,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            song.albumArtImagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey.shade200,
              child: const Icon(Icons.music_note),
            ),
          ),
        ),
        title: Text(
          song.songName,
          style: TextStyle(
            fontWeight: isPlaying ? FontWeight.bold : FontWeight.normal,
            color: isPlaying ? const Color(0xFF6A11CB) : Colors.black87,
          ),
        ),
        subtitle: Text(
          song.artistName,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Icon(
          isPlaying ? Icons.pause_circle : Icons.play_circle,
          color: const Color(0xFF6A11CB),
        ),
        onTap: onTap,
      ),
    );
  }
}