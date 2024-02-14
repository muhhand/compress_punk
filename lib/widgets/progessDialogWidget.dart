import 'package:compress_punk/constants.dart';
import 'package:compress_punk/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({super.key});

  @override
  State<ProgressDialogWidget> createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  late Subscription subscription;
  double? progress;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = VideoCompress.compressProgress$.subscribe((progress) {
      setState(() {
        this.progress = progress;
      });
    });
  }

  @override
  void dispose() {
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final value = progress == null ? progress : progress! / 100;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: mainColor,
        border: Border.all(color: Colors.black, width: 3),
      ),
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Compressing Video...',
              style: TextStyle(fontSize: 20, color: seconndaryColor),
            ),
            const SizedBox(
              height: 24,
            ),
            LinearProgressIndicator(
              backgroundColor: mainColor,
              valueColor: const AlwaysStoppedAnimation<Color?>(seconndaryColor),
              color: seconndaryColor,
              value: value,
              minHeight: 12,
            ),
            const SizedBox(
              height: 16,
            ),
            Button(
                title: 'Cancel',
                onPressed: () => VideoCompress.cancelCompression())
          ],
        ),
      ),
    );
  }
}
