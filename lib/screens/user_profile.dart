import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/search_page.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/cust_widgets.dart';
import 'package:jukeboxd/utils/users_ratings.dart';
import 'package:jukeboxd/screens/song_page.dart';

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
              Top5(),
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
