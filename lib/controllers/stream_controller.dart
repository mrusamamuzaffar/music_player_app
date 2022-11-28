import 'dart:io';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:music_player_getx_mvc/models/stream.dart';
import 'package:permission_handler/permission_handler.dart';

class StreamController extends GetxController {
  RxList<Stream> streams = <Stream>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchStreams();
  }

  void fetchStreams() async {
    List<Stream> serverResponse = [];
    List<FileSystemEntity> songs = [];
    PermissionStatus permissionStatus = await Permission.storage.request();
    if(permissionStatus.isGranted) {
      List<FileSystemEntity> files = Directory('/storage/emulated/0/').listSync(recursive: true, followLinks: false);
      for(FileSystemEntity entity in files) {
        if(entity.path.endsWith('.mp3')) {
          songs.add(entity);
          Metadata metadata = await MetadataRetriever.fromFile(File(entity.path));
          serverResponse.add(
            Stream(
              musicPath: metadata.filePath,
              picture: metadata.albumArt,
              title: metadata.trackName,
              long: metadata.trackDuration.toString(),
            ),
          );
        }
      }
    }

    streams.value = serverResponse;
  }
}
