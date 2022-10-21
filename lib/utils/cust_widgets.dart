import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/user_ratings.dart';
import 'package:jukeboxd/screens/user_reviews.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

//Widget for album and song covers
/*Will need to replace AssetImage later*/
//Located on these pages: song, album
class CoverImage extends StatelessWidget {
  final AssetImage titleImage;
  const CoverImage({
    this.titleImage = const AssetImage("images/portrait_default.png"),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 150.0,
          height: 150.0,
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            image: DecorationImage(
              image: titleImage,
            ),
          ),
        ),
      ],
    );
  }
}

//Slimmer review function widget
//Located on these pages: song, album
class SlimReviewWidget extends StatelessWidget {
  const SlimReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: purple,
        ),
        child: Row(
          children: [
            const Padding(
                padding: EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 15.0),
                child: Icon(Icons.edit)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(2.0, 8.0, 8.0, 8.0),
                child: TextFormField(
                  cursorColor: purple,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: iconsGray,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: buttonRed,
                      ),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    labelText: "Your review",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.all(8.0),
                  ),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Alternative review function widget with a submit and delete (nonfunctional)
//Located on these pages: song, album
class BlockReviewWidget extends StatelessWidget {
  const BlockReviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: purple,
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: iconsGray,
                  ),
                  child: const TextField(
                    cursorColor: purple,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: "Your review",
                      labelStyle: TextStyle(color: purple),
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    style: TextStyle(fontSize: 20.0),
                    maxLines: 3,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: iconsGray,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Submit',
                        style: TextStyle(color: purple),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: buttonRed,
                    ),
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: bbarGray),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//Large version of comments on album or song pages
//Located on these pages: song, album
class ReviewComment extends StatelessWidget {
  final String title, artist, username;
  const ReviewComment({
    required this.title,
    required this.artist,
    required this.username,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150.0,
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: purple,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 150.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: iconsGray,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "$username said:\n1\n2\n3\n4\n5",
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: purple,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Condensed version of comments
//Located on these pages: song, album
class CondensedReviewComment extends StatelessWidget {
  final String username, text;
  final double rating;
  const CondensedReviewComment(
      {required this.username,
      required this.text,
      this.rating = 0.0,
      super.key});
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screenWidth,
        height: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: iconsGray,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$username said: $text",
                style: const TextStyle(fontSize: 18.0, color: purple)),
          ),
        ),
      ),
    );
  }
}

//Container to hold comments
//Located on these pages: song, album
class ReviewSection extends StatefulWidget {
  final int numComments;
  const ReviewSection({
    required this.numComments,
    Key? key,
  }) : super(key: key);

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: purple,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Community',
                style: TextStyle(
                    color: bbarGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            Column(
              children: List.generate(
                  widget.numComments,
                  (index) => CondensedReviewComment(
                        username: "username$index",
                        text: '\n1\n2\n3\n4\n5',
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

//Information block containing title, artist, average score, etc.
//Located on these pages: song, album
class InfoBlock extends StatefulWidget {
  final String title, artist;
  final double avgRating;
  const InfoBlock({
    required this.title,
    required this.artist,
    this.avgRating = 0.0,
    super.key,
  });

  @override
  State<InfoBlock> createState() => _InfoBlockState();
}

class _InfoBlockState extends State<InfoBlock> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 150.0,
        width: screenWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: purple,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: iconsGray,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                    "${widget.title} by ${widget.artist}\nCommunity score: ${widget.avgRating}",
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: purple,
                    ),
                    textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//Interactable flutter_rating_bar plug-in
//Located on these pages: song, album
class RateBar extends StatefulWidget {
  const RateBar({
    required this.initRating,
    required this.ignoreChange,
    required this.starSize,
    super.key,
  });
  final double initRating;
  final bool ignoreChange;
  final double starSize;

  @override
  State<RateBar> createState() => _RateBarState();
}

class _RateBarState extends State<RateBar> {
  double? _ratingValue;
  @override
  Widget build(BuildContext context) {
    return RatingBar(
        initialRating: widget.initRating,
        ignoreGestures: widget.ignoreChange,
        itemSize: widget.starSize,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        glow: false,
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: buttonRed),
          half: const Icon(Icons.star_half, color: buttonRed),
          empty: const Icon(Icons.star_outline, color: buttonRed),
        ),
        onRatingUpdate: (value) {
          setState(() {
            _ratingValue = value;
          });
        });
  }
}

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
