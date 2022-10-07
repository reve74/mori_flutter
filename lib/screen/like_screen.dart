import 'package:flutter/material.dart';
import 'package:mori/models/movie_details.dart';
import 'package:mori/provider/user_provider.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:mori/util/const.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/widgets/like_message_popup.dart';
import 'package:mori/widgets/skeleton.dart';
import 'package:provider/provider.dart';
import 'package:mori/models/user.dart' as model;

class LikeScreen extends StatefulWidget {
  LikeScreen({Key? key}) : super(key: key);

  @override
  State<LikeScreen> createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  UserProvider? _userProvider;
  List likesList = [];
  bool isLoading = false;
  // Future<Map<List , List<MovieDetails>>> fetchData() async{

  // Future<void> fetchData() async {
  //   List<Future> futures = [];
  //
  //   for (String id in likesList) {
  //     futures.add(
  //       MovieRepository().getMovieList(id: id.toString()),
  //     );
  //   }
  //   final results = await Future.wait(futures);
  //   // print(results);
  // }

  Widget myLikesCard({
    required String image,
    required String title,
    required String runtime,
    required String releaseDate,
    required BuildContext context,
    required int id,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                image.isNotEmpty
                    ? Image.network(
                        Poster + image,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width / 3.1,
                        height: 70,
                      )
                    : Container(
                        color: Colors.white.withOpacity(0.9),
                        child: Image.asset(
                          'assets/img/empty.png',
                          width: MediaQuery.of(context).size.width / 3.1,
                          height: 70,
                        ),
                      ),
                eWidth(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('$runtime 분'),
                      Text(releaseDate),
                    ],
                  ),
                ),
              ],
            ),
            eHeight(5),
            // Container(
            //   height: 2,
            //   color: Colors.white30,
            // ),
          ],
        ),
      ),
    );
  }

  Widget myLikes() {
    return Column(
      children: [
        ...likesList.map(
          (e) => FutureBuilder<MovieDetails>(
            future: MovieRepository().getMovieDetails(id: int.parse(e)),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('에러가 있습니다'));
              }
              if (!snapshot.hasData) {
                return LikeSkeleton(context: context);
              }
              MovieDetails md = snapshot.data!;
              return GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) =>
                          LikeMessagePopup(title: md.title, id: md.id));
                },
                child: myLikesCard(
                  title: md.title,
                  image: md.backdrop_path,
                  runtime: md.runtime.toString(),
                  releaseDate: md.release_date,
                  context: context,
                  id: md.id,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget emptyLikes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        eHeight(50),
        const Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              '아직 찜한 콘텐츠가 없습니다',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        const Text(
          '관심있는 콘텐츠를 찜해주세요!',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider!.initialize();

    return Scaffold(
      appBar: AppBar(
        title: const Text('찜한 콘텐츠'),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<model.User>(
                stream: _userProvider!.currentUser,
                builder: (context, AsyncSnapshot<model.User> snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasError) {
                      const Center(child: Text('에러가 있습니다'));
                    }
                    if (snapshot.hasData) {
                      model.User user = snapshot.data!;
                      likesList = user.likes!;
                      // fetchData();
                      // final aa =
                      //     MovieRepository().getMovieList(movieIdList: likesList);
                      // print(aa.length);
                      return likesList.isNotEmpty ? myLikes() : emptyLikes();
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
