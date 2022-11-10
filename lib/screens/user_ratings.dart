import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/custom_widgets/user_page_widgets.dart';

class UserRatings extends StatelessWidget {
  UserRatings({required this.title, required this.type, super.key});
  final String title, type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
          title,
          style: const TextStyle(fontSize: 30.0),
        )),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [UserList(title: title, type: type)],
          )),
        ));
  }
}
