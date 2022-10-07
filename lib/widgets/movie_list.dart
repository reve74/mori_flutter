import 'package:flutter/material.dart';
import 'package:mori/models/movie.dart';
import 'package:mori/screen/movie_details_screen.dart';

class MovieList extends StatelessWidget {
  // Movie? movie;
  List<Movie> movies;
  // List<int> id;

  MovieList({
    required this.movies,
    // required this.id,
    Key? key,
  }) : super(key: key);

  _makeMovieOne({required Movie movie, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MovieDetailsScreen(id: movie.id)));
      },
      child: movie.poster_path.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                movie.postUrl,
                fit: BoxFit.cover,
                // width: 110,
              ),
            )
          : Container(
              color: Colors.white,
              height: 150,
              child: Column(
                children: [
                  Container(
                    color: Colors.white.withOpacity(0.9),
                    child: Image.asset(
                      'assets/img/empty.png',
                      // width: 100,
                      // height: 150,
                    ),
                  ),
                  Container(
                    child: Text(movie.title),
                  ),
                ],
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: ListView.builder(
        // physics: NeverScrollableScrollPhysics()
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              // height: 50,
              child: _makeMovieOne(
                movie: movies[index],
                context: context,
              ),
            ),
          );
        },
      ),
    );
  }
}
