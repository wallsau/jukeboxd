import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/artist_page.dart';
import 'package:jukeboxd/screens/song_page.dart';
import 'package:jukeboxd/screens/user_profile.dart';
import '../services/firebase.dart';
import '../services/remote_services.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'dart:async';
import 'package:jukeboxd/utils/colors.dart';
import 'album_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  _clearHistory() {
    final db = FirebaseFirestore.instance;
    final uid = DataBase().getUid();
    final docRef = db.collection('accounts').doc(uid);
    final deletion = {'search history': FieldValue.delete()};
    docRef.update(deletion);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bgGray,
      appBar: AppBar(
        backgroundColor: purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          )
        ],
      ),
      body: Container(
        width: screenWidth,
        child: Column(
          children: [
            const Expanded(
              child: Text(
                'Search for your favorite artists, songs, or albums by pressing the search icon in the top right corner of your screen',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserProfile()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: purple,
                  ),
                  child: const Text(
                    'Return to Profile',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                OutlinedButton(
                  onPressed: _clearHistory,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: purple,
                  ),
                  child: const Text(
                    'Clear Search History',
                    style: TextStyle(color: Colors.white),
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

class CustomSearchDelegate extends SearchDelegate {
  final db = FirebaseFirestore.instance;
  final uid = DataBase().getUid();

  // first overwrite to
  // clear the search text
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  // second overwrite to pop out of search menu
  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  // third overwrite to show query result
  @override
  Widget buildResults(BuildContext context) {
    return Container(
      color: Colors.black,
      child: FutureBuilder<List<dynamic>?>(
          future: RemoteService().search(query, 3),
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoMatches();

            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return buildNoMatches();
                } else {
                  return buildResultsSuccess(snapshot.data);
                }
            }
          }),
    );
  }

  Widget buildNoMatches() => const Center(
        child: Text(
          'No Matches',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );

  Widget buildResultsSuccess(List<dynamic>? results) {
    String imageUrl = '';
    final suggestArr = [query];
    _storeHistory(suggestArr);
    return Container(
      color: bgGray,
      child: ListView.builder(
          itemCount: results!.length,
          itemBuilder: (context, index) {
            final result = results[index];
            if (result.type.toString() != 'track') {
              if (result.images.isNotEmpty) {
                imageUrl = result.images[0].url.toString();
                print(imageUrl + result.name.toString() + result.id.toString());
              } else {
                imageUrl = 'https://via.placeholder.com/150';
              }
            }
            return ListTile(
              leading: (result!.type.toString() != 'track' && imageUrl != '')
                  ? FadeInImage.assetNetwork(
                      placeholder: 'images/jukeboxd.jpg',
                      image: imageUrl,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return img.Image.asset('images/Jukeboxd.jpg');
                      },
                    )
                  : img.Image.asset('images/jukeboxd.jpg'),
              title: Text(
                result!.name.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontStyle: FontStyle.italic,
                ),
              ),
              subtitle: Text(
                //result!.id.toString(),
                result!.type.toString(),
                style: TextStyle(color: bbarGray),
              ),
              //trailing: Text(result!.type.toString()),
              trailing: (result!.type.toString().toLowerCase() == 'artist')
                  ? Icon(
                      Icons.person,
                      color: Colors.white,
                    )
                  : (result!.type.toString().toLowerCase() == 'album')
                      ? Icon(
                          Icons.album,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.music_note,
                          color: Colors.white,
                        ),
              onTap: () {
                switch (result!.type.toString().toLowerCase()) {
                  case 'artist':
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ArtistPage(artistId: result!.id.toString())),
                      );
                    }
                    break;
                  case 'album':
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AlbumPage(albumId: result!.id.toString())),
                      );
                    }
                    break;
                  case 'track':
                    {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SongPage(trackId: result!.id.toString())),
                      );
                    }
                    break;
                }
              },
            );
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder(
        stream: db.collection('accounts').doc(uid).snapshots(),
        builder: ((context, snapshot) {
          final containsSearch =
              snapshot.data?.data()?.containsKey('search history');
          if (containsSearch != true) {
            final defaultSearchHistory = [
              'The Beatles',
              'Michael Jackson',
              'Stevie Wonder',
              'The Rolling Stones',
              'James Brown',
              'Led Zeppelin',
              'Bob Dylan',
              'Jimi Hendrix',
              'Prince',
              'Bob Marley'
            ];
            final List suggestions = defaultSearchHistory.where((element) {
              return element.toLowerCase().contains(
                    query.toLowerCase(),
                  );
            }).toList();
            return ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    title: Text(suggestions[index]),
                    onTap: () {
                      query = suggestions[index];
                    },
                    textColor: Colors.white,
                  );
                }));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          final List searchHistory = snapshot.data!.get('search history');
          final List suggestions = searchHistory.where((element) {
            return element.toLowerCase().contains(
                  query.toLowerCase(),
                );
          }).toList();
          return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  title: Text(suggestions[index]),
                  onTap: () {
                    query = suggestions[index];
                  },
                  textColor: Colors.white,
                );
              }));
        }));
  }

  Future _storeHistory(searchTerm) async {
    final searchMap = {'search history': FieldValue.arrayUnion(searchTerm)};
    final docRef = db.collection('accounts').doc(uid);
    docRef.set(searchMap, SetOptions(merge: true));
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
