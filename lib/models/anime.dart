import 'dart:core';

class Anime {
  final int malId;
  final String title;
  final String imageUrl;
  final int year;
  final int episodes;
  final int members;

  Anime(
      {required this.malId,
      required this.title,
      required this.imageUrl,
      required this.year,
      required this.episodes,
      required this.members});

  Map<String, dynamic> toMap() {
    return {
      'id': malId,
      'title': title,
      'imageUrl': imageUrl,
      'year': year,
      'episodes': episodes,
      'members': members,
    };
  }

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      malId: json['mal_id'] ?? 0,
      title: json['title'] ?? '',
      imageUrl: json['images']['jpg']['image_url'] ?? '',
      year: json['year'] ?? 0,
      episodes: json['episodes'] ?? 0,
      members: json['members'] ?? 0,
    );
  }

  factory Anime.fromMap(Map<String, dynamic> map) {
    return Anime(
      malId: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      year: map['year'],
      episodes: map['episodes'],
      members: map['members'],
    );
  }
}
