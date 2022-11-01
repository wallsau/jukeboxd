import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:jukeboxd/services/remote_services.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:spotify/src/models/_models.dart' as spotiyImg;
import 'dart:async';
import 'package:jukeboxd/utils/colors.dart';

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

  var countryCode = 'US';

  void _getArtist(artistId) {
    RemoteService().getArtist(artistId).then((value) {
      setState(() {
        artist = value!;
        imageUrl = value!.images!.first.url.toString();
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

  @override
  void initState() {
    super.initState();
    _getArtist(widget.artistId);
    _getTopTracks(widget.artistId, 'US');
    _getAlbums(widget.artistId);
  }

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
                    color: purple,
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Songs",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: iconsGray,
                          ),
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.only(top: 2.0, bottom: 2.0),
                            itemCount: TrackNames.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: Text(
                                  TrackNames.elementAt(index).toString(),
                                  style: const TextStyle(
                                    color: purple,
                                  ),
                                ),
                                trailing: Icon(Icons.star_border_outlined),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: purple,
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          "Albums",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: iconsGray,
                          ),
                          height: 250,
                          child: ListView.builder(
                            itemCount: artistAlbums.length,
                            itemBuilder: (context, index) {
                              final results = artistAlbums[index];
                              return ListTile(
                                leading: Text(
                                  results.toString(),
                                  style: TextStyle(color: purple),
                                ),
                                trailing: Icon(Icons.star_border_outlined),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
