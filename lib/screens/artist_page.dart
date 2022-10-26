import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:jukeboxd/services/remote_services.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:spotify/src/models/_models.dart' as spotiyImg;
import 'dart:async';

class ArtistPage extends StatefulWidget {
  final String artistId;
  const ArtistPage({Key? key, required this.artistId}) : super(key: key);
  @override
  State<ArtistPage> createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  Artist artist = Artist();
  Iterable topTracks = [];
  List TrackNames = [];
  List TestAlbums = [];
  List artistAlbums = [];
  var imageUrl = '';
  var artistId = '1r1uxoy19fzMxunt3ONAkG';
  var countryCode = 'US';

  void _getArtist(artistId) {
    RemoteService().getArtist(artistId).then((value) {
      setState(() {
        artist = value!;
      });
    });
  }

  void _getTopTracks(artistId, countryCode) {
    RemoteService().getTopTracks(artistId, countryCode).then((value) {
      setState(() {
        topTracks = value;
        topTracks.toList();
        TrackNames.add(value.elementAt(0).name);
        TrackNames.add(value.elementAt(1).name);
        TrackNames.add(value.elementAt(2).name);
        TrackNames.add(value.elementAt(3).name);
        TrackNames.add(value.elementAt(4).name);
      });
    });
  }

  void _getAlbums(artistId) {
    RemoteService().getArtistAlbums(artistId).then((value) {
      setState(() {
        TestAlbums = value;
        TestAlbums.toList();
        artistAlbums.add(value[0].name.toString());
        artistAlbums.add(value[1].name.toString());
        artistAlbums.add(value[2].name.toString());
        artistAlbums.add(value[3].name.toString());
        artistAlbums.add(value[4].name.toString());
      });
    });
  }

  void _getImage(artistId) {
    RemoteService().getArtist(artistId).then((value) {
      setState(() {
        imageUrl = value!.images!.first.url.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(artist.name.toString()),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: (() {
                    _getArtist(artistId);
                    _getTopTracks(artistId, countryCode);
                    _getAlbums(artistId);
                    _getImage(artistId);
                  }),
                  child: Text('Push for album')),
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
                        image: NetworkImage(imageUrl),
                      ),
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
                      itemCount: TrackNames.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(TrackNames.elementAt(index).toString()),
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
                      itemCount: artistAlbums.length,
                      itemBuilder: (context, index) {
                        final results = artistAlbums[index];
                        return ListTile(
                          leading: Text(results.toString()),
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
