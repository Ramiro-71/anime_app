import 'package:flutter/material.dart';
import 'package:prep_final/models/anime.dart';
import 'package:prep_final/databases/anime_repository.dart';

class FavoriteList extends StatefulWidget {
  const FavoriteList({Key? key}) : super(key: key);

  @override
  State<FavoriteList> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteList> {
  AnimeRepository? _animeRepository;
  List<Anime>? _animes;

  initialize() async {
    _animes = await _animeRepository?.getAll() ?? [];
    setState(() {
      _animes = _animes;
    });
  }

  @override
  void initState() {
    _animeRepository = AnimeRepository();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite List"),
      ),
      body: ListView.builder(
        itemCount: _animes?.length ?? 0,
        itemBuilder: ((context, index) {
          return Card(
              child: ListTile(
                title: Text(_animes?[index].title ?? ""),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Year: ${_animes?[index].year}"),
                    Text("Members: ${_animes?[index].members}"),
                    Text("Episodes: ${_animes?[index].episodes}"),
                  ],
                ),
                leading: Image.network(_animes?[index].imageUrl ?? ""),
              )
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSumDialog(context);
        },
        child: const Icon(Icons.calculate),
      ),
    );
  }

  void _showSumDialog(BuildContext context) {
    int totalMembers = 0;
    int totalEpisodes = 0;

    if (_animes != null) {
      for (Anime anime in _animes!) {
        totalMembers += anime.members;
        totalEpisodes += anime.episodes;
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Sum of Members and Episodes"),
          content: Column(
            children: [
              Text("Total Members: $totalMembers"),
              Text("Total Episodes: $totalEpisodes"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
