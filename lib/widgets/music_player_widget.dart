import 'package:flutter/material.dart';

class MusicPlayerWidget extends StatelessWidget {
  final String url;
  const MusicPlayerWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white70,
      child: ListTile(
        leading: const Icon(Icons.music_note, color: Colors.pink),
        title: Text("Playing Music 🎶"),
        subtitle: Text(url),
        trailing: IconButton(
          icon: const Icon(Icons.stop),
          onPressed: () {
            // TODO: Implement audio stop
          },
        ),
      ),
    );
  }
}
