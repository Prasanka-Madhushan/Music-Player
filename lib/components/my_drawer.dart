import 'package:flutter/material.dart';
import 'package:music_player/pages/settings_page.dart';
import '../pages/aboutpage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          //logo
          DrawerHeader(
              child: Center(
                child: Icon(
                  Icons.music_note,
                  size: 40,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              )),
          //home title
          Padding(
            padding: EdgeInsets.only(left: 25, top: 25),
            child: ListTile(
              title: Text("A B O U T   U S"),
              leading: Icon(Icons.info_outline),
              onTap: () {
                //pop the drawer
                Navigator.pop(context);
                // navigate to home page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutPage(),
                    ));
              },
            ),
          ),
          //setting title
          Padding(
            padding: EdgeInsets.only(left: 25, top: 25),
            child: ListTile(
              title: Text("S E T T I N G S"),
              leading: Icon(Icons.settings),
              onTap: () {
                //pop the drawer
                Navigator.pop(context);
                // navigate to settings page
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ));
              },
            ),
          )
        ],
      ),
    );
  }
}
