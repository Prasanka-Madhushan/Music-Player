import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/playlist_provider.dart';
import 'song_page.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        if (!value.showMiniPlayer || value.playlist.isEmpty) return const SizedBox.shrink();

        final currentSong = value.playlist[value.currentSongIndex ?? 0];

        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  SongPage())),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16),bottom: Radius.circular(16)),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12)],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Album Art
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    currentSong.albumArtImagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.music_note),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Song Info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentSong.songName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        currentSong.artistName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Controls
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.blue),
                  onPressed: value.playPreviousSong,
                ),
                IconButton(
                  icon: Icon(
                    value.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.blue,
                  ),
                  onPressed: value.pauseOrResume,
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.blue),
                  onPressed: value.playNextSong,
                ),

                // Close
                IconButton(
                  icon: Icon(Icons.close, size: 20, color: Colors.blue),
                  onPressed: () => value.toggleMiniPlayer(false),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}