import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/colors.dart';
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
        .collection('songs')
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

  Future _getInitReviewMap(String id) async {
    await FirebaseFirestore.instance
        .collection('songs')
        .doc(id)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          allReviews = snapshot.data()!['allReviews'];
        });
      } else {
        avgRating = 0.0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getTrack(widget.trackId);
    _getTrackImg(widget.trackId);
    _getInitRating();
    _getInitRatingMap('trackid');
    _getInitReviewMap('trackid');
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
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: SingleChildScrollView(
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
                ),
                BlockReviewWidget(
                  id: widget.trackId,
                  type: track!.type,
                  initReview: review,
                  artist: (artistList.isEmpty)
                      ? ''
                      : track!.artists![0].name.toString(),
                  title: (artistList.isEmpty) ? '' : track!.name,
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
      ),
    );
  }
}
