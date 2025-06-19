import 'package:flutter/material.dart';
import 'package:music_player/pages/chat_page.dart';

class ChatButton extends StatelessWidget {
  const ChatButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 70.0,
          right: 10.0,
          child: FloatingActionButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatPage()),
            ),
            child: Image.asset('assets/images/chat.png'),
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
