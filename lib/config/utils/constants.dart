const instance = "https://pipedapi-libre.kavin.rocks";
const defaultPoster = "assets/images/default_poster.jpeg";
const defaultLoader = "assets/images/loading.gif";

// ignore_for_file: non_constant_identifier_names

final Map<String, String> headers = {
  'accept': '*/*',
  'accept-encoding': 'gzip, deflate',
  'content-type': 'application/json',
  'content-encoding': 'gzip',
  'origin': 'https://music.youtube.com/',
  'cookie': 'CONSENT=YES+1',
};

final WEB_CONTEXT = {
  'client': {
    "clientName": "WEB_REMIX",
    "clientVersion": "1.20230213.01.00",
  },
  'user': {}
};

final ANDROID_CONTEXT = {
  'client': {
    'clientName': 'ANDROID_MUSIC',
    'clientVersion': '5.22.1',
    'androidSdkVersion': 31,
    'userAgent':
        'com.google.android.youtube/19.29.1  (Linux; U; Android 11) gzip',
    'hl': 'en',
    'timeZone': 'UTC',
    'utcOffsetMinutes': 0,
  },
};

final IOS_CONTEXT = {
  'client': {
    'clientName': 'IOS',
    'clientVersion': '19.29.1',
    'deviceMake': 'Apple',
    'deviceModel': 'iPhone16,2',
    'hl': 'en',
    'osName': 'iPhone',
    'osVersion': '17.5.1.21F90',
    'timeZone': 'UTC',
    'userAgent':
        'com.google.ios.youtube/19.29.1 (iPhone16,2; U; CPU iOS 17_5_1 like Mac OS X;)',
    'utcOffsetMinutes': 0
  }
};

const kPartIOS = "AIzaSyB-63vPrdThhKuerbB2N_l7Kwwcxj6yUAc";
const kPartAndroid = "AIzaSyAOghZGza2MQSZkY_zfZ370N-PUdXEo8AI";
const kpartWeb = "AIzaSyBAETezhkwP0ZWA02RsqT1zu78Fpt0bC_s";
const kpartWeb2 = "AIzaSyBAETezhkwP0ZWA02RsqT1zu78Fpt0bC_s";
const allKeys = [kPartIOS, kPartAndroid, kpartWeb, kpartWeb2];

String getUrl(int option) =>
    "https://music.youtube.com/youtubei/v1/player?key=${allKeys[option]}&prettyPrint=false";

Map<String, dynamic> getBody(int option) => {
      "context": option == 0 ? IOS_CONTEXT : option == 1 ? ANDROID_CONTEXT : option == 2 ? WEB_CONTEXT : IOS_CONTEXT,
    };