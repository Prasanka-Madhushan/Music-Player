import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/youtube_playlist_provider.dart';
import 'auth/loginscreen.dart';
import 'auth/registerscreen.dart';
import 'bottom_nav_bar_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  final themeProvider = ThemeProvider();
  await themeProvider.initializeTheme();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => themeProvider),
        ChangeNotifierProvider<PlaylistProvider>(create: (_) => PlaylistProvider()),
        ChangeNotifierProvider<YouTubePlaylistProvider>(create: (_) => YouTubePlaylistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Music Player',
      theme: themeProvider.themeData,
      // Automatically navigate based on user auth state
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData) {
            return const BottomNavBarScreen(); // Logged in
          } else {
            return LoginScreen(); // Not logged in
          }
        },
      ),
      routes: {
        '/login': (context) =>  LoginScreen(),
        '/register': (context) =>  RegisterScreen(),
        '/home': (context) => const BottomNavBarScreen(),
      },
    );
  }
}
