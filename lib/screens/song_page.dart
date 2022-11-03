import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/colors.dart';
//import 'package:jukeboxd/utils/cust_widgets.dart';
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
  String artistList = '';
  var imageUrl = '';

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

  @override
  void initState() {
    super.initState();
    _getTrack(widget.trackId);
    _getInitRating();
    _getInitRatingMap('trackid');
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
              SongImage(),
              RateBar(
                initRating: rating,
                ignoreChange: false,
                starSize: 50.0,
                id: widget.trackId,
                type: (artistList.isEmpty) ? 'track' : track!.type!,
              ),
              //SlimReviewWidget(),
              BlockReviewWidget(
                id: widget.trackId,
                type: track!.type,
                initReview: review,
                artist: (artistList.isEmpty)
                    ? ''
                    : track!.artists![0].name.toString(),
                title: (artistList.isEmpty) ? '' : track!.name,
              ), //Alternate review widget; there will be only one review widget normally
              InfoBlock(
                title: (artistList.isEmpty) ? 'Loading...' : track!.name!,
                artist: artistList,
                avgRating: avgRating,
              ),
              ReviewSection(numComments: 5),
            ]),
          ),
        ),
      ),
    );
  }
}
