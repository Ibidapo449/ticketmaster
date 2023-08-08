class Event {
    int userId;
    int id;
    String title;
    bool completed;

    Event ({
        required this.userId,
        required this.id,
        required this.title,
        required this.completed,
    });
}

// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);

// // ignore_for_file: constant_identifier_names

// import 'dart:convert';

// Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

// String welcomeToJson(Welcome data) => json.encode(data.toJson());

// class Welcome {
//     WelcomeEmbedded embedded;
//     WelcomeLinks links;
//     Page page;

//     Welcome({
//         required this.embedded,
//         required this.links,
//         required this.page,
//     });

//     factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
//         embedded: WelcomeEmbedded.fromJson(json["_embedded"]),
//         links: WelcomeLinks.fromJson(json["_links"]),
//         page: Page.fromJson(json["page"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "_embedded": embedded.toJson(),
//         "_links": links.toJson(),
//         "page": page.toJson(),
//     };
// }

// class WelcomeEmbedded {
//     List<Event> events;

//     WelcomeEmbedded({
//         required this.events,
//     });

//     factory WelcomeEmbedded.fromJson(Map<String, dynamic> json) => WelcomeEmbedded(
//         events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "events": List<dynamic>.from(events.map((x) => x.toJson())),
//     };
// }

// class Event {
//     EventName name;
//     EventType type;
//     String id;
//     bool test;
//     String url;
//     Locale locale;
//     List<Image> images;
//     Sales sales;
//     Dates dates;
//     List<Classification> classifications;
//     Promoter? promoter;
//     List<Promoter>? promoters;
//     List<PriceRange>? priceRanges;
//     List<Product>? products;
//     Seatmap? seatmap;
//     Accessibility? accessibility;
//     TicketLimit? ticketLimit;
//     AgeRestrictions? ageRestrictions;
//     Ticketing? ticketing;
//     EventLinks links;
//     EventEmbedded embedded;
//     String? info;
//     String? pleaseNote;
//     List<Outlet>? outlets;

//     Event({
//         required this.name,
//         required this.type,
//         required this.id,
//         required this.test,
//         required this.url,
//         required this.locale,
//         required this.images,
//         required this.sales,
//         required this.dates,
//         required this.classifications,
//         this.promoter,
//         this.promoters,
//         this.priceRanges,
//         this.products,
//         this.seatmap,
//         this.accessibility,
//         this.ticketLimit,
//         this.ageRestrictions,
//         this.ticketing,
//         required this.links,
//         required this.embedded,
//         this.info,
//         this.pleaseNote,
//         this.outlets,
//     });

//     factory Event.fromJson(Map<String, dynamic> json) => Event(
//         name: eventNameValues.map[json["name"]]!,
//         type: eventTypeValues.map[json["type"]]!,
//         id: json["id"],
//         test: json["test"],
//         url: json["url"],
//         locale: localeValues.map[json["locale"]]!,
//         images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
//         sales: Sales.fromJson(json["sales"]),
//         dates: Dates.fromJson(json["dates"]),
//         classifications: List<Classification>.from(json["classifications"].map((x) => Classification.fromJson(x))),
//         promoter: json["promoter"] == null ? null : Promoter.fromJson(json["promoter"]),
//         promoters: json["promoters"] == null ? [] : List<Promoter>.from(json["promoters"]!.map((x) => Promoter.fromJson(x))),
//         priceRanges: json["priceRanges"] == null ? [] : List<PriceRange>.from(json["priceRanges"]!.map((x) => PriceRange.fromJson(x))),
//         products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
//         seatmap: json["seatmap"] == null ? null : Seatmap.fromJson(json["seatmap"]),
//         accessibility: json["accessibility"] == null ? null : Accessibility.fromJson(json["accessibility"]),
//         ticketLimit: json["ticketLimit"] == null ? null : TicketLimit.fromJson(json["ticketLimit"]),
//         ageRestrictions: json["ageRestrictions"] == null ? null : AgeRestrictions.fromJson(json["ageRestrictions"]),
//         ticketing: json["ticketing"] == null ? null : Ticketing.fromJson(json["ticketing"]),
//         links: EventLinks.fromJson(json["_links"]),
//         embedded: EventEmbedded.fromJson(json["_embedded"]),
//         info: json["info"],
//         pleaseNote: json["pleaseNote"],
//         outlets: json["outlets"] == null ? [] : List<Outlet>.from(json["outlets"]!.map((x) => Outlet.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "name": eventNameValues.reverse[name],
//         "type": eventTypeValues.reverse[type],
//         "id": id,
//         "test": test,
//         "url": url,
//         "locale": localeValues.reverse[locale],
//         "images": List<dynamic>.from(images.map((x) => x.toJson())),
//         "sales": sales.toJson(),
//         "dates": dates.toJson(),
//         "classifications": List<dynamic>.from(classifications.map((x) => x.toJson())),
//         "promoter": promoter?.toJson(),
//         "promoters": promoters == null ? [] : List<dynamic>.from(promoters!.map((x) => x.toJson())),
//         "priceRanges": priceRanges == null ? [] : List<dynamic>.from(priceRanges!.map((x) => x.toJson())),
//         "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
//         "seatmap": seatmap?.toJson(),
//         "accessibility": accessibility?.toJson(),
//         "ticketLimit": ticketLimit?.toJson(),
//         "ageRestrictions": ageRestrictions?.toJson(),
//         "ticketing": ticketing?.toJson(),
//         "_links": links.toJson(),
//         "_embedded": embedded.toJson(),
//         "info": info,
//         "pleaseNote": pleaseNote,
//         "outlets": outlets == null ? [] : List<dynamic>.from(outlets!.map((x) => x.toJson())),
//     };
// }

