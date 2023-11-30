import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:prep_final/models/anime.dart';
import 'package:prep_final/services/anime_service.dart';
import 'package:prep_final/databases/anime_repository.dart';

class AnimeList extends StatefulWidget {
  const AnimeList({Key? key}) : super(key: key);

  @override
  State<AnimeList> createState() => _AnimeListState();
}

class _AnimeListState extends State<AnimeList> {
  AnimeService? _animeService;
  final _pageSize = 25;

  final PagingController<int, Anime> _pagingController =
      PagingController(firstPageKey: 0);

  Future _fetchPage(int pageKey) async {
    try {
      print("Fetching page: $pageKey");
      final animes = await _animeService?.getAll(pageKey, _pageSize) ?? [];
      final isLastPage = animes.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(animes);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(animes, nextPageKey);
      }
    } catch (error) {
      print("Error fetching page: $error");
      _pagingController.error = error;
    }
  }

  @override
  void initState() {
    _animeService = AnimeService();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Anime>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Anime>(
        itemBuilder: (context, item, index) => AnimeItem(
          anime: item,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}

class AnimeItem extends StatefulWidget {
  const AnimeItem({Key? key, required this.anime}) : super(key: key);
  final Anime? anime;

  @override
  State<AnimeItem> createState() => _AnimeItemState();
}

class _AnimeItemState extends State<AnimeItem> {
  bool isFavorite = false;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    isFavorite = await AnimeRepository().isFavorite(widget.anime!);

    if (mounted) {
      setState(() {
        isFavorite = isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final icon =
        Icon(Icons.favorite, color: isFavorite ? Colors.red : Colors.grey);

    return GestureDetector(
      child: Card(
        child: ListTile(
          title: Text(widget.anime!.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Id: ${widget.anime!.malId}"),
              Text("Episodes: ${widget.anime!.episodes}"),
              Text("Year: ${widget.anime!.year.toString()}"),
              Text("Members: ${widget.anime!.members}"),
            ],
          ),
          leading: Image.network(widget.anime!.imageUrl),
          trailing: IconButton(
            icon: icon,
            onPressed: () async {
              if (isFavorite) {
                await AnimeRepository().delete(widget.anime!);
              } else {
                await AnimeRepository().insert(widget.anime!);
              }
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ),
      ),
    );

    // return Card(
    //   child: ListTile(
    //     title: Text(widget.anime!.title),
    //     subtitle: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text("Id: ${widget.anime!.malId}"),
    //         Text("Episodes: ${widget.anime!.episodes}"),
    //         Text("Year: ${widget.anime!.year.toString()}"),
    //         Text("Members: ${widget.anime!.members}"),
    //       ],
    //     ),
    //     leading: Image.network(widget.anime!.imageUrl),
    //   ),
    // );
  }
}
