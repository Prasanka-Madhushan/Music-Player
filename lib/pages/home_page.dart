// import 'package:flutter/material.dart';
// import 'package:music_player/components/my_drawer.dart';
// import 'package:music_player/models/playlist_provider.dart';
// import 'package:music_player/pages/song_page.dart';
// import 'package:provider/provider.dart';
//
// import '../models/song.dart';
// import 'mood_selection_page.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late final dynamic playlistProvider;
//
//   @override
//   void initState() {
//     super.initState();
//     playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
//   }
//
//   void goToSong(int songIndex) {
//     playlistProvider.currentSongIndex = songIndex;
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SongPage(),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       appBar: AppBar(
//         title: const Text("S O N G S"),
//         backgroundColor: Theme.of(context).colorScheme.secondary,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.mood),
//             onPressed: () => Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const MoodSelectionPage()),
//             ),
//           ),
//         ],
//       ),
//       drawer: MyDrawer(),
//       body: Consumer<PlaylistProvider>(
//         builder: (context, value, child) {
//           final List<Song> playlist = value.playlist;
//
//           return ListView.builder(
//             itemCount: playlist.length,
//             itemBuilder: (context, index) {
//               final Song song = playlist[index];
//
//               return ListTile(
//                 title: Text(song.songName),
//                 subtitle: Text(song.artistName),
//                 leading: Container(
//                   width: 50,
//                   height: 50,
//                   child: song.albumArtImagePath.startsWith('http')
//                       ? Image.network(
//                     song.albumArtImagePath,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) =>
//                     const Icon(Icons.music_note),
//                   )
//                       : Image.asset(
//                     song.albumArtImagePath,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 onTap: () => goToSong(index),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:music_player/components/my_drawer.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/pages/song_page.dart';
import 'package:provider/provider.dart';
import 'package:music_player/models/song.dart';
import '../chat_button.dart';
import 'mood_selection_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final dynamic playlistProvider;

  @override
  void initState() {
    super.initState();
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);
  }

  // Add time vibe determination logic
  String _getCurrentTimeVibe() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    if (hour < 21) return 'Evening';
    return 'Night';
  }

// Build the time vibe card widget
  Widget _buildTimeVibeCard(BuildContext context) {
    final timeVibe = _getCurrentTimeVibe();
    final provider = Provider.of<PlaylistProvider>(context, listen: false);
    final subtitleMap = {
      'Morning': 'Fresh & Energizing',
      'Afternoon': 'Productive & Balanced',
      'Evening': 'Chill & Reflective',
      'Night': 'Calm & Relaxing',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          provider.fetchSongsByTimeVibe(timeVibe.toLowerCase());
        },
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color(0xFF2575FC),Color(0xFF6A11CB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -30,
                child: Icon(Icons.access_time_filled,
                    size: 120, color: Colors.white.withOpacity(0.1)),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$timeVibe Vibe',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    Text(subtitleMap[timeVibe]!,
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.8))),
                    const Spacer(),
                    Row(
                      children: [
                        Text('Tap to play recommendations',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.7))),
                        const Icon(Icons.chevron_right,
                            color: Colors.white70),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void goToSong(int songIndex) {
    playlistProvider.currentSongIndex = songIndex;
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => SongPage(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            collapsedHeight: 80,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: const Text("Discover Music",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00E5FF), Color(0xFF0099FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.mood, color: Colors.white),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MoodSelectionPage(),
                  ),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: _buildTimeVibeCard(context),
          ),
          Consumer<PlaylistProvider>(
            builder: (context, value, child) {
              final List<Song> playlist = value.playlist;
              return SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildSongCard(playlist[index], index),
                    childCount: playlist.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: const ChatButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSongCard(Song song, int index) {
    return GestureDetector(
      onTap: () => goToSong(index),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              song.albumArtImagePath.startsWith('http')
                  ? Image.network(
                song.albumArtImagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFF16213E),
                  child: const Icon(Icons.music_note,
                      color: Colors.white54, size: 40),
                ),
              )
                  : Image.asset(
                song.albumArtImagePath,
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.songName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      song.artistName,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}