import 'package:flutter/material.dart';
import 'package:mori/util/size_helper.dart';

class Skeleton extends StatelessWidget {
  final double? height, width;

  const Skeleton({
    this.height,
    this.width,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(16 / 2),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
    );
  }
}


class LikeSkeleton extends StatelessWidget {
  const LikeSkeleton({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: Row(
        children: [
          Skeleton(
            width: MediaQuery.of(context).size.width / 3.1,
            height: 70,
          ),
          eWidth(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Skeleton(width: 90,),
                eHeight(8),
                Skeleton(width: 40,),
                eHeight(8),
                Skeleton(width: 100,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

