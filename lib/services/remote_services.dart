import 'package:spotify/spotify.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RemoteService {
  final credentials = SpotifyApiCredentials(
      dotenv.env['CLIENT_ID'], dotenv.env['CLIENT_SECRET']);

  Future<Artist?> getArtist(String artistId) async {
    final spotify = SpotifyApi(credentials);
    final artist = await spotify.artists.get(artistId);
    return artist;
  }

  Future<Album?> getAlbum(String albumId) async {
    final spotify = SpotifyApi(credentials);
    final album = await spotify.albums.get(albumId);
    return album;
  }

  Future<Track?> getTrack(String trackId) async {
    final spotify = SpotifyApi(credentials);
    final track = await spotify.tracks.get(trackId);
    return track;
  }

  Future<List<Album>> getArtistAlbums(String artistId) async {
    List<String>? includeGroups = ['album', 'single'];
    final spotify = SpotifyApi(credentials);
    final artistAlbums =
        await spotify.artists.albums(artistId, includeGroups: includeGroups);
    var albumList = await artistAlbums.all();
    return albumList.toList();
  }

  Future<List<TrackSimple>?> getAlbumTracks(String albumId) async {
    List<TrackSimple> trackList = [];
    final spotify = SpotifyApi(credentials);
    final tracks = await spotify.albums.getTracks(albumId).all();
    for (var track in tracks) {
      trackList.add(track);
    }
    return trackList;
  }

  Future<List<dynamic>?> search(String searchQuery, int limit) async {
    List<dynamic> searchList = [];
    final spotify = SpotifyApi(credentials);
    var search = await spotify.search.get(searchQuery, types: [
      SearchType.artist,
      SearchType.album,
      SearchType.track
    ]).first(limit);
    for (var pages in search) {
      for (var item in pages.items!) {
        searchList.add(item);
      }
    }
    return searchList;
  }

  /*Future<List<TrackSimple>?> searchTrack(String searchQuery, int limit) async {
    List<TrackSimple> searchList = [];
    final spotify = SpotifyApi(credentials);
    var search = await spotify.search
        .get(searchQuery, types: [SearchType.track]).first(limit);
    for (var pages in search) {
      for (var item in pages.items!) {
        searchList.add(item);
      }
    }
    return searchList;
  }

  Future<List<AlbumSimple>?> searchAlbum(String searchQuery, int limit) async {
    List<AlbumSimple> searchList = [];
    final spotify = SpotifyApi(credentials);
    var search = await spotify.search
        .get(searchQuery, types: [SearchType.album]).first(limit);
    for (var pages in search) {
      for (var item in pages.items!) {
        searchList.add(item);
      }
    }
    return searchList;
  }*/
}
