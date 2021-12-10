import 'package:audio_player/DBHelper.dart';
import 'package:audio_player/musicplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

class addToFavourite extends StatefulWidget {
  const addToFavourite({Key? key}) : super(key: key);

  @override
  _addToFavouriteState createState() => _addToFavouriteState();
}

class _addToFavouriteState extends State<addToFavourite> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  List allSong = [];
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();

  @override
  void initState() {
    ShowAllSongs();
    super.initState();
  }

   ShowAllSongs() async {
    await databaseHelper.readalldata().then((value){
      setState(() {
        allSong = value;
      });
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != allSong.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState!.setSong(allSong[currentIndex]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Icon(Icons.music_note, color: Colors.white),
        title: Text('Favourite List', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(itemCount: allSong.length,itemBuilder: (context,index){
        return Container(
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.all(3.0),
          decoration: new BoxDecoration(
              borderRadius: const BorderRadius.only(
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
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              border: Border.all(color: Colors.black)
          ),
          child: InkWell(
            child: ListTile(
              leading: CircleAvatar(backgroundColor: Colors.black,child: Text(allSong[index]["songname"][0],style: TextStyle(color: Colors.white),),),
              title: Text(allSong[index]["songname"],maxLines: 1),
            ),
            // onTap: (){
            //     currentIndex = index;
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (context) => MusicPlayer(
            //             changeTrack: changeTrack,
            //             songInfo: allSong[currentIndex],
            //             key: key)));
            // },
          ),
        );
      }),
    );
  }

}
