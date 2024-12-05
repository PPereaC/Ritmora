// ignore_for_file: prefer_if_null_operators

class YoutubeSearchSongsResponse {
    final ResponseContext responseContext;
    final Contents contents;
    final String trackingParams;

    YoutubeSearchSongsResponse({
        required this.responseContext,
        required this.contents,
        required this.trackingParams,
    });

    factory YoutubeSearchSongsResponse.fromJson(Map<String, dynamic> json) => YoutubeSearchSongsResponse(
        responseContext: ResponseContext.fromJson(json["responseContext"] ?? {}),
        contents: Contents.fromJson(json["contents"] ?? {}),
        trackingParams: json["trackingParams"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "responseContext": responseContext.toJson(),
        "contents": contents.toJson(),
        "trackingParams": trackingParams,
    };
}

class Contents {
    final TabbedSearchResultsRenderer tabbedSearchResultsRenderer;

    Contents({
        required this.tabbedSearchResultsRenderer,
    });

    factory Contents.fromJson(Map<String, dynamic> json) => Contents(
        tabbedSearchResultsRenderer: TabbedSearchResultsRenderer.fromJson(json["tabbedSearchResultsRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "tabbedSearchResultsRenderer": tabbedSearchResultsRenderer.toJson(),
    };
}

class TabbedSearchResultsRenderer {
    final List<Tab> tabs;

    TabbedSearchResultsRenderer({
        required this.tabs,
    });

    factory TabbedSearchResultsRenderer.fromJson(Map<String, dynamic> json) => TabbedSearchResultsRenderer(
        tabs: json["tabs"] != null ? List<Tab>.from(json["tabs"].map((x) => Tab.fromJson(x))) : [],
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
        tabRenderer: TabRenderer.fromJson(json["tabRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "tabRenderer": tabRenderer.toJson(),
    };
}

class TabRenderer {
    final String title;
    final bool selected;
    final TabRendererContent content;
    final String tabIdentifier;
    final String trackingParams;

    TabRenderer({
        required this.title,
        required this.selected,
        required this.content,
        required this.tabIdentifier,
        required this.trackingParams,
    });

    factory TabRenderer.fromJson(Map<String, dynamic> json) => TabRenderer(
        title: json["title"] ?? '',
        selected: json["selected"] ?? false,
        content: TabRendererContent.fromJson(json["content"] ?? {}),
        tabIdentifier: json["tabIdentifier"] ?? '',
        trackingParams: json["trackingParams"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "selected": selected,
        "content": content.toJson(),
        "tabIdentifier": tabIdentifier,
        "trackingParams": trackingParams,
    };
}

class TabRendererContent {
    final SectionListRenderer sectionListRenderer;

    TabRendererContent({
        required this.sectionListRenderer,
    });

    factory TabRendererContent.fromJson(Map<String, dynamic> json) => TabRendererContent(
        sectionListRenderer: SectionListRenderer.fromJson(json["sectionListRenderer"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "sectionListRenderer": sectionListRenderer.toJson(),
    };
}

class SectionListRenderer {
    final List<SectionListRendererContent> contents;
    final String trackingParams;
    final SectionListRendererHeader header;

    SectionListRenderer({
        required this.contents,
        required this.trackingParams,
        required this.header,
    });

    factory SectionListRenderer.fromJson(Map<String, dynamic> json) => SectionListRenderer(
        contents: json["contents"] != null ? List<SectionListRendererContent>.from(json["contents"].map((x) => SectionListRendererContent.fromJson(x))) : [],
        trackingParams: json["trackingParams"] ?? '',
        header: SectionListRendererHeader.fromJson(json["header"] ?? {}),
    );

    Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
        "trackingParams": trackingParams,
        "header": header.toJson(),
    };
}

class SectionListRendererContent {
    final ItemSectionRenderer itemSectionRenderer;
    final MusicCardShelfRenderer musicCardShelfRenderer;
    final MusicShelfRenderer musicShelfRenderer;

    SectionListRendererContent({
        required this.itemSectionRenderer,
        required this.musicCardShelfRenderer,
        required this.musicShelfRenderer,
    });

    factory SectionListRendererContent.fromJson(Map<String, dynamic> json) => SectionListRendererContent(
        itemSectionRenderer: ItemSectionRenderer.fromJson(json["itemSectionRenderer"]),
        musicCardShelfRenderer: MusicCardShelfRenderer.fromJson(json["musicCardShelfRenderer"]),
        musicShelfRenderer: MusicShelfRenderer.fromJson(json["musicShelfRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "itemSectionRenderer": itemSectionRenderer.toJson(),
        "musicCardShelfRenderer": musicCardShelfRenderer.toJson(),
        "musicShelfRenderer": musicShelfRenderer.toJson(),
    };
}

class ItemSectionRenderer {
    final List<ItemSectionRendererContent> contents;
    final String trackingParams;

    ItemSectionRenderer({
        required this.contents,
        required this.trackingParams,
    });

    factory ItemSectionRenderer.fromJson(Map<String, dynamic> json) => ItemSectionRenderer(
        contents: List<ItemSectionRendererContent>.from(json["contents"].map((x) => ItemSectionRendererContent.fromJson(x))),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
        "trackingParams": trackingParams,
    };
}

class ItemSectionRendererContent {
    final MessageRenderer messageRenderer;
    final MusicResponsiveListItemRenderer? musicResponsiveListItemRenderer; // Añadir este campo

    ItemSectionRendererContent({
        required this.messageRenderer,
        this.musicResponsiveListItemRenderer, // Hacerlo opcional
    });

    factory ItemSectionRendererContent.fromJson(Map<String, dynamic> json) => ItemSectionRendererContent(
        messageRenderer: MessageRenderer.fromJson(json["messageRenderer"] ?? {}),
        musicResponsiveListItemRenderer: json["musicResponsiveListItemRenderer"] != null 
            ? MusicResponsiveListItemRenderer.fromJson(json["musicResponsiveListItemRenderer"])
            : null,
    );

    Map<String, dynamic> toJson() => {
        "messageRenderer": messageRenderer.toJson(),
        if (musicResponsiveListItemRenderer != null)
          "musicResponsiveListItemRenderer": musicResponsiveListItemRenderer!.toJson(),
    };
}

class MessageRenderer {
    final String trackingParams;
    final MessageRendererButton button;
    final MessageRendererStyle style;

    MessageRenderer({
        required this.trackingParams,
        required this.button,
        required this.style,
    });

    factory MessageRenderer.fromJson(Map<String, dynamic> json) => MessageRenderer(
        trackingParams: json["trackingParams"],
        button: MessageRendererButton.fromJson(json["button"]),
        style: MessageRendererStyle.fromJson(json["style"]),
    );

    Map<String, dynamic> toJson() => {
        "trackingParams": trackingParams,
        "button": button.toJson(),
        "style": style.toJson(),
    };
}

class MessageRendererButton {
    final PurpleButtonRenderer buttonRenderer;

    MessageRendererButton({
        required this.buttonRenderer,
    });

    factory MessageRendererButton.fromJson(Map<String, dynamic> json) => MessageRendererButton(
        buttonRenderer: PurpleButtonRenderer.fromJson(json["buttonRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "buttonRenderer": buttonRenderer.toJson(),
    };
}

class PurpleButtonRenderer {
    final String style;
    final bool isDisabled;
    final ButtonRendererText text;
    final Icon icon;
    final PurpleNavigationEndpoint navigationEndpoint;
    final String trackingParams;
    final String iconPosition;

    PurpleButtonRenderer({
        required this.style,
        required this.isDisabled,
        required this.text,
        required this.icon,
        required this.navigationEndpoint,
        required this.trackingParams,
        required this.iconPosition,
    });

    factory PurpleButtonRenderer.fromJson(Map<String, dynamic> json) => PurpleButtonRenderer(
        style: json["style"],
        isDisabled: json["isDisabled"],
        text: ButtonRendererText.fromJson(json["text"]),
        icon: Icon.fromJson(json["icon"]),
        navigationEndpoint: PurpleNavigationEndpoint.fromJson(json["navigationEndpoint"]),
        trackingParams: json["trackingParams"],
        iconPosition: json["iconPosition"],
    );

    Map<String, dynamic> toJson() => {
        "style": style,
        "isDisabled": isDisabled,
        "text": text.toJson(),
        "icon": icon.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
        "trackingParams": trackingParams,
        "iconPosition": iconPosition,
    };
}

class Icon {
    final String iconType;

    Icon({
        required this.iconType,
    });

    factory Icon.fromJson(Map<String, dynamic> json) => Icon(
        iconType: json["iconType"],
    );

    Map<String, dynamic> toJson() => {
        "iconType": iconType,
    };
}

class PurpleNavigationEndpoint {
    final String clickTrackingParams;
    final UrlEndpoint urlEndpoint;

    PurpleNavigationEndpoint({
        required this.clickTrackingParams,
        required this.urlEndpoint,
    });

    factory PurpleNavigationEndpoint.fromJson(Map<String, dynamic> json) => PurpleNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        urlEndpoint: UrlEndpoint.fromJson(json["urlEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "urlEndpoint": urlEndpoint.toJson(),
    };
}

class UrlEndpoint {
    final String url;
    final String target;

    UrlEndpoint({
        required this.url,
        required this.target,
    });

    factory UrlEndpoint.fromJson(Map<String, dynamic> json) => UrlEndpoint(
        url: json["url"],
        target: json["target"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
        "target": target,
    };
}

class ButtonRendererText {
    final String simpleText;

    ButtonRendererText({
        required this.simpleText,
    });

    factory ButtonRendererText.fromJson(Map<String, dynamic> json) => ButtonRendererText(
        simpleText: json["simpleText"],
    );

    Map<String, dynamic> toJson() => {
        "simpleText": simpleText,
    };
}

class MessageRendererStyle {
    final String value;

    MessageRendererStyle({
        required this.value,
    });

    factory MessageRendererStyle.fromJson(Map<String, dynamic> json) => MessageRendererStyle(
        value: json["value"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
    };
}

class MusicCardShelfRenderer {
    final String trackingParams;
    final Title title;
    final Subtitle subtitle;
    final List<ButtonElement> buttons;
    final OnTap onTap;
    final MusicCardShelfRendererHeader header;

    MusicCardShelfRenderer({
        required this.trackingParams,
        required this.title,
        required this.subtitle,
        required this.buttons,
        required this.onTap,
        required this.header,
    });

    factory MusicCardShelfRenderer.fromJson(Map<String, dynamic> json) => MusicCardShelfRenderer(
        trackingParams: json["trackingParams"],
        title: Title.fromJson(json["title"]),
        subtitle: Subtitle.fromJson(json["subtitle"]),
        buttons: List<ButtonElement>.from(json["buttons"].map((x) => ButtonElement.fromJson(x))),
        onTap: OnTap.fromJson(json["onTap"]),
        header: MusicCardShelfRendererHeader.fromJson(json["header"]),
    );

    Map<String, dynamic> toJson() => {
        "trackingParams": trackingParams,
        "title": title.toJson(),
        "subtitle": subtitle.toJson(),
        "buttons": List<dynamic>.from(buttons.map((x) => x.toJson())),
        "onTap": onTap.toJson(),
        "header": header.toJson(),
    };
}

class ButtonElement {
    final FluffyButtonRenderer buttonRenderer;

    ButtonElement({
        required this.buttonRenderer,
    });

    factory ButtonElement.fromJson(Map<String, dynamic> json) => ButtonElement(
        buttonRenderer: FluffyButtonRenderer.fromJson(json["buttonRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "buttonRenderer": buttonRenderer.toJson(),
    };
}

class FluffyButtonRenderer {
    final String style;
    final String size;
    final bool isDisabled;
    final BottomText text;
    final Icon icon;
    final AccessibilityAccessibilityData accessibility;
    final String trackingParams;
    final AccessibilityPauseDataClass accessibilityData;
    final ButtonRendererCommand command;

    FluffyButtonRenderer({
        required this.style,
        required this.size,
        required this.isDisabled,
        required this.text,
        required this.icon,
        required this.accessibility,
        required this.trackingParams,
        required this.accessibilityData,
        required this.command,
    });

    factory FluffyButtonRenderer.fromJson(Map<String, dynamic> json) => FluffyButtonRenderer(
        style: json["style"],
        size: json["size"],
        isDisabled: json["isDisabled"],
        text: BottomText.fromJson(json["text"]),
        icon: Icon.fromJson(json["icon"]),
        accessibility: AccessibilityAccessibilityData.fromJson(json["accessibility"]),
        trackingParams: json["trackingParams"],
        accessibilityData: AccessibilityPauseDataClass.fromJson(json["accessibilityData"]),
        command: ButtonRendererCommand.fromJson(json["command"]),
    );

    Map<String, dynamic> toJson() => {
        "style": style,
        "size": size,
        "isDisabled": isDisabled,
        "text": text.toJson(),
        "icon": icon.toJson(),
        "accessibility": accessibility.toJson(),
        "trackingParams": trackingParams,
        "accessibilityData": accessibilityData.toJson(),
        "command": command.toJson(),
    };
}

class AccessibilityAccessibilityData {
    final String label;

    AccessibilityAccessibilityData({
        required this.label,
    });

    factory AccessibilityAccessibilityData.fromJson(Map<String, dynamic> json) => AccessibilityAccessibilityData(
        label: json["label"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
    };
}

class AccessibilityPauseDataClass {
    final AccessibilityAccessibilityData accessibilityData;

    AccessibilityPauseDataClass({
        required this.accessibilityData,
    });

    factory AccessibilityPauseDataClass.fromJson(Map<String, dynamic> json) => AccessibilityPauseDataClass(
        accessibilityData: AccessibilityAccessibilityData.fromJson(json["accessibilityData"]),
    );

    Map<String, dynamic> toJson() => {
        "accessibilityData": accessibilityData.toJson(),
    };
}

class ButtonRendererCommand {
    final String clickTrackingParams;
    final CommandWatchEndpoint watchEndpoint;
    final ModalEndpoint modalEndpoint;

    ButtonRendererCommand({
        required this.clickTrackingParams,
        required this.watchEndpoint,
        required this.modalEndpoint,
    });

    factory ButtonRendererCommand.fromJson(Map<String, dynamic> json) => ButtonRendererCommand(
        clickTrackingParams: json["clickTrackingParams"],
        watchEndpoint: CommandWatchEndpoint.fromJson(json["watchEndpoint"]),
        modalEndpoint: ModalEndpoint.fromJson(json["modalEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
        "modalEndpoint": modalEndpoint.toJson(),
    };
}

class ModalEndpoint {
    final Modal modal;

    ModalEndpoint({
        required this.modal,
    });

    factory ModalEndpoint.fromJson(Map<String, dynamic> json) => ModalEndpoint(
        modal: Modal.fromJson(json["modal"]),
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
        modalWithTitleAndButtonRenderer: ModalWithTitleAndButtonRenderer.fromJson(json["modalWithTitleAndButtonRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "modalWithTitleAndButtonRenderer": modalWithTitleAndButtonRenderer.toJson(),
    };
}

class ModalWithTitleAndButtonRenderer {
    final BottomText title;
    final BottomText content;
    final ModalWithTitleAndButtonRendererButton button;

    ModalWithTitleAndButtonRenderer({
        required this.title,
        required this.content,
        required this.button,
    });

    factory ModalWithTitleAndButtonRenderer.fromJson(Map<String, dynamic> json) => ModalWithTitleAndButtonRenderer(
        title: BottomText.fromJson(json["title"]),
        content: BottomText.fromJson(json["content"]),
        button: ModalWithTitleAndButtonRendererButton.fromJson(json["button"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "content": content.toJson(),
        "button": button.toJson(),
    };
}

class ModalWithTitleAndButtonRendererButton {
    final TentacledButtonRenderer buttonRenderer;

    ModalWithTitleAndButtonRendererButton({
        required this.buttonRenderer,
    });

    factory ModalWithTitleAndButtonRendererButton.fromJson(Map<String, dynamic> json) => ModalWithTitleAndButtonRendererButton(
        buttonRenderer: TentacledButtonRenderer.fromJson(json["buttonRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "buttonRenderer": buttonRenderer.toJson(),
    };
}

class TentacledButtonRenderer {
    final StyleEnum style;
    final bool isDisabled;
    final BottomText text;
    final FluffyNavigationEndpoint navigationEndpoint;
    final String trackingParams;

    TentacledButtonRenderer({
        required this.style,
        required this.isDisabled,
        required this.text,
        required this.navigationEndpoint,
        required this.trackingParams,
    });

    factory TentacledButtonRenderer.fromJson(Map<String, dynamic> json) => TentacledButtonRenderer(
        style: styleEnumValues.map[json["style"]]!,
        isDisabled: json["isDisabled"],
        text: BottomText.fromJson(json["text"]),
        navigationEndpoint: FluffyNavigationEndpoint.fromJson(json["navigationEndpoint"]),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "style": styleEnumValues.reverse[style],
        "isDisabled": isDisabled,
        "text": text.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
        "trackingParams": trackingParams,
    };
}

class FluffyNavigationEndpoint {
    final String clickTrackingParams;
    final SignInEndpoint signInEndpoint;

    FluffyNavigationEndpoint({
        required this.clickTrackingParams,
        required this.signInEndpoint,
    });

    factory FluffyNavigationEndpoint.fromJson(Map<String, dynamic> json) => FluffyNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        signInEndpoint: SignInEndpoint.fromJson(json["signInEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "signInEndpoint": signInEndpoint.toJson(),
    };
}

class SignInEndpoint {
    final bool hack;

    SignInEndpoint({
        required this.hack,
    });

    factory SignInEndpoint.fromJson(Map<String, dynamic> json) => SignInEndpoint(
        hack: json["hack"],
    );

    Map<String, dynamic> toJson() => {
        "hack": hack,
    };
}

enum StyleEnum {
    STYLE_BLUE_TEXT
}

final styleEnumValues = EnumValues({
    "STYLE_BLUE_TEXT": StyleEnum.STYLE_BLUE_TEXT
});

class BottomText {
    final List<BottomTextRun> runs;

    BottomText({
        required this.runs,
    });

    factory BottomText.fromJson(Map<String, dynamic> json) => BottomText(
        runs: List<BottomTextRun>.from(json["runs"].map((x) => BottomTextRun.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
    };
}

class BottomTextRun {
    final String text;

    BottomTextRun({
        required this.text,
    });

    factory BottomTextRun.fromJson(Map<String, dynamic> json) => BottomTextRun(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}

class CommandWatchEndpoint {
    final String videoId;
    final String params;
    final WatchEndpointMusicSupportedConfigs watchEndpointMusicSupportedConfigs;

    CommandWatchEndpoint({
        required this.videoId,
        required this.params,
        required this.watchEndpointMusicSupportedConfigs,
    });

    factory CommandWatchEndpoint.fromJson(Map<String, dynamic> json) => CommandWatchEndpoint(
        videoId: json["videoId"],
        params: json["params"],
        watchEndpointMusicSupportedConfigs: WatchEndpointMusicSupportedConfigs.fromJson(json["watchEndpointMusicSupportedConfigs"]),
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "params": params,
        "watchEndpointMusicSupportedConfigs": watchEndpointMusicSupportedConfigs.toJson(),
    };
}

class WatchEndpointMusicSupportedConfigs {
    final WatchEndpointMusicConfig watchEndpointMusicConfig;

    WatchEndpointMusicSupportedConfigs({
        required this.watchEndpointMusicConfig,
    });

    factory WatchEndpointMusicSupportedConfigs.fromJson(Map<String, dynamic> json) => WatchEndpointMusicSupportedConfigs(
        watchEndpointMusicConfig: WatchEndpointMusicConfig.fromJson(json["watchEndpointMusicConfig"]),
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
        musicVideoType: musicVideoTypeValues.map[json["musicVideoType"]]!,
    );

    Map<String, dynamic> toJson() => {
        "musicVideoType": musicVideoTypeValues.reverse[musicVideoType],
    };
}

enum MusicVideoType {
    MUSIC_VIDEO_TYPE_ATV,
    MUSIC_VIDEO_TYPE_OMV,
    MUSIC_VIDEO_TYPE_PODCAST_EPISODE
}

final musicVideoTypeValues = EnumValues({
    "MUSIC_VIDEO_TYPE_ATV": MusicVideoType.MUSIC_VIDEO_TYPE_ATV,
    "MUSIC_VIDEO_TYPE_OMV": MusicVideoType.MUSIC_VIDEO_TYPE_OMV,
    "MUSIC_VIDEO_TYPE_PODCAST_EPISODE": MusicVideoType.MUSIC_VIDEO_TYPE_PODCAST_EPISODE
});

class MusicCardShelfRendererHeader {
    final MusicCardShelfHeaderBasicRenderer musicCardShelfHeaderBasicRenderer;

    MusicCardShelfRendererHeader({
        required this.musicCardShelfHeaderBasicRenderer,
    });

    factory MusicCardShelfRendererHeader.fromJson(Map<String, dynamic> json) => MusicCardShelfRendererHeader(
        musicCardShelfHeaderBasicRenderer: MusicCardShelfHeaderBasicRenderer.fromJson(json["musicCardShelfHeaderBasicRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "musicCardShelfHeaderBasicRenderer": musicCardShelfHeaderBasicRenderer.toJson(),
    };
}

class MusicCardShelfHeaderBasicRenderer {
    final BottomText title;
    final String trackingParams;

    MusicCardShelfHeaderBasicRenderer({
        required this.title,
        required this.trackingParams,
    });

    factory MusicCardShelfHeaderBasicRenderer.fromJson(Map<String, dynamic> json) => MusicCardShelfHeaderBasicRenderer(
        title: BottomText.fromJson(json["title"]),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "trackingParams": trackingParams,
    };
}

class MenuNavigationItemRendererNavigationEndpoint {
    final String clickTrackingParams;
    final PurpleWatchEndpoint watchEndpoint;
    final ModalEndpoint modalEndpoint;
    final BrowseEndpoint browseEndpoint;
    final ShareEntityEndpoint shareEntityEndpoint;
    final WatchPlaylistEndpoint watchPlaylistEndpoint;

    MenuNavigationItemRendererNavigationEndpoint({
        required this.clickTrackingParams,
        required this.watchEndpoint,
        required this.modalEndpoint,
        required this.browseEndpoint,
        required this.shareEntityEndpoint,
        required this.watchPlaylistEndpoint,
    });

    factory MenuNavigationItemRendererNavigationEndpoint.fromJson(Map<String, dynamic> json) => MenuNavigationItemRendererNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        watchEndpoint: PurpleWatchEndpoint.fromJson(json["watchEndpoint"]),
        modalEndpoint: ModalEndpoint.fromJson(json["modalEndpoint"]),
        browseEndpoint: BrowseEndpoint.fromJson(json["browseEndpoint"]),
        shareEntityEndpoint: ShareEntityEndpoint.fromJson(json["shareEntityEndpoint"]),
        watchPlaylistEndpoint: WatchPlaylistEndpoint.fromJson(json["watchPlaylistEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
        "modalEndpoint": modalEndpoint.toJson(),
        "browseEndpoint": browseEndpoint.toJson(),
        "shareEntityEndpoint": shareEntityEndpoint.toJson(),
        "watchPlaylistEndpoint": watchPlaylistEndpoint.toJson(),
    };
}

class BrowseEndpoint {
    final String browseId;
    final BrowseEndpointContextSupportedConfigs browseEndpointContextSupportedConfigs;

    BrowseEndpoint({
        required this.browseId,
        required this.browseEndpointContextSupportedConfigs,
    });

    factory BrowseEndpoint.fromJson(Map<String, dynamic> json) => BrowseEndpoint(
        browseId: json["browseId"],
        browseEndpointContextSupportedConfigs: BrowseEndpointContextSupportedConfigs.fromJson(json["browseEndpointContextSupportedConfigs"]),
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
        browseEndpointContextMusicConfig: BrowseEndpointContextMusicConfig.fromJson(json["browseEndpointContextMusicConfig"]),
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
        pageType: pageTypeValues.map[json["pageType"]]!,
    );

    Map<String, dynamic> toJson() => {
        "pageType": pageTypeValues.reverse[pageType],
    };
}

enum PageType {
    MUSIC_PAGE_TYPE_ALBUM,
    MUSIC_PAGE_TYPE_ARTIST,
    MUSIC_PAGE_TYPE_NON_MUSIC_AUDIO_TRACK_PAGE,
    MUSIC_PAGE_TYPE_PLAYLIST,
    MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE,
    MUSIC_PAGE_TYPE_TRACK_CREDITS,
    MUSIC_PAGE_TYPE_USER_CHANNEL
}

final pageTypeValues = EnumValues({
    "MUSIC_PAGE_TYPE_ALBUM": PageType.MUSIC_PAGE_TYPE_ALBUM,
    "MUSIC_PAGE_TYPE_ARTIST": PageType.MUSIC_PAGE_TYPE_ARTIST,
    "MUSIC_PAGE_TYPE_NON_MUSIC_AUDIO_TRACK_PAGE": PageType.MUSIC_PAGE_TYPE_NON_MUSIC_AUDIO_TRACK_PAGE,
    "MUSIC_PAGE_TYPE_PLAYLIST": PageType.MUSIC_PAGE_TYPE_PLAYLIST,
    "MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE": PageType.MUSIC_PAGE_TYPE_PODCAST_SHOW_DETAIL_PAGE,
    "MUSIC_PAGE_TYPE_TRACK_CREDITS": PageType.MUSIC_PAGE_TYPE_TRACK_CREDITS,
    "MUSIC_PAGE_TYPE_USER_CHANNEL": PageType.MUSIC_PAGE_TYPE_USER_CHANNEL
});

class ShareEntityEndpoint {
    final String serializedShareEntity;
    final SharePanelType sharePanelType;

    ShareEntityEndpoint({
        required this.serializedShareEntity,
        required this.sharePanelType,
    });

    factory ShareEntityEndpoint.fromJson(Map<String, dynamic> json) => ShareEntityEndpoint(
        serializedShareEntity: json["serializedShareEntity"],
        sharePanelType: sharePanelTypeValues.map[json["sharePanelType"]]!,
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

class PurpleWatchEndpoint {
    final String videoId;
    final String playlistId;
    final Params params;
    final LoggingContext loggingContext;
    final WatchEndpointMusicSupportedConfigs watchEndpointMusicSupportedConfigs;

    PurpleWatchEndpoint({
        required this.videoId,
        required this.playlistId,
        required this.params,
        required this.loggingContext,
        required this.watchEndpointMusicSupportedConfigs,
    });

    factory PurpleWatchEndpoint.fromJson(Map<String, dynamic> json) => PurpleWatchEndpoint(
        videoId: json["videoId"],
        playlistId: json["playlistId"],
        params: paramsValues.map[json["params"]]!,
        loggingContext: LoggingContext.fromJson(json["loggingContext"]),
        watchEndpointMusicSupportedConfigs: WatchEndpointMusicSupportedConfigs.fromJson(json["watchEndpointMusicSupportedConfigs"]),
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "playlistId": playlistId,
        "params": paramsValues.reverse[params],
        "loggingContext": loggingContext.toJson(),
        "watchEndpointMusicSupportedConfigs": watchEndpointMusicSupportedConfigs.toJson(),
    };
}

class LoggingContext {
    final VssLoggingContext vssLoggingContext;

    LoggingContext({
        required this.vssLoggingContext,
    });

    factory LoggingContext.fromJson(Map<String, dynamic> json) => LoggingContext(
        vssLoggingContext: VssLoggingContext.fromJson(json["vssLoggingContext"]),
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
        serializedContextData: json["serializedContextData"],
    );

    Map<String, dynamic> toJson() => {
        "serializedContextData": serializedContextData,
    };
}

enum Params {
    W_AEB,
    W_AEB8_G_ECGAE_3_D,
    W_AEB8_G_ECKAE_3_D
}

final paramsValues = EnumValues({
    "wAEB": Params.W_AEB,
    "wAEB8gECGAE%3D": Params.W_AEB8_G_ECGAE_3_D,
    "wAEB8gECKAE%3D": Params.W_AEB8_G_ECKAE_3_D
});

class WatchPlaylistEndpoint {
    final String playlistId;
    final Params params;

    WatchPlaylistEndpoint({
        required this.playlistId,
        required this.params,
    });

    factory WatchPlaylistEndpoint.fromJson(Map<String, dynamic> json) => WatchPlaylistEndpoint(
        playlistId: json["playlistId"],
        params: paramsValues.map[json["params"]]!,
    );

    Map<String, dynamic> toJson() => {
        "playlistId": playlistId,
        "params": paramsValues.reverse[params],
    };
}

class MenuNavigationItemRendererServiceEndpoint {
    final String clickTrackingParams;
    final QueueAddEndpoint queueAddEndpoint;

    MenuNavigationItemRendererServiceEndpoint({
        required this.clickTrackingParams,
        required this.queueAddEndpoint,
    });

    factory MenuNavigationItemRendererServiceEndpoint.fromJson(Map<String, dynamic> json) => MenuNavigationItemRendererServiceEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        queueAddEndpoint: QueueAddEndpoint.fromJson(json["queueAddEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "queueAddEndpoint": queueAddEndpoint.toJson(),
    };
}

class QueueAddEndpoint {
    final QueueTarget queueTarget;
    final QueueInsertPosition queueInsertPosition;
    final List<CommandElement> commands;

    QueueAddEndpoint({
        required this.queueTarget,
        required this.queueInsertPosition,
        required this.commands,
    });

    factory QueueAddEndpoint.fromJson(Map<String, dynamic> json) => QueueAddEndpoint(
        queueTarget: QueueTarget.fromJson(json["queueTarget"]),
        queueInsertPosition: queueInsertPositionValues.map[json["queueInsertPosition"]]!,
        commands: List<CommandElement>.from(json["commands"].map((x) => CommandElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "queueTarget": queueTarget.toJson(),
        "queueInsertPosition": queueInsertPositionValues.reverse[queueInsertPosition],
        "commands": List<dynamic>.from(commands.map((x) => x.toJson())),
    };
}

class CommandElement {
    final String clickTrackingParams;
    final AddToToastAction addToToastAction;

    CommandElement({
        required this.clickTrackingParams,
        required this.addToToastAction,
    });

    factory CommandElement.fromJson(Map<String, dynamic> json) => CommandElement(
        clickTrackingParams: json["clickTrackingParams"],
        addToToastAction: AddToToastAction.fromJson(json["addToToastAction"]),
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
        item: AddToToastActionItem.fromJson(json["item"]),
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
        notificationTextRenderer: NotificationTextRenderer.fromJson(json["notificationTextRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "notificationTextRenderer": notificationTextRenderer.toJson(),
    };
}

class NotificationTextRenderer {
    final BottomText successResponseText;
    final String trackingParams;

    NotificationTextRenderer({
        required this.successResponseText,
        required this.trackingParams,
    });

    factory NotificationTextRenderer.fromJson(Map<String, dynamic> json) => NotificationTextRenderer(
        successResponseText: BottomText.fromJson(json["successResponseText"]),
        trackingParams: json["trackingParams"],
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
    final String playlistId;

    QueueTarget({
        required this.videoId,
        required this.onEmptyQueue,
        required this.playlistId,
    });

    factory QueueTarget.fromJson(Map<String, dynamic> json) => QueueTarget(
        videoId: json["videoId"],
        onEmptyQueue: OnEmptyQueue.fromJson(json["onEmptyQueue"]),
        playlistId: json["playlistId"],
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "onEmptyQueue": onEmptyQueue.toJson(),
        "playlistId": playlistId,
    };
}

class OnEmptyQueue {
    final String clickTrackingParams;
    final OnEmptyQueueWatchEndpoint watchEndpoint;

    OnEmptyQueue({
        required this.clickTrackingParams,
        required this.watchEndpoint,
    });

    factory OnEmptyQueue.fromJson(Map<String, dynamic> json) => OnEmptyQueue(
        clickTrackingParams: json["clickTrackingParams"],
        watchEndpoint: OnEmptyQueueWatchEndpoint.fromJson(json["watchEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
    };
}

class OnEmptyQueueWatchEndpoint {
    final String videoId;
    final String playlistId;

    OnEmptyQueueWatchEndpoint({
        required this.videoId,
        required this.playlistId,
    });

    factory OnEmptyQueueWatchEndpoint.fromJson(Map<String, dynamic> json) => OnEmptyQueueWatchEndpoint(
        videoId: json["videoId"],
        playlistId: json["playlistId"],
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "playlistId": playlistId,
    };
}

class ToggleMenuServiceItemRenderer {
    final BottomText defaultText;
    final Icon defaultIcon;
    final DefaultServiceEndpoint defaultServiceEndpoint;
    final BottomText toggledText;
    final Icon toggledIcon;
    final String trackingParams;
    final ToggledServiceEndpoint toggledServiceEndpoint;

    ToggleMenuServiceItemRenderer({
        required this.defaultText,
        required this.defaultIcon,
        required this.defaultServiceEndpoint,
        required this.toggledText,
        required this.toggledIcon,
        required this.trackingParams,
        required this.toggledServiceEndpoint,
    });

    factory ToggleMenuServiceItemRenderer.fromJson(Map<String, dynamic> json) => ToggleMenuServiceItemRenderer(
        defaultText: BottomText.fromJson(json["defaultText"]),
        defaultIcon: Icon.fromJson(json["defaultIcon"]),
        defaultServiceEndpoint: DefaultServiceEndpoint.fromJson(json["defaultServiceEndpoint"]),
        toggledText: BottomText.fromJson(json["toggledText"]),
        toggledIcon: Icon.fromJson(json["toggledIcon"]),
        trackingParams: json["trackingParams"],
        toggledServiceEndpoint: ToggledServiceEndpoint.fromJson(json["toggledServiceEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "defaultText": defaultText.toJson(),
        "defaultIcon": defaultIcon.toJson(),
        "defaultServiceEndpoint": defaultServiceEndpoint.toJson(),
        "toggledText": toggledText.toJson(),
        "toggledIcon": toggledIcon.toJson(),
        "trackingParams": trackingParams,
        "toggledServiceEndpoint": toggledServiceEndpoint.toJson(),
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
        clickTrackingParams: json["clickTrackingParams"],
        modalEndpoint: ModalEndpoint.fromJson(json["modalEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "modalEndpoint": modalEndpoint.toJson(),
    };
}

class ToggledServiceEndpoint {
    final String clickTrackingParams;
    final LikeEndpoint likeEndpoint;

    ToggledServiceEndpoint({
        required this.clickTrackingParams,
        required this.likeEndpoint,
    });

    factory ToggledServiceEndpoint.fromJson(Map<String, dynamic> json) => ToggledServiceEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        likeEndpoint: LikeEndpoint.fromJson(json["likeEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "likeEndpoint": likeEndpoint.toJson(),
    };
}

class LikeEndpoint {
    final String status;
    final Target target;

    LikeEndpoint({
        required this.status,
        required this.target,
    });

    factory LikeEndpoint.fromJson(Map<String, dynamic> json) => LikeEndpoint(
        status: json["status"],
        target: Target.fromJson(json["target"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "target": target.toJson(),
    };
}

class Target {
    final String playlistId;

    Target({
        required this.playlistId,
    });

    factory Target.fromJson(Map<String, dynamic> json) => Target(
        playlistId: json["playlistId"],
    );

    Map<String, dynamic> toJson() => {
        "playlistId": playlistId,
    };
}

class OnTap {
    final String clickTrackingParams;
    final OnTapWatchEndpoint watchEndpoint;

    OnTap({
        required this.clickTrackingParams,
        required this.watchEndpoint,
    });

    factory OnTap.fromJson(Map<String, dynamic> json) => OnTap(
        clickTrackingParams: json["clickTrackingParams"],
        watchEndpoint: OnTapWatchEndpoint.fromJson(json["watchEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
    };
}

class OnTapWatchEndpoint {
    final String videoId;
    final WatchEndpointMusicSupportedConfigs watchEndpointMusicSupportedConfigs;

    OnTapWatchEndpoint({
        required this.videoId,
        required this.watchEndpointMusicSupportedConfigs,
    });

    factory OnTapWatchEndpoint.fromJson(Map<String, dynamic> json) => OnTapWatchEndpoint(
        videoId: json["videoId"],
        watchEndpointMusicSupportedConfigs: WatchEndpointMusicSupportedConfigs.fromJson(json["watchEndpointMusicSupportedConfigs"]),
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "watchEndpointMusicSupportedConfigs": watchEndpointMusicSupportedConfigs.toJson(),
    };
}

class Subtitle {
    final List<BottomTextRun> runs;
    final AccessibilityPauseDataClass accessibility;

    Subtitle({
        required this.runs,
        required this.accessibility,
    });

    factory Subtitle.fromJson(Map<String, dynamic> json) => Subtitle(
        runs: List<BottomTextRun>.from(json["runs"].map((x) => BottomTextRun.fromJson(x))),
        accessibility: AccessibilityPauseDataClass.fromJson(json["accessibility"]),
    );

    Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
        "accessibility": accessibility.toJson(),
    };
}

class Background {
    final VerticalGradient verticalGradient;

    Background({
        required this.verticalGradient,
    });

    factory Background.fromJson(Map<String, dynamic> json) => Background(
        verticalGradient: VerticalGradient.fromJson(json["verticalGradient"]),
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
        gradientLayerColors: List<String>.from(json["gradientLayerColors"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "gradientLayerColors": List<dynamic>.from(gradientLayerColors.map((x) => x)),
    };
}

enum RippleTarget {
    MUSIC_PLAY_BUTTON_RIPPLE_TARGET_SELF
}

final rippleTargetValues = EnumValues({
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

class Title {
    final List<PurpleRun> runs;

    Title({
        required this.runs,
    });

    factory Title.fromJson(Map<String, dynamic> json) => Title(
        runs: List<PurpleRun>.from(json["runs"].map((x) => PurpleRun.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
    };
}

class PurpleRun {
    final String text;
    final OnTap navigationEndpoint;

    PurpleRun({
        required this.text,
        required this.navigationEndpoint,
    });

    factory PurpleRun.fromJson(Map<String, dynamic> json) => PurpleRun(
        text: json["text"],
        navigationEndpoint: OnTap.fromJson(json["navigationEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "navigationEndpoint": navigationEndpoint.toJson(),
    };
}

class MusicShelfRenderer {
    final BottomText title;
    final List<MusicShelfRendererContent> contents;
    final String trackingParams;
    final BottomText bottomText;
    final Endpoint bottomEndpoint;
    final ShelfDivider shelfDivider;

    MusicShelfRenderer({
        required this.title,
        required this.contents,
        required this.trackingParams,
        required this.bottomText,
        required this.bottomEndpoint,
        required this.shelfDivider,
    });

    factory MusicShelfRenderer.fromJson(Map<String, dynamic> json) => MusicShelfRenderer(
        title: BottomText.fromJson(json["title"]),
        contents: List<MusicShelfRendererContent>.from(json["contents"].map((x) => MusicShelfRendererContent.fromJson(x))),
        trackingParams: json["trackingParams"],
        bottomText: BottomText.fromJson(json["bottomText"]),
        bottomEndpoint: Endpoint.fromJson(json["bottomEndpoint"]),
        shelfDivider: ShelfDivider.fromJson(json["shelfDivider"]),
    );

    Map<String, dynamic> toJson() => {
        "title": title.toJson(),
        "contents": List<dynamic>.from(contents.map((x) => x.toJson())),
        "trackingParams": trackingParams,
        "bottomText": bottomText.toJson(),
        "bottomEndpoint": bottomEndpoint.toJson(),
        "shelfDivider": shelfDivider.toJson(),
    };
}

class Endpoint {
    final String clickTrackingParams;
    final SearchEndpoint searchEndpoint;

    Endpoint({
        required this.clickTrackingParams,
        required this.searchEndpoint,
    });

    factory Endpoint.fromJson(Map<String, dynamic> json) => Endpoint(
        clickTrackingParams: json["clickTrackingParams"],
        searchEndpoint: SearchEndpoint.fromJson(json["searchEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "searchEndpoint": searchEndpoint.toJson(),
    };
}

class SearchEndpoint {
    final Query query;
    final String params;

    SearchEndpoint({
        required this.query,
        required this.params,
    });

    factory SearchEndpoint.fromJson(Map<String, dynamic> json) => SearchEndpoint(
        query: queryValues.map[json["query"]]!,
        params: json["params"],
    );

    Map<String, dynamic> toJson() => {
        "query": queryValues.reverse[query],
        "params": params,
    };
}

enum Query {
    CHAPA
}

final queryValues = EnumValues({
    "chapa": Query.CHAPA
});

class MusicShelfRendererContent {
    final MusicResponsiveListItemRenderer musicResponsiveListItemRenderer;

    MusicShelfRendererContent({
        required this.musicResponsiveListItemRenderer,
    });

    factory MusicShelfRendererContent.fromJson(Map<String, dynamic> json) => MusicShelfRendererContent(
        musicResponsiveListItemRenderer: MusicResponsiveListItemRenderer.fromJson(json["musicResponsiveListItemRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "musicResponsiveListItemRenderer": musicResponsiveListItemRenderer.toJson(),
    };
}

class MusicResponsiveListItemRenderer {
    final String trackingParams;
    final List<FlexColumn> flexColumns;
    final MusicResponsiveListItemRendererMenu menu;
    final List<Badge> badges;
    final PlaylistItemData playlistItemData;
    final String? flexColumnDisplayStyle;
    final ItemHeight? itemHeight;
    final MusicResponsiveListItemRendererNavigationEndpoint? navigationEndpoint;

    MusicResponsiveListItemRenderer({
        required this.trackingParams,
        required this.flexColumns,
        required this.menu,
        this.badges = const [],
        required this.playlistItemData,
        this.flexColumnDisplayStyle,
        this.itemHeight,
        this.navigationEndpoint, 
    });

    factory MusicResponsiveListItemRenderer.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRenderer(
        trackingParams: json["trackingParams"] ?? "",
        flexColumns: List<FlexColumn>.from((json["flexColumns"] ?? []).map((x) => FlexColumn.fromJson(x))),
        menu: MusicResponsiveListItemRendererMenu.fromJson(json["menu"] ?? {}),
        badges: List<Badge>.from((json["badges"] ?? []).map((x) => Badge.fromJson(x))),
        playlistItemData: PlaylistItemData.fromJson(json["playlistItemData"] ?? {}),
        flexColumnDisplayStyle: json["flexColumnDisplayStyle"],
        itemHeight: json["itemHeight"] != null ? itemHeightValues.map[json["itemHeight"]] : null, 
        navigationEndpoint: json["navigationEndpoint"] != null 
            ? MusicResponsiveListItemRendererNavigationEndpoint.fromJson(json["navigationEndpoint"])
            : null,
    );

    Map<String, dynamic> toJson() => {
        "trackingParams": trackingParams,
        "flexColumns": List<dynamic>.from(flexColumns.map((x) => x.toJson())),
        "menu": menu.toJson(),
        "badges": List<dynamic>.from(badges.map((x) => x.toJson())),
        "playlistItemData": playlistItemData.toJson(),
        "flexColumnDisplayStyle": flexColumnDisplayStyle,
        "itemHeight": itemHeightValues.reverse[itemHeight],
        "navigationEndpoint": navigationEndpoint?.toJson(),
    };
}

class Badge {
    final MusicInlineBadgeRenderer musicInlineBadgeRenderer;

    Badge({
        required this.musicInlineBadgeRenderer,
    });

    factory Badge.fromJson(Map<String, dynamic> json) => Badge(
        musicInlineBadgeRenderer: MusicInlineBadgeRenderer.fromJson(json["musicInlineBadgeRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "musicInlineBadgeRenderer": musicInlineBadgeRenderer.toJson(),
    };
}

class MusicInlineBadgeRenderer {
    final String trackingParams;
    final Icon icon;
    final AccessibilityPauseDataClass accessibilityData;

    MusicInlineBadgeRenderer({
        required this.trackingParams,
        required this.icon,
        required this.accessibilityData,
    });

    factory MusicInlineBadgeRenderer.fromJson(Map<String, dynamic> json) => MusicInlineBadgeRenderer(
        trackingParams: json["trackingParams"],
        icon: Icon.fromJson(json["icon"]),
        accessibilityData: AccessibilityPauseDataClass.fromJson(json["accessibilityData"]),
    );

    Map<String, dynamic> toJson() => {
        "trackingParams": trackingParams,
        "icon": icon.toJson(),
        "accessibilityData": accessibilityData.toJson(),
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
    final MusicResponsiveListItemFlexColumnRendererText text;
    final DisplayPriority displayPriority;

    MusicResponsiveListItemFlexColumnRenderer({
        required this.text,
        required this.displayPriority,
    });

    factory MusicResponsiveListItemFlexColumnRenderer.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemFlexColumnRenderer(
        text: MusicResponsiveListItemFlexColumnRendererText.fromJson(json["text"]),
        displayPriority: displayPriorityValues.map[json["displayPriority"]]!,
    );

    Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "displayPriority": displayPriorityValues.reverse[displayPriority],
    };
}

enum DisplayPriority {
    MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_HIGH
}

final displayPriorityValues = EnumValues({
    "MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_HIGH": DisplayPriority.MUSIC_RESPONSIVE_LIST_ITEM_COLUMN_DISPLAY_PRIORITY_HIGH
});

class MusicResponsiveListItemFlexColumnRendererText {
    final List<FluffyRun> runs;
    final AccessibilityPauseDataClass accessibility;

    MusicResponsiveListItemFlexColumnRendererText({
        required this.runs,
        required this.accessibility,
    });

    factory MusicResponsiveListItemFlexColumnRendererText.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemFlexColumnRendererText(
        runs: List<FluffyRun>.from(json["runs"].map((x) => FluffyRun.fromJson(x))),
        accessibility: AccessibilityPauseDataClass.fromJson(json["accessibility"]),
    );

    Map<String, dynamic> toJson() => {
        "runs": List<dynamic>.from(runs.map((x) => x.toJson())),
        "accessibility": accessibility.toJson(),
    };
}

class FluffyRun {
    final String text;
    final RunNavigationEndpoint navigationEndpoint;

    FluffyRun({
        required this.text,
        required this.navigationEndpoint,
    });

    factory FluffyRun.fromJson(Map<String, dynamic> json) => FluffyRun(
        text: json["text"],
        navigationEndpoint: RunNavigationEndpoint.fromJson(json["navigationEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "text": text,
        "navigationEndpoint": navigationEndpoint.toJson(),
    };
}

class RunNavigationEndpoint {
    final String clickTrackingParams;
    final OnTapWatchEndpoint watchEndpoint;
    final BrowseEndpoint browseEndpoint;

    RunNavigationEndpoint({
        required this.clickTrackingParams,
        required this.watchEndpoint,
        required this.browseEndpoint,
    });

    factory RunNavigationEndpoint.fromJson(Map<String, dynamic> json) => RunNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        watchEndpoint: OnTapWatchEndpoint.fromJson(json["watchEndpoint"]),
        browseEndpoint: BrowseEndpoint.fromJson(json["browseEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
        "browseEndpoint": browseEndpoint.toJson(),
    };
}

enum ItemHeight {
    MUSIC_RESPONSIVE_LIST_ITEM_HEIGHT_TALL
}

final itemHeightValues = EnumValues({
    "MUSIC_RESPONSIVE_LIST_ITEM_HEIGHT_TALL": ItemHeight.MUSIC_RESPONSIVE_LIST_ITEM_HEIGHT_TALL
});

class MusicResponsiveListItemRendererMenu {
    final FluffyMenuRenderer menuRenderer;

    MusicResponsiveListItemRendererMenu({
        required this.menuRenderer,
    });

    factory MusicResponsiveListItemRendererMenu.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRendererMenu(
        menuRenderer: FluffyMenuRenderer.fromJson(json["menuRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "menuRenderer": menuRenderer.toJson(),
    };
}

class FluffyMenuRenderer {
    final List<FluffyItem> items;
    final String trackingParams;
    final AccessibilityPauseDataClass accessibility;

    FluffyMenuRenderer({
        required this.items,
        required this.trackingParams,
        required this.accessibility,
    });

    factory FluffyMenuRenderer.fromJson(Map<String, dynamic> json) => FluffyMenuRenderer(
        items: List<FluffyItem>.from(json["items"].map((x) => FluffyItem.fromJson(x))),
        trackingParams: json["trackingParams"],
        accessibility: AccessibilityPauseDataClass.fromJson(json["accessibility"]),
    );

    Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "trackingParams": trackingParams,
        "accessibility": accessibility.toJson(),
    };
}

class FluffyItem {
    final ToggleMenuServiceItemRenderer toggleMenuServiceItemRenderer;
    final MenuServiceItemDownloadRenderer menuServiceItemDownloadRenderer;

    FluffyItem({
        required this.toggleMenuServiceItemRenderer,
        required this.menuServiceItemDownloadRenderer,
    });

    factory FluffyItem.fromJson(Map<String, dynamic> json) => FluffyItem(
        toggleMenuServiceItemRenderer: ToggleMenuServiceItemRenderer.fromJson(json["toggleMenuServiceItemRenderer"]),
        menuServiceItemDownloadRenderer: MenuServiceItemDownloadRenderer.fromJson(json["menuServiceItemDownloadRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "toggleMenuServiceItemRenderer": toggleMenuServiceItemRenderer.toJson(),
        "menuServiceItemDownloadRenderer": menuServiceItemDownloadRenderer.toJson(),
    };
}

class MenuServiceItemDownloadRenderer {
    final MenuServiceItemDownloadRendererServiceEndpoint serviceEndpoint;
    final String trackingParams;

    MenuServiceItemDownloadRenderer({
        required this.serviceEndpoint,
        required this.trackingParams,
    });

    factory MenuServiceItemDownloadRenderer.fromJson(Map<String, dynamic> json) => MenuServiceItemDownloadRenderer(
        serviceEndpoint: MenuServiceItemDownloadRendererServiceEndpoint.fromJson(json["serviceEndpoint"]),
        trackingParams: json["trackingParams"],
    );

    Map<String, dynamic> toJson() => {
        "serviceEndpoint": serviceEndpoint.toJson(),
        "trackingParams": trackingParams,
    };
}

class MenuServiceItemDownloadRendererServiceEndpoint {
    final String clickTrackingParams;
    final OfflineVideoEndpoint offlineVideoEndpoint;

    MenuServiceItemDownloadRendererServiceEndpoint({
        required this.clickTrackingParams,
        required this.offlineVideoEndpoint,
    });

    factory MenuServiceItemDownloadRendererServiceEndpoint.fromJson(Map<String, dynamic> json) => MenuServiceItemDownloadRendererServiceEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        offlineVideoEndpoint: OfflineVideoEndpoint.fromJson(json["offlineVideoEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "offlineVideoEndpoint": offlineVideoEndpoint.toJson(),
    };
}

class OfflineVideoEndpoint {
    final String videoId;
    final OnAddCommand onAddCommand;

    OfflineVideoEndpoint({
        required this.videoId,
        required this.onAddCommand,
    });

    factory OfflineVideoEndpoint.fromJson(Map<String, dynamic> json) => OfflineVideoEndpoint(
        videoId: json["videoId"],
        onAddCommand: OnAddCommand.fromJson(json["onAddCommand"]),
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "onAddCommand": onAddCommand.toJson(),
    };
}

class OnAddCommand {
    final String clickTrackingParams;
    final GetDownloadActionCommand getDownloadActionCommand;

    OnAddCommand({
        required this.clickTrackingParams,
        required this.getDownloadActionCommand,
    });

    factory OnAddCommand.fromJson(Map<String, dynamic> json) => OnAddCommand(
        clickTrackingParams: json["clickTrackingParams"],
        getDownloadActionCommand: GetDownloadActionCommand.fromJson(json["getDownloadActionCommand"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "getDownloadActionCommand": getDownloadActionCommand.toJson(),
    };
}

class GetDownloadActionCommand {
    final String videoId;
    final String params;

    GetDownloadActionCommand({
        required this.videoId,
        required this.params,
    });

    factory GetDownloadActionCommand.fromJson(Map<String, dynamic> json) => GetDownloadActionCommand(
        videoId: json["videoId"],
        params: json["params"],
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
        "params": params,
    };
}

class PlaylistItemData {
    final String videoId;

    PlaylistItemData({
        required this.videoId,
    });

    factory PlaylistItemData.fromJson(Map<String, dynamic> json) => PlaylistItemData(
        videoId: json["videoId"],
    );

    Map<String, dynamic> toJson() => {
        "videoId": videoId,
    };
}

class MusicResponsiveListItemRendererNavigationEndpoint {
    final String clickTrackingParams;
    final BrowseEndpoint browseEndpoint;

    MusicResponsiveListItemRendererNavigationEndpoint({
        required this.clickTrackingParams,
        required this.browseEndpoint,
    });

    factory MusicResponsiveListItemRendererNavigationEndpoint.fromJson(Map<String, dynamic> json) => MusicResponsiveListItemRendererNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        browseEndpoint: BrowseEndpoint.fromJson(json["browseEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "browseEndpoint": browseEndpoint.toJson(),
    };
}

class PlayNavigationEndpoint {
    final String clickTrackingParams;
    final CommandWatchEndpoint watchEndpoint;
    final WatchPlaylistEndpoint watchPlaylistEndpoint;

    PlayNavigationEndpoint({
        required this.clickTrackingParams,
        required this.watchEndpoint,
        required this.watchPlaylistEndpoint,
    });

    factory PlayNavigationEndpoint.fromJson(Map<String, dynamic> json) => PlayNavigationEndpoint(
        clickTrackingParams: json["clickTrackingParams"],
        watchEndpoint: CommandWatchEndpoint.fromJson(json["watchEndpoint"]),
        watchPlaylistEndpoint: WatchPlaylistEndpoint.fromJson(json["watchPlaylistEndpoint"]),
    );

    Map<String, dynamic> toJson() => {
        "clickTrackingParams": clickTrackingParams,
        "watchEndpoint": watchEndpoint.toJson(),
        "watchPlaylistEndpoint": watchPlaylistEndpoint.toJson(),
    };
}

class ShelfDivider {
    final MusicShelfDividerRenderer musicShelfDividerRenderer;

    ShelfDivider({
        required this.musicShelfDividerRenderer,
    });

    factory ShelfDivider.fromJson(Map<String, dynamic> json) => ShelfDivider(
        musicShelfDividerRenderer: MusicShelfDividerRenderer.fromJson(json["musicShelfDividerRenderer"]),
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
        hidden: json["hidden"],
    );

    Map<String, dynamic> toJson() => {
        "hidden": hidden,
    };
}

class SectionListRendererHeader {
    final ChipCloudRenderer chipCloudRenderer;

    SectionListRendererHeader({
        required this.chipCloudRenderer,
    });

    factory SectionListRendererHeader.fromJson(Map<String, dynamic> json) => SectionListRendererHeader(
        chipCloudRenderer: ChipCloudRenderer.fromJson(json["chipCloudRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "chipCloudRenderer": chipCloudRenderer.toJson(),
    };
}

class ChipCloudRenderer {
    final List<Chip> chips;
    final int collapsedRowCount;
    final String trackingParams;
    final bool horizontalScrollable;

    ChipCloudRenderer({
        required this.chips,
        required this.collapsedRowCount,
        required this.trackingParams,
        required this.horizontalScrollable,
    });

    factory ChipCloudRenderer.fromJson(Map<String, dynamic> json) => ChipCloudRenderer(
        chips: List<Chip>.from(json["chips"].map((x) => Chip.fromJson(x))),
        collapsedRowCount: json["collapsedRowCount"],
        trackingParams: json["trackingParams"],
        horizontalScrollable: json["horizontalScrollable"],
    );

    Map<String, dynamic> toJson() => {
        "chips": List<dynamic>.from(chips.map((x) => x.toJson())),
        "collapsedRowCount": collapsedRowCount,
        "trackingParams": trackingParams,
        "horizontalScrollable": horizontalScrollable,
    };
}

class Chip {
    final ChipCloudChipRenderer chipCloudChipRenderer;

    Chip({
        required this.chipCloudChipRenderer,
    });

    factory Chip.fromJson(Map<String, dynamic> json) => Chip(
        chipCloudChipRenderer: ChipCloudChipRenderer.fromJson(json["chipCloudChipRenderer"]),
    );

    Map<String, dynamic> toJson() => {
        "chipCloudChipRenderer": chipCloudChipRenderer.toJson(),
    };
}

class ChipCloudChipRenderer {
    final ChipCloudChipRendererStyle style;
    final BottomText text;
    final Endpoint navigationEndpoint;
    final String trackingParams;
    final AccessibilityPauseDataClass accessibilityData;
    final bool isSelected;
    final String uniqueId;

    ChipCloudChipRenderer({
        required this.style,
        required this.text,
        required this.navigationEndpoint,
        required this.trackingParams,
        required this.accessibilityData,
        required this.isSelected,
        required this.uniqueId,
    });

    factory ChipCloudChipRenderer.fromJson(Map<String, dynamic> json) => ChipCloudChipRenderer(
        style: ChipCloudChipRendererStyle.fromJson(json["style"]),
        text: BottomText.fromJson(json["text"]),
        navigationEndpoint: Endpoint.fromJson(json["navigationEndpoint"]),
        trackingParams: json["trackingParams"],
        accessibilityData: AccessibilityPauseDataClass.fromJson(json["accessibilityData"]),
        isSelected: json["isSelected"],
        uniqueId: json["uniqueId"],
    );

    Map<String, dynamic> toJson() => {
        "style": style.toJson(),
        "text": text.toJson(),
        "navigationEndpoint": navigationEndpoint.toJson(),
        "trackingParams": trackingParams,
        "accessibilityData": accessibilityData.toJson(),
        "isSelected": isSelected,
        "uniqueId": uniqueId,
    };
}

class ChipCloudChipRendererStyle {
    final String styleType;

    ChipCloudChipRendererStyle({
        required this.styleType,
    });

    factory ChipCloudChipRendererStyle.fromJson(Map<String, dynamic> json) => ChipCloudChipRendererStyle(
        styleType: json["styleType"],
    );

    Map<String, dynamic> toJson() => {
        "styleType": styleType,
    };
}

class ResponseContext {
    final String visitorData;
    final List<ServiceTrackingParam> serviceTrackingParams;
    final int? maxAgeSeconds;

    ResponseContext({
        required this.visitorData,
        required this.serviceTrackingParams,
        this.maxAgeSeconds,
    });

    factory ResponseContext.fromJson(Map<String, dynamic> json) => ResponseContext(
        visitorData: json["visitorData"],
        serviceTrackingParams: List<ServiceTrackingParam>.from(json["serviceTrackingParams"].map((x) => ServiceTrackingParam.fromJson(x))),
        maxAgeSeconds: json["maxAgeSeconds"] != null ? json["maxAgeSeconds"] : null,
    );

    Map<String, dynamic> toJson() => {
        "visitorData": visitorData,
        "serviceTrackingParams": List<dynamic>.from(serviceTrackingParams.map((x) => x.toJson())),
        if (maxAgeSeconds != null) "maxAgeSeconds": maxAgeSeconds,
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