// class Accessibility {
//     int? ticketLimit;
//     String? info;

//     Accessibility({
//         this.ticketLimit,
//         this.info,
//     });

//     factory Accessibility.fromJson(Map<String, dynamic> json) => Accessibility(
//         ticketLimit: json["ticketLimit"],
//         info: json["info"],
//     );

//     Map<String, dynamic> toJson() => {
//         "ticketLimit": ticketLimit,
//         "info": info,
//     };
// }

// class AgeRestrictions {
//     bool legalAgeEnforced;

//     AgeRestrictions({
//         required this.legalAgeEnforced,
//     });

//     factory AgeRestrictions.fromJson(Map<String, dynamic> json) => AgeRestrictions(
//         legalAgeEnforced: json["legalAgeEnforced"],
//     );

//     Map<String, dynamic> toJson() => {
//         "legalAgeEnforced": legalAgeEnforced,
//     };
// }

// class Classification {
//     bool primary;
//     Genre segment;
//     Genre genre;
//     Genre subGenre;
//     Genre? type;
//     Genre? subType;
//     bool family;

//     Classification({
//         required this.primary,
//         required this.segment,
//         required this.genre,
//         required this.subGenre,
//         this.type,
//         this.subType,
//         required this.family,
//     });

//     factory Classification.fromJson(Map<String, dynamic> json) => Classification(
//         primary: json["primary"],
//         segment: Genre.fromJson(json["segment"]),
//         genre: Genre.fromJson(json["genre"]),
//         subGenre: Genre.fromJson(json["subGenre"]),
//         type: json["type"] == null ? null : Genre.fromJson(json["type"]),
//         subType: json["subType"] == null ? null : Genre.fromJson(json["subType"]),
//         family: json["family"],
//     );

//     Map<String, dynamic> toJson() => {
//         "primary": primary,
//         "segment": segment.toJson(),
//         "genre": genre.toJson(),
//         "subGenre": subGenre.toJson(),
//         "type": type?.toJson(),
//         "subType": subType?.toJson(),
//         "family": family,
//     };
// }

// class Genre {
//     String id;
//     String name;

//     Genre({
//         required this.id,
//         required this.name,
//     });

//     factory Genre.fromJson(Map<String, dynamic> json) => Genre(
//         id: json["id"],
//         name: json["name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//     };
// }

// class Dates {
//     Start start;
//     Timezone? timezone;
//     Status status;
//     bool spanMultipleDays;
//     InitialStartDate? initialStartDate;

//     Dates({
//         required this.start,
//         this.timezone,
//         required this.status,
//         required this.spanMultipleDays,
//         this.initialStartDate,
//     });

//     factory Dates.fromJson(Map<String, dynamic> json) => Dates(
//         start: Start.fromJson(json["start"]),
//         timezone: timezoneValues.map[json["timezone"]]!,
//         status: Status.fromJson(json["status"]),
//         spanMultipleDays: json["spanMultipleDays"],
//         initialStartDate: json["initialStartDate"] == null ? null : InitialStartDate.fromJson(json["initialStartDate"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "start": start.toJson(),
//         "timezone": timezoneValues.reverse[timezone],
//         "status": status.toJson(),
//         "spanMultipleDays": spanMultipleDays,
//         "initialStartDate": initialStartDate?.toJson(),
//     };
// }

// class InitialStartDate {
//     DateTime localDate;
//     String localTime;
//     DateTime dateTime;

//     InitialStartDate({
//         required this.localDate,
//         required this.localTime,
//         required this.dateTime,
//     });

//     factory InitialStartDate.fromJson(Map<String, dynamic> json) => InitialStartDate(
//         localDate: DateTime.parse(json["localDate"]),
//         localTime: json["localTime"],
//         dateTime: DateTime.parse(json["dateTime"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "localDate": "${localDate.year.toString().padLeft(4, '0')}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}",
//         "localTime": localTime,
//         "dateTime": dateTime.toIso8601String(),
//     };
// }

// class Start {
//     DateTime localDate;
//     String localTime;
//     DateTime dateTime;
//     bool dateTbd;
//     bool dateTba;
//     bool timeTba;
//     bool noSpecificTime;

//     Start({
//         required this.localDate,
//         required this.localTime,
//         required this.dateTime,
//         required this.dateTbd,
//         required this.dateTba,
//         required this.timeTba,
//         required this.noSpecificTime,
//     });

//     factory Start.fromJson(Map<String, dynamic> json) => Start(
//         localDate: DateTime.parse(json["localDate"]),
//         localTime: json["localTime"],
//         dateTime: DateTime.parse(json["dateTime"]),
//         dateTbd: json["dateTBD"],
//         dateTba: json["dateTBA"],
//         timeTba: json["timeTBA"],
//         noSpecificTime: json["noSpecificTime"],
//     );

