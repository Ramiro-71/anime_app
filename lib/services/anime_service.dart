import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:prep_final/models/anime.dart';

class AnimeService {
  final baseUrl = "https://api.jikan.moe/v4/anime/";

  Future<List<Anime>?> getAll(int page, int size) async {
    http.Response response = await http.get(
        Uri.parse("$baseUrl?offset=${page * size}&limit=$size"));

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      log(response.body);
      final List maps = jsonResponse["data"];
      final animes = maps.map((e) => Anime.fromJson(e)).toList();
      print(animes);
      return animes;
    }
    print("Failed to load animes: ${response.statusCode}");
    return null;
  }

  Future<Anime> getById(String id) async {
    http.Response response = await http.get(Uri.parse("$baseUrl$id"));

    if (response.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(response.body);
      final anime = Anime.fromJson(jsonResponse);
      print(anime);
      return anime;
    }
    throw Exception('Failed to load anime');
  }
}