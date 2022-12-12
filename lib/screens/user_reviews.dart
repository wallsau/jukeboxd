import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/custom_widgets/user_page_widgets.dart';

//User review screen contributed by Angie Ly
class UserReviews extends StatelessWidget {
  UserReviews({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(title, style: const TextStyle(fontSize: 30.0))),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              UserReviewList(title: 'Albums', type: 'album'),
              UserReviewList(title: 'Songs', type: 'track')
            ],
          )),
        ));
  }
}
