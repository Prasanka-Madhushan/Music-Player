// lib/pages/chat_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:music_player/services/gemini_service.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final GeminiService _gemini = GeminiService();
  bool _isLoading = false;

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'text': text, 'isBot': false});
      _isLoading = true;
    });

    final response = await _gemini.getMusicRecommendation(text);
    final provider = Provider.of<PlaylistProvider>(context, listen: false);

    // Parse Gemini response
    final match = RegExp(r'\[(.*?)\|(.*?)\|(.*?)\]').firstMatch(response);
    if (match != null) {
      final vibes = match.group(1)!.split(',');
      final explanation = match.group(2)!;
      final emoji = match.group(3)!;

      // Update playlist based on first vibe
      provider.fetchSongsByMood(vibes.first.trim());

      setState(() {
        _messages.add({
          'text': '$emoji $explanation\n\n**Suggested vibe:** ${vibes.join(', ')}',
          'isBot': true
        });
      });
    } else {
      setState(() {
        _messages.add({'text': response, 'isBot': true});
      });
    }

    setState(() {
      _isLoading = false;
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Assistant',style: TextStyle(fontWeight: FontWeight.bold) ,),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.music_note),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(
                  text: message['text'],
                  isBot: message['isBot'],
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Describe your mood or activity...',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _handleSubmitted(_controller.text),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isBot;

  const ChatBubble({super.key, required this.text, required this.isBot});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isBot) const Icon(Icons.smart_toy, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isBot ? Colors.blue.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: MarkdownBody(
                data: text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    color: isBot ? Colors.blue.shade900 : Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}