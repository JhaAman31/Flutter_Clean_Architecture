import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'audio_player_page.dart';

class AudioListPage extends StatelessWidget {
  final List<String> audioAssets = [
    'assets/audios/itachi.mp3',
    'assets/audios/tu_ru_tu_ruru.mp3',
    'assets/audios/madara.mp3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Audio List',style: TextStyle(fontWeight: FontWeight.bold),)),
      body: ListView.separated(
        itemCount: audioAssets.length,
        separatorBuilder:
            (context, index) =>
                const Divider(color: Colors.white12, thickness: 1, height: 0),
        itemBuilder: (context, index) {
          final asset = audioAssets[index];
          final fileName = asset.split('/').last;
          return ListTile(
            leading: Icon(CupertinoIcons.music_note_2),
            title: Text(fileName),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => AudioPlayerPage(
                        audioAssets: audioAssets,
                        currentIndex: index,
                      ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
