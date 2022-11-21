import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/custom_widgets/result_page_widgets.dart';
import 'package:jukeboxd/utils/custom_widgets/rating_widget.dart';
import '../services/firebase.dart';
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
  double rating = 0.0;
  String review = '';
  late Track? track = Track();
  double avgRating = 0.0;
  Map allRatings = {};
  Map allReviews = {};
  String artistList = '';
  String imageUrl = '';
  var db = FirebaseFirestore.instance;

//Get the track model
  void _getTrack(trackId) {
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

//Get the url for track image
  void _getTrackImg(trackId) {
    RemoteService().getTrackImage(trackId).then((value) {
      setState(() {
        imageUrl = value;
      });
    });
  }

//Gets the user's initial rating and review
  Future _getInitRating() async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(DataBase().getUid())
        .collection('track')
        .doc(widget.trackId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          rating = snapshot.data()!['rating'];
          review = snapshot.data()!['review'];
        });
      }
    });
  }

//Sets up a document in albums collection if the song does not have one
  Future _createSongStorage(String id) async {
    final reviews = <String, Map<dynamic, dynamic>>{'allReviews': HashMap()};
    final ratings = <String, Map<dynamic, double>>{'allRatings': HashMap()};
    await FirebaseFirestore.instance.collection('songs').doc(id).set(ratings);
    await FirebaseFirestore.instance
        .collection('songs')
        .doc(id)
        .update(reviews);
  }

//Get all reviews and rating for this page
  Future _getSongStorage(String id) async {
    final albumDB =
        FirebaseFirestore.instance.collection('songs').doc(id).get();
    await albumDB.then((snapshot) {
      if (snapshot.exists) {
        setState(() {
          allReviews = snapshot.data()!['allReviews'];
          allRatings = snapshot.data()!['allRatings'];
          avgRating = _getAverage(allRatings);
        });
      } else {
        avgRating = 0.0;
        _createSongStorage(id);
      }
    });
  }

//Return an average rating
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
    _getTrack(widget.trackId);
    _getTrackImg(widget.trackId);
    _getInitRating();
    _getSongStorage(widget.trackId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: (artistList.isEmpty)
              ? const Text('Placeholder')
              : (track!.name.toString().length > 32)
                  ? Text(track!.name.toString(),
                      style: TextStyle(fontSize: 20.0))
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(track!.name.toString()))),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SongImage(
                imageUrl: imageUrl,
              ),
              RateBar(
                initRating: rating,
                ignoreChange: false,
                starSize: 50.0,
                id: widget.trackId,
                type: (artistList.isEmpty) ? 'track' : track!.type!,
                artist: (artistList.isEmpty)
                    ? ''
                    : track!.artists![0].name.toString(),
                title: (artistList.isEmpty) ? '' : track!.name,
                imageUrl: imageUrl,
                typeCollection: 'songs',
              ),
              BlockReviewWidget(
                id: widget.trackId,
                type: track!.type,
                initReview: review,
                artist: (artistList.isEmpty)
                    ? ''
                    : track!.artists![0].name.toString(),
                title: (artistList.isEmpty) ? '' : track!.name,
                typeCollection: 'songs',
              ),
              InfoBlock(
                title: (artistList.isEmpty) ? 'Loading...' : track!.name!,
                artist: artistList,
                avgRating: avgRating,
              ),
              ReviewSection(
                comments: allReviews,
                scores: allRatings
                    .map((key, value) => MapEntry(key, value?.toDouble())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
