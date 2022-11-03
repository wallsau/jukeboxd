import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/search_page.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/custom_widgets/user_page_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../services/firebase.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    //final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SearchPage()));
              });
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          //here
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              /*Widgets to build out the profile*/
              UserHeader(username: "MyUser"),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('accounts')
                    .doc(DataBase().getUid())
                    .collection('album')
                    .orderBy('rating')
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      child: const Center(
                        child: Text('No Data'),
                      ),
                    );
                  }
                  if (snapshot.data!.size < 5) {
                    return Top5(
                        pic1: 'https://via.placeholder.com/150',
                        pic2: 'https://via.placeholder.com/150',
                        pic3: 'https://via.placeholder.com/150',
                        pic4: 'https://via.placeholder.com/150',
                        pic5: 'https://via.placeholder.com/150');
                  }
                  return Top5(
                      pic1: snapshot.data!.docs[0]['imageUrl'],
                      pic2: snapshot.data!.docs[1]['imageUrl'],
                      pic3: snapshot.data!.docs[2]['imageUrl'],
                      pic4: snapshot.data!.docs[3]['imageUrl'],
                      pic5: snapshot.data!.docs[4]['imageUrl']);
                },
              ),
              //UserMenu(),
              ProfileMenu(
                  toAlbumRatings: "MY ALBUMS",
                  toSongRatings: "MY SONGS",
                  toReviews: "MY REVIEWS")
            ]),
          ),
        ),
      ),
    );
  }
}

class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
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
              onPressed: () {},
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
              onPressed: () {},
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
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
