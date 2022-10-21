import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/cust_widgets.dart';

class UserRatings extends StatelessWidget {
  UserRatings({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [UserList(numRatings: 20, title: title)],
          )),
        ));
  }
}