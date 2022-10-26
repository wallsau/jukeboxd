import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';
import 'package:jukeboxd/services/remote_services.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'package:spotify/src/models/_models.dart' as spotiyImg;
import 'dart:async';

class AlbumPage extends StatefulWidget {
  final String albumId;
  const AlbumPage({Key? key, required this.albumId}) : super(key: key);
  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  Album album = Album();
  var albumId = '0qWcLfCZ8wtcoOdX14oGNI';
  var imageUrl = '';

  void _getAlbum(albumId) {
    RemoteService().getAlbum(albumId).then((value) {
      setState(() {
        album = value!;
      });
    });
  }

  void _getImage(albumId) {
    RemoteService().getAlbum(albumId).then((value) {
      setState(() {
        imageUrl = value!.images!.first.url.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(album.name.toString()),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
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
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
              ]),
              Text("Community Rating"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue,
                  ),
                  child: Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: album.tracks?.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(
                              album.tracks!.elementAt(index).name.toString()),
                          trailing: Icon(Icons.star_border_outlined),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue,
                  ),
                  child: Row(
                    children: [
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 15.0),
                          child: Icon(Icons.edit)),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(2.0, 8.0, 8.0, 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.grey[50],
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                labelText: "Your rating",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: const EdgeInsets.all(8.0),
                              ),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[50],
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Your review",
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          style: TextStyle(fontSize: 20.0),
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
