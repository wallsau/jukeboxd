import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> albums = [
  'album 1',
  'album 2',
  'album 3',
  'album 4',
  'album 5',
];

List<String> songs = [
  'song 1',
  'song 2',
  'song 3',
  'song 4',
  'song 5',
];

class ArtistPage extends StatelessWidget {
  final String artistId;
  ArtistPage({Key? key, required this.artistId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Album Title"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/43/43566.png')),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue,
                  ),
                  child: Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: albums.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(albums.elementAt(index).toString()),
                          trailing: Icon(Icons.star_border_outlined),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue,
                  ),
                  child: Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(songs.elementAt(index).toString()),
                          trailing: Icon(Icons.star_border_outlined),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
