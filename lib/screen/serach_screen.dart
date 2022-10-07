import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mori/models/movie.dart';
import 'package:mori/provider/user_provider.dart';
import 'package:mori/repository/movie_repository.dart';
import 'package:mori/screen/movie_details_screen.dart';
import 'package:mori/util/size_helper.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  UserProvider? _userProvider;
  final TextEditingController _searchController = TextEditingController();
  String? _searchKey;

  @override
  void dispose() {
    _searchController;
    super.dispose();
  }

  Widget searchList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: FutureBuilder<List<Movie>>(
              future: MovieRepository().searchMovies(
                _searchKey!,
              ),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    height: 50,
                    child: Center(
                      child: Text('검색결과가 없습니다.'),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Container();
                }
                final searchList = snapshot.data;
                return searchList!.isNotEmpty
                    ? SizedBox(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            print(searchList[index].poster_path);
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => MovieDetailsScreen(
                                        id: searchList[index].id)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 180,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        // color: Colors.blueAccent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black38,
                                            blurRadius: 2.0,
                                            offset: Offset(0, 0),
                                            spreadRadius: 3.0,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          searchList[index]
                                                  .poster_path
                                                  .isNotEmpty
                                              ? ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                  ),
                                                  child: Image.network(
                                                    searchList[index].postUrl,
                                                    fit: BoxFit.cover,
                                                    height: 210,
                                                  ),
                                                )
                                              : ClipRRect(
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(8.0),
                                                    bottomLeft:
                                                        Radius.circular(8.0),
                                                  ),
                                                  child: Container(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    child: Image.asset(
                                                      'assets/img/empty.png',
                                                      fit: BoxFit.cover,
                                                      width: 120,
                                                      height: 210,
                                                      // height: 220,
                                                    ),
                                                  ),
                                                ),
                                          eWidth(10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  searchList[index].title,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18.0),
                                                ),
                                                eHeight(5),
                                                searchList[index]
                                                        .release_date
                                                        .isNotEmpty
                                                    ? Text(
                                                        DateFormat('M월d일.y')
                                                            .format(
                                                          DateTime.parse(
                                                              searchList[index]
                                                                  .release_date),
                                                        ),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54),
                                                      )
                                                    : Container(),
                                                eHeight(20),
                                                Text(
                                                  searchList[index].overview,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    eHeight(15),
                                    Container(
                                      height: 2,
                                      color: Colors.white30,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TextField(
          cursorColor: Colors.white,
          controller: _searchController,
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _searchKey = '';
                  setState(() {});
                },
                child: Icon(
                  Icons.clear,
                  color: Colors.grey[500],
                )),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            contentPadding: const EdgeInsets.all(0),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[500],
            ),
            hintText: '제목으로 검색해보세요',
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
          onChanged: (value) {
            _searchKey = value;
            setState(() {});
            print(value);
          },
        ),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: _searchKey == null ? Container() : searchList(),
      ),
    );
  }
}
