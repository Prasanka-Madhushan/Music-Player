import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/pages/aboutpage.dart';
import 'package:music_player/pages/profile_page.dart';
import 'package:music_player/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Appearance'),
            _buildThemeSwitch(context),
            _buildSectionHeader('Playback'),
            _buildListTile(
              icon: Icons.volume_up,
              title: 'Audio Quality',
              subtitle: 'High quality streaming',
              trailing: _buildQualityDropdown(),
            ),
            _buildListTile(
              icon: Icons.download,
              title: 'Download Quality',
              subtitle: 'Set download preferences',
              onTap: () => _showDownloadQualityDialog(context),
            ),
            _buildSectionHeader('Account'),
            _buildListTile(
              icon: Icons.person,
              title: 'Account Settings',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()),
                );
              },
            ),

            _buildSectionHeader('Support'),
            _buildListTile(
              icon: Icons.help,
              title: 'Help Center',
              onTap: () => _openHelpCenter(),
            ),
            _buildListTile(
              icon: Icons.info,
              title: 'About TuneTrail',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutPage()),
              ),

              // const SizedBox(height: 30),
              // Center(
              //   child: Text(
              //     'Version 1.2.1',
              //     style: TextStyle(
              //         color: Colors.grey.shade600,
              //         fontSize: 12
              //     ),
              //   ),
              // )
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildThemeSwitch(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        leading:
        Icon(Icons.dark_mode, color: Theme.of(context).iconTheme.color),
        title: const Text('Dark Theme'),
        trailing: CupertinoSwitch(
            value:
            Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme()),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? color,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: Colors.white70,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildQualityDropdown() {
    return DropdownButton<String>(
      value: 'High',
      items: const [
        DropdownMenuItem(value: 'High', child: Text('High')),
        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
        DropdownMenuItem(value: 'Low', child: Text('Low')),
      ],
      onChanged: (value) {},
    );
  }

  void _showDownloadQualityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Download Quality'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQualityOption('High Quality (320kbps)', context),
            _buildQualityOption('Medium Quality (192kbps)', context),
            _buildQualityOption('Low Quality (96kbps)', context),
          ],
        ),
      ),
    );
  }

  Widget _buildQualityOption(String title, BuildContext context) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: 'High Quality (320kbps)',
      onChanged: (value) {},
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              /* Implement logout logic */
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openHelpCenter() {
    // Implement help center navigation
  }
}
