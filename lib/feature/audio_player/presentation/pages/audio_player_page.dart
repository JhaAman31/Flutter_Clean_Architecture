import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerPage extends StatefulWidget {
  final List<String> audioAssets;
  final int currentIndex;

  const AudioPlayerPage({
    super.key,
    required this.audioAssets,
    required this.currentIndex,
  });

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  late AudioPlayer _audioPlayer;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.currentIndex;
    _playCurrentAudio();
  }

  void _playCurrentAudio() async {
    await _audioPlayer.setAsset(widget.audioAssets[_currentIndex]);
    _audioPlayer.play();
  }

  void _nextAudio() {
    if (_currentIndex < widget.audioAssets.length - 1) {
      setState(() {
        _currentIndex++;
        _playCurrentAudio();
      });
    }
  }

  void _previousAudio() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _playCurrentAudio();
      });
    }
  }

  Stream<DurationState> get _durationStateStream =>
      Rx.combineLatest2<Duration, Duration, DurationState>(
        _audioPlayer.positionStream.map((d) => d ?? Duration.zero),
        _audioPlayer.durationStream.map((d) => d ?? Duration.zero),
            (position, duration) => DurationState(position, duration),
      );


  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, "0").substring(3);
  }

  @override
  Widget build(BuildContext context) {
    final assetName = widget.audioAssets[_currentIndex].split('/').last;

    return Scaffold(
      appBar: AppBar(title: Text(assetName)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Icon(Icons.music_note, size: 150, color: Colors.deepPurple),
          const Spacer(),
          StreamBuilder<DurationState>(
            stream: _durationStateStream,
            builder: (context, snapshot) {
              final durationState = snapshot.data;
              final position = durationState?.position ?? Duration.zero;
              final total = durationState?.total ?? Duration.zero;

              return Column(
                children: [
                  Slider(
                    min: 0,
                    max: total.inMilliseconds.toDouble(),
                    value: position.inMilliseconds.clamp(0, total.inMilliseconds).toDouble(),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(milliseconds: value.toInt()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position)),
                        Text(_formatDuration(total)),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: _previousAudio,
                icon: const Icon(Icons.skip_previous, size: 40),
              ),
              StreamBuilder<PlayerState>(
                stream: _audioPlayer.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final playing = playerState?.playing ?? false;

                  if (playing) {
                    return IconButton(
                      icon: const Icon(Icons.pause, size: 40),
                      onPressed: _audioPlayer.pause,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow, size: 40),
                      onPressed: _audioPlayer.play,
                    );
                  }
                },
              ),
              IconButton(
                onPressed: _nextAudio,
                icon: const Icon(Icons.skip_next, size: 40),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class DurationState {
  final Duration position;
  final Duration total;

  DurationState(this.position, this.total);
}
