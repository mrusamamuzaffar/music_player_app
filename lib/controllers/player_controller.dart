import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:music_player_getx_mvc/controllers/stream_controller.dart';
import 'package:music_player_getx_mvc/models/stream.dart';

class PlayerController extends GetxController {
  final AudioPlayer _advancedPlayer = AudioPlayer();

  Rx<Duration> duration = const Duration(seconds: 0).obs;
  Rx<Duration> position = const Duration(seconds: 0).obs;
  final Rx<int> currentStreamIndex = 0.obs;
  final Rx<PlayerState> playState = PlayerState.stopped.obs;
  var streams = <Stream>[].obs;

  @override
  void onInit() {
    super.onInit();

    final streamController = Get.put(StreamController());
    streams = streamController.streams;

    _advancedPlayer.onDurationChanged.listen((d) => duration.value = d);
    _advancedPlayer.onPositionChanged.listen((p) => position.value = p);
    _advancedPlayer.onPlayerStateChanged.listen((PlayerState state) => playState.value = state);
    _advancedPlayer.onPlayerComplete.listen((event) => position.value = duration.value);
  }

  Future<void> smartPlay() async {
    if (playState.value == PlayerState.playing) {
      await pause();
    } else {
      await resume();
    }
  }

  Future<void> play() async {
    await stop();
    await resume();
  }

  Future<void> resume() async {
    await _advancedPlayer.play(DeviceFileSource(streams[currentStreamIndex.value].musicPath!));
  }

  Future<void> pause() async {
    await _advancedPlayer.pause();
  }

  Future<void> stop() async {
    await _advancedPlayer.stop();
  }

  Future<void> next() async {
    if (currentStreamIndex.value + 1 != streams.length) {
      currentStreamIndex.value++;
    }
    await play();
  }

  Future<void> back() async {
    if (currentStreamIndex.value - 1 != -1) currentStreamIndex.value--;
    await play();
  }

  set setPositionValue(double value) {
    _advancedPlayer.seek(Duration(seconds: value.toInt()));
  }
}
