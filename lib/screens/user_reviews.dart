import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/custom_widgets/user_page_widgets.dart';

class UserReviews extends StatelessWidget {
  UserReviews({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              UserReviewList(title: title, type: 'track'),
              UserReviewList(title: title, type: 'album')
            ],
          )),
        ));
  }
}
