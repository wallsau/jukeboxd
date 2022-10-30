import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/cust_widgets.dart';
import '../services/remote_services.dart';
import 'package:spotify/spotify.dart';

class SongPage extends StatefulWidget {
  const SongPage({
    required this.trackId,
    super.key,
  });
  final String trackId;

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  late Track? track = Track();
  String artistList = '';

  void _getAlbum(trackId) {
    RemoteService().getTrack(trackId).then((value) {
      setState(() {
        track = value;
        track?.artists?.forEach((element) {
          if (artistList.isEmpty) {
            artistList += element.name.toString();
          } else {
            artistList += ', ${element.name}';
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAlbum(widget.trackId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: (artistList.isEmpty)
              ? const Text('Placeholder')
              : Text(track!.name.toString())),
      body: GestureDetector(
        onTap: () {
          //here
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              CoverImage(),
              RateBar(
                initRating: 0.0,
                ignoreChange: false,
                starSize: 50.0,
              ),
              SlimReviewWidget(),
              //BlockReviewWidget(), //Alternate review widget; there will be only one review widget normally
              InfoBlock(
                title: (artistList.isEmpty) ? 'Placeholder' : track!.name!,
                artist: artistList,
                avgRating: 0,
              ),
              ReviewSection(numComments: 5),
            ]),
          ),
        ),
      ),
    );
  }
}
