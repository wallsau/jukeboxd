import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:jukeboxd/services/remote_services.dart';
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
  List<Track> TrackNames = [];
  List TestAlbums = [];
  List<Album> artistAlbums = [];
  var imageUrl = '';

  var countryCode = 'US';

  //Get artist model and image url
  void _getArtist(artistId) {
    RemoteService().getArtist(artistId).then((value) {
      setState(() {
        artist = value!;
        imageUrl = value.images!.first.url.toString();
      });
    });
  }

  //Find top tracks and add to TrackNames list
  void _getTopTracks(artistId, countryCode) {
    RemoteService().getTopTracks(artistId, countryCode).then((value) {
      setState(() {
        topTracks = value;
        topTracks.toList();
        TrackNames.add(value.elementAt(0));
        TrackNames.add(value.elementAt(1));
        TrackNames.add(value.elementAt(2));
        TrackNames.add(value.elementAt(3));
        TrackNames.add(value.elementAt(4));
      });
    });
  }

//Add the albums to artistAlbums list
  void _getAlbums(artistId) {
    RemoteService().getArtistAlbums(artistId).then((value) {
      setState(() {
        TestAlbums = value;
        TestAlbums.toList();
        artistAlbums.add(value[0]);
        artistAlbums.add(value[1]);
        artistAlbums.add(value[2]);
        artistAlbums.add(value[3]);
        artistAlbums.add(value[4]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: (artist.name.toString().length > 32)
            ? Text(artist.name.toString(), style: TextStyle(fontSize: 20.0))
            : FittedBox(
                fit: BoxFit.scaleDown, child: Text(artist.name.toString())),
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
