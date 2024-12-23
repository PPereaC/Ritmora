class YoutubeTrendingResponse {
  final Contents contents;

  YoutubeTrendingResponse({
    required this.contents,
  });

  factory YoutubeTrendingResponse.fromJson(Map<String, dynamic> json) => YoutubeTrendingResponse(
    contents: Contents.fromJson(json["contents"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "contents": contents.toJson(),
  };
}

class Contents {
  final SingleColumnBrowseResultsRenderer singleColumnBrowseResultsRenderer;

  Contents({
    required this.singleColumnBrowseResultsRenderer,
  });

  factory Contents.fromJson(Map<String, dynamic> json) => Contents(
    singleColumnBrowseResultsRenderer: SingleColumnBrowseResultsRenderer.fromJson(json["singleColumnBrowseResultsRenderer"]),
  );

  Map<String, dynamic> toJson() => {
    "singleColumnBrowseResultsRenderer": singleColumnBrowseResultsRenderer.toJson(),
  };
}

class SingleColumnBrowseResultsRenderer {
  final List<Tab> tabs;

  SingleColumnBrowseResultsRenderer({
    required this.tabs,
  });

  factory SingleColumnBrowseResultsRenderer.fromJson(Map<String, dynamic> json) => SingleColumnBrowseResultsRenderer(
    tabs: List<Tab>.from(json["tabs"].map((x) => Tab.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "tabs": List<dynamic>.from(tabs.map((x) => x.toJson())),
  };
}

class Tab {
  final TabRenderer tabRenderer;

  Tab({
    required this.tabRenderer,
  });

  factory Tab.fromJson(Map<String, dynamic> json) => Tab(
    tabRenderer: TabRenderer.fromJson(json["tabRenderer"]),
  );

  Map<String, dynamic> toJson() => {
    "tabRenderer": tabRenderer.toJson(),
  };
}

class TabRenderer {
  final TabRendererContent content;

  TabRenderer({
    required this.content,
  });

  factory TabRenderer.fromJson(Map<String, dynamic> json) => TabRenderer(
    content: TabRendererContent.fromJson(json["content"]),
  );

  Map<String, dynamic> toJson() => {
    "content": content.toJson(),
  };
}

class TabRendererContent {
  final SectionListRenderer sectionListRenderer;

  TabRendererContent({
    required this.sectionListRenderer,
  });

  factory TabRendererContent.fromJson(Map<String, dynamic> json) => TabRendererContent(
    sectionListRenderer: SectionListRenderer.fromJson(json["sectionListRenderer"]),
  );

  Map<String, dynamic> toJson() => {
    "sectionListRenderer": sectionListRenderer.toJson(),
  };
}

class SectionListRenderer {
  final List<SectionListRendererContent> contents;

  SectionListRenderer({
    required this.contents,
  });

  factory SectionListRenderer.fromJson(Map<String, dynamic> json) => SectionListRenderer(
    contents: List<SectionListRendererContent>.from(json["contents"].map((x) => SectionListRendererContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
  };
}

class SectionListRendererContent {
  final MusicCarouselShelfRenderer? musicCarouselShelfRenderer;

  SectionListRendererContent({
    this.musicCarouselShelfRenderer,
  });

  factory SectionListRendererContent.fromJson(Map<String, dynamic> json) => SectionListRendererContent(
    musicCarouselShelfRenderer: json.containsKey('musicCarouselShelfRenderer') 
        ? MusicCarouselShelfRenderer.fromJson(json['musicCarouselShelfRenderer'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    if (musicCarouselShelfRenderer != null) 
      'musicCarouselShelfRenderer': musicCarouselShelfRenderer!.toJson(),
  };
}

class MusicCarouselShelfRenderer {
  final List<MusicCarouselShelfRendererContent> contents;

  MusicCarouselShelfRenderer({
    required this.contents,
  });

  factory MusicCarouselShelfRenderer.fromJson(Map<String, dynamic> json) => MusicCarouselShelfRenderer(
    contents: List<MusicCarouselShelfRendererContent>.from(json["contents"].map((x) => MusicCarouselShelfRendererContent.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
  };
}

class MusicCarouselShelfRendererContent {
  final MusicResponsiveListItemRendererr musicResponsiveListItemRenderer;

  MusicCarouselShelfRendererContent({
    required this.musicResponsiveListItemRenderer,
  });

  factory MusicCarouselShelfRendererContent.fromJson(Map<String, dynamic> json) => MusicCarouselShelfRendererContent(
    musicResponsiveListItemRenderer: MusicResponsiveListItemRendererr.fromJson(json["musicResponsiveListItemRenderer"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "musicResponsiveListItemRenderer": musicResponsiveListItemRenderer.toJson(),
  };
}

class MusicResponsiveListItemRendererr {
  final List<FlexColumn> flexColumns;
  final PlaylistItemData playlistItemData;

  MusicResponsiveListItemRendererr({
    required this.flexColumns,
    required this.playlistItemData,
  });

  factory MusicResponsiveListItemRendererr.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRendererr(
    flexColumns: List<FlexColumn>.from(json["flexColumns"].map((x) => FlexColumn.fromJson(x))),
    playlistItemData: PlaylistItemData.fromJson(json["playlistItemData"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "flexColumns": List<dynamic>.from(flexColumns.map((x) => x.toJson())),
    "playlistItemData": playlistItemData.toJson(),
  };
}

class FlexColumn {
  final MusicResponsiveListItemFlexColumnRenderer musicResponsiveListItemFlexColumnRenderer;

  FlexColumn({
    required this.musicResponsiveListItemFlexColumnRenderer,
  });

  factory FlexColumn.fromJson(Map<String, dynamic> json) => FlexColumn(
    musicResponsiveListItemFlexColumnRenderer: MusicResponsiveListItemFlexColumnRenderer.fromJson(json["musicResponsiveListItemFlexColumnRenderer"]),
  );

  Map<String, dynamic> toJson() => {
    "musicResponsiveListItemFlexColumnRenderer": musicResponsiveListItemFlexColumnRenderer.toJson(),
  };
}

class MusicResponsiveListItemFlexColumnRenderer {
  final Text text;

  MusicResponsiveListItemFlexColumnRenderer({
    required this.text,
  });

  factory MusicResponsiveListItemFlexColumnRenderer.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemFlexColumnRenderer(
    text: Text.fromJson(json["text"]),
  );

  Map<String, dynamic> toJson() => {
    "text": text.toJson(),
  };
}

class Text {
  final List<PurpleRun> runs;

  Text({
    required this.runs,
  });

  factory Text.fromJson(Map<String, dynamic> json) => Text(
    runs: List<PurpleRun>.from(json["runs"].map((x) => PurpleRun.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
  };
}

class PurpleRun {
  final String text;

  PurpleRun({
    required this.text,
  });

  factory PurpleRun.fromJson(Map<String, dynamic> json) => PurpleRun(
    text: json["text"],
  );

  Map<String, dynamic> toJson() => {
    "text": text,
  };
}

class PlaylistItemData {
  final String videoId;

  PlaylistItemData({
    required this.videoId,
  });

  factory PlaylistItemData.fromJson(Map<String, dynamic> json) => PlaylistItemData(
    videoId: json["videoId"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "videoId": videoId,
  };
}