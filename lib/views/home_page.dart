import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_player_getx_mvc/controllers/player_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:music_player_getx_mvc/extensions/duration_extensions.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final PlayerController playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xFF7AC9FF),
          title: const Center(
            child: Text(
              'Music Player',
              style: TextStyle(
                color: Color(0xFFFBFFFF),
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: 5.h,
            left: 16.sp,
            bottom: 10.sp,
            right: 16.sp,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Obx(
                  () => ListView.builder(
                    itemCount: playerController.streams.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.sp),
                        child: InkWell(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.sp),
                          ),
                          onTap: () async {
                            await playerController.stop();
                            playerController.currentStreamIndex.value = index;
                            await playerController.play();
                          },
                          child: Obx(
                            () => Container(
                              height: 52.sp,
                              decoration: BoxDecoration(
                                color: (playerController.currentStreamIndex.value == index)
                                    ? const Color(0xFF7AC9FF)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.sp),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 13.sp),
                                    child: SizedBox(
                                      height: 35.sp,
                                      width: 35.sp,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15.sp)),
                                        child: playerController.streams[index].picture != null ?
                                        Image.memory(
                                            playerController.streams[index].picture ?? Uint8List(0),
                                        ) :
                                        Container(
                                          color: const Color(0xFFB2D3DA),
                                          child: const Center(
                                            child: Text("404"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                playerController
                                                    .streams[index].title!,
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  overflow: TextOverflow.ellipsis,
                                                  color: (playerController.currentStreamIndex.value == index)
                                                      ? const Color(0xFFFBFFFF)
                                                      : const Color(0xFF7AC9FF),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Segoe UI",
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 15.sp),
                                              child: Text(
                                                Duration(
                                                  milliseconds: int.tryParse(
                                                      playerController.streams[index].long!.toString()
                                                  ) ?? 0,
                                                ).timeFormat,
                                                style: TextStyle(
                                                  fontSize: 13.sp,
                                                  color: (playerController.currentStreamIndex.value == index)
                                                      ? const Color(0xFFFBFFFF)
                                                      : const Color(0xFF7AC9FF),
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: "Segoe UI",
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Obx(
                () => Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 15.sp, left: 15.sp),
                      child: Row(
                        children: [
                          Text(
                            playerController.position.value.timeFormat,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xFF7AC9FF),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                                activeColor: const Color(0xFF7AC9FF),
                                value: playerController.position.value.inSeconds.toDouble(),
                                min: 0.0,
                                max: playerController.duration.value.inSeconds.toDouble() + 1.0,
                                onChanged: (double value) {
                                  playerController.setPositionValue = value;
                                }),
                          ),
                          Text(
                            playerController.duration.value.timeFormat,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: const Color(0xFF7AC9FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          right: 30.sp,
                          left: 30.sp,
                          top: 5.sp,
                          bottom: 5.sp),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await playerController.stop();
                              await playerController.back();
                            },
                            child: Icon(
                              Icons.skip_previous,
                              color: const Color(0xFF7AC9FF),
                              size: 35.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await playerController.smartPlay();
                            },
                            child: Icon(
                              (playerController.playState.value == PlayerState.playing)
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: const Color(0xFF7AC9FF),
                              size: 60.sp,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              await playerController.stop();
                              await playerController.next();
                            },
                            child: Icon(
                              Icons.skip_next,
                              color: const Color(0xFF7AC9FF),
                              size: 35.sp,),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'by Usama Muzaffar',
                      style: TextStyle(
                        color: Color(0xFF7AC9FF),
                      ),
                    ),
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
