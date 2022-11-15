/* Custom widgets used for result pages of these types: album, song, artist */
import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/album_page.dart';
import 'package:jukeboxd/screens/song_page.dart';
import 'package:jukeboxd/services/firebase.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/custom_widgets/rating_widget.dart';
import 'package:spotify/spotify.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//Artist or album picture
//Found on: artist_page, album_page
class CoverImage extends StatelessWidget {
  const CoverImage({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200.0,
          height: 200.0,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            image: DecorationImage(
              image: NetworkImage(imageUrl),
            ),
          ),
        ),
      ],
    );
  }
}

//Song picture,
/*Will need to replace AssetImage later*/
//Located on these pages: song
class SongImage extends StatelessWidget {
  final String imageUrl;
  const SongImage({
    required this.imageUrl,
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
              image: NetworkImage(imageUrl),
              //scale: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

//Collection of albums or songs. Requires a title and a list of albums/songs
//Found on: artist_page
class ArtistList extends StatelessWidget {
  ArtistList({required this.title, required this.musicCollection, super.key});
  final String title;
  final List musicCollection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: purple,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: iconsGray,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  itemCount: musicCollection.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text(
                        musicCollection.elementAt(index).name.toString(),
                        style: const TextStyle(
                          color: purple,
                        ),
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      onTap: () {
                        switch (
                            musicCollection!.elementAt(index).type.toString()) {
                          case 'album':
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AlbumPage(
                                    albumId: musicCollection
                                        .elementAt(index)
                                        .id
                                        .toString(),
                                  ),
                                ),
                              );
                            }
                            break;
                          case 'track':
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SongPage(
                                    trackId: musicCollection
                                        .elementAt(index)
                                        .id
                                        .toString(),
                                  ),
                                ),
                              );
                            }
                            break;
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Collection of songs for an album. Requires a title and a list of songs
//Found on: album_page
class AlbumList extends StatelessWidget {
  const AlbumList({required this.album, super.key});
  final Album album;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.0),
          color: purple,
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Songs in this album',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 250,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(40.0)),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: album.tracks?.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: SizedBox(
                          width: 200,
                          child: Text(
                              album.tracks!.elementAt(index).name.toString())),
                      trailing: Icon(Icons.keyboard_arrow_right_sharp),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongPage(
                              trackId:
                                  album.tracks!.elementAt(index).id.toString(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Review function widget with a submit and delete button (nonfunctional)
//Located on these pages: song_page, album_page
class BlockReviewWidget extends StatefulWidget {
  BlockReviewWidget(
      {required this.title,
      required this.artist,
      required this.id,
      required this.type,
      this.initReview,
      this.imageUrl = '',
      this.typeCollection,
      super.key});
  final String id;
  final String? type, initReview, title, artist, imageUrl, typeCollection;
  @override
  State<BlockReviewWidget> createState() => _BlockReviewWidgetState();
}

class _BlockReviewWidgetState extends State<BlockReviewWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initReview != null) {
      _controller.text = widget.initReview!;
    }
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
                  child: TextField(
                    controller: _controller,
                    cursorColor: purple,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: "Your review",
                      labelStyle: TextStyle(color: purple),
                      contentPadding: EdgeInsets.all(8.0),
                    ),
                    style: const TextStyle(fontSize: 20.0),
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
                      onPressed: () {
                        DataBase().setReview(
                            _controller.text,
                            widget.id,
                            widget.type,
                            widget.title,
                            widget.artist,
                            widget.imageUrl,
                            widget.typeCollection);
                      },
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
                      onPressed: () {
                        DataBase().deleteReview(
                            widget.id, widget.type, widget.typeCollection);
                      },
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

//Comment section widgets
//Container to hold comments which consist of a text and a score
//Located on these pages: song, album
class ReviewSection extends StatefulWidget {
  final Map comments;
  final Map? scores;
  ReviewSection({
    required this.comments,
    this.scores,
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 300.0,
              child: (widget.comments.isEmpty)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'No comments found.\nBe the first to review!',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemCount: widget.comments.length,
                      itemBuilder: (BuildContext context, int index) {
                        String key = widget.comments.keys.elementAt(index);
                        return ReviewComment(
                          userid: key,
                          text: widget.comments[key],
                          rating: widget.scores?[key] ?? 0.0,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//Review comments from other users
//Located on these pages: song, album
class ReviewComment extends StatefulWidget {
  final String userid, text;
  final double rating;
  const ReviewComment(
      {required this.userid,
      required this.text,
      required this.rating,
      super.key});

  @override
  State<ReviewComment> createState() => _ReviewCommentState();
}

class _ReviewCommentState extends State<ReviewComment> {
  String username = 'Default';
  Future _getUsername(String id) async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(id)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          String email = snapshot.data()!['email'];
          final emailsplit = email.split('@');
          username = emailsplit[0];
        });
      } else {
        username = widget.userid;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsername(widget.userid);
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("$username said: ${widget.text}",
                    style: const TextStyle(fontSize: 18.0, color: purple)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: RateBar(
                    initRating: widget.rating,
                    ignoreChange: true,
                    starSize: 15.0),
              )
            ],
          ),
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
