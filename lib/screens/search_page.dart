import 'package:flutter/material.dart';
import 'package:jukeboxd/screens/artist_page.dart';
import 'package:jukeboxd/screens/song_page.dart';
import '../services/remote_services.dart';
import 'package:spotify/spotify.dart';
import 'package:flutter/src/widgets/image.dart' as img;
import 'dart:async';

import 'album_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        backgroundColor: Colors.black,
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
          children: const <Widget>[
            Center(child: Text('Select Search Type: ')),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
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
  Widget buildResults(BuildContext context) => Container(
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

  Widget buildNoMatches() => const Center(
        child: Text(
          'No Matches',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );

  Widget buildResultsSuccess(results) => Container(
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

  @override
  Widget buildSuggestions(BuildContext context) => SizedBox();

  /*@override
  Widget buildSuggestions(BuildContext context) => FutureBuilder<List<Artist>?>(
        future: RemoteService().searchArtist(query, 12),
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
        },
      );

  Widget buildSuggestionsSuccess(suggestions) => ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: ((context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          onTap: () {
            query = suggestion;

            showResults(context);
          },
          leading: img.Image.asset('images/jukeboxd.jpg'),
          title: Text(suggestion!.name.toString()),
          subtitle: Text(suggestion!.type.toString()),
        );
      }));*/
}

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }
}