//     Map<String, dynamic> toJson() => {
//         "localDate": "${localDate.year.toString().padLeft(4, '0')}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}",
//         "localTime": localTime,
//         "dateTime": dateTime.toIso8601String(),
//         "dateTBD": dateTbd,
//         "dateTBA": dateTba,
//         "timeTBA": timeTba,
//         "noSpecificTime": noSpecificTime,
//     };
// }

// class Status {
//     Code code;

//     Status({
//         required this.code,
//     });

//     factory Status.fromJson(Map<String, dynamic> json) => Status(
//         code: codeValues.map[json["code"]]!,
//     );

//     Map<String, dynamic> toJson() => {
//         "code": codeValues.reverse[code],
//     };
// }

// enum Code {
//     ONSALE,
//     RESCHEDULED
// }

// final codeValues = EnumValues({
//     "onsale": Code.ONSALE,
//     "rescheduled": Code.RESCHEDULED
// });

// enum Timezone {
//     AMERICA_CHICAGO,
//     AMERICA_LOS_ANGELES,
//     AMERICA_NEW_YORK,
//     AMERICA_PHOENIX
// }

// final timezoneValues = EnumValues({
//     "America/Chicago": Timezone.AMERICA_CHICAGO,
//     "America/Los_Angeles": Timezone.AMERICA_LOS_ANGELES,
//     "America/New_York": Timezone.AMERICA_NEW_YORK,
//     "America/Phoenix": Timezone.AMERICA_PHOENIX
// });

// class EventEmbedded {
//     List<Venue> venues;
//     List<Attraction> attractions;

//     EventEmbedded({
//         required this.venues,
//         required this.attractions,
//     });

//     factory EventEmbedded.fromJson(Map<String, dynamic> json) => EventEmbedded(
//         venues: List<Venue>.from(json["venues"].map((x) => Venue.fromJson(x))),
//         attractions: List<Attraction>.from(json["attractions"].map((x) => Attraction.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "venues": List<dynamic>.from(venues.map((x) => x.toJson())),
//         "attractions": List<dynamic>.from(attractions.map((x) => x.toJson())),
//     };
// }

// class Attraction {
//     String name;
//     AttractionType type;
//     String id;
//     bool test;
//     String url;
//     Locale locale;
//     ExternalLinks? externalLinks;
//     List<Alias>? aliases;
//     List<Image> images;
//     List<Classification> classifications;
//     UpcomingEvents upcomingEvents;
//     AttractionLinks links;

//     Attraction({
//         required this.name,
//         required this.type,
//         required this.id,
//         required this.test,
//         required this.url,
//         required this.locale,
//         this.externalLinks,
//         this.aliases,
//         required this.images,
//         required this.classifications,
//         required this.upcomingEvents,
//         required this.links,
//     });

//     factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
//         name: json["name"],
//         type: attractionTypeValues.map[json["type"]]!,
//         id: json["id"],
//         test: json["test"],
//         url: json["url"],
//         locale: localeValues.map[json["locale"]]!,
//         externalLinks: json["externalLinks"] == null ? null : ExternalLinks.fromJson(json["externalLinks"]),
//         aliases: json["aliases"] == null ? [] : List<Alias>.from(json["aliases"]!.map((x) => aliasValues.map[x]!)),
//         images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
//         classifications: List<Classification>.from(json["classifications"].map((x) => Classification.fromJson(x))),
//         upcomingEvents: UpcomingEvents.fromJson(json["upcomingEvents"]),
//         links: AttractionLinks.fromJson(json["_links"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//         "type": attractionTypeValues.reverse[type],
//         "id": id,
//         "test": test,
//         "url": url,
//         "locale": localeValues.reverse[locale],
//         "externalLinks": externalLinks?.toJson(),
//         "aliases": aliases == null ? [] : List<dynamic>.from(aliases!.map((x) => aliasValues.reverse[x])),
//         "images": List<dynamic>.from(images.map((x) => x.toJson())),
//         "classifications": List<dynamic>.from(classifications.map((x) => x.toJson())),
//         "upcomingEvents": upcomingEvents.toJson(),
//         "_links": links.toJson(),
//     };
// }

// enum Alias {
//     BEONCE,
//     BETONC,
//     BEYONCE,
//     BEYONCE_KNOWLES,
//     BEYOUNCE,
//     BYONCE,
//     PHILLY,
//     PINK,
//     P_NK
// }

// final aliasValues = EnumValues({
//     "beonce": Alias.BEONCE,
//     "betonc": Alias.BETONC,
//     "beyonce": Alias.BEYONCE,
//     "beyonce knowles": Alias.BEYONCE_KNOWLES,
//     "beyounce": Alias.BEYOUNCE,
//     "byonce": Alias.BYONCE,
//     "philly": Alias.PHILLY,
//     "pink": Alias.PINK,
//     "p!nk": Alias.P_NK
// });

// class ExternalLinks {
//     List<Facebook>? youtube;
//     List<Facebook>? twitter;
//     List<Facebook>? itunes;
//     List<Facebook>? lastfm;
//     List<Facebook> facebook;
//     List<Facebook>? wiki;
//     List<Facebook>? spotify;
//     List<Facebook>? instagram;
//     List<Musicbrainz>? musicbrainz;
//     List<Facebook> homepage;

