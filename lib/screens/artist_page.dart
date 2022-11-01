import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:jukeboxd/services/remote_services.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:spotify/src/models/_models.dart' as spotiyImg;
import 'dart:async';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/custom_widgets/result_page_widgets.dart';

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
              CoverImage(imageUrl: imageUrl),
              ArtistList(title: 'Songs', musicCollection: TrackNames),
              ArtistList(title: 'Albums', musicCollection: artistAlbums),
            ],
          ),
        ),
      ),
    );
  }
}
