import 'package:drop_shadow_image/drop_shadow_image.dart';
import 'package:flutter/material.dart';
import 'package:mori/screen/poster_screen.dart';

class DetailsAppBar extends StatelessWidget {
  final String title;
  final String poster_Path;
  final bool isExpanded;
  const DetailsAppBar({
    required this.title,
    required this.poster_Path,
    required this.isExpanded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: isExpanded ? null : Text(title),
      centerTitle: true,
      pinned: true,
      expandedHeight: MediaQuery.of(context).size.height * 0.65,
      // backgroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white.withOpacity(0.9),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      PosterScreen(title: title, poster_Path: poster_Path)));
            },
            child: DropShadowImage(
              offset: Offset(10, 10),
              scale: 1,
              blurRadius: 20,
              // borderRadius: 20,

              image: poster_Path.isNotEmpty
                  ? Image.network(
                      poster_Path,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    )
                  : Image.asset(
                      'assets/img/empty.png',
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