//     ExternalLinks({
//         this.youtube,
//         this.twitter,
//         this.itunes,
//         this.lastfm,
//         required this.facebook,
//         this.wiki,
//         this.spotify,
//         this.instagram,
//         this.musicbrainz,
//         required this.homepage,
//     });

//     factory ExternalLinks.fromJson(Map<String, dynamic> json) => ExternalLinks(
//         youtube: json["youtube"] == null ? [] : List<Facebook>.from(json["youtube"]!.map((x) => Facebook.fromJson(x))),
//         twitter: json["twitter"] == null ? [] : List<Facebook>.from(json["twitter"]!.map((x) => Facebook.fromJson(x))),
//         itunes: json["itunes"] == null ? [] : List<Facebook>.from(json["itunes"]!.map((x) => Facebook.fromJson(x))),
//         lastfm: json["lastfm"] == null ? [] : List<Facebook>.from(json["lastfm"]!.map((x) => Facebook.fromJson(x))),
//         facebook: List<Facebook>.from(json["facebook"].map((x) => Facebook.fromJson(x))),
//         wiki: json["wiki"] == null ? [] : List<Facebook>.from(json["wiki"]!.map((x) => Facebook.fromJson(x))),
//         spotify: json["spotify"] == null ? [] : List<Facebook>.from(json["spotify"]!.map((x) => Facebook.fromJson(x))),
//         instagram: json["instagram"] == null ? [] : List<Facebook>.from(json["instagram"]!.map((x) => Facebook.fromJson(x))),
//         musicbrainz: json["musicbrainz"] == null ? [] : List<Musicbrainz>.from(json["musicbrainz"]!.map((x) => Musicbrainz.fromJson(x))),
//         homepage: List<Facebook>.from(json["homepage"].map((x) => Facebook.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "youtube": youtube == null ? [] : List<dynamic>.from(youtube!.map((x) => x.toJson())),
//         "twitter": twitter == null ? [] : List<dynamic>.from(twitter!.map((x) => x.toJson())),
//         "itunes": itunes == null ? [] : List<dynamic>.from(itunes!.map((x) => x.toJson())),
//         "lastfm": lastfm == null ? [] : List<dynamic>.from(lastfm!.map((x) => x.toJson())),
//         "facebook": List<dynamic>.from(facebook.map((x) => x.toJson())),
//         "wiki": wiki == null ? [] : List<dynamic>.from(wiki!.map((x) => x.toJson())),
//         "spotify": spotify == null ? [] : List<dynamic>.from(spotify!.map((x) => x.toJson())),
//         "instagram": instagram == null ? [] : List<dynamic>.from(instagram!.map((x) => x.toJson())),
//         "musicbrainz": musicbrainz == null ? [] : List<dynamic>.from(musicbrainz!.map((x) => x.toJson())),
//         "homepage": List<dynamic>.from(homepage.map((x) => x.toJson())),
//     };
// }

// class Facebook {
//     String url;

//     Facebook({
//         required this.url,
//     });

//     factory Facebook.fromJson(Map<String, dynamic> json) => Facebook(
//         url: json["url"],
//     );

//     Map<String, dynamic> toJson() => {
//         "url": url,
//     };
// }

// class Musicbrainz {
//     String id;

//     Musicbrainz({
//         required this.id,
//     });

//     factory Musicbrainz.fromJson(Map<String, dynamic> json) => Musicbrainz(
//         id: json["id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//     };
// }

// class Image {
//     Ratio ratio;
//     String url;
//     int width;
//     int height;
//     bool fallback;

//     Image({
//         required this.ratio,
//         required this.url,
//         required this.width,
//         required this.height,
//         required this.fallback,
//     });

//     factory Image.fromJson(Map<String, dynamic> json) => Image(
//         ratio: ratioValues.map[json["ratio"]]!,
//         url: json["url"],
//         width: json["width"],
//         height: json["height"],
//         fallback: json["fallback"],
//     );

//     Map<String, dynamic> toJson() => {
//         "ratio": ratioValues.reverse[ratio],
//         "url": url,
//         "width": width,
//         "height": height,
//         "fallback": fallback,
//     };
// }

// enum Ratio {
//     THE_169,
//     THE_32,
//     THE_43
// }

// final ratioValues = EnumValues({
//     "16_9": Ratio.THE_169,
//     "3_2": Ratio.THE_32,
//     "4_3": Ratio.THE_43
// });

// class AttractionLinks {
//     First self;

//     AttractionLinks({
//         required this.self,
//     });

//     factory AttractionLinks.fromJson(Map<String, dynamic> json) => AttractionLinks(
//         self: First.fromJson(json["self"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "self": self.toJson(),
//     };
// }

// class First {
//     String href;

//     First({
//         required this.href,
//     });

//     factory First.fromJson(Map<String, dynamic> json) => First(
//         href: json["href"],
//     );

//     Map<String, dynamic> toJson() => {
//         "href": href,
//     };
// }

// enum Locale {
//     EN_US
// }

// final localeValues = EnumValues({
//     "en-us": Locale.EN_US
// });

// enum AttractionType {
//     ATTRACTION
// }

// final attractionTypeValues = EnumValues({
//     "attraction": AttractionType.ATTRACTION
// });

// class UpcomingEvents {
//     int ticketmaster;
//     int total;
//     int filtered;
//     int? tmr;

