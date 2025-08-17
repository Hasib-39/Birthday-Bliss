import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();
  final _messageController = TextEditingController();
  final _musicController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.read<SettingsProvider>();
    final settings = settingsProvider.settings;

    _nameController.text = settings.recipientName;
    _messageController.text = settings.customMessage;
    _musicController.text = settings.musicUrl ?? "";

    return Scaffold(
      appBar: AppBar(title: const Text("Customize Birthday App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Recipient Name"),
              onChanged: (val) => settingsProvider.updateRecipient(val),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Custom Message"),
              onChanged: (val) => settingsProvider.updateMessage(val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Color>(
              value: settings.cakeColor,
              decoration: const InputDecoration(labelText: "Cake Flavor"),
              items: const [
                DropdownMenuItem(
                  value: Colors.pink,
                  child: Text("Strawberry 🍓"),
                ),
                DropdownMenuItem(
                  value: Colors.brown,
                  child: Text("Chocolate 🍫"),
                ),
                DropdownMenuItem(
                  value: Colors.yellow,
                  child: Text("Vanilla 🍦"),
                ),
                DropdownMenuItem(
                  value: Colors.red,
                  child: Text("Red Velvet ❤️"),
                ),
              ],
              onChanged: (color) {
                if (color != null) settingsProvider.updateCakeColor(color);
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _musicController,
              decoration: const InputDecoration(
                  labelText: "Background Music URL (YouTube/MP3)"),
              onChanged: (val) => settingsProvider.updateMusicUrl(val),
            ),
          ],
        ),
      ),
    );
  }
}
