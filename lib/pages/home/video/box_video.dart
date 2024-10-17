import 'package:flutter/material.dart';
import 'package:car_app/constants/app_color.dart';
import 'package:car_app/pages/home/video/play_video.dart';

class BoxVideo extends StatelessWidget {
  const BoxVideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColor.gradientFirst.withOpacity(0.8),
            AppColor.gradientSecond.withOpacity(0.9)
          ], begin: Alignment.bottomLeft, end: Alignment.centerRight),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
              topRight: Radius.circular(80)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(5, 10),
                blurRadius: 20,
                color: AppColor.gradientSecond.withOpacity(0.2))
          ]),
      child: Container(
        padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Things To Do When ",
              style: TextStyle(
                fontSize: 16,
                color: AppColor.homePageContainerTextSmall,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "When Calling For Help",
              style: TextStyle(
                fontSize: 25,
                color: AppColor.homePageContainerTextSmall,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              "24/7 Rescue",
              style: TextStyle(
                fontSize: 25,
                color: AppColor.homePageContainerTextSmall,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.timer,
                      size: 20,
                      color: AppColor.homePageContainerTextSmall,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "60min",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColor.homePageContainerTextSmall,
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                            color: AppColor.gradientFirst,
                            blurRadius: 10,
                            offset: const Offset(4, 8))
                      ]),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const YouTubeVideoPlayer(
                            videoId: '1IptHpaZXig',
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 60,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