//     UpcomingEvents({
//         required this.ticketmaster,
//         required this.total,
//         required this.filtered,
//         this.tmr,
//     });

//     factory UpcomingEvents.fromJson(Map<String, dynamic> json) => UpcomingEvents(
//         ticketmaster: json["ticketmaster"],
//         total: json["_total"],
//         filtered: json["_filtered"],
//         tmr: json["tmr"],
//     );

//     Map<String, dynamic> toJson() => {
//         "ticketmaster": ticketmaster,
//         "_total": total,
//         "_filtered": filtered,
//         "tmr": tmr,
//     };
// }

// class Venue {
//     String name;
//     VenueType type;
//     String id;
//     bool test;
//     String? url;
//     Locale locale;
//     List<Image>? images;
//     String postalCode;
//     Timezone timezone;
//     City city;
//     State state;
//     Country country;
//     Address address;
//     Location location;
//     List<Genre>? markets;
//     List<Dma> dmas;
//     BoxOfficeInfo? boxOfficeInfo;
//     String? parkingDetail;
//     String? accessibleSeatingDetail;
//     GeneralInfo? generalInfo;
//     UpcomingEvents upcomingEvents;
//     Ada? ada;
//     AttractionLinks links;
//     Social? social;
//     List<String>? aliases;

//     Venue({
//         required this.name,
//         required this.type,
//         required this.id,
//         required this.test,
//         this.url,
//         required this.locale,
//         this.images,
//         required this.postalCode,
//         required this.timezone,
//         required this.city,
//         required this.state,
//         required this.country,
//         required this.address,
//         required this.location,
//         this.markets,
//         required this.dmas,
//         this.boxOfficeInfo,
//         this.parkingDetail,
//         this.accessibleSeatingDetail,
//         this.generalInfo,
//         required this.upcomingEvents,
//         this.ada,
//         required this.links,
//         this.social,
//         this.aliases,
//     });

//     factory Venue.fromJson(Map<String, dynamic> json) => Venue(
//         name: json["name"],
//         type: venueTypeValues.map[json["type"]]!,
//         id: json["id"],
//         test: json["test"],
//         url: json["url"],
//         locale: localeValues.map[json["locale"]]!,
//         images: json["images"] == null ? [] : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
//         postalCode: json["postalCode"],
//         timezone: timezoneValues.map[json["timezone"]]!,
//         city: City.fromJson(json["city"]),
//         state: State.fromJson(json["state"]),
//         country: Country.fromJson(json["country"]),
//         address: Address.fromJson(json["address"]),
//         location: Location.fromJson(json["location"]),
//         markets: json["markets"] == null ? [] : List<Genre>.from(json["markets"]!.map((x) => Genre.fromJson(x))),
//         dmas: List<Dma>.from(json["dmas"].map((x) => Dma.fromJson(x))),
//         boxOfficeInfo: json["boxOfficeInfo"] == null ? null : BoxOfficeInfo.fromJson(json["boxOfficeInfo"]),
//         parkingDetail: json["parkingDetail"],
//         accessibleSeatingDetail: json["accessibleSeatingDetail"],
//         generalInfo: json["generalInfo"] == null ? null : GeneralInfo.fromJson(json["generalInfo"]),
//         upcomingEvents: UpcomingEvents.fromJson(json["upcomingEvents"]),
//         ada: json["ada"] == null ? null : Ada.fromJson(json["ada"]),
//         links: AttractionLinks.fromJson(json["_links"]),
//         social: json["social"] == null ? null : Social.fromJson(json["social"]),
//         aliases: json["aliases"] == null ? [] : List<String>.from(json["aliases"]!.map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//         "type": venueTypeValues.reverse[type],
//         "id": id,
//         "test": test,
//         "url": url,
//         "locale": localeValues.reverse[locale],
//         "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
//         "postalCode": postalCode,
//         "timezone": timezoneValues.reverse[timezone],
//         "city": city.toJson(),
//         "state": state.toJson(),
//         "country": country.toJson(),
//         "address": address.toJson(),
//         "location": location.toJson(),
//         "markets": markets == null ? [] : List<dynamic>.from(markets!.map((x) => x.toJson())),
//         "dmas": List<dynamic>.from(dmas.map((x) => x.toJson())),
//         "boxOfficeInfo": boxOfficeInfo?.toJson(),
//         "parkingDetail": parkingDetail,
//         "accessibleSeatingDetail": accessibleSeatingDetail,
//         "generalInfo": generalInfo?.toJson(),
//         "upcomingEvents": upcomingEvents.toJson(),
//         "ada": ada?.toJson(),
//         "_links": links.toJson(),
//         "social": social?.toJson(),
//         "aliases": aliases == null ? [] : List<dynamic>.from(aliases!.map((x) => x)),
//     };
// }

// class Ada {
//     String adaPhones;
//     String adaCustomCopy;
//     String adaHours;

//     Ada({
//         required this.adaPhones,
//         required this.adaCustomCopy,
//         required this.adaHours,
//     });

//     factory Ada.fromJson(Map<String, dynamic> json) => Ada(
//         adaPhones: json["adaPhones"],
//         adaCustomCopy: json["adaCustomCopy"],
//         adaHours: json["adaHours"],
//     );

//     Map<String, dynamic> toJson() => {
//         "adaPhones": adaPhones,
//         "adaCustomCopy": adaCustomCopy,
//         "adaHours": adaHours,
//     };
// }

