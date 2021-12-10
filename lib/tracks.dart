import 'dart:io';

import 'package:audio_player/DBHelper.dart';
import 'package:audio_player/addtofavourite.dart';
import 'package:audio_player/musicplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class Tracks extends StatefulWidget {
  _TracksState createState() => _TracksState();
}

class _TracksState extends State<Tracks> {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
  DatabaseHelper dbhelper = DatabaseHelper();


  void initState() {
    super.initState();
    getTracks();
  }

  void addtoFavoutire(String songname) async {
   await dbhelper.insertdata(songname).then((value) {});
  }
  
  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != songs.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState!.setSong(songs[currentIndex]);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to exit an App'),
        actions: <Widget>[
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          OutlinedButton(
            onPressed: () => exit(0),
            child: Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  Widget build(context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.music_note, color: Colors.white),
        title: Text('Music App', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => addToFavourite()));

            },
            icon: Icon(Icons.favorite,color: Colors.white,),
          ),
        ],
      ),
      body: ListView.builder(itemCount: songs.length,
        itemBuilder: (context, index) => songs.length == 0?Center(child: CircularProgressIndicator()):Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(3.0),
          decoration: new BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(10)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.black)
          ),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.black,child: Text(songs[index].title[0],style: TextStyle(color: Colors.white),),),
            title: Text(songs[index].title,maxLines: 1),
            trailing: IconButton(onPressed: (){
              setState(() {
                Scaffold.of(context).showSnackBar(new SnackBar(
                    content: new Text('Item Added In Favourite List')
                ));
                addtoFavoutire(songs[index].title.toString());
              });

            }, icon: Icon(Icons.favorite_border),color: Colors.black,),
            onTap: () {
              currentIndex = index;
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MusicPlayer(
                      changeTrack: changeTrack,
                      songInfo: songs[currentIndex],
                      key: key)));
            },
          ),
        ),),
    ), onWillPop: _onWillPop
    );
  }
}





