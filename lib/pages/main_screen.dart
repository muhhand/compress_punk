import 'dart:io';
import 'dart:typed_data';
import 'package:compress_punk/constants.dart';
import 'package:compress_punk/controller/controller.dart';
import 'package:compress_punk/widgets/choicechip.dart';
import 'package:compress_punk/widgets/progessDialogWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

import 'package:video_compress/video_compress.dart';

import '../widgets/button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File? fileVideo;
  Uint8List? uint8list;
  int? videoSize;
  MediaInfo? compressedVideoInfo;
  bool lowquality = true;
  bool mediumquality = false;
  bool highquality = false;
  VideoQuality? Thequality = VideoQuality.LowQuality;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            fileVideo == null
                ? Column(
                    children: [
                      const Text(
                        'Compress Punk',
                        style: TextStyle(
                            color: seconndaryColor,
                            fontFamily: 'Cyperbunk',
                            fontSize: 52),
                      ),
                      Container(
                        color: seconndaryColor,
                        height: 2,
                        width: 100,
                      ),
                      const SizedBox(
                        height: 200,
                      ),
                      const Text(
                        'A Tool To Help You Compress Your Video.',
                        style: TextStyle(
                            color: seconndaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Text(
                        'Please Don\'t Use The App With Small Videos.',
                        style: TextStyle(color: seconndaryColor, fontSize: 11),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Center(
                          child: Button(
                        onPressed: pickVideo,
                        title: 'Pick Video',
                      )),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        uint8list == null
                            ? const CircularProgressIndicator()
                            : Container(
                                width: double.infinity,
                                color: seconndaryColor,
                                child: Image.memory(
                                  uint8list!,
                                  height: 300,
                                ),
                              ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          'Size: ${videoSize! / 1000} KB',
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Container(
                          color: seconndaryColor,
                          height: 2,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        compressedVideoInfo == null
                            ? Container(
                                child: const Text(
                                  'Please Select The Quality Of The Video:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : Container(),
                        const SizedBox(
                          height: 18,
                        ),
                        compressedVideoInfo == null
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ChoiceChipWidget(
                                      title: 'Low',
                                      selected: lowquality,
                                      onSelected: (newBoolValue) {
                                        setState(() {
                                          Thequality = VideoQuality.LowQuality;
                                          lowquality = newBoolValue;
                                          mediumquality = false;
                                          highquality = false;
                                        });
                                      }),
                                  ChoiceChipWidget(
                                      title: 'Medium',
                                      selected: mediumquality,
                                      onSelected: (newBoolValue) {
                                        setState(() {
                                          Thequality =
                                              VideoQuality.MediumQuality;
                                          mediumquality = newBoolValue;
                                          lowquality = false;
                                          highquality = false;
                                        });
                                      }),
                                  ChoiceChipWidget(
                                      title: 'High',
                                      selected: highquality,
                                      onSelected: (newBoolValue) {
                                        setState(() {
                                          Thequality =
                                              VideoQuality.HighestQuality;
                                          highquality = newBoolValue;
                                          lowquality = false;
                                          mediumquality = false;
                                        });
                                      }),
                                ],
                              )
                            : Container(),
                        const SizedBox(
                          height: 18,
                        ),
                        Center(
                          child: compressedVideoInfo == null
                              ? Button(
                                  onPressed: () {
                                    compressVideo(fileVideo!, Thequality!);
                                  },
                                  title: 'Compress Video',
                                )
                              : Column(
                                  children: [
                                    const Text(
                                      "New Video Info:",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        "Size : ${compressedVideoInfo!.filesize! / 1000} KB",
                                        style: const TextStyle(fontSize: 20)),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "${compressedVideoInfo!.path}",
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Button(title: 'Clear', onPressed: Clear),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Button(
                                      onPressed: () async {
                                        await shareFile(
                                            compressedVideoInfo!.path!);
                                      },
                                      title: 'Share',
                                    )
                                  ],
                                ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Future pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) return;
    final file = File(pickedFile.path);
    setState(() {
      fileVideo = file;
    });
    generateThumbnail(fileVideo!);
    getVideoSize(fileVideo!);
  }

  Future generateThumbnail(File file) async {
    final thumbnailFile = await VideoCompress.getByteThumbnail(file.path);
    setState(() {
      uint8list = thumbnailFile;
    });
  }

  Future compressVideo(File file, VideoQuality quality) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: ProgressDialogWidget(),
      ),
    );
    final info = await VideoCompressorApi.compressVideo(fileVideo!, quality);
    setState(() {
      compressedVideoInfo = info;
    });
    Navigator.of(context).pop();
  }

  Future getVideoSize(File file) async {
    final size = await file.length();
    setState(() {
      videoSize = size;
      print(size.toString());
    });
  }

  void Clear() {
    setState(() {
      fileVideo = null;
      uint8list = null;
      videoSize = null;
      compressedVideoInfo = null;
    });
  }

  Future<void> shareFile(String videoPath) async {
    await Share.shareXFiles([XFile(videoPath)]);
  }
}
