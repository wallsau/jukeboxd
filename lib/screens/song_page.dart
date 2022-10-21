import 'package:flutter/material.dart';
import 'package:jukeboxd/utils/colors.dart';
import 'package:jukeboxd/utils/cust_widgets.dart';

class SongPage extends StatefulWidget {
  const SongPage({
    required this.trackId,
    super.key,
  });
  final String trackId;

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('placeholder')),
      body: GestureDetector(
        onTap: () {
          //here
          FocusScope.of(context).unfocus();
          TextEditingController().clear();
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(children: [
              CoverImage(),
              RateBar(
                initRating: 0.0,
                ignoreChange: false,
                starSize: 50.0,
              ),
              SlimReviewWidget(),
              //BlockReviewWidget(), //Alternate review widget; there will be only one review widget normally
              InfoBlock(
                title: 'placeholder',
                artist: 'placeholder',
                avgRating: 0,
              ),
              ReviewSection(numComments: 5),
            ]),
          ),
        ),
      ),
    );
  }
}
