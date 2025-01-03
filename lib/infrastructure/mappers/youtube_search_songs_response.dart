class YoutubeSearchSongsResponse {
    final Contents contents;

    YoutubeSearchSongsResponse({
        required this.contents,
    });

    factory YoutubeSearchSongsResponse.fromJson(Map<String, dynamic> json) => YoutubeSearchSongsResponse(
        contents: Contents.fromJson(json["contents"] ?? {}),
    );
}

class Contents {
    final TabbedSearchResultsRenderer tabbedSearchResultsRenderer;

    Contents({
        required this.tabbedSearchResultsRenderer,
    });

    factory Contents.fromJson(Map<String, dynamic> json) => Contents(
        tabbedSearchResultsRenderer: TabbedSearchResultsRenderer.fromJson(json["tabbedSearchResultsRenderer"] ?? {}),
    );
}

class TabbedSearchResultsRenderer {
    final List<Tab> tabs;

    TabbedSearchResultsRenderer({
        required this.tabs,
    });

    factory TabbedSearchResultsRenderer.fromJson(Map<String, dynamic> json) => TabbedSearchResultsRenderer(
        tabs: json["tabs"] != null ? List<Tab>.from(json["tabs"].map((x) => Tab.fromJson(x))) : [],
    );
}

class Tab {
    final TabRenderer tabRenderer;

    Tab({
        required this.tabRenderer,
    });

    factory Tab.fromJson(Map<String, dynamic> json) => Tab(
        tabRenderer: TabRenderer.fromJson(json["tabRenderer"] ?? {}),
    );
}

class TabRenderer {
    final TabRendererContent content;

    TabRenderer({
        required this.content,
    });

    factory TabRenderer.fromJson(Map<String, dynamic> json) => TabRenderer(
        content: TabRendererContent.fromJson(json["content"] ?? {}),
    );
}

class TabRendererContent {
    final SectionListRenderer sectionListRenderer;

    TabRendererContent({
        required this.sectionListRenderer,
    });

    factory TabRendererContent.fromJson(Map<String, dynamic> json) => TabRendererContent(
        sectionListRenderer: SectionListRenderer.fromJson(json["sectionListRenderer"] ?? {}),
    );
}

class SectionListRenderer {
    final List<SectionListRendererContent> contents;

    SectionListRenderer({
        required this.contents,
    });

    factory SectionListRenderer.fromJson(Map<String, dynamic> json) => SectionListRenderer(
        contents: json["contents"] != null ? List<SectionListRendererContent>.from(json["contents"].map((x) => SectionListRendererContent.fromJson(x))) : [],
    );
}

class SectionListRendererContent {
    final ItemSectionRenderer? itemSectionRenderer;
    final MusicShelfRenderer? musicShelfRenderer;

    SectionListRendererContent({
        this.itemSectionRenderer,
        this.musicShelfRenderer,
    });

    factory SectionListRendererContent.fromJson(Map<String, dynamic> json) => SectionListRendererContent(
        itemSectionRenderer: json["itemSectionRenderer"] != null 
            ? ItemSectionRenderer.fromJson(json["itemSectionRenderer"]) 
            : null,
        musicShelfRenderer: json["musicShelfRenderer"] != null 
            ? MusicShelfRenderer.fromJson(json["musicShelfRenderer"]) 
            : null,
    );
}

class ItemSectionRenderer {
    final List<ItemSectionRendererContent> contents;

    ItemSectionRenderer({
        required this.contents,
    });

    factory ItemSectionRenderer.fromJson(Map<String, dynamic> json) => ItemSectionRenderer(
        contents: List<ItemSectionRendererContent>.from(json["contents"].map((x) => ItemSectionRendererContent.fromJson(x))),
    );
}

class ItemSectionRendererContent {
    final MusicResponsiveListItemRenderer? musicResponsiveListItemRenderer;

    ItemSectionRendererContent({
        this.musicResponsiveListItemRenderer,
    });

    factory ItemSectionRendererContent.fromJson(Map<String, dynamic> json) => ItemSectionRendererContent(
        musicResponsiveListItemRenderer: json["musicResponsiveListItemRenderer"] != null 
            ? MusicResponsiveListItemRenderer.fromJson(json["musicResponsiveListItemRenderer"])
            : null,
    );
}

class MusicShelfRenderer {
    final List<MusicShelfRendererContent> contents;

    MusicShelfRenderer({
        required this.contents,
    });

    factory MusicShelfRenderer.fromJson(Map<String, dynamic> json) => MusicShelfRenderer(
        contents: List<MusicShelfRendererContent>.from(json["contents"].map((x) => MusicShelfRendererContent.fromJson(x))),
    );
}

class MusicShelfRendererContent {
    final MusicResponsiveListItemRenderer musicResponsiveListItemRenderer;

    MusicShelfRendererContent({
        required this.musicResponsiveListItemRenderer,
    });

    factory MusicShelfRendererContent.fromJson(Map<String, dynamic> json) => MusicShelfRendererContent(
        musicResponsiveListItemRenderer: MusicResponsiveListItemRenderer.fromJson(json["musicResponsiveListItemRenderer"]),
    );
}

class MusicResponsiveListItemRenderer {
    final List<FlexColumn> flexColumns;
    final PlaylistItemData playlistItemData;

    MusicResponsiveListItemRenderer({
        required this.flexColumns,
        required this.playlistItemData,
    });

    factory MusicResponsiveListItemRenderer.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRenderer(
        flexColumns: List<FlexColumn>.from((json["flexColumns"] ?? []).map((x) => FlexColumn.fromJson(x))),
        playlistItemData: PlaylistItemData.fromJson(json["playlistItemData"] ?? {}),
    );
}

class FlexColumn {
    final MusicResponsiveListItemFlexColumnRenderer musicResponsiveListItemFlexColumnRenderer;

    FlexColumn({
        required this.musicResponsiveListItemFlexColumnRenderer,
    });

    factory FlexColumn.fromJson(Map<String, dynamic> json) => FlexColumn(
        musicResponsiveListItemFlexColumnRenderer: MusicResponsiveListItemFlexColumnRenderer.fromJson(json["musicResponsiveListItemFlexColumnRenderer"]),
    );
}

class MusicResponsiveListItemFlexColumnRenderer {
    final Text? text;

    MusicResponsiveListItemFlexColumnRenderer({
        this.text,
    });

    factory MusicResponsiveListItemFlexColumnRenderer.fromJson(Map<String, dynamic>? json) {
        if (json == null) return MusicResponsiveListItemFlexColumnRenderer();
        return MusicResponsiveListItemFlexColumnRenderer(
            text: json["text"] != null ? Text.fromJson(json["text"]) : null,
        );
    }
}

class Text {
    final List<Run> runs;

    Text({
        required this.runs,
    });

    factory Text.fromJson(Map<String, dynamic> json) => Text(
        runs: List<Run>.from(json["runs"].map((x) => Run.fromJson(x))),
    );
}

class Run {
    final String text;

    Run({
        required this.text,
    });

    factory Run.fromJson(Map<String, dynamic> json) => Run(
        text: json["text"] ?? '',
    );
}

class PlaylistItemData {
    final String videoId;

    PlaylistItemData({
        required this.videoId,
    });

    factory PlaylistItemData.fromJson(Map<String, dynamic> json) => PlaylistItemData(
        videoId: json["videoId"] ?? '',
    );
}