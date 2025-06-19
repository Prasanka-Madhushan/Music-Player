// import 'package:flutter/material.dart';
// import 'package:music_player/models/playlist_provider.dart';
// import 'package:provider/provider.dart';
//
// class MoodSelectionPage extends StatelessWidget {
//   const MoodSelectionPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(title: const Text('Select Mood')),
//       body: ListView(
//         children: [
//           _buildMoodTile(context, 'Happy', playlistProvider),
//           _buildMoodTile(context, 'Sad', playlistProvider),
//           _buildMoodTile(context, 'Energetic', playlistProvider),
//           _buildMoodTile(context, 'Relaxed', playlistProvider),
//           ListTile(
//             title: const Text('Reset to All Songs'),
//             onTap: () {
//               playlistProvider.fetchSongsFromDeezer();
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildMoodTile(BuildContext context, String mood, PlaylistProvider provider) {
//     return ListTile(
//       title: Text(mood),
//       onTap: () {
//         provider.fetchSongsByMood(mood);
//         Navigator.pop(context);
//       },
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class MoodSelectionPage extends StatelessWidget {
  const MoodSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Mood',
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
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
      body: Container(

          color: Theme.of(context).colorScheme.surface,

        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'How are you feeling today?',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: moods.length,
                itemBuilder: (context, index) => _buildMoodCard(
                  context,
                  moods[index].emoji,
                  moods[index].title,
                  moods[index].subtitle,
                  playlistProvider,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.refresh, color: Colors.white70, size: 24),
                label: const Text('Reset to All Songs',
                    style: TextStyle(color: Colors.white70,fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD32F2F),
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  playlistProvider.fetchSongsFromDeezer();
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Mood> moods = const [
    Mood('😄', 'Happy', 'Upbeat & Positive'),
    Mood('😢', 'Sad', 'Melancholic & Reflective'),
    Mood('⚡', 'Energetic', 'Fast-paced & Powerful'),
    Mood('😌', 'Relaxed', 'Calm & Soothing'),
  ];

  Widget _buildMoodCard(
      BuildContext context,
      String emoji,
      String title,
      String subtitle,
      PlaylistProvider provider,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        provider.fetchSongsByMood(title);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2575FC),Color(0xFF6A11CB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 5),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7))),
          ],
        ),
      ),
    );
  }
}

class Mood {
  final String emoji;
  final String title;
  final String subtitle;

  const Mood(this.emoji, this.title, this.subtitle);
}