// class Address {
//     String line1;
//     String? line2;

//     Address({
//         required this.line1,
//         this.line2,
//     });

//     factory Address.fromJson(Map<String, dynamic> json) => Address(
//         line1: json["line1"],
//         line2: json["line2"],
//     );

//     Map<String, dynamic> toJson() => {
//         "line1": line1,
//         "line2": line2,
//     };
// }

// class BoxOfficeInfo {
//     String phoneNumberDetail;
//     String? openHoursDetail;
//     String? acceptedPaymentDetail;
//     String? willCallDetail;

//     BoxOfficeInfo({
//         required this.phoneNumberDetail,
//         this.openHoursDetail,
//         this.acceptedPaymentDetail,
//         this.willCallDetail,
//     });

//     factory BoxOfficeInfo.fromJson(Map<String, dynamic> json) => BoxOfficeInfo(
//         phoneNumberDetail: json["phoneNumberDetail"],
//         openHoursDetail: json["openHoursDetail"],
//         acceptedPaymentDetail: json["acceptedPaymentDetail"],
//         willCallDetail: json["willCallDetail"],
//     );

//     Map<String, dynamic> toJson() => {
//         "phoneNumberDetail": phoneNumberDetail,
//         "openHoursDetail": openHoursDetail,
//         "acceptedPaymentDetail": acceptedPaymentDetail,
//         "willCallDetail": willCallDetail,
//     };
// }

// class City {
//     String name;

//     City({
//         required this.name,
//     });

//     factory City.fromJson(Map<String, dynamic> json) => City(
//         name: json["name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//     };
// }

// class Country {
//     CountryName name;
//     CountryCode countryCode;

//     Country({
//         required this.name,
//         required this.countryCode,
//     });

//     factory Country.fromJson(Map<String, dynamic> json) => Country(
//         name: countryNameValues.map[json["name"]]!,
//         countryCode: countryCodeValues.map[json["countryCode"]]!,
//     );

//     Map<String, dynamic> toJson() => {
//         "name": countryNameValues.reverse[name],
//         "countryCode": countryCodeValues.reverse[countryCode],
//     };
// }

// enum CountryCode {
//     US
// }

// final countryCodeValues = EnumValues({
//     "US": CountryCode.US
// });

// enum CountryName {
//     UNITED_STATES_OF_AMERICA
// }

// final countryNameValues = EnumValues({
//     "United States Of America": CountryName.UNITED_STATES_OF_AMERICA
// });

// class Dma {
//     int id;

//     Dma({
//         required this.id,
//     });

//     factory Dma.fromJson(Map<String, dynamic> json) => Dma(
//         id: json["id"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//     };
// }

// class GeneralInfo {
//     String generalRule;
//     String childRule;

//     GeneralInfo({
//         required this.generalRule,
//         required this.childRule,
//     });

//     factory GeneralInfo.fromJson(Map<String, dynamic> json) => GeneralInfo(
//         generalRule: json["generalRule"],
//         childRule: json["childRule"],
//     );

//     Map<String, dynamic> toJson() => {
//         "generalRule": generalRule,
//         "childRule": childRule,
//     };
// }

// class Location {
//     String longitude;
//     String latitude;

//     Location({
//         required this.longitude,
//         required this.latitude,
//     });

//     factory Location.fromJson(Map<String, dynamic> json) => Location(
//         longitude: json["longitude"],
//         latitude: json["latitude"],
//     );

//     Map<String, dynamic> toJson() => {
//         "longitude": longitude,
//         "latitude": latitude,
//     };
// }

// class Social {
//     Twitter twitter;

//     Social({
//         required this.twitter,
//     });

//     factory Social.fromJson(Map<String, dynamic> json) => Social(
//         twitter: Twitter.fromJson(json["twitter"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "twitter": twitter.toJson(),
//     };
// }

// class Twitter {
//     String handle;

//     Twitter({
//         required this.handle,
//     });

//     factory Twitter.fromJson(Map<String, dynamic> json) => Twitter(
//         handle: json["handle"],
//     );

//     Map<String, dynamic> toJson() => {
//         "handle": handle,
//     };
// }

// class State {
//     String name;
//     String stateCode;

//     State({
//         required this.name,
//         required this.stateCode,
//     });

//     factory State.fromJson(Map<String, dynamic> json) => State(
//         name: json["name"],
//         stateCode: json["stateCode"],
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//         "stateCode": stateCode,
//     };
// }

// enum VenueType {
//     VENUE
// }

// final venueTypeValues = EnumValues({
//     "venue": VenueType.VENUE
// });

// class EventLinks {
//     First self;
//     List<First> attractions;
//     List<First> venues;

//     EventLinks({
//         required this.self,
//         required this.attractions,
//         required this.venues,
//     });

//     factory EventLinks.fromJson(Map<String, dynamic> json) => EventLinks(
//         self: First.fromJson(json["self"]),
//         attractions: List<First>.from(json["attractions"].map((x) => First.fromJson(x))),
//         venues: List<First>.from(json["venues"].map((x) => First.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "self": self.toJson(),
//         "attractions": List<dynamic>.from(attractions.map((x) => x.toJson())),
//         "venues": List<dynamic>.from(venues.map((x) => x.toJson())),
//     };
// }

