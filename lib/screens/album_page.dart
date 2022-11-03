import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:jukeboxd/services/remote_services.dart';
import 'package:jukeboxd/utils/custom_widgets/result_page_widgets.dart';
import 'package:jukeboxd/utils/custom_widgets/rating_widget.dart';

class AlbumPage extends StatefulWidget {
  final String albumId;
  const AlbumPage({Key? key, required this.albumId}) : super(key: key);
  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  Album album = Album();
  var imageUrl = '';

  void _getAlbum(albumId) {
    RemoteService().getAlbum(albumId).then((value) {
      setState(() {
        album = value!;
        imageUrl = value!.images!.first.url.toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getAlbum(widget.albumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: (album.name == null)
            ? const Text('Loading...')
            : Text(album.name.toString()),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                CoverImage(imageUrl: imageUrl),
                RateBar(
                  initRating: 0.0,
                  ignoreChange: false,
                  starSize: 50.0,
                ),
                BlockReviewWidget(
                  id: album.id.toString(),
                  type: '',
                  initReview: '',
                ),
                /*InfoBlock(
                    title: album.name.toString(),
                    artist: album.artists.toString()),*/
                AlbumList(album: album),
                ReviewSection(numComments: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
