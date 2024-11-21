library player_response;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../config/utils/constants.dart';

class PlayerResponse {
  final bool playable;
  final List<Audio> audioFormats;
  PlayerResponse({required this.playable, required this.audioFormats});
  static int retry = 0;

  static Future<PlayerResponse?> fetch(String videoId, {int option = 0}) async {
    final url = getUrl(option);
    final body = getBody(option);
    body['videoId'] = videoId;
    try {
      final response = (await Dio().post(url,
          options: Options(
            headers: headers,
          ),
          data: body));
      if (response.statusCode == 200) {
        final playable = response.data["playabilityStatus"]["status"] == "OK";

        //if playable then return the response
        if (playable) {
          retry = 0;
          return PlayerResponse.fromJson(response.data);
        }

        //if not playable and not retried yet then retry once
        if (!playable && retry == 0) {
          retry++;
          return fetch(videoId, option: (option + 1) % 2);
        } else {
          retry = 0;
          return PlayerResponse(playable: false, audioFormats: []);
        }
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode || kProfileMode) {
        print(e);
      }
      return null;
    }
  }

  factory PlayerResponse.fromJson(json) {
    final availableAudioFormats =
        (json["streamingData"]["adaptiveFormats"] as List)
            .where((item) => item['mimeType'].contains("audio"));
    return PlayerResponse(
        playable: true,
        audioFormats:
            availableAudioFormats.map((item) => Audio.fromJson(item)).toList());
  }

  Audio get highestBitrateAudio => sortByBitrate[0];

  Audio get highestQualityAudio =>
      audioFormats.lastWhere((item) => item.itag == 251 || item.itag == 140);

  Audio get highestBitrateMp4aAudio =>
      audioFormats.lastWhere((item) => item.itag == 140 || item.itag == 139,
          orElse: () => highestBitrateOpusAudio);

  Audio get highestBitrateOpusAudio =>
      audioFormats.lastWhere((item) => item.itag == 251 || item.itag == 250,
          orElse: () => highestBitrateMp4aAudio);

  Audio get lowQualityAudio =>
      audioFormats.lastWhere((item) => item.itag == 249 || item.itag == 139);

  List<Audio> get sortByBitrate {
    final audioFormatsCopy = audioFormats.toList();
    audioFormatsCopy
        .sort((audio1, audio2) => audio1.bitrate.compareTo(audio2.bitrate));
    return audioFormatsCopy;
  }

  List<dynamic> get hmStreamingData {
    if (!playable) return [false, null, null];
    return [
      true,
      lowQualityAudio.toJson(),
      highestQualityAudio.toJson(),
    ];
  }
}

class Audio {
  final int itag;
  final Codec audioCodec;
  final int bitrate;
  final int duration;
  final int size;
  final double loudnessDb;
  final String url;
  Audio(
      {required this.itag,
      required this.audioCodec,
      required this.bitrate,
      required this.duration,
      required this.loudnessDb,
      required this.url,
      required this.size});

  factory Audio.fromJson(json) => Audio(
      audioCodec: (json["mimeType"] as String).contains("mp4a")
          ? Codec.mp4a
          : Codec.opus,
      itag: json['itag'],
      duration: int.tryParse(json["approxDurationMs"]) ?? 0,
      bitrate: json["bitrate"] ?? 0,
      loudnessDb: (json['loudnessDb'])?.toDouble() ?? 0.0,
      url: json['url'],
      size: int.tryParse(json["contentLength"]) ?? 0);

  Map<String, dynamic> toJson() => {
        "itag": itag,
        "audioCodec": audioCodec.toString(),
        "bitrate": bitrate,
        "loudnessDb": loudnessDb,
        "url": url,
        "approxDurationMs": duration,
        "size": size
      };
}

enum Codec { mp4a, opus }