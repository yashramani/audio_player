import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<MusicPlayerState> key;

  MusicPlayer(
      {required this.songInfo, required this.changeTrack, required this.key})
      : super(key: key);

  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {

  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  void dispose() {
    super.dispose();
    player.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white)),
        title: Text('Now Playing', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Column(
              children: [
                //Spacer(),
                Text(
                  widget.songInfo.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 5,),
                Center(child: CircleAvatar(child: Text(widget.songInfo.title[0],style: TextStyle(fontSize: 100,color: Colors.white),),backgroundColor: Colors.black,maxRadius: 100,)),
                //Spacer(),
              ],
            ),
          ),
          Spacer(),
          Slider(
            inactiveColor: Colors.black12,
            activeColor: Colors.black,
            min: minimumValue,
            max: maximumValue,
            value: currentValue,
            onChanged: (value) {
              currentValue = value;
              player.seek(Duration(milliseconds: currentValue.round()));
            },
          ),
          Container(
            transform: Matrix4.translationValues(0, -15, 0),
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500)),
                Text(endTime,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child:
                      Icon(Icons.skip_previous, color: Colors.black, size: 55),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.changeTrack(false);
                  },
                ),
                GestureDetector(
                  child: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled_rounded
                          : Icons.play_circle_fill_rounded,
                      color: Colors.black,
                      size: 85),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    changeStatus();
                  },
                ),
                GestureDetector(
                  child: Icon(Icons.skip_next, color: Colors.black, size: 55),
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    widget.changeTrack(true);
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
