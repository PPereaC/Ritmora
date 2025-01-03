class PipedSearchSongsResponse {
    final List<Item> items;
    final String nextpage;
    final String suggestion;
    final bool corrected;

    PipedSearchSongsResponse({
        required this.items,
        required this.nextpage,
        required this.suggestion,
        required this.corrected,
    });

    factory PipedSearchSongsResponse.fromJson(Map<String, dynamic> json) => PipedSearchSongsResponse(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        nextpage: json["nextpage"],
        suggestion: json["suggestion"],
        corrected: json["corrected"],
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "nextpage": nextpage,
        "suggestion": suggestion,
        "corrected": corrected,
    };
}

class Item {
    final String url;
    final Type type;
    final String title;
    final String thumbnail;
    final String uploaderName;
    final String uploaderUrl;
    final dynamic uploaderAvatar;
    final dynamic uploadedDate;
    final dynamic shortDescription;
    final int duration;
    final int views;
    final int uploaded;
    final bool uploaderVerified;
    final bool isShort;

    Item({
        required this.url,
        required this.type,
        required this.title,
        required this.thumbnail,
        required this.uploaderName,
        required this.uploaderUrl,
        required this.uploaderAvatar,
        required this.uploadedDate,
        required this.shortDescription,
        required this.duration,
        required this.views,
        required this.uploaded,
        required this.uploaderVerified,
        required this.isShort,
    });

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        url: json["url"],
        type: typeValues.map[json["type"]]!,
        title: json["title"],
        thumbnail: json["thumbnail"],
        uploaderName: json["uploaderName"],
        uploaderUrl: json["uploaderUrl"] ?? '',
        uploaderAvatar: json["uploaderAvatar"] ?? '',
        uploadedDate: json["uploadedDate"] ?? '',
        shortDescription: json["shortDescription"] ?? '',
        duration: json["duration"],
        views: json["views"] ?? '',
        uploaded: json["uploaded"] ?? '',
        uploaderVerified: json["uploaderVerified"] ?? '',
        isShort: json["isShort"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "type": typeValues.reverse[type],
        "title": title,
        "thumbnail": thumbnail,
        "uploaderName": uploaderName,
        "uploaderUrl": uploaderUrl,
        "uploaderAvatar": uploaderAvatar,
        "uploadedDate": uploadedDate,
        "shortDescription": shortDescription,
        "duration": duration,
        "views": views,
        "uploaded": uploaded,
        "uploaderVerified": uploaderVerified,
        "isShort": isShort,
    };
}

enum Type {
    STREAM
}

final typeValues = EnumValues({
    "stream": Type.STREAM
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
