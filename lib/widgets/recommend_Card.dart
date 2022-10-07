import 'package:flutter/material.dart';
import 'package:mori/models/movie.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:mori/screen/movie_details_screen.dart';

class RecommendCard extends StatelessWidget {
  final String title;
  final String id;
  const RecommendCard({
    required this.title,
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<List<Movie>>(
          future: MovieRepository().recommendMovies(id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('에러가 있습니다'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final movieList = snapshot.data;
            return movieList!.isNotEmpty
                ? SizedBox(
                    height: 180,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: movieList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsScreen(id: movieList[index].id),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              width: 100,
                              child: Column(
                                children: [
                                  movieList[index].poster_path.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            movieList[index].postUrl,
                                            width: 100,
                                            height: 150,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Container(
                                          color: Colors.white.withOpacity(0.9),
                                          child: Image.asset(
                                            'assets/img/empty.png',
                                            width: 100,
                                            height: 150,
                                          ),
                                        ),
                                  Text(
                                    movieList[index].title,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('${title}의 기반으로 추천할 영화가 없습니다.'),
                        ],
                      ),
                    ),
                  );
          },
        ),
      ],
    );
  }
}
