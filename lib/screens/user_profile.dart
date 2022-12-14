import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/login_page.dart';
import 'package:jukeboxd/screens/search_page.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/custom_widgets/user_page_widgets.dart';

import '../services/firebase.dart';

//UserProfile screen contributed by Angie Ly
class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final uid = DataBase().getUid();
  String username = 'Placeholder';
  Future _getUsername() async {
    await FirebaseFirestore.instance
        .collection('accounts')
        .doc(DataBase().getUid())
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          username = snapshot.data()!['email'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

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
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              /*Widgets to build out the profile*/
              UserHeader(username: username),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('accounts')
                    .doc((FirebaseAuth.instance.currentUser != null)
                        ? uid
                        : '1BwBzTdDz1uy1n40j31q')
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
              const ProfileMenu(
                  toAlbumRatings: "MY RATED ALBUMS",
                  toSongRatings: "MY RATED SONGS",
                  toReviews: "MY REVIEWS"),
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: ((context) => LoginPage()),
                      ),
                    );
                  });
                },
                child: const Text('Sign Out'),
              ),
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
