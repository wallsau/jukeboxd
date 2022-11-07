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
      backgroundColor: purple,
      appBar: AppBar(
        backgroundColor: Colors.purple,
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3279e2), Colors.purple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
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
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Return to Profile'),
                ),
                OutlinedButton(
                  onPressed: _clearHistory,
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Clear Search History'),
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

  Widget buildResultsSuccess(results) {
    final suggestArr = [query];
    _storeHistory(suggestArr);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3279e2), Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: ListView.builder(
          itemCount: results.length,
          itemBuilder: (context, index) {
            final result = results[index];

            return ListTile(
              leading: (result!.type.toString() != 'track')
                  ? img.Image.network(
                      result!.images![0].url.toString(),
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? strackTrace) {
                        return const Text('Error');
                      },
                    )
                  : img.Image.asset('images/jukeboxd.jpg'),
              title: Text(result!.name.toString()),
              subtitle: Text(result!.type.toString()),
              trailing: Text(result!.id.toString()),
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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3279e2), Colors.purple],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: StreamBuilder(
          stream: db.collection('accounts').doc(uid).snapshots(),
          builder: ((context, snapshot) {
            final containsSearch =
                snapshot.data?.data()?.containsKey('search history');
            if (containsSearch != true) {
              final defaultSearchHistory = ['Cher', 'Metallica', 'Drake'];
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
                  );
                }));
          })),
    );
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
