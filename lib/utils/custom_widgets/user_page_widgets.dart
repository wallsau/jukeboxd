/* Widgets associated with user_profile, user_ratings, and user_reviews */
import 'dart:async';
import 'package:jukeboxd/services/firebase.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/user_ratings.dart';
import 'package:jukeboxd/screens/user_reviews.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/custom_widgets/rating_widget.dart';

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
          "@$username",
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
    this.pic1 = const AssetImage("images/portrait_default.png"),
    this.pic2 = const AssetImage("images/portrait_default.png"),
    this.pic3 = const AssetImage("images/portrait_default.png"),
    this.pic4 = const AssetImage("images/portrait_default.png"),
    this.pic5 = const AssetImage("images/portrait_default.png"),
    super.key,
  });
  AssetImage? pic1;
  AssetImage? pic2;
  AssetImage? pic3;
  AssetImage? pic4;
  AssetImage? pic5;

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
                "My Top 5",
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
              Expanded(
                child: Image(
                  image: widget.pic1 as ImageProvider,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Expanded(
                child: Image(
                  image: widget.pic2 as ImageProvider,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Expanded(
                child: Image(
                  image: widget.pic3 as ImageProvider,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Expanded(
                child: Image(
                  image: widget.pic4 as ImageProvider,
                  width: 50.0,
                  height: 50.0,
                ),
              ),
              Expanded(
                child: Image(
                  image: widget.pic5 as ImageProvider,
                  width: 50.0,
                  height: 50.0,
                ),
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
  final int numRatings;
  final String title;
  UserList({required this.numRatings, required this.title, super.key});

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
          child: Column(
            children: List.generate(
              widget.numRatings,
              (index) => TitleAndRating(
                rating: index % 5,
                artist: index.toString(),
              ),
            ),
          ),
        ),
      )
    ]);
  }
}

//Creates the main container for holding the user's reviews
//Located on these pages: user_reviews
class UserReviewList extends StatefulWidget {
  final int numRatings;
  final String title;
  UserReviewList({required this.numRatings, required this.title, super.key});

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
            children: List.generate(
              widget.numRatings,
              (index) => TitleAndReview(
                reviewText: '$index My Review',
                artist: index.toString(),
              ),
            ),
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
  final String trackTitle;
  final String artist;
  TitleAndRating(
      {required this.rating,
      this.trackTitle = 'Untitled',
      this.artist = 'Unknown',
      super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 20.0),
            width: 0.55 * screenWidth,
            height: 40.0,
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
                    Row(
                      children: [
                        Text(
                          trackTitle,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              color: buttonRed,
                              fontSize: 17.0),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text('by',
                              style: TextStyle(
                                fontSize: 17.0,
                                color: purple,
                              )),
                        ),
                        Text(
                          artist,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
                            color: purple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: RateBar(
              initRating: rating,
              ignoreChange: true,
              starSize: 20.0,
            ),
          ),
        ],
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
      this.trackTitle = 'Untitled',
      this.artist = 'Unknown',
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
              height: 70.0,
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
                      Row(
                        children: [
                          Text(
                            trackTitle,
                            style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                color: buttonRed,
                                fontSize: 17.0),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text('by',
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: purple,
                                )),
                          ),
                          Text(
                            artist,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: purple,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        reviewText,
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.black),
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