// enum EventName {
//     BEYONCE_RENAISSANCE_WORLD_TOUR,
//     BEYONC_RENAISSANCE_WORLD_TOUR,
//     PHILADEPHIA_EAGLES_PUBLIC_PRACTICE,
//     P_NK_SUMMER_CARNIVAL_2023
// }

// final eventNameValues = EnumValues({
//     "BEYONCE - RENAISSANCE WORLD TOUR": EventName.BEYONCE_RENAISSANCE_WORLD_TOUR,
//     "BEYONCÉ - RENAISSANCE WORLD TOUR": EventName.BEYONC_RENAISSANCE_WORLD_TOUR,
//     "Philadephia Eagles Public Practice": EventName.PHILADEPHIA_EAGLES_PUBLIC_PRACTICE,
//     "P!NK: Summer Carnival 2023": EventName.P_NK_SUMMER_CARNIVAL_2023
// });

// class Outlet {
//     String url;
//     String type;

//     Outlet({
//         required this.url,
//         required this.type,
//     });

//     factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
//         url: json["url"],
//         type: json["type"],
//     );

//     Map<String, dynamic> toJson() => {
//         "url": url,
//         "type": type,
//     };
// }

// class PriceRange {
//     PriceRangeType type;
//     Currency currency;
//     double min;
//     double max;

//     PriceRange({
//         required this.type,
//         required this.currency,
//         required this.min,
//         required this.max,
//     });

//     factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
//         type: priceRangeTypeValues.map[json["type"]]!,
//         currency: currencyValues.map[json["currency"]]!,
//         min: json["min"]?.toDouble(),
//         max: json["max"]?.toDouble(),
//     );

//     Map<String, dynamic> toJson() => {
//         "type": priceRangeTypeValues.reverse[type],
//         "currency": currencyValues.reverse[currency],
//         "min": min,
//         "max": max,
//     };
// }

// enum Currency {
//     USD
// }

// final currencyValues = EnumValues({
//     "USD": Currency.USD
// });

// enum PriceRangeType {
//     STANDARD
// }

// final priceRangeTypeValues = EnumValues({
//     "standard": PriceRangeType.STANDARD
// });

// class Product {
//     String name;
//     String id;
//     String url;
//     String type;
//     List<Classification> classifications;

//     Product({
//         required this.name,
//         required this.id,
//         required this.url,
//         required this.type,
//         required this.classifications,
//     });

//     factory Product.fromJson(Map<String, dynamic> json) => Product(
//         name: json["name"],
//         id: json["id"],
//         url: json["url"],
//         type: json["type"],
//         classifications: List<Classification>.from(json["classifications"].map((x) => Classification.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "name": name,
//         "id": id,
//         "url": url,
//         "type": type,
//         "classifications": List<dynamic>.from(classifications.map((x) => x.toJson())),
//     };
// }

// class Promoter {
//     String id;
//     PromoterName name;
//     Description description;

//     Promoter({
//         required this.id,
//         required this.name,
//         required this.description,
//     });

//     factory Promoter.fromJson(Map<String, dynamic> json) => Promoter(
//         id: json["id"],
//         name: promoterNameValues.map[json["name"]]!,
//         description: descriptionValues.map[json["description"]]!,
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": promoterNameValues.reverse[name],
//         "description": descriptionValues.reverse[description],
//     };
// }

// enum Description {
//     LIVE_NATION_MUSIC_NTL_USA,
//     NFL_EXHIBITION_PRESEASON_NTL_USA,
//     PROMOTED_BY_VENUE_NTL_USA
// }

// final descriptionValues = EnumValues({
//     "LIVE NATION MUSIC / NTL / USA": Description.LIVE_NATION_MUSIC_NTL_USA,
//     "NFL EXHIBITION & PRESEASON / NTL / USA": Description.NFL_EXHIBITION_PRESEASON_NTL_USA,
//     "PROMOTED BY VENUE / NTL / USA": Description.PROMOTED_BY_VENUE_NTL_USA
// });

// enum PromoterName {
//     LIVE_NATION_MUSIC,
//     NFL_EXHIBITION_PRESEASON,
//     PROMOTED_BY_VENUE
// }

// final promoterNameValues = EnumValues({
//     "LIVE NATION MUSIC": PromoterName.LIVE_NATION_MUSIC,
//     "NFL EXHIBITION & PRESEASON": PromoterName.NFL_EXHIBITION_PRESEASON,
//     "PROMOTED BY VENUE": PromoterName.PROMOTED_BY_VENUE
// });

// class Sales {
//     Public public;
//     List<Presale>? presales;

//     Sales({
//         required this.public,
//         this.presales,
//     });

//     factory Sales.fromJson(Map<String, dynamic> json) => Sales(
//         public: Public.fromJson(json["public"]),
//         presales: json["presales"] == null ? [] : List<Presale>.from(json["presales"]!.map((x) => Presale.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "public": public.toJson(),
//         "presales": presales == null ? [] : List<dynamic>.from(presales!.map((x) => x.toJson())),
//     };
// }

// class Presale {
//     DateTime startDateTime;
//     DateTime endDateTime;
//     String name;

//     Presale({
//         required this.startDateTime,
//         required this.endDateTime,
//         required this.name,
//     });

