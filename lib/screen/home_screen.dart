import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mori/provider/movie_provider.dart';
import 'package:mori/screen/my_review.dart';
import 'package:mori/widgets/movie_list.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MovieProvider? _movieProvider;
  bool isLoading = false;

  // @override
  // void initState() {
  //   loading();
  //   super.initState();
  // }
  //
  // void loading() {
  //   setState(() {
  //     isLoading = true;
  //     Future.delayed(Duration(seconds: 1), () {
  //       print('delay 끝');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     });
  //     // isLoading = false;
  //   });
  // }

  Widget _popular() {
    return Container(
      height: 170,
      child: Consumer<MovieProvider>(
        builder: (
          context,
          provider,
          child,
        ) {
          if (provider.popularMV.isNotEmpty) {
            return MovieList(
              movies: provider.popularMV,
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _nowPlaying() {
    return Container(
      height: 170,
      child: Consumer<MovieProvider>(
        builder: (
          context,
          provider,
          child,
        ) {
          if (provider.nowPlayingMv.isNotEmpty) {
            return MovieList(
              movies: provider.nowPlayingMv,
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget titleAndList({required String title, required Widget widget}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(title),
          ),
          const SizedBox(height: 5),
          widget,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _movieProvider = Provider.of<MovieProvider>(context, listen: false);
    _movieProvider!.popularMovies();
    _movieProvider!.nowPlayingMovies();
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Mori',
                      style: GoogleFonts.lobster(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    titleAndList(title: '인기 영화 목록', widget: _popular()),
                    titleAndList(title: '현재 상영 영화', widget: _nowPlaying()),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          // MyReviewWidget(),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('내가 쓴 리뷰'),
                          ),
                          MyReview(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

// StreamBuilder(
//   stream: ReviewRepository().streamMyReview(),
//   builder: (context, snapshot) {
//     if (snapshot.connectionState ==
//         ConnectionState.waiting) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//     if (snapshot.connectionState ==
//         ConnectionState.active) {
//       if (snapshot.hasData) {
//         return SizedBox(
//           height: 80,
//           child: Column(
//             children: List.generate(
//                 (snapshot.data as dynamic).docs.length,
//                 (index) {
//               var movieId = (snapshot.data as dynamic)
//                   .docs[index]
//                   .data()['id'];
//               return FutureBuilder<MovieDetails>(
//                 future: MovieRepository()
//                     .getMovieDetails(id: movieId),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return const Text('에러가 있습니다');
//                   }
//                   if(!snapshot.hasData) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   return CircleAvatar(
//                     backgroundImage: NetworkImage(
//                       snapshot.data!.postUrl,
//                     ),
//                     radius: 50,
//                   );
//                 },
//               );
//             }
//
//                 // return Text((snapshot.data as dynamic)
//                 //     .docs[index]
//                 //     .data()['id']
//                 //     .toString());
//                 // },
//                 ),
//           ),
//         );
//       }
//       if (snapshot.hasError) {
//         const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//     }
//     return Container();
//   },
// ),
