class YoutubeTrendingResponse {
    final ResponseContext responseContext;
    final Contents contents;
    final YoutubeTrendingResponseHeader header;
    final String trackingParams;
    final FrameworkUpdates frameworkUpdates;

    YoutubeTrendingResponse({
        required this.responseContext,
        required this.contents,
        required this.header,
        required this.trackingParams,
        required this.frameworkUpdates,
    });

    factory YoutubeTrendingResponse.fromJson(Map<String, dynamic> json) => YoutubeTrendingResponse(
        responseContext: ResponseContext.fromJson(json["responseContext"]),
        contents: Contents.fromJson(json["contents"]),
        header: YoutubeTrendingResponseHeader.fromJson(json["header"]),
        trackingParams: json["trackingParams"],
        frameworkUpdates: FrameworkUpdates.fromJson(json["frameworkUpdates"]),
    );

    Map<String, dynamic> toJson() => {
        "responseContext": responseContext.toJson(),
        "contents": contents.toJson(),
        "header": header.toJson(),
        "trackingParams": trackingParams,
        "frameworkUpdates": frameworkUpdates.toJson(),
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
    final String trackingParams;

    TabRenderer({
        required this.content,
        required this.trackingParams,
    });

    factory TabRenderer.fromJson(Map<String, dynamic> json) => TabRenderer(
        content: TabRendererContent.fromJson(json["content"]),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "trackingParams": trackingParams,
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
    final String trackingParams;

    SectionListRenderer({
        required this.contents,
        required this.trackingParams,
    });

    factory SectionListRenderer.fromJson(Map<String, dynamic> json) => SectionListRenderer(
      contents: json["contents"] == null 
        ? <SectionListRendererContent>[] 
        : List<SectionListRendererContent>.from(json["contents"].map((x) => SectionListRendererContent.fromJson(x))),
      trackingParams: json["trackingParams"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
        "trackingParams": trackingParams,
    };
}

class SectionListRendererContent {
    final MusicShelfRenderer musicShelfRenderer;
    final MusicCarouselShelfRenderer musicCarouselShelfRenderer;

    SectionListRendererContent({
        required this.musicShelfRenderer,
        required this.musicCarouselShelfRenderer,
    });

    factory SectionListRendererContent.fromJson(Map<String, dynamic> json) => SectionListRendererContent(
        musicShelfRenderer: MusicShelfRenderer.fromJson(json["musicShelfRenderer"] ?? {}),
        musicCarouselShelfRenderer: MusicCarouselShelfRenderer.fromJson(json["musicCarouselShelfRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicShelfRenderer": musicShelfRenderer.toJson(),
        "musicCarouselShelfRenderer": musicCarouselShelfRenderer.toJson(),
    };
}

class MusicCarouselShelfRenderer {
    final MusicCarouselShelfRendererHeader header;
    final List<MusicCarouselShelfRendererContent> contents;
    final String trackingParams;
    final String itemSize;
    final String numItemsPerColumn;

    MusicCarouselShelfRenderer({
        required this.header,
        required this.contents,
        required this.trackingParams,
        required this.itemSize,
        required this.numItemsPerColumn,
    });

    factory MusicCarouselShelfRenderer.fromJson(Map<String, dynamic> json) => MusicCarouselShelfRenderer(
        header: MusicCarouselShelfRendererHeader.fromJson(json["header"] ?? {}),
        contents: json["contents"] == null 
          ? <MusicCarouselShelfRendererContent>[] 
          : List<MusicCarouselShelfRendererContent>.from(json["contents"].map((x) => MusicCarouselShelfRendererContent.fromJson(x))),
        trackingParams: json["trackingParams"] ?? '',
        itemSize: json["itemSize"] ?? '',
        numItemsPerColumn: json["numItemsPerColumn"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "header": header.toJson(),
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
        "trackingParams": trackingParams,
        "itemSize": itemSize,
        "numItemsPerColumn": numItemsPerColumn,
    };
}

class MusicCarouselShelfRendererContent {
    final MusicTwoRowItemRenderer musicTwoRowItemRenderer;
    final MusicResponsiveListItemRendererr musicResponsiveListItemRenderer;

    MusicCarouselShelfRendererContent({
        required this.musicTwoRowItemRenderer,
        required this.musicResponsiveListItemRenderer,
    });

    factory MusicCarouselShelfRendererContent.fromJson(Map<String, dynamic> json) => MusicCarouselShelfRendererContent(
        musicTwoRowItemRenderer: MusicTwoRowItemRenderer.fromJson(json["musicTwoRowItemRenderer"] ?? {}),
        musicResponsiveListItemRenderer: MusicResponsiveListItemRendererr.fromJson(json["musicResponsiveListItemRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicTwoRowItemRenderer": musicTwoRowItemRenderer.toJson(),
        "musicResponsiveListItemRenderer": musicResponsiveListItemRenderer.toJson(),
    };
}

class MusicResponsiveListItemRendererr {
    final String trackingParams;
    final ThumbnailRendererClass thumbnail;
    final List<FlexColumn> flexColumns;
    final MusicResponsiveListItemRendererMenu menu;
    final String flexColumnDisplayStyle;
    final MusicResponsiveListItemRendererNavigationEndpoint navigationEndpoint;
    final ItemHeight itemHeight;
    final CustomIndexColumn customIndexColumn;
    final Overlay overlay;
    final PlaylistItemData playlistItemData;

    MusicResponsiveListItemRendererr({
        required this.trackingParams,
        required this.thumbnail,
        required this.flexColumns,
        required this.menu,
        required this.flexColumnDisplayStyle,
        required this.navigationEndpoint,
        required this.itemHeight,
        required this.customIndexColumn,
        required this.overlay,
        required this.playlistItemData,
    });

    factory MusicResponsiveListItemRendererr.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRendererr(
        trackingParams: json["trackingParams"] ?? '',
        thumbnail: ThumbnailRendererClass.fromJson(json["thumbnail"] ?? {}),
        flexColumns: json["flexColumns"] == null 
          ? <FlexColumn>[] 
          : List<FlexColumn>.from(json["flexColumns"].map((x) => FlexColumn.fromJson(x))),
        menu: MusicResponsiveListItemRendererMenu.fromJson(json["menu"] ?? {}),
        flexColumnDisplayStyle: json["flexColumnDisplayStyle"] ?? '',
        navigationEndpoint: MusicResponsiveListItemRendererNavigationEndpoint.fromJson(json["navigationEndpoint"] ?? {}),
        itemHeight: itemHeightValues.map[json["itemHeight"]] ?? ItemHeight.MUSIC_RESPONSIVE_LIST_ITEM_HEIGHT_MEDIUM_COMPACT,
        customIndexColumn: CustomIndexColumn.fromJson(json["customIndexColumn"] ?? {}),
        overlay: Overlay.fromJson(json["overlay"] ?? {}),
        playlistItemData: PlaylistItemData.fromJson(json["playlistItemData"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "trackingParams": trackingParams,
        "thumbnail": thumbnail.toJson(),
        "flexColumns": List<dynamic>.from(flexColumns.map((x) => x.toJson())),
        "menu": menu.toJson(),
        "flexColumnDisplayStyle": flexColumnDisplayStyle,
        "navigationEndpoint": navigationEndpoint.toJson(),
        "itemHeight": itemHeightValues.reverse[itemHeight],
        "customIndexColumn": customIndexColumn.toJson(),
        "overlay": overlay.toJson(),
        "playlistItemData": playlistItemData.toJson(),
    };
}

class CustomIndexColumn {
    final MusicCustomIndexColumnRenderer musicCustomIndexColumnRenderer;

    CustomIndexColumn({
        required this.musicCustomIndexColumnRenderer,
    });

    factory CustomIndexColumn.fromJson(Map<String, dynamic> json) => CustomIndexColumn(
        musicCustomIndexColumnRenderer: MusicCustomIndexColumnRenderer.fromJson(json["musicCustomIndexColumnRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicCustomIndexColumnRenderer": musicCustomIndexColumnRenderer.toJson(),
    };
}

class MusicCustomIndexColumnRenderer {
    final TextClass text;
    final Icon icon;
    final IconColorStyle iconColorStyle;
    final AccessibilityData accessibilityData;

    MusicCustomIndexColumnRenderer({
        required this.text,
        required this.icon,
        required this.iconColorStyle,
        required this.accessibilityData,
    });

    factory MusicCustomIndexColumnRenderer.fromJson(Map<String, dynamic> json) => MusicCustomIndexColumnRenderer(
        text: TextClass.fromJson(json["text"] ?? {}),
        icon: Icon.fromJson(json["icon"] ?? {}),
        iconColorStyle: iconColorStyleValues.map[json["iconColorStyle"] ?? ''] ?? IconColorStyle.CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_GREEN,
        accessibilityData: AccessibilityData.fromJson(json["accessibilityData"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "icon": icon.toJson(),
        "iconColorStyle": iconColorStyleValues.reverse[iconColorStyle],
        "accessibilityData": accessibilityData.toJson(),
    };
}

class AccessibilityData {
    final AccessibilityDataAccessibilityData accessibilityData;

    AccessibilityData({
        required this.accessibilityData,
    });

    factory AccessibilityData.fromJson(Map<String, dynamic> json) => AccessibilityData(
        accessibilityData: AccessibilityDataAccessibilityData.fromJson(json["accessibilityData"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "accessibilityData": accessibilityData.toJson(),
    };
}

class AccessibilityDataAccessibilityData {
    final String label;

    AccessibilityDataAccessibilityData({
        required this.label,
    });

    factory AccessibilityDataAccessibilityData.fromJson(Map<String, dynamic> json) => AccessibilityDataAccessibilityData(
        label: json["label"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "label": label,
    };
}

class Icon {
    final IconType iconType;

    Icon({
        required this.iconType,
    });

    factory Icon.fromJson(Map<String, dynamic> json) => Icon(
        iconType: iconTypeValues.map[json["iconType"]] ?? IconType.ADD_TO_PLAYLIST,
    );

    Map<String, dynamic> toJson() => {
        "iconType": iconTypeValues.reverse[iconType],
    };
}

enum IconType {
    ADD_TO_PLAYLIST,
    ADD_TO_REMOTE_QUEUE,
    ARROW_CHART_NEUTRAL,
    ARROW_DROP_DOWN,
    ARROW_DROP_UP,
    ARTIST,
    CHECK,
    FAVORITE,
    MIX,
    MUSIC_SHUFFLE,
    PAUSE,
    PLAY_ARROW,
    QUEUE_PLAY_NEXT,
    SHARE,
    SUBSCRIBE,
    UNFAVORITE,
    VOLUME_UP
}

final iconTypeValues = EnumValues({
    "ADD_TO_PLAYLIST": IconType.ADD_TO_PLAYLIST,
    "ADD_TO_REMOTE_QUEUE": IconType.ADD_TO_REMOTE_QUEUE,
    "ARROW_CHART_NEUTRAL": IconType.ARROW_CHART_NEUTRAL,
    "ARROW_DROP_DOWN": IconType.ARROW_DROP_DOWN,
    "ARROW_DROP_UP": IconType.ARROW_DROP_UP,
    "ARTIST": IconType.ARTIST,
    "CHECK": IconType.CHECK,
    "FAVORITE": IconType.FAVORITE,
    "MIX": IconType.MIX,
    "MUSIC_SHUFFLE": IconType.MUSIC_SHUFFLE,
    "PAUSE": IconType.PAUSE,
    "PLAY_ARROW": IconType.PLAY_ARROW,
    "QUEUE_PLAY_NEXT": IconType.QUEUE_PLAY_NEXT,
    "SHARE": IconType.SHARE,
    "SUBSCRIBE": IconType.SUBSCRIBE,
    "UNFAVORITE": IconType.UNFAVORITE,
    "VOLUME_UP": IconType.VOLUME_UP
});

enum IconColorStyle {
    CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_GREEN,
    CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_GREY,
    CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_RED
}

final iconColorStyleValues = EnumValues({
    "CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_GREEN": IconColorStyle.CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_GREEN,
    "CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_GREY": IconColorStyle.CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_GREY,
    "CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_RED": IconColorStyle.CUSTOM_INDEX_COLUMN_ICON_COLOR_STYLE_RED
});

class TextClass {
    final List<DefaultTextRun> runs;

    TextClass({
        required this.runs,
    });

    factory TextClass.fromJson(Map<String, dynamic> json) => TextClass(
      runs: json["runs"] == null 
          ? <DefaultTextRun>[]  
          : List<DefaultTextRun>.from(json["runs"].map((x) => DefaultTextRun.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
    };
}

class DefaultTextRun {
    final String text;

    DefaultTextRun({
        required this.text,
    });

    factory DefaultTextRun.fromJson(Map<String, dynamic> json) => DefaultTextRun(
        text: json["text"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "text": text,
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
    final DisplayPriority displayPriority;

    MusicResponsiveListItemFlexColumnRenderer({
        required this.text,
        required this.displayPriority,
    });

    factory MusicResponsiveListItemFlexColumnRenderer.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemFlexColumnRenderer(
        text: Text.fromJson(json["text"] ?? {}),
        displayPriority: displayPriorityValues.map[json["displayPriority"]] ?? DisplayPriority.MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_MEDIUM,
    );

    Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "displayPriority": displayPriorityValues.reverse[displayPriority],
    };
}

enum DisplayPriority {
    MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_HIGH,
    MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_MEDIUM
}

final displayPriorityValues = EnumValues({
    "MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_HIGH": DisplayPriority.MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_HIGH,
    "MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_MEDIUM": DisplayPriority.MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_MEDIUM
});

class Text {
    final List<PurpleRun> runs;

    Text({
        required this.runs,
    });

    factory Text.fromJson(Map<String, dynamic> json) => Text(
      runs: json["runs"] == null 
        ? <PurpleRun>[] 
        : List<PurpleRun>.from(json["runs"].map((x) => PurpleRun.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
    };
}

class PurpleRun {
    final String text;
    final PurpleNavigationEndpoint navigationEndpoint;

    PurpleRun({
        required this.text,
        required this.navigationEndpoint,
    });

    factory PurpleRun.fromJson(Map<String, dynamic> json) => PurpleRun(
        text: json["text"] ?? '',
        navigationEndpoint: PurpleNavigationEndpoint.fromJson(json["navigationEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "navigationEndpoint": navigationEndpoint.toJson(),
    };
}

class PurpleNavigationEndpoint {
    final String clickTrackingParams;
    final WatchEndpoint watchEndpoint;
    final NavigationEndpointBrowseEndpoint browseEndpoint;

    PurpleNavigationEndpoint({
        required this.clickTrackingParams,
        required this.watchEndpoint,
        required this.browseEndpoint,
    });

    factory PurpleNavigationEndpoint.fromJson(Map<String, dynamic> json) => PurpleNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        watchEndpoint: WatchEndpoint.fromJson(json["watchEndpoint"] ?? {}),
        browseEndpoint: NavigationEndpointBrowseEndpoint.fromJson(json["browseEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
        "browseEndpoint": browseEndpoint.toJson(),
    };
}

class NavigationEndpointBrowseEndpoint {
    final String browseId;
    final BrowseEndpointContextSupportedConfigs browseEndpointContextSupportedConfigs;

    NavigationEndpointBrowseEndpoint({
        required this.browseId,
        required this.browseEndpointContextSupportedConfigs,
    });

    factory NavigationEndpointBrowseEndpoint.fromJson(Map<String, dynamic> json) => NavigationEndpointBrowseEndpoint(
        browseId: json["browseId"] ?? '',
        browseEndpointContextSupportedConfigs: BrowseEndpointContextSupportedConfigs.fromJson(json["browseEndpointContextSupportedConfigs"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "browseId": browseId,
        "browseEndpointContextSupportedConfigs": browseEndpointContextSupportedConfigs.toJson(),
    };
}

class BrowseEndpointContextSupportedConfigs {
    final BrowseEndpointContextMusicConfig browseEndpointContextMusicConfig;

    BrowseEndpointContextSupportedConfigs({
        required this.browseEndpointContextMusicConfig,
    });

    factory BrowseEndpointContextSupportedConfigs.fromJson(Map<String, dynamic> json) => BrowseEndpointContextSupportedConfigs(
        browseEndpointContextMusicConfig: BrowseEndpointContextMusicConfig.fromJson(json["browseEndpointContextMusicConfig"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "browseEndpointContextMusicConfig": browseEndpointContextMusicConfig.toJson(),
    };
}

class BrowseEndpointContextMusicConfig {
    final PageType pageType;

    BrowseEndpointContextMusicConfig({
        required this.pageType,
    });

    factory BrowseEndpointContextMusicConfig.fromJson(Map<String, dynamic> json) => BrowseEndpointContextMusicConfig(
        pageType: pageTypeValues.map[json["pageType"] ?? ''] ?? PageType.MUSIC_PAGE_TYPE_ARTIST,
    );

    Map<String, dynamic> toJson() => {
        "pageType": pageTypeValues.reverse[pageType],
    };
}

enum PageType {
    MUSIC_PAGE_TYPE_ARTIST,
    MUSIC_PAGE_TYPE_PLAYLIST,
    MUSIC_PAGE_TYPE_USER_CHANNEL
}

final pageTypeValues = EnumValues({
    "MUSIC_PAGE_TYPE_ARTIST": PageType.MUSIC_PAGE_TYPE_ARTIST,
    "MUSIC_PAGE_TYPE_PLAYLIST": PageType.MUSIC_PAGE_TYPE_PLAYLIST,
    "MUSIC_PAGE_TYPE_USER_CHANNEL": PageType.MUSIC_PAGE_TYPE_USER_CHANNEL
});

class WatchEndpoint {
    final String videoId;
    final String playlistId;
    final LoggingContext loggingContext;
    final WatchEndpointMusicSupportedConfigs watchEndpointMusicSupportedConfigs;
    final Params params;

    WatchEndpoint({
        required this.videoId,
        required this.playlistId,
        required this.loggingContext,
        required this.watchEndpointMusicSupportedConfigs,
        required this.params,
    });

    factory WatchEndpoint.fromJson(Map<String, dynamic> json) => WatchEndpoint(
        videoId: json["videoId"] ?? '',
        playlistId: json["playlistId"] ?? '',
        loggingContext: LoggingContext.fromJson(json["loggingContext"] ?? {}),
        watchEndpointMusicSupportedConfigs: WatchEndpointMusicSupportedConfigs.fromJson(json["watchEndpointMusicSupportedConfigs"] ?? {}),
        params: paramsValues.map[json["params"]] ?? Params.W_AEB,
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "playlistId": playlistId,
        "loggingContext": loggingContext.toJson(),
        "watchEndpointMusicSupportedConfigs": watchEndpointMusicSupportedConfigs.toJson(),
        "params": paramsValues.reverse[params],
    };
}

class LoggingContext {
    final VssLoggingContext vssLoggingContext;

    LoggingContext({
        required this.vssLoggingContext,
    });

    factory LoggingContext.fromJson(Map<String, dynamic> json) => LoggingContext(
        vssLoggingContext: VssLoggingContext.fromJson(json["vssLoggingContext"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "vssLoggingContext": vssLoggingContext.toJson(),
    };
}

class VssLoggingContext {
    final String serializedContextData;

    VssLoggingContext({
        required this.serializedContextData,
    });

    factory VssLoggingContext.fromJson(Map<String, dynamic> json) => VssLoggingContext(
        serializedContextData: json["serializedContextData"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "serializedContextData": serializedContextData,
    };
}

enum Params {
    W_AEB,
    W_AEB8_G_ECGAE_3_D
}

final paramsValues = EnumValues({
    "wAEB": Params.W_AEB,
    "wAEB8gECGAE%3D": Params.W_AEB8_G_ECGAE_3_D
});

class WatchEndpointMusicSupportedConfigs {
    final WatchEndpointMusicConfig watchEndpointMusicConfig;

    WatchEndpointMusicSupportedConfigs({
        required this.watchEndpointMusicConfig,
    });

    factory WatchEndpointMusicSupportedConfigs.fromJson(Map<String, dynamic> json) => WatchEndpointMusicSupportedConfigs(
        watchEndpointMusicConfig: WatchEndpointMusicConfig.fromJson(json["watchEndpointMusicConfig"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "watchEndpointMusicConfig": watchEndpointMusicConfig.toJson(),
    };
}

class WatchEndpointMusicConfig {
    final MusicVideoType musicVideoType;

    WatchEndpointMusicConfig({
        required this.musicVideoType,
    });

    factory WatchEndpointMusicConfig.fromJson(Map<String, dynamic> json) => WatchEndpointMusicConfig(
        musicVideoType: musicVideoTypeValues.map[json["musicVideoType"]] ?? MusicVideoType.MUSIC_VIDEO_TYPE_OMV,
    );

    Map<String, dynamic> toJson() => {
        "musicVideoType": musicVideoTypeValues.reverse[musicVideoType],
    };
}

enum MusicVideoType {
    MUSIC_VIDEO_TYPE_OMV,
    MUSIC_VIDEO_TYPE_UGC
}

final musicVideoTypeValues = EnumValues({
    "MUSIC_VIDEO_TYPE_OMV": MusicVideoType.MUSIC_VIDEO_TYPE_OMV,
    "MUSIC_VIDEO_TYPE_UGC": MusicVideoType.MUSIC_VIDEO_TYPE_UGC
});

enum ItemHeight {
    MUSIC_RESPONSIVE_LIST_ITEM_HEIGHT_MEDIUM_COMPACT
}

final itemHeightValues = EnumValues({
    "MUSIC_RESPONSIVE_LIST_ITEM_HEIGHT_MEDIUM_COMPACT": ItemHeight.MUSIC_RESPONSIVE_LIST_ITEM_HEIGHT_MEDIUM_COMPACT
});

class MusicResponsiveListItemRendererMenu {
    final PurpleMenuRenderer menuRenderer;

    MusicResponsiveListItemRendererMenu({
        required this.menuRenderer,
    });

    factory MusicResponsiveListItemRendererMenu.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRendererMenu(
        menuRenderer: PurpleMenuRenderer.fromJson(json["menuRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "menuRenderer": menuRenderer.toJson(),
    };
}

class PurpleMenuRenderer {
    final List<ItemElement> items;
    final String trackingParams;
    final AccessibilityData accessibility;
    final List<TopLevelButton> topLevelButtons;

    PurpleMenuRenderer({
        required this.items,
        required this.trackingParams,
        required this.accessibility,
        required this.topLevelButtons,
    });

    factory PurpleMenuRenderer.fromJson(Map<String, dynamic> json) => PurpleMenuRenderer(
        items: json["items"] == null 
          ? <ItemElement>[] 
          : List<ItemElement>.from(json["items"].map((x) => ItemElement.fromJson(x))),
        trackingParams: json["trackingParams"] ?? '',
        accessibility: AccessibilityData.fromJson(json["accessibility"] ?? {}),
        topLevelButtons: json["topLevelButtons"] == null 
          ? <TopLevelButton>[] 
          : List<TopLevelButton>.from(json["topLevelButtons"].map((x) => TopLevelButton.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "trackingParams": trackingParams,
        "accessibility": accessibility.toJson(),
        "topLevelButtons": List<dynamic>.from(topLevelButtons.map((x) => x.toJson())),
    };
}

class ItemElement {
    final MenuItemRenderer menuNavigationItemRenderer;
    final ToggleMenuServiceItemRenderer toggleMenuServiceItemRenderer;
    final MenuItemRenderer menuServiceItemRenderer;

    ItemElement({
        required this.menuNavigationItemRenderer,
        required this.toggleMenuServiceItemRenderer,
        required this.menuServiceItemRenderer,
    });

    factory ItemElement.fromJson(Map<String, dynamic> json) => ItemElement(
        menuNavigationItemRenderer: MenuItemRenderer.fromJson(json["menuNavigationItemRenderer"] ?? {}),
        toggleMenuServiceItemRenderer: ToggleMenuServiceItemRenderer.fromJson(json["toggleMenuServiceItemRenderer"] ?? {}),
        menuServiceItemRenderer: MenuItemRenderer.fromJson(json["menuServiceItemRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "menuNavigationItemRenderer": menuNavigationItemRenderer.toJson(),
        "toggleMenuServiceItemRenderer": toggleMenuServiceItemRenderer.toJson(),
        "menuServiceItemRenderer": menuServiceItemRenderer.toJson(),
    };
}

class MenuItemRenderer {
    final TextClass text;
    final Icon icon;
    final MenuNavigationItemRendererNavigationEndpoint navigationEndpoint;
    final String trackingParams;
    final ServiceEndpoint serviceEndpoint;

    MenuItemRenderer({
        required this.text,
        required this.icon,
        required this.navigationEndpoint,
        required this.trackingParams,
        required this.serviceEndpoint,
    });

    factory MenuItemRenderer.fromJson(Map<String, dynamic> json) => MenuItemRenderer(
        text: TextClass.fromJson(json["text"] ?? {}),
        icon: Icon.fromJson(json["icon"] ?? {}),
        navigationEndpoint: MenuNavigationItemRendererNavigationEndpoint.fromJson(json["navigationEndpoint"] ?? {}),
        trackingParams: json["trackingParams"] ?? '',
        serviceEndpoint: ServiceEndpoint.fromJson(json["serviceEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "icon": icon.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
        "trackingParams": trackingParams,
        "serviceEndpoint": serviceEndpoint.toJson(),
    };
}

class MenuNavigationItemRendererNavigationEndpoint {
    final String clickTrackingParams;
    final WatchPlaylistEndpoint watchPlaylistEndpoint;
    final ShareEntityEndpoint shareEntityEndpoint;
    final WatchEndpoint watchEndpoint;
    final ModalEndpoint modalEndpoint;
    final NavigationEndpointBrowseEndpoint browseEndpoint;

    MenuNavigationItemRendererNavigationEndpoint({
        required this.clickTrackingParams,
        required this.watchPlaylistEndpoint,
        required this.shareEntityEndpoint,
        required this.watchEndpoint,
        required this.modalEndpoint,
        required this.browseEndpoint,
    });

    factory MenuNavigationItemRendererNavigationEndpoint.fromJson(Map<String, dynamic> json) => MenuNavigationItemRendererNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        watchPlaylistEndpoint: WatchPlaylistEndpoint.fromJson(json["watchPlaylistEndpoint"] ?? {}),
        shareEntityEndpoint: ShareEntityEndpoint.fromJson(json["shareEntityEndpoint"] ?? {}),
        watchEndpoint: WatchEndpoint.fromJson(json["watchEndpoint"] ?? {}),
        modalEndpoint: ModalEndpoint.fromJson(json["modalEndpoint"] ?? {}),
        browseEndpoint: NavigationEndpointBrowseEndpoint.fromJson(json["browseEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchPlaylistEndpoint": watchPlaylistEndpoint.toJson(),
        "shareEntityEndpoint": shareEntityEndpoint.toJson(),
        "watchEndpoint": watchEndpoint.toJson(),
        "modalEndpoint": modalEndpoint.toJson(),
        "browseEndpoint": browseEndpoint.toJson(),
    };
}

class ModalEndpoint {
    final Modal modal;

    ModalEndpoint({
        required this.modal,
    });

    factory ModalEndpoint.fromJson(Map<String, dynamic> json) => ModalEndpoint(
        modal: Modal.fromJson(json["modal"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "modal": modal.toJson(),
    };
}

class Modal {
    final ModalWithTitleAndButtonRenderer modalWithTitleAndButtonRenderer;

    Modal({
        required this.modalWithTitleAndButtonRenderer,
    });

    factory Modal.fromJson(Map<String, dynamic> json) => Modal(
        modalWithTitleAndButtonRenderer: ModalWithTitleAndButtonRenderer.fromJson(json["modalWithTitleAndButtonRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "modalWithTitleAndButtonRenderer": modalWithTitleAndButtonRenderer.toJson(),
    };
}

class ModalWithTitleAndButtonRenderer {
    final TextClass title;
    final TextClass content;
    final Button button;

    ModalWithTitleAndButtonRenderer({
        required this.title,
        required this.content,
        required this.button,
    });

    factory ModalWithTitleAndButtonRenderer.fromJson(Map<String, dynamic> json) => ModalWithTitleAndButtonRenderer(
        title: TextClass.fromJson(json["title"] ?? {}),
        content: TextClass.fromJson(json["content"] ?? {}),
        button: Button.fromJson(json["button"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "content": content.toJson(),
        "button": button.toJson(),
    };
}

class Button {
    final ButtonButtonRenderer buttonRenderer;

    Button({
        required this.buttonRenderer,
    });

    factory Button.fromJson(Map<String, dynamic> json) => Button(
        buttonRenderer: ButtonButtonRenderer.fromJson(json["buttonRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "buttonRenderer": buttonRenderer.toJson(),
    };
}

class ButtonButtonRenderer {
    final Style style;
    final bool isDisabled;
    final TextClass text;
    final FluffyNavigationEndpoint navigationEndpoint;
    final String trackingParams;

    ButtonButtonRenderer({
        required this.style,
        required this.isDisabled,
        required this.text,
        required this.navigationEndpoint,
        required this.trackingParams,
    });

    factory ButtonButtonRenderer.fromJson(Map<String, dynamic> json) => ButtonButtonRenderer(
        style: styleValues.map[json["style"]] ?? Style.STYLE_BLUE_TEXT,
        isDisabled: json["isDisabled"] ?? false,
        text: TextClass.fromJson(json["text"] ?? {}),
        navigationEndpoint: FluffyNavigationEndpoint.fromJson(json["navigationEndpoint"] ?? {}),
        trackingParams: json["trackingParams"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "style": styleValues.reverse[style],
        "isDisabled": isDisabled,
        "text": text.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
        "trackingParams": trackingParams,
    };
}

class FluffyNavigationEndpoint {
    final String clickTrackingParams;
    final MusicMenuItemDividerRenderer signInEndpoint;

    FluffyNavigationEndpoint({
        required this.clickTrackingParams,
        required this.signInEndpoint,
    });

    factory FluffyNavigationEndpoint.fromJson(Map<String, dynamic> json) => FluffyNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        signInEndpoint: MusicMenuItemDividerRenderer.fromJson(json["signInEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "signInEndpoint": signInEndpoint.toJson(),
    };
}

class MusicMenuItemDividerRenderer {
    final bool hack;

    MusicMenuItemDividerRenderer({
        required this.hack,
    });

    factory MusicMenuItemDividerRenderer.fromJson(Map<String, dynamic> json) => MusicMenuItemDividerRenderer(
        hack: json["hack"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "hack": hack,
    };
}

enum Style {
    STYLE_BLUE_TEXT
}

final styleValues = EnumValues({
    "STYLE_BLUE_TEXT": Style.STYLE_BLUE_TEXT
});

class ShareEntityEndpoint {
    final String serializedShareEntity;
    final SharePanelType sharePanelType;

    ShareEntityEndpoint({
        required this.serializedShareEntity,
        required this.sharePanelType,
    });

    factory ShareEntityEndpoint.fromJson(Map<String, dynamic> json) => ShareEntityEndpoint(
        serializedShareEntity: json["serializedShareEntity"] ?? '',
        sharePanelType: sharePanelTypeValues.map[json["sharePanelType"]] ?? SharePanelType.SHARE_PANEL_TYPE_UNIFIED_SHARE_PANEL,
    );

    Map<String, dynamic> toJson() => {
        "serializedShareEntity": serializedShareEntity,
        "sharePanelType": sharePanelTypeValues.reverse[sharePanelType],
    };
}

enum SharePanelType {
    SHARE_PANEL_TYPE_UNIFIED_SHARE_PANEL
}

final sharePanelTypeValues = EnumValues({
    "SHARE_PANEL_TYPE_UNIFIED_SHARE_PANEL": SharePanelType.SHARE_PANEL_TYPE_UNIFIED_SHARE_PANEL
});

class WatchPlaylistEndpoint {
    final String playlistId;
    final Params params;

    WatchPlaylistEndpoint({
        required this.playlistId,
        required this.params,
    });

    factory WatchPlaylistEndpoint.fromJson(Map<String, dynamic> json) => WatchPlaylistEndpoint(
        playlistId: json["playlistId"] ?? '',
        params: paramsValues.map[json["params"]] ?? Params.W_AEB,
    );

    Map<String, dynamic> toJson() => {
        "playlistId": playlistId,
        "params": paramsValues.reverse[params],
    };
}

class ServiceEndpoint {
    final String clickTrackingParams;
    final QueueAddEndpoint queueAddEndpoint;

    ServiceEndpoint({
        required this.clickTrackingParams,
        required this.queueAddEndpoint,
    });

    factory ServiceEndpoint.fromJson(Map<String, dynamic> json) => ServiceEndpoint(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        queueAddEndpoint: QueueAddEndpoint.fromJson(json["queueAddEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "queueAddEndpoint": queueAddEndpoint.toJson(),
    };
}

class QueueAddEndpoint {
    final QueueTarget queueTarget;
    final QueueInsertPosition queueInsertPosition;
    final List<QueueAddEndpointCommand> commands;

    QueueAddEndpoint({
        required this.queueTarget,
        required this.queueInsertPosition,
        required this.commands,
    });

    factory QueueAddEndpoint.fromJson(Map<String, dynamic> json) => QueueAddEndpoint(
        queueTarget: QueueTarget.fromJson(json["queueTarget"] ?? {}),
        queueInsertPosition: queueInsertPositionValues.map[json["queueInsertPosition"]] ?? QueueInsertPosition.INSERT_AFTER_CURRENT_VIDEO,
        commands: json["commands"] == null 
          ? <QueueAddEndpointCommand>[] 
          : List<QueueAddEndpointCommand>.from(json["commands"].map((x) => QueueAddEndpointCommand.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "queueTarget": queueTarget.toJson(),
        "queueInsertPosition": queueInsertPositionValues.reverse[queueInsertPosition],
        "commands": List<dynamic>.from(commands.map((x) => x.toJson())),
    };
}

class QueueAddEndpointCommand {
    final String clickTrackingParams;
    final AddToToastAction addToToastAction;

    QueueAddEndpointCommand({
        required this.clickTrackingParams,
        required this.addToToastAction,
    });

    factory QueueAddEndpointCommand.fromJson(Map<String, dynamic> json) => QueueAddEndpointCommand(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        addToToastAction: AddToToastAction.fromJson(json["addToToastAction"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "addToToastAction": addToToastAction.toJson(),
    };
}

class AddToToastAction {
    final AddToToastActionItem item;

    AddToToastAction({
        required this.item,
    });

    factory AddToToastAction.fromJson(Map<String, dynamic> json) => AddToToastAction(
        item: AddToToastActionItem.fromJson(json["item"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "item": item.toJson(),
    };
}

class AddToToastActionItem {
    final NotificationTextRenderer notificationTextRenderer;

    AddToToastActionItem({
        required this.notificationTextRenderer,
    });

    factory AddToToastActionItem.fromJson(Map<String, dynamic> json) => AddToToastActionItem(
        notificationTextRenderer: NotificationTextRenderer.fromJson(json["notificationTextRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "notificationTextRenderer": notificationTextRenderer.toJson(),
    };
}

class NotificationTextRenderer {
    final TextClass successResponseText;
    final String trackingParams;

    NotificationTextRenderer({
        required this.successResponseText,
        required this.trackingParams,
    });

    factory NotificationTextRenderer.fromJson(Map<String, dynamic> json) => NotificationTextRenderer(
        successResponseText: TextClass.fromJson(json["successResponseText"] ?? {}),
        trackingParams: json["trackingParams"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "successResponseText": successResponseText.toJson(),
        "trackingParams": trackingParams,
    };
}

enum QueueInsertPosition {
    INSERT_AFTER_CURRENT_VIDEO,
    INSERT_AT_END
}

final queueInsertPositionValues = EnumValues({
    "INSERT_AFTER_CURRENT_VIDEO": QueueInsertPosition.INSERT_AFTER_CURRENT_VIDEO,
    "INSERT_AT_END": QueueInsertPosition.INSERT_AT_END
});

class QueueTarget {
    final String videoId;
    final OnEmptyQueue onEmptyQueue;

    QueueTarget({
        required this.videoId,
        required this.onEmptyQueue,
    });

    factory QueueTarget.fromJson(Map<String, dynamic> json) => QueueTarget(
        videoId: json["videoId"] ?? '',
        onEmptyQueue: OnEmptyQueue.fromJson(json["onEmptyQueue"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "onEmptyQueue": onEmptyQueue.toJson(),
    };
}

class OnEmptyQueue {
    final String clickTrackingParams;
    final PlaylistItemData watchEndpoint;

    OnEmptyQueue({
        required this.clickTrackingParams,
        required this.watchEndpoint,
    });

    factory OnEmptyQueue.fromJson(Map<String, dynamic> json) => OnEmptyQueue(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        watchEndpoint: PlaylistItemData.fromJson(json["watchEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
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

class ToggleMenuServiceItemRenderer {
    final TextClass defaultText;
    final Icon defaultIcon;
    final DefaultServiceEndpoint defaultServiceEndpoint;
    final TextClass toggledText;
    final Icon toggledIcon;
    final String trackingParams;

    ToggleMenuServiceItemRenderer({
        required this.defaultText,
        required this.defaultIcon,
        required this.defaultServiceEndpoint,
        required this.toggledText,
        required this.toggledIcon,
        required this.trackingParams,
    });

    factory ToggleMenuServiceItemRenderer.fromJson(Map<String, dynamic> json) => ToggleMenuServiceItemRenderer(
        defaultText: TextClass.fromJson(json["defaultText"] ?? {}),
        defaultIcon: Icon.fromJson(json["defaultIcon"] ?? {}),
        defaultServiceEndpoint: DefaultServiceEndpoint.fromJson(json["defaultServiceEndpoint"] ?? {}),
        toggledText: TextClass.fromJson(json["toggledText"] ?? {}),
        toggledIcon: Icon.fromJson(json["toggledIcon"] ?? {}),
        trackingParams: json["trackingParams"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "defaultText": defaultText.toJson(),
        "defaultIcon": defaultIcon.toJson(),
        "defaultServiceEndpoint": defaultServiceEndpoint.toJson(),
        "toggledText": toggledText.toJson(),
        "toggledIcon": toggledIcon.toJson(),
        "trackingParams": trackingParams,
    };
}

class DefaultServiceEndpoint {
    final String clickTrackingParams;
    final ModalEndpoint modalEndpoint;

    DefaultServiceEndpoint({
        required this.clickTrackingParams,
        required this.modalEndpoint,
    });

    factory DefaultServiceEndpoint.fromJson(Map<String, dynamic> json) => DefaultServiceEndpoint(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        modalEndpoint: ModalEndpoint.fromJson(json["modalEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "modalEndpoint": modalEndpoint.toJson(),
    };
}

class TopLevelButton {
    final LikeButtonRenderer likeButtonRenderer;

    TopLevelButton({
        required this.likeButtonRenderer,
    });

    factory TopLevelButton.fromJson(Map<String, dynamic> json) => TopLevelButton(
        likeButtonRenderer: LikeButtonRenderer.fromJson(json["likeButtonRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "likeButtonRenderer": likeButtonRenderer.toJson(),
    };
}

class LikeButtonRenderer {
    final PlaylistItemData target;
    final LikeStatus likeStatus;
    final String trackingParams;
    final bool likesAllowed;
    final DefaultServiceEndpoint dislikeNavigationEndpoint;
    final DefaultServiceEndpoint likeCommand;

    LikeButtonRenderer({
        required this.target,
        required this.likeStatus,
        required this.trackingParams,
        required this.likesAllowed,
        required this.dislikeNavigationEndpoint,
        required this.likeCommand,
    });

    factory LikeButtonRenderer.fromJson(Map<String, dynamic> json) => LikeButtonRenderer(
        target: PlaylistItemData.fromJson(json["target"] ?? {}),
        likeStatus: likeStatusValues.map[json["likeStatus"] ?? 'INDIFFERENT']!,
        trackingParams: json["trackingParams"] ?? '',
        likesAllowed: json["likesAllowed"] ?? false,
        dislikeNavigationEndpoint: DefaultServiceEndpoint.fromJson(json["dislikeNavigationEndpoint"] ?? {}),
        likeCommand: DefaultServiceEndpoint.fromJson(json["likeCommand"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "target": target.toJson(),
        "likeStatus": likeStatusValues.reverse[likeStatus],
        "trackingParams": trackingParams,
        "likesAllowed": likesAllowed,
        "dislikeNavigationEndpoint": dislikeNavigationEndpoint.toJson(),
        "likeCommand": likeCommand.toJson(),
    };
}

enum LikeStatus {
    INDIFFERENT
}

final likeStatusValues = EnumValues({
    "INDIFFERENT": LikeStatus.INDIFFERENT
});

class MusicResponsiveListItemRendererNavigationEndpoint {
    final String clickTrackingParams;
    final NavigationEndpointBrowseEndpoint browseEndpoint;

    MusicResponsiveListItemRendererNavigationEndpoint({
        required this.clickTrackingParams,
        required this.browseEndpoint,
    });

    factory MusicResponsiveListItemRendererNavigationEndpoint.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRendererNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"] ?? "",
        browseEndpoint: NavigationEndpointBrowseEndpoint.fromJson(json["browseEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "browseEndpoint": browseEndpoint.toJson(),
    };
}

class Overlay {
    final MusicItemThumbnailOverlayRenderer musicItemThumbnailOverlayRenderer;

    Overlay({
        required this.musicItemThumbnailOverlayRenderer,
    });

    factory Overlay.fromJson(Map<String, dynamic> json) => Overlay(
        musicItemThumbnailOverlayRenderer: MusicItemThumbnailOverlayRenderer.fromJson(json["musicItemThumbnailOverlayRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicItemThumbnailOverlayRenderer": musicItemThumbnailOverlayRenderer.toJson(),
    };
}

class MusicItemThumbnailOverlayRenderer {
    final Background background;
    final MusicItemThumbnailOverlayRendererContent content;
    final ContentPosition contentPosition;
    final DisplayStyle displayStyle;

    MusicItemThumbnailOverlayRenderer({
        required this.background,
        required this.content,
        required this.contentPosition,
        required this.displayStyle,
    });

    factory MusicItemThumbnailOverlayRenderer.fromJson(Map<String, dynamic> json) => MusicItemThumbnailOverlayRenderer(
        background: Background.fromJson(json["background"] ?? {}),
        content: MusicItemThumbnailOverlayRendererContent.fromJson(json["content"] ?? {}),
        contentPosition: contentPositionValues.map[json["contentPosition"]] ?? ContentPosition.values[0],
        displayStyle: displayStyleValues.map[json["displayStyle"]] ?? DisplayStyle.values[0],
    );

    Map<String, dynamic> toJson() => {
        "background": background.toJson(),
        "content": content.toJson(),
        "contentPosition": contentPositionValues.reverse[contentPosition],
        "displayStyle": displayStyleValues.reverse[displayStyle],
    };
}

class Background {
    final VerticalGradient verticalGradient;

    Background({
        required this.verticalGradient,
    });

    factory Background.fromJson(Map<String, dynamic> json) => Background(
        verticalGradient: VerticalGradient.fromJson(json["verticalGradient"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "verticalGradient": verticalGradient.toJson(),
    };
}

class VerticalGradient {
    final List<String> gradientLayerColors;

    VerticalGradient({
        required this.gradientLayerColors,
    });

    factory VerticalGradient.fromJson(Map<String, dynamic> json) => VerticalGradient(
      gradientLayerColors: json["gradientLayerColors"] == null 
        ? <String>[] 
        : List<String>.from(json["gradientLayerColors"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "gradientLayerColors": List<dynamic>.from(gradientLayerColors.map((x) => x)),
    };
}

class MusicItemThumbnailOverlayRendererContent {
    final MusicPlayButtonRenderer musicPlayButtonRenderer;

    MusicItemThumbnailOverlayRendererContent({
        required this.musicPlayButtonRenderer,
    });

    factory MusicItemThumbnailOverlayRendererContent.fromJson(Map<String, dynamic> json) => MusicItemThumbnailOverlayRendererContent(
        musicPlayButtonRenderer: MusicPlayButtonRenderer.fromJson(json["musicPlayButtonRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicPlayButtonRenderer": musicPlayButtonRenderer.toJson(),
    };
}

class MusicPlayButtonRenderer {
    final NavigationEndpoint playNavigationEndpoint;
    final String trackingParams;
    final Icon playIcon;
    final Icon pauseIcon;
    final int iconColor;
    final int backgroundColor;
    final int activeBackgroundColor;
    final int loadingIndicatorColor;
    final Icon playingIcon;
    final int iconLoadingColor;
    final int activeScaleFactor;
    final ButtonSize buttonSize;
    final RippleTarget rippleTarget;
    final AccessibilityData accessibilityPlayData;
    final AccessibilityData accessibilityPauseData;

    MusicPlayButtonRenderer({
        required this.playNavigationEndpoint,
        required this.trackingParams,
        required this.playIcon,
        required this.pauseIcon,
        required this.iconColor,
        required this.backgroundColor,
        required this.activeBackgroundColor,
        required this.loadingIndicatorColor,
        required this.playingIcon,
        required this.iconLoadingColor,
        required this.activeScaleFactor,
        required this.buttonSize,
        required this.rippleTarget,
        required this.accessibilityPlayData,
        required this.accessibilityPauseData,
    });

    factory MusicPlayButtonRenderer.fromJson(Map<String, dynamic> json) => MusicPlayButtonRenderer(
        playNavigationEndpoint: NavigationEndpoint.fromJson(json["playNavigationEndpoint"] ?? {}),
        trackingParams: json["trackingParams"] ?? '',
        playIcon: Icon.fromJson(json["playIcon"] ?? {}),
        pauseIcon: Icon.fromJson(json["pauseIcon"] ?? {}),
        iconColor: json["iconColor"] ?? 0,
        backgroundColor: json["backgroundColor"] ?? 0,
        activeBackgroundColor: json["activeBackgroundColor"] ?? 0,
        loadingIndicatorColor: json["loadingIndicatorColor"] ?? 0,
        playingIcon: Icon.fromJson(json["playingIcon"] ?? {}),
        iconLoadingColor: json["iconLoadingColor"] ?? 0,
        activeScaleFactor: json["activeScaleFactor"] ?? 0,
        buttonSize: buttonSizeValues.map[json["buttonSize"]] ?? ButtonSize.MUSIC_PLAY_BUTTON_SIZE_HUGE,
        rippleTarget: rippleTargetValues.map[json["rippleTarget"]] ?? RippleTarget.MUSIC_PLAY_BUTTON_RIPPLE_TARGET_SELF,
        accessibilityPlayData: AccessibilityData.fromJson(json["accessibilityPlayData"] ?? {}),
        accessibilityPauseData: AccessibilityData.fromJson(json["accessibilityPauseData"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "playNavigationEndpoint": playNavigationEndpoint.toJson(),
        "trackingParams": trackingParams,
        "playIcon": playIcon.toJson(),
        "pauseIcon": pauseIcon.toJson(),
        "iconColor": iconColor,
        "backgroundColor": backgroundColor,
        "activeBackgroundColor": activeBackgroundColor,
        "loadingIndicatorColor": loadingIndicatorColor,
        "playingIcon": playingIcon.toJson(),
        "iconLoadingColor": iconLoadingColor,
        "activeScaleFactor": activeScaleFactor,
        "buttonSize": buttonSizeValues.reverse[buttonSize],
        "rippleTarget": rippleTargetValues.reverse[rippleTarget],
        "accessibilityPlayData": accessibilityPlayData.toJson(),
        "accessibilityPauseData": accessibilityPauseData.toJson(),
    };
}

enum ButtonSize {
    MUSIC_PLAY_BUTTON_SIZE_HUGE,
    MUSIC_PLAY_BUTTON_SIZE_SMALL
}

final buttonSizeValues = EnumValues({
    "MUSIC_PLAY_BUTTON_SIZE_HUGE": ButtonSize.MUSIC_PLAY_BUTTON_SIZE_HUGE,
    "MUSIC_PLAY_BUTTON_SIZE_SMALL": ButtonSize.MUSIC_PLAY_BUTTON_SIZE_SMALL
});

class NavigationEndpoint {
    final String clickTrackingParams;
    final WatchEndpoint watchEndpoint;

    NavigationEndpoint({
        required this.clickTrackingParams,
        required this.watchEndpoint,
    });

    factory NavigationEndpoint.fromJson(Map<String, dynamic> json) => NavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"] ?? '',
        watchEndpoint: WatchEndpoint.fromJson(json["watchEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
    };
}

enum RippleTarget {
    MUSIC_PLAY_BUTTON_RIPPLE_TARGET_ANCESTOR,
    MUSIC_PLAY_BUTTON_RIPPLE_TARGET_SELF
}

final rippleTargetValues = EnumValues({
    "MUSIC_PLAY_BUTTON_RIPPLE_TARGET_ANCESTOR": RippleTarget.MUSIC_PLAY_BUTTON_RIPPLE_TARGET_ANCESTOR,
    "MUSIC_PLAY_BUTTON_RIPPLE_TARGET_SELF": RippleTarget.MUSIC_PLAY_BUTTON_RIPPLE_TARGET_SELF
});

enum ContentPosition {
    MUSIC_ITEM_THUMBNAIL_OVERLAY_CONTENT_POSITION_CENTERED
}

final contentPositionValues = EnumValues({
    "MUSIC_ITEM_THUMBNAIL_OVERLAY_CONTENT_POSITION_CENTERED": ContentPosition.MUSIC_ITEM_THUMBNAIL_OVERLAY_CONTENT_POSITION_CENTERED
});

enum DisplayStyle {
    MUSIC_ITEM_THUMBNAIL_OVERLAY_DISPLAY_STYLE_PERSISTENT
}

final displayStyleValues = EnumValues({
    "MUSIC_ITEM_THUMBNAIL_OVERLAY_DISPLAY_STYLE_PERSISTENT": DisplayStyle.MUSIC_ITEM_THUMBNAIL_OVERLAY_DISPLAY_STYLE_PERSISTENT
});

class ThumbnailRendererClass {
    final MusicThumbnailRenderer musicThumbnailRenderer;

    ThumbnailRendererClass({
        required this.musicThumbnailRenderer,
    });

    factory ThumbnailRendererClass.fromJson(Map<String, dynamic> json) => ThumbnailRendererClass(
        musicThumbnailRenderer: MusicThumbnailRenderer.fromJson(json["musicThumbnailRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicThumbnailRenderer": musicThumbnailRenderer.toJson(),
    };
}

class MusicThumbnailRenderer {
    final MusicThumbnailRendererThumbnail thumbnail;
    final ThumbnailCrop thumbnailCrop;
    final ThumbnailScale thumbnailScale;
    final String trackingParams;

    MusicThumbnailRenderer({
        required this.thumbnail,
        required this.thumbnailCrop,
        required this.thumbnailScale,
        required this.trackingParams,
    });

    factory MusicThumbnailRenderer.fromJson(Map<String, dynamic> json) => MusicThumbnailRenderer(
        thumbnail: MusicThumbnailRendererThumbnail.fromJson(json["thumbnail"] ?? {}),
        thumbnailCrop: thumbnailCropValues.map[json["thumbnailCrop"]] ?? ThumbnailCrop.MUSIC_THUMBNAIL_CROP_UNSPECIFIED,
        thumbnailScale: thumbnailScaleValues.map[json["thumbnailScale"]] ?? ThumbnailScale.MUSIC_THUMBNAIL_SCALE_ASPECT_FIT,
        trackingParams: json["trackingParams"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "thumbnail": thumbnail.toJson(),
        "thumbnailCrop": thumbnailCropValues.reverse[thumbnailCrop],
        "thumbnailScale": thumbnailScaleValues.reverse[thumbnailScale],
        "trackingParams": trackingParams,
    };
}

class MusicThumbnailRendererThumbnail {
    final List<ThumbnailElement> thumbnails;

    MusicThumbnailRendererThumbnail({
        required this.thumbnails,
    });

    factory MusicThumbnailRendererThumbnail.fromJson(Map<String, dynamic> json) => MusicThumbnailRendererThumbnail(
      thumbnails: json["thumbnails"] == null 
        ? <ThumbnailElement>[] 
        : List<ThumbnailElement>.from(json["thumbnails"].map((x) => ThumbnailElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "thumbnails": List<dynamic>.from(thumbnails.map((x) => x.toJson())),
    };
}

class ThumbnailElement {
    final String url;
    final int width;
    final int height;

    ThumbnailElement({
        required this.url,
        required this.width,
        required this.height,
    });

    factory ThumbnailElement.fromJson(Map<String, dynamic> json) => ThumbnailElement(
        url: json["url"] ?? '',
        width: json["width"] ?? 0,
        height: json["height"] ?? 0,
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
    };
}

enum ThumbnailCrop {
    MUSIC_THUMBNAIL_CROP_CIRCLE,
    MUSIC_THUMBNAIL_CROP_UNSPECIFIED
}

final thumbnailCropValues = EnumValues({
    "MUSIC_THUMBNAIL_CROP_CIRCLE": ThumbnailCrop.MUSIC_THUMBNAIL_CROP_CIRCLE,
    "MUSIC_THUMBNAIL_CROP_UNSPECIFIED": ThumbnailCrop.MUSIC_THUMBNAIL_CROP_UNSPECIFIED
});

enum ThumbnailScale {
    MUSIC_THUMBNAIL_SCALE_ASPECT_FILL,
    MUSIC_THUMBNAIL_SCALE_ASPECT_FIT
}

final thumbnailScaleValues = EnumValues({
    "MUSIC_THUMBNAIL_SCALE_ASPECT_FILL": ThumbnailScale.MUSIC_THUMBNAIL_SCALE_ASPECT_FILL,
    "MUSIC_THUMBNAIL_SCALE_ASPECT_FIT": ThumbnailScale.MUSIC_THUMBNAIL_SCALE_ASPECT_FIT
});

class MusicTwoRowItemRenderer {
    final ThumbnailRendererClass thumbnailRenderer;
    final AspectRatio aspectRatio;
    final TextClass title;
    final SubtitleClass subtitle;
    final NavigationEndpoint navigationEndpoint;
    final String trackingParams;
    final MusicTwoRowItemRendererMenu menu;
    final Overlay thumbnailOverlay;
    final CustomIndexColumn customIndexColumn;

    MusicTwoRowItemRenderer({
        required this.thumbnailRenderer,
        required this.aspectRatio,
        required this.title,
        required this.subtitle,
        required this.navigationEndpoint,
        required this.trackingParams,
        required this.menu,
        required this.thumbnailOverlay,
        required this.customIndexColumn,
    });

    factory MusicTwoRowItemRenderer.fromJson(Map<String, dynamic> json) => MusicTwoRowItemRenderer(
        thumbnailRenderer: ThumbnailRendererClass.fromJson(json["thumbnailRenderer"] ?? {}),
        aspectRatio: aspectRatioValues.map[json["aspectRatio"]] ?? AspectRatio.MUSIC_TWO_ROW_ITEM_THUMBNAIL_ASPECT_RATIO_RECTANGLE_169,
        title: TextClass.fromJson(json["title"] ?? {}),
        subtitle: SubtitleClass.fromJson(json["subtitle"] ?? {}),
        navigationEndpoint: NavigationEndpoint.fromJson(json["navigationEndpoint"] ?? {}),
        trackingParams: json["trackingParams"] ?? '',
        menu: MusicTwoRowItemRendererMenu.fromJson(json["menu"] ?? {}),
        thumbnailOverlay: Overlay.fromJson(json["thumbnailOverlay"] ?? {}),
        customIndexColumn: CustomIndexColumn.fromJson(json["customIndexColumn"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "thumbnailRenderer": thumbnailRenderer.toJson(),
        "aspectRatio": aspectRatioValues.reverse[aspectRatio],
        "title": title.toJson(),
        "subtitle": subtitle.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
        "trackingParams": trackingParams,
        "menu": menu.toJson(),
        "thumbnailOverlay": thumbnailOverlay.toJson(),
        "customIndexColumn": customIndexColumn.toJson(),
    };
}

enum AspectRatio {
    MUSIC_TWO_ROW_ITEM_THUMBNAIL_ASPECT_RATIO_RECTANGLE_169
}

final aspectRatioValues = EnumValues({
    "MUSIC_TWO_ROW_ITEM_THUMBNAIL_ASPECT_RATIO_RECTANGLE_16_9": AspectRatio.MUSIC_TWO_ROW_ITEM_THUMBNAIL_ASPECT_RATIO_RECTANGLE_169
});

class MusicTwoRowItemRendererMenu {
    final FluffyMenuRenderer menuRenderer;

    MusicTwoRowItemRendererMenu({
        required this.menuRenderer,
    });

    factory MusicTwoRowItemRendererMenu.fromJson(Map<String, dynamic> json) => MusicTwoRowItemRendererMenu(
        menuRenderer: FluffyMenuRenderer.fromJson(json["menuRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "menuRenderer": menuRenderer.toJson(),
    };
}

class FluffyMenuRenderer {
    final List<ItemElement> items;
    final String trackingParams;
    final AccessibilityData accessibility;

    FluffyMenuRenderer({
        required this.items,
        required this.trackingParams,
        required this.accessibility,
    });

    factory FluffyMenuRenderer.fromJson(Map<String, dynamic> json) => FluffyMenuRenderer(
        items: json["items"] == null 
          ? <ItemElement>[] 
          : List<ItemElement>.from(json["items"].map((x) => ItemElement.fromJson(x))),
        trackingParams: json["trackingParams"] ?? '',
        accessibility: AccessibilityData.fromJson(json["accessibility"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "trackingParams": trackingParams,
        "accessibility": accessibility.toJson(),
    };
}

class SubtitleClass {
    final List<SubtitleRun> runs;

    SubtitleClass({
        required this.runs,
    });

    factory SubtitleClass.fromJson(Map<String, dynamic> json) => SubtitleClass(
      runs: json["runs"] == null 
          ? <SubtitleRun>[] 
          : List<SubtitleRun>.from(json["runs"].map((x) => SubtitleRun.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
    };
}

class SubtitleRun {
    final String text;
    final MusicResponsiveListItemRendererNavigationEndpoint navigationEndpoint;

    SubtitleRun({
        required this.text,
        required this.navigationEndpoint,
    });

    factory SubtitleRun.fromJson(Map<String, dynamic> json) => SubtitleRun(
        text: json["text"] ?? "",
        navigationEndpoint: MusicResponsiveListItemRendererNavigationEndpoint.fromJson(json["navigationEndpoint"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "navigationEndpoint": navigationEndpoint.toJson(),
    };
}

class MusicCarouselShelfRendererHeader {
    final MusicCarouselShelfBasicHeaderRenderer musicCarouselShelfBasicHeaderRenderer;

    MusicCarouselShelfRendererHeader({
        required this.musicCarouselShelfBasicHeaderRenderer,
    });

    factory MusicCarouselShelfRendererHeader.fromJson(Map<String, dynamic> json) => MusicCarouselShelfRendererHeader(
        musicCarouselShelfBasicHeaderRenderer: MusicCarouselShelfBasicHeaderRenderer.fromJson(json["musicCarouselShelfBasicHeaderRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicCarouselShelfBasicHeaderRenderer": musicCarouselShelfBasicHeaderRenderer.toJson(),
    };
}

class MusicCarouselShelfBasicHeaderRenderer {
    final SubtitleClass title;
    final AccessibilityData accessibilityData;
    final String headerStyle;
    final MoreContentButton moreContentButton;
    final String trackingParams;

    MusicCarouselShelfBasicHeaderRenderer({
        required this.title,
        required this.accessibilityData,
        required this.headerStyle,
        required this.moreContentButton,
        required this.trackingParams,
    });

    factory MusicCarouselShelfBasicHeaderRenderer.fromJson(Map<String, dynamic> json) => MusicCarouselShelfBasicHeaderRenderer(
        title: SubtitleClass.fromJson(json["title"] ?? {}),
        accessibilityData: AccessibilityData.fromJson(json["accessibilityData"] ?? {}),
        headerStyle: json["headerStyle"] ?? "",
        moreContentButton: MoreContentButton.fromJson(json["moreContentButton"] ?? {}),
        trackingParams: json["trackingParams"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "accessibilityData": accessibilityData.toJson(),
        "headerStyle": headerStyle,
        "moreContentButton": moreContentButton.toJson(),
        "trackingParams": trackingParams,
    };
}

class MoreContentButton {
    final MoreContentButtonButtonRenderer buttonRenderer;

    MoreContentButton({
        required this.buttonRenderer,
    });

    factory MoreContentButton.fromJson(Map<String, dynamic> json) => MoreContentButton(
        buttonRenderer: MoreContentButtonButtonRenderer.fromJson(json["buttonRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "buttonRenderer": buttonRenderer.toJson(),
    };
}

class MoreContentButtonButtonRenderer {
    final String style;
    final TextClass text;
    final MusicResponsiveListItemRendererNavigationEndpoint navigationEndpoint;
    final String trackingParams;
    final AccessibilityData accessibilityData;

    MoreContentButtonButtonRenderer({
        required this.style,
        required this.text,
        required this.navigationEndpoint,
        required this.trackingParams,
        required this.accessibilityData,
    });

    factory MoreContentButtonButtonRenderer.fromJson(Map<String, dynamic> json) => MoreContentButtonButtonRenderer(
        style: json["style"] ?? "",
        text: TextClass.fromJson(json["text"] ?? {}),
        navigationEndpoint: MusicResponsiveListItemRendererNavigationEndpoint.fromJson(json["navigationEndpoint"] ?? {}),
        trackingParams: json["trackingParams"] ?? "",
        accessibilityData: AccessibilityData.fromJson(json["accessibilityData"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "style": style,
        "text": text.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
        "trackingParams": trackingParams,
        "accessibilityData": accessibilityData.toJson(),
    };
}

class MusicShelfRenderer {
    final String trackingParams;
    final ShelfDivider shelfDivider;
    final List<Subheader> subheaders;

    MusicShelfRenderer({
        required this.trackingParams,
        required this.shelfDivider,
        required this.subheaders,
    });

    factory MusicShelfRenderer.fromJson(Map<String, dynamic> json) => MusicShelfRenderer(
        trackingParams: json["trackingParams"] ?? "",
        shelfDivider: ShelfDivider.fromJson(json["shelfDivider"] ?? {}),
        subheaders: json["subheaders"] == null 
          ? <Subheader>[] 
          : List<Subheader>.from(json["subheaders"].map((x) => Subheader.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "trackingParams": trackingParams,
        "shelfDivider": shelfDivider.toJson(),
        "subheaders": List<dynamic>.from(subheaders.map((x) => x.toJson())),
    };
}

class ShelfDivider {
    final MusicShelfDividerRenderer musicShelfDividerRenderer;

    ShelfDivider({
        required this.musicShelfDividerRenderer,
    });

    factory ShelfDivider.fromJson(Map<String, dynamic> json) => ShelfDivider(
        musicShelfDividerRenderer: MusicShelfDividerRenderer.fromJson(json["musicShelfDividerRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicShelfDividerRenderer": musicShelfDividerRenderer.toJson(),
    };
}

class MusicShelfDividerRenderer {
    final bool hidden;

    MusicShelfDividerRenderer({
        required this.hidden,
    });

    factory MusicShelfDividerRenderer.fromJson(Map<String, dynamic> json) => MusicShelfDividerRenderer(
        hidden: json["hidden"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "hidden": hidden,
    };
}

class Subheader {
    final MusicSideAlignedItemRenderer musicSideAlignedItemRenderer;

    Subheader({
        required this.musicSideAlignedItemRenderer,
    });

    factory Subheader.fromJson(Map<String, dynamic> json) => Subheader(
        musicSideAlignedItemRenderer: MusicSideAlignedItemRenderer.fromJson(json["musicSideAlignedItemRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "musicSideAlignedItemRenderer": musicSideAlignedItemRenderer.toJson(),
    };
}

class MusicSideAlignedItemRenderer {
    final List<StartItem> startItems;
    final String trackingParams;

    MusicSideAlignedItemRenderer({
        required this.startItems,
        required this.trackingParams,
    });

    factory MusicSideAlignedItemRenderer.fromJson(Map<String, dynamic> json) => MusicSideAlignedItemRenderer(
        startItems: List<StartItem>.from(json["startItems"].map((x) => StartItem.fromJson(x))),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "startItems": List<dynamic>.from(startItems.map((x) => x.toJson())),
        "trackingParams": trackingParams,
    };
}

class StartItem {
    final MusicSortFilterButtonRenderer musicSortFilterButtonRenderer;

    StartItem({
        required this.musicSortFilterButtonRenderer,
    });

    factory StartItem.fromJson(Map<String, dynamic> json) => StartItem(
        musicSortFilterButtonRenderer: MusicSortFilterButtonRenderer.fromJson(json["musicSortFilterButtonRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "musicSortFilterButtonRenderer": musicSortFilterButtonRenderer.toJson(),
    };
}

class MusicSortFilterButtonRenderer {
    final TextClass title;
    final Icon icon;
    final MusicSortFilterButtonRendererMenu menu;
    final AccessibilityData accessibility;
    final String trackingParams;

    MusicSortFilterButtonRenderer({
        required this.title,
        required this.icon,
        required this.menu,
        required this.accessibility,
        required this.trackingParams,
    });

    factory MusicSortFilterButtonRenderer.fromJson(Map<String, dynamic> json) => MusicSortFilterButtonRenderer(
        title: TextClass.fromJson(json["title"]),
        icon: Icon.fromJson(json["icon"]),
        menu: MusicSortFilterButtonRendererMenu.fromJson(json["menu"]),
        accessibility: AccessibilityData.fromJson(json["accessibility"]),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "icon": icon.toJson(),
        "menu": menu.toJson(),
        "accessibility": accessibility.toJson(),
        "trackingParams": trackingParams,
    };
}

class MusicSortFilterButtonRendererMenu {
    final MusicMultiSelectMenuRenderer musicMultiSelectMenuRenderer;

    MusicSortFilterButtonRendererMenu({
        required this.musicMultiSelectMenuRenderer,
    });

    factory MusicSortFilterButtonRendererMenu.fromJson(Map<String, dynamic> json) => MusicSortFilterButtonRendererMenu(
        musicMultiSelectMenuRenderer: MusicMultiSelectMenuRenderer.fromJson(json["musicMultiSelectMenuRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "musicMultiSelectMenuRenderer": musicMultiSelectMenuRenderer.toJson(),
    };
}

class MusicMultiSelectMenuRenderer {
    final MusicMultiSelectMenuRendererTitle title;
    final List<Option> options;
    final String trackingParams;
    final Id formEntityKey;

    MusicMultiSelectMenuRenderer({
        required this.title,
        required this.options,
        required this.trackingParams,
        required this.formEntityKey,
    });

    factory MusicMultiSelectMenuRenderer.fromJson(Map<String, dynamic> json) => MusicMultiSelectMenuRenderer(
        title: MusicMultiSelectMenuRendererTitle.fromJson(json["title"]),
        options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
        trackingParams: json["trackingParams"],
        formEntityKey: idValues.map[json["formEntityKey"]]!,
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "trackingParams": trackingParams,
        "formEntityKey": idValues.reverse[formEntityKey],
    };
}

enum Id {
    EI_VLE_H_BSB3_JL_X2_NO_YXJ0_C19_JB3_VUD_HJ5_X21_LBN_VF_MZ_E2_NZ_Y2_NTY3_IJABKAE_3_D
}

final idValues = EnumValues({
    "EiVleHBsb3JlX2NoYXJ0c19jb3VudHJ5X21lbnVfMzE2NzY2NTY3IJABKAE%3D": Id.EI_VLE_H_BSB3_JL_X2_NO_YXJ0_C19_JB3_VUD_HJ5_X21_LBN_VF_MZ_E2_NZ_Y2_NTY3_IJABKAE_3_D
});

class Option {
    final MusicMultiSelectMenuItemRenderer musicMultiSelectMenuItemRenderer;

    Option({
        required this.musicMultiSelectMenuItemRenderer,
    });

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        musicMultiSelectMenuItemRenderer: MusicMultiSelectMenuItemRenderer.fromJson(json["musicMultiSelectMenuItemRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicMultiSelectMenuItemRenderer": musicMultiSelectMenuItemRenderer.toJson(),
    };
}

class MusicMultiSelectMenuItemRenderer {
    final TextClass title;
    final String formItemEntityKey;
    final String trackingParams;
    final Icon selectedIcon;
    final AccessibilityData selectedAccessibility;
    final AccessibilityData deselectedAccessibility;

    MusicMultiSelectMenuItemRenderer({
        required this.title,
        required this.formItemEntityKey,
        required this.trackingParams,
        required this.selectedIcon,
        required this.selectedAccessibility,
        required this.deselectedAccessibility,
    });

    factory MusicMultiSelectMenuItemRenderer.fromJson(Map<String, dynamic> json) => MusicMultiSelectMenuItemRenderer(
        title: TextClass.fromJson(json["title"] ?? {}),
        formItemEntityKey: json["formItemEntityKey"] ?? "",
        trackingParams: json["trackingParams"] ?? "",
        selectedIcon: Icon.fromJson(json["selectedIcon"] ?? {}),
        selectedAccessibility: AccessibilityData.fromJson(json["selectedAccessibility"] ?? {}),
        deselectedAccessibility: AccessibilityData.fromJson(json["deselectedAccessibility"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "formItemEntityKey": formItemEntityKey,
        "trackingParams": trackingParams,
        "selectedIcon": selectedIcon.toJson(),
        "selectedAccessibility": selectedAccessibility.toJson(),
        "deselectedAccessibility": deselectedAccessibility.toJson(),
    };
}

class SelectedCommand {
    final String clickTrackingParams;
    final CommandExecutorCommand commandExecutorCommand;

    SelectedCommand({
        required this.clickTrackingParams,
        required this.commandExecutorCommand,
    });

    factory SelectedCommand.fromJson(Map<String, dynamic> json) => SelectedCommand(
        clickTrackingParams: json["clickTrackingParams"] ?? "",
        commandExecutorCommand: CommandExecutorCommand.fromJson(json["commandExecutorCommand"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "commandExecutorCommand": commandExecutorCommand.toJson(),
    };
}

class CommandExecutorCommand {
    final List<CommandExecutorCommandCommand> commands;

    CommandExecutorCommand({
        required this.commands,
    });

    factory CommandExecutorCommand.fromJson(Map<String, dynamic> json) => CommandExecutorCommand(
      commands: json["commands"] == null 
        ? <CommandExecutorCommandCommand>[] 
        : List<CommandExecutorCommandCommand>.from(json["commands"].map((x) => CommandExecutorCommandCommand.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "commands": List<dynamic>.from(commands.map((x) => x.toJson())),
    };
}

class CommandExecutorCommandCommand {
    final String clickTrackingParams;
    final MusicCheckboxFormItemMutatedCommand musicCheckboxFormItemMutatedCommand;
    final MusicBrowseFormBinderCommand musicBrowseFormBinderCommand;

    CommandExecutorCommandCommand({
        required this.clickTrackingParams,
        required this.musicCheckboxFormItemMutatedCommand,
        required this.musicBrowseFormBinderCommand,
    });

    factory CommandExecutorCommandCommand.fromJson(Map<String, dynamic> json) => CommandExecutorCommandCommand(
        clickTrackingParams: json["clickTrackingParams"] ?? "",
        musicCheckboxFormItemMutatedCommand: MusicCheckboxFormItemMutatedCommand.fromJson(json["musicCheckboxFormItemMutatedCommand"] ?? {}),
        musicBrowseFormBinderCommand: MusicBrowseFormBinderCommand.fromJson(json["musicBrowseFormBinderCommand"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "musicCheckboxFormItemMutatedCommand": musicCheckboxFormItemMutatedCommand.toJson(),
        "musicBrowseFormBinderCommand": musicBrowseFormBinderCommand.toJson(),
    };
}

class MusicBrowseFormBinderCommand {
    final MusicBrowseFormBinderCommandBrowseEndpoint browseEndpoint;
    final Id formEntityKey;

    MusicBrowseFormBinderCommand({
        required this.browseEndpoint,
        required this.formEntityKey,
    });

    factory MusicBrowseFormBinderCommand.fromJson(Map<String, dynamic> json) => MusicBrowseFormBinderCommand(
        browseEndpoint: MusicBrowseFormBinderCommandBrowseEndpoint.fromJson(json["browseEndpoint"] ?? {}),
        formEntityKey: idValues.map[json["formEntityKey"]] ?? Id.EI_VLE_H_BSB3_JL_X2_NO_YXJ0_C19_JB3_VUD_HJ5_X21_LBN_VF_MZ_E2_NZ_Y2_NTY3_IJABKAE_3_D,
    );

    Map<String, dynamic> toJson() => {
        "browseEndpoint": browseEndpoint.toJson(),
        "formEntityKey": idValues.reverse[formEntityKey],
    };
}

class MusicBrowseFormBinderCommandBrowseEndpoint {
    final BrowseId browseId;
    final NavigationType navigationType;

    MusicBrowseFormBinderCommandBrowseEndpoint({
        required this.browseId,
        required this.navigationType,
    });

    factory MusicBrowseFormBinderCommandBrowseEndpoint.fromJson(Map<String, dynamic> json) => MusicBrowseFormBinderCommandBrowseEndpoint(
        browseId: browseIdValues.map[json["browseId"]] ?? BrowseId.F_EMUSIC_CHARTS,
        navigationType: navigationTypeValues.map[json["navigationType"]] ?? NavigationType.BROWSE_NAVIGATION_TYPE_LOAD_IN_PLACE,
    );

    Map<String, dynamic> toJson() => {
        "browseId": browseIdValues.reverse[browseId],
        "navigationType": navigationTypeValues.reverse[navigationType],
    };
}

enum BrowseId {
    F_EMUSIC_CHARTS
}

final browseIdValues = EnumValues({
    "FEmusic_charts": BrowseId.F_EMUSIC_CHARTS
});

enum NavigationType {
    BROWSE_NAVIGATION_TYPE_LOAD_IN_PLACE
}

final navigationTypeValues = EnumValues({
    "BROWSE_NAVIGATION_TYPE_LOAD_IN_PLACE": NavigationType.BROWSE_NAVIGATION_TYPE_LOAD_IN_PLACE
});

class MusicCheckboxFormItemMutatedCommand {
    final String formItemEntityKey;
    final bool newCheckedState;

    MusicCheckboxFormItemMutatedCommand({
        required this.formItemEntityKey,
        required this.newCheckedState,
    });

    factory MusicCheckboxFormItemMutatedCommand.fromJson(Map<String, dynamic> json) => MusicCheckboxFormItemMutatedCommand(
        formItemEntityKey: json["formItemEntityKey"] ?? "",
        newCheckedState: json["newCheckedState"] ?? false,
    );

    Map<String, dynamic> toJson() => {
        "formItemEntityKey": formItemEntityKey,
        "newCheckedState": newCheckedState,
    };
}

class MusicMultiSelectMenuRendererTitle {
    final MusicMenuTitleRenderer musicMenuTitleRenderer;

    MusicMultiSelectMenuRendererTitle({
        required this.musicMenuTitleRenderer,
    });

    factory MusicMultiSelectMenuRendererTitle.fromJson(Map<String, dynamic> json) => MusicMultiSelectMenuRendererTitle(
        musicMenuTitleRenderer: MusicMenuTitleRenderer.fromJson(json["musicMenuTitleRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicMenuTitleRenderer": musicMenuTitleRenderer.toJson(),
    };
}

class MusicMenuTitleRenderer {
    final TextClass primaryText;

    MusicMenuTitleRenderer({
        required this.primaryText,
    });

    factory MusicMenuTitleRenderer.fromJson(Map<String, dynamic> json) => MusicMenuTitleRenderer(
        primaryText: TextClass.fromJson(json["primaryText"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "primaryText": primaryText.toJson(),
    };
}

class FrameworkUpdates {
    final EntityBatchUpdate entityBatchUpdate;

    FrameworkUpdates({
        required this.entityBatchUpdate,
    });

    factory FrameworkUpdates.fromJson(Map<String, dynamic> json) => FrameworkUpdates(
        entityBatchUpdate: EntityBatchUpdate.fromJson(json["entityBatchUpdate"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "entityBatchUpdate": entityBatchUpdate.toJson(),
    };
}

class EntityBatchUpdate {
    final List<Mutation> mutations;
    final Timestamp timestamp;

    EntityBatchUpdate({
        required this.mutations,
        required this.timestamp,
    });

    factory EntityBatchUpdate.fromJson(Map<String, dynamic> json) => EntityBatchUpdate(
        mutations: json["mutations"] == null 
          ? <Mutation>[] 
          : List<Mutation>.from(json["mutations"].map((x) => Mutation.fromJson(x))),
        timestamp: Timestamp.fromJson(json["timestamp"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "mutations": List<dynamic>.from(mutations.map((x) => x.toJson())),
        "timestamp": timestamp.toJson(),
    };
}

class Mutation {
    final String entityKey;
    final Type type;
    final Payload payload;

    Mutation({
        required this.entityKey,
        required this.type,
        required this.payload,
    });

    factory Mutation.fromJson(Map<String, dynamic> json) => Mutation(
        entityKey: json["entityKey"] ?? '',
        type: typeValues.map[json["type"]] ?? Type.ENTITY_MUTATION_TYPE_REPLACE,
        payload: Payload.fromJson(json["payload"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "entityKey": entityKey,
        "type": typeValues.reverse[type],
        "payload": payload.toJson(),
    };
}

class Payload {
    final MusicForm musicForm;
    final MusicFormBooleanChoice musicFormBooleanChoice;

    Payload({
        required this.musicForm,
        required this.musicFormBooleanChoice,
    });

    factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        musicForm: MusicForm.fromJson(json["musicForm"] ?? {}),
        musicFormBooleanChoice: MusicFormBooleanChoice.fromJson(json["musicFormBooleanChoice"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "musicForm": musicForm.toJson(),
        "musicFormBooleanChoice": musicFormBooleanChoice.toJson(),
    };
}

class MusicForm {
    final Id id;
    final List<String> booleanChoiceEntityKeys;

    MusicForm({
        required this.id,
        required this.booleanChoiceEntityKeys,
    });

    factory MusicForm.fromJson(Map<String, dynamic> json) => MusicForm(
        id: idValues.map[json["id"]] ?? Id.EI_VLE_H_BSB3_JL_X2_NO_YXJ0_C19_JB3_VUD_HJ5_X21_LBN_VF_MZ_E2_NZ_Y2_NTY3_IJABKAE_3_D,
        booleanChoiceEntityKeys: json["booleanChoiceEntityKeys"] == null 
          ? <String>[] 
          : List<String>.from(json["booleanChoiceEntityKeys"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": idValues.reverse[id],
        "booleanChoiceEntityKeys": List<dynamic>.from(booleanChoiceEntityKeys.map((x) => x)),
    };
}

class MusicFormBooleanChoice {
    final String id;
    final Id parentFormEntityKey;
    final bool selected;
    final String opaqueToken;

    MusicFormBooleanChoice({
        required this.id,
        required this.parentFormEntityKey,
        required this.selected,
        required this.opaqueToken,
    });

    factory MusicFormBooleanChoice.fromJson(Map<String, dynamic> json) => MusicFormBooleanChoice(
        id: json["id"] ?? '',
        parentFormEntityKey: idValues.map[json["parentFormEntityKey"]] ?? Id.EI_VLE_H_BSB3_JL_X2_NO_YXJ0_C19_JB3_VUD_HJ5_X21_LBN_VF_MZ_E2_NZ_Y2_NTY3_IJABKAE_3_D,
        selected: json["selected"] ?? false,
        opaqueToken: json["opaqueToken"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "parentFormEntityKey": idValues.reverse[parentFormEntityKey],
        "selected": selected,
        "opaqueToken": opaqueToken,
    };
}

enum Type {
    ENTITY_MUTATION_TYPE_REPLACE
}

final typeValues = EnumValues({
    "ENTITY_MUTATION_TYPE_REPLACE": Type.ENTITY_MUTATION_TYPE_REPLACE
});

class Timestamp {
    final String seconds;
    final int nanos;

    Timestamp({
        required this.seconds,
        required this.nanos,
    });

    factory Timestamp.fromJson(Map<String, dynamic> json) => Timestamp(
        seconds: json["seconds"],
        nanos: json["nanos"],
    );

    Map<String, dynamic> toJson() => {
        "seconds": seconds,
        "nanos": nanos,
    };
}

class YoutubeTrendingResponseHeader {
    final MusicHeaderRenderer musicHeaderRenderer;

    YoutubeTrendingResponseHeader({
        required this.musicHeaderRenderer,
    });

    factory YoutubeTrendingResponseHeader.fromJson(Map<String, dynamic> json) => YoutubeTrendingResponseHeader(
        musicHeaderRenderer: MusicHeaderRenderer.fromJson(json["musicHeaderRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "musicHeaderRenderer": musicHeaderRenderer.toJson(),
    };
}

class MusicHeaderRenderer {
    final TextClass title;
    final String trackingParams;

    MusicHeaderRenderer({
        required this.title,
        required this.trackingParams,
    });

    factory MusicHeaderRenderer.fromJson(Map<String, dynamic> json) => MusicHeaderRenderer(
        title: TextClass.fromJson(json["title"]),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "trackingParams": trackingParams,
    };
}

class ResponseContext {
    final String visitorData;
    final List<ServiceTrackingParam> serviceTrackingParams;

    ResponseContext({
        required this.visitorData,
        required this.serviceTrackingParams,
    });

    factory ResponseContext.fromJson(Map<String, dynamic> json) => ResponseContext(
        visitorData: json["visitorData"],
        serviceTrackingParams: List<ServiceTrackingParam>.from(json["serviceTrackingParams"].map((x) => ServiceTrackingParam.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "visitorData": visitorData,
        "serviceTrackingParams": List<dynamic>.from(serviceTrackingParams.map((x) => x.toJson())),
    };
}

class ServiceTrackingParam {
    final String service;
    final List<Param> params;

    ServiceTrackingParam({
        required this.service,
        required this.params,
    });

    factory ServiceTrackingParam.fromJson(Map<String, dynamic> json) => ServiceTrackingParam(
        service: json["service"],
        params: List<Param>.from(json["params"].map((x) => Param.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "service": service,
        "params": List<dynamic>.from(params.map((x) => x.toJson())),
    };
}

class Param {
    final String key;
    final String value;

    Param({
        required this.key,
        required this.value,
    });

    factory Param.fromJson(Map<String, dynamic> json) => Param(
        key: json["key"],
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
    };
}

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}