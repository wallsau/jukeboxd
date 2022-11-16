/* Widgets associated with user_profile, user_ratings, and user_reviews */
import 'dart:async';
import 'package:jukeboxd/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/user_ratings.dart';
import 'package:jukeboxd/screens/user_reviews.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/custom_widgets/rating_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

//User profile picture and name
/*Will need to replace AssetImages later*/
//Located on these pages: user_profile
class UserHeader extends StatelessWidget {
  final AssetImage userProfile;
  final String username;
  const UserHeader(
      {this.userProfile = const AssetImage("images/portrait_default.png"),
      required this.username,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 100.0,
          height: 100.0,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            shape: BoxShape.circle,
            image: DecorationImage(image: userProfile),
          ),
        ),
        Text(
          username,
          style: const TextStyle(color: buttonRed, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

//Images of top five rated
/*Will need to replace AssetImages later*/
//Located on these pages: user_profile
class Top5 extends StatefulWidget {
  Top5({
    required this.pic1,
    required this.pic2,
    required this.pic3,
    required this.pic4,
    required this.pic5,
    super.key,
  });
  final String pic1;
  final String pic2;
  final String pic3;
  final String pic4;
  final String pic5;

  @override
  State<Top5> createState() => _Top5State();
}

class _Top5State extends State<Top5> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(
          height: 50.0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "My Top 5 Albums",
                style: TextStyle(color: bbarGray),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CachedNetworkImage(
                imageUrl: widget.pic1,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              CachedNetworkImage(
                imageUrl: widget.pic2,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              CachedNetworkImage(
                imageUrl: widget.pic3,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              CachedNetworkImage(
                imageUrl: widget.pic4,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              CachedNetworkImage(
                imageUrl: widget.pic5,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ],
          ),
        ),
        const SizedBox(height: 50.0),
      ],
    );
  }
}

//Menu containing options to view user collections
//Located on these pages: user_profile
class ProfileMenu extends StatefulWidget {
  const ProfileMenu({
    required this.toAlbumRatings,
    required this.toSongRatings,
    required this.toReviews,
    super.key,
  });
  final String toAlbumRatings;
  final String toSongRatings;
  final String toReviews;

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 200.0,
      width: screenWidth,
      child: ListView(
        children: <Widget>[
          ListTile(
            shape: const Border(
              top: BorderSide(
                width: 1.0,
              ),
            ),
            title: const Text(
              "My Rated Albums",
              style: TextStyle(color: bbarGray),
            ),
            trailing: IconButton(
              icon:
                  const Icon(Icons.keyboard_arrow_right_sharp, color: bbarGray),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserRatings(
                      title: widget.toAlbumRatings,
                      type: 'album',
                    ),
                  ),
                );
              },
            ),
          ),
          ListTile(
            shape: const Border(
              top: BorderSide(
                width: 1.0,
              ),
            ),
            title: const Text(
              "My Rated Songs",
              style: TextStyle(color: bbarGray),
            ),
            trailing: IconButton(
              icon:
                  const Icon(Icons.keyboard_arrow_right_sharp, color: bbarGray),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserRatings(
                            title: widget.toSongRatings,
                            type: 'track',
                          )),
                );
              },
            ),
          ),
          ListTile(
            shape: const Border(
              top: BorderSide(
                width: 1.0,
              ),
              bottom: BorderSide(width: 1.0),
            ),
            title: const Text(
              "My Reviews",
              style: TextStyle(color: bbarGray),
            ),
            trailing: IconButton(
              icon:
                  const Icon(Icons.keyboard_arrow_right_sharp, color: bbarGray),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserReviews(
                            title: widget.toReviews,
                          )),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

//Creates the main container for holding the user's ratings collections
//Located on these pages: user_ratings
class UserList extends StatefulWidget {
  final String title, type;
  UserList({required this.title, required this.type, super.key});

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: purple,
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('accounts')
                .doc(DataBase().getUid())
                .collection(widget.type)
                .where('rating', isNull: false)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.active) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Data'),
                  );
                }
                return Column(
                  children: List.generate(
                    snapshot.data!.size,
                    (index) => TitleAndRating(
                      rating: snapshot.data!.docs[index]['rating'],
                      musicTitle: snapshot.data!.docs[index]['title'],
                      artist: snapshot.data!.docs[index]['artist'],
                    ),
                  ),
                );
              }
              return const Center(
                child: Text('No ratings found'),
              );
            },
          ),
        ),
      )
    ]);
  }
}

//Creates the main container for holding the user's reviews
//Located on these pages: user_reviews
class UserReviewList extends StatefulWidget {
  final String title, type;
  UserReviewList({required this.title, required this.type, super.key});

  @override
  State<UserReviewList> createState() => _UserReviewListState();
}

class _UserReviewListState extends State<UserReviewList> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          width: screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: purple,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('accounts')
                    .doc(DataBase().getUid())
                    .collection(widget.type)
                    .where('review', isNull: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: const Center(child: Text('No Data')),
                    );
                  }
                  return Column(
                    children: List.generate(
                      snapshot.data!.size,
                      (index) => TitleAndReview(
                        reviewText: snapshot.data!.docs[index]['review'],
                        trackTitle: snapshot.data!.docs[index]['title'],
                        artist: snapshot.data!.docs[index]['artist'],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

//Show the title of a song/album and a star rating
//Located on user_ratings
class TitleAndRating extends StatelessWidget {
  final double rating;
  final String musicTitle;
  final String artist;
  TitleAndRating(
      {required this.rating,
      required this.musicTitle,
      required this.artist,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: bbarGray,
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                musicTitle,
                style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: buttonRed,
                    fontSize: 18.0),
                maxLines: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: Text('by',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: purple,
                        )),
                  ),
                  Text(
                    artist,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                      color: purple,
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              const SizedBox(height: 5.0),
              RateBar(
                initRating: rating,
                ignoreChange: true,
                starSize: 20.0,
              ),
            ],
          ),
        )),
      ),
    );
  }
}

//Show the title of a song/album and a review
//Located on user_reviews
class TitleAndReview extends StatelessWidget {
  final String trackTitle;
  final String artist;
  final String reviewText;
  TitleAndReview(
      {required this.reviewText,
      required this.trackTitle,
      required this.artist,
      super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 8.0, right: 8.0),
              width: screenWidth,
              height: 100.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: bbarGray,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trackTitle,
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: buttonRed,
                            fontSize: 20.0),
                        maxLines: 3,
                      ),
                      Text(
                        artist,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                          color: purple,
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        reviewText,
                        style: const TextStyle(
                            fontSize: 18.0, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
