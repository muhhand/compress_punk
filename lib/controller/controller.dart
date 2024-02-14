import 'dart:io';
import 'package:video_compress/video_compress.dart';

class VideoCompressorApi {
  static Future<MediaInfo?> compressVideo(
      File file, VideoQuality videoQuality) async {
    try {
      await VideoCompress.setLogLevel(0);
      return VideoCompress.compressVideo(
        file.path,
        quality: videoQuality,
        deleteOrigin: false,
        includeAudio: true,
      );
    } catch (e) {
      VideoCompress.cancelCompression();
    }
  }
}
