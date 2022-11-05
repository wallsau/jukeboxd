import 'dart:collection';

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
  Map allReviews = {};
  double avgRating = 0.0;
  var db = FirebaseFirestore.instance;

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

  Future _createAlbumStorage(String id) async {
    final reviews = <String, Map<dynamic, dynamic>>{'allReviews': HashMap()};
    final ratings = <String, Map<dynamic, double>>{'allRatings': HashMap()};
    db.collection('albums').doc(id).set(ratings);
    db.collection('albums').doc(id).update(reviews);
  }

  Future _getAlbumStorage(String id) async {
    final albumDB =
        FirebaseFirestore.instance.collection('albums').doc(id).get();
    await albumDB.then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          allReviews = snapshot.data()!['allReviews'];
          allRatings = snapshot.data()!['allRatings'];
          avgRating = _getAverage(allRatings);
        });
      } else {
        avgRating = 0.0;
        _createAlbumStorage(id);
      }
    });
  }

  double _getAverage(Map ratings) {
    if (ratings.isEmpty) {
      return 0.0;
    }
    var tmp = 0.0;
    ratings.forEach((key, value) {
      tmp += value;
    });
    return double.parse((tmp / ratings.length).toStringAsFixed(2));
  }

  @override
  void initState() {
    super.initState();
    _getAlbum(widget.albumId);
    _getInitRating();
    _getAlbumStorage(widget.albumId);
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
                ReviewSection(
                  comments: allReviews,
                  scores: allRatings
                      .map((key, value) => MapEntry(key, value?.toDouble())),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