//     factory Presale.fromJson(Map<String, dynamic> json) => Presale(
//         startDateTime: DateTime.parse(json["startDateTime"]),
//         endDateTime: DateTime.parse(json["endDateTime"]),
//         name: json["name"],
//     );

//     Map<String, dynamic> toJson() => {
//         "startDateTime": startDateTime.toIso8601String(),
//         "endDateTime": endDateTime.toIso8601String(),
//         "name": name,
//     };
// }

// class Public {
//     bool startTbd;
//     bool startTba;
//     DateTime? startDateTime;
//     DateTime? endDateTime;

//     Public({
//         required this.startTbd,
//         required this.startTba,
//         this.startDateTime,
//         this.endDateTime,
//     });

//     factory Public.fromJson(Map<String, dynamic> json) => Public(
//         startTbd: json["startTBD"],
//         startTba: json["startTBA"],
//         startDateTime: json["startDateTime"] == null ? null : DateTime.parse(json["startDateTime"]),
//         endDateTime: json["endDateTime"] == null ? null : DateTime.parse(json["endDateTime"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "startTBD": startTbd,
//         "startTBA": startTba,
//         "startDateTime": startDateTime?.toIso8601String(),
//         "endDateTime": endDateTime?.toIso8601String(),
//     };
// }

// class Seatmap {
//     String staticUrl;

//     Seatmap({
//         required this.staticUrl,
//     });

//     factory Seatmap.fromJson(Map<String, dynamic> json) => Seatmap(
//         staticUrl: json["staticUrl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "staticUrl": staticUrl,
//     };
// }

// class TicketLimit {
//     String info;

//     TicketLimit({
//         required this.info,
//     });

//     factory TicketLimit.fromJson(Map<String, dynamic> json) => TicketLimit(
//         info: json["info"],
//     );

//     Map<String, dynamic> toJson() => {
//         "info": info,
//     };
// }

// class Ticketing {
//     AllInclusivePricing safeTix;
//     AllInclusivePricing allInclusivePricing;
//     HealthCheck? healthCheck;

//     Ticketing({
//         required this.safeTix,
//         required this.allInclusivePricing,
//         this.healthCheck,
//     });

//     factory Ticketing.fromJson(Map<String, dynamic> json) => Ticketing(
//         safeTix: AllInclusivePricing.fromJson(json["safeTix"]),
//         allInclusivePricing: AllInclusivePricing.fromJson(json["allInclusivePricing"]),
//         healthCheck: json["healthCheck"] == null ? null : HealthCheck.fromJson(json["healthCheck"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "safeTix": safeTix.toJson(),
//         "allInclusivePricing": allInclusivePricing.toJson(),
//         "healthCheck": healthCheck?.toJson(),
//     };
// }

// class AllInclusivePricing {
//     bool enabled;

//     AllInclusivePricing({
//         required this.enabled,
//     });

//     factory AllInclusivePricing.fromJson(Map<String, dynamic> json) => AllInclusivePricing(
//         enabled: json["enabled"],
//     );

//     Map<String, dynamic> toJson() => {
//         "enabled": enabled,
//     };
// }

// class HealthCheck {
//     String summary;
//     String description;
//     String learnMoreUrl;

//     HealthCheck({
//         required this.summary,
//         required this.description,
//         required this.learnMoreUrl,
//     });

//     factory HealthCheck.fromJson(Map<String, dynamic> json) => HealthCheck(
//         summary: json["summary"],
//         description: json["description"],
//         learnMoreUrl: json["learnMoreUrl"],
//     );

//     Map<String, dynamic> toJson() => {
//         "summary": summary,
//         "description": description,
//         "learnMoreUrl": learnMoreUrl,
//     };
// }

// enum EventType {
//     EVENT
// }

// final eventTypeValues = EnumValues({
//     "event": EventType.EVENT
// });

// class WelcomeLinks {
//     First first;
//     First self;
//     First next;
//     First last;

//     WelcomeLinks({
//         required this.first,
//         required this.self,
//         required this.next,
//         required this.last,
//     });

//     factory WelcomeLinks.fromJson(Map<String, dynamic> json) => WelcomeLinks(
//         first: First.fromJson(json["first"]),
//         self: First.fromJson(json["self"]),
//         next: First.fromJson(json["next"]),
//         last: First.fromJson(json["last"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "first": first.toJson(),
//         "self": self.toJson(),
//         "next": next.toJson(),
//         "last": last.toJson(),
//     };
// }

// class Page {
//     int size;
//     int totalElements;
//     int totalPages;
//     int number;

//     Page({
//         required this.size,
//         required this.totalElements,
//         required this.totalPages,
//         required this.number,
//     });

//     factory Page.fromJson(Map<String, dynamic> json) => Page(
//         size: json["size"],
//         totalElements: json["totalElements"],
//         totalPages: json["totalPages"],
//         number: json["number"],
//     );

//     Map<String, dynamic> toJson() => {
//         "size": size,
//         "totalElements": totalElements,
//         "totalPages": totalPages,
//         "number": number,
//     };
// }

// class EnumValues<T> {
//     Map<String, T> map;
//     late Map<T, String> reverseMap;

//     EnumValues(this.map);

//     Map<T, String> get reverse {
//         reverseMap = map.map((k, v) => MapEntry(v, k));
//         return reverseMap;
//     }
// }
