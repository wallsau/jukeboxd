import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';
import 'package:jukeboxd/services/remote_services.dart';
import 'package:jukeboxd/utils/custom_widgets/result_page_widgets.dart';
import 'package:jukeboxd/utils/custom_widgets/rating_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase.dart';

class AlbumPage extends StatefulWidget {
  final String albumId;
  const AlbumPage({Key? key, required this.albumId}) : super(key: key);
  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  Album album = Album();
  double rating = 0.0;
  String review = '';
  var imageUrl = '';
  Map allRatings = {};
  double avgRating = 0.0;

  void _getAlbum(albumId) {
    RemoteService().getAlbum(albumId).then((value) {
      setState(() {
        album = value!;
        imageUrl = value!.images!.first.url.toString();
      });
    });
  }

  Future _getInitRating() async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(DataBase().getUid())
        .collection('album')
        .doc(widget.albumId)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          rating = snapshot.data()!['rating'];
          review = snapshot.data()!['review'];
        });
      }
    });
  }

  Future _getInitRatingMap(String id) async {
    await FirebaseFirestore.instance
        .collection('albums')
        .doc(id)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          allRatings = snapshot.data()!['allRatings'];
          allRatings.forEach((key, value) {
            avgRating += value;
          });
          avgRating =
              double.parse((avgRating / allRatings.length).toStringAsFixed(2));
        });
      } else {
        avgRating = 0.0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getAlbum(widget.albumId);
    _getInitRating();
    _getInitRatingMap('albumid');
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
                  initRating: rating,
                  ignoreChange: false,
                  starSize: 50.0,
                  id: widget.albumId,
                  type: 'album',
                ),
                BlockReviewWidget(
                  id: widget.albumId,
                  type: album.type,
                  initReview: review,
                  artist: (album.name == null)
                      ? ''
                      : album.artists![0].name.toString(),
                  title: album.name,
                  imageUrl: (album.name == null) ? '' : album.images!.first.url,
                ),
                InfoBlock(
                  title: album.name.toString(),
                  artist: album.artists.toString(),
                  avgRating: avgRating,
                ),
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
