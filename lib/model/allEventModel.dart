// To parse this JSON data, do
//
//     final allEvent = allEventFromJson(jsonString);

import 'dart:convert';

AllEvent allEventFromJson(String str) => AllEvent.fromJson(json.decode(str));

class AllEvent {
  AllEventEmbedded? embedded;
  AllEventLinks? links;
  Page? page;

  AllEvent({
    this.embedded,
    this.links,
    this.page,
  });

  factory AllEvent.fromJson(Map<String, dynamic> json) => AllEvent(
        embedded: json["_embedded"] == null
            ? null
            : AllEventEmbedded.fromJson(json["_embedded"]),
        links: json["_links"] == null
            ? null
            : AllEventLinks.fromJson(json["_links"]),
        page: json["page"] == null ? null : Page.fromJson(json["page"]),
      );
}

class AllEventEmbedded {
  List<EventModel>? events;

  AllEventEmbedded({
    this.events,
  });

  factory AllEventEmbedded.fromJson(Map<String, dynamic> json) =>
      AllEventEmbedded(
        events: json["events"] == null
            ? []
            : List<EventModel>.from(
                json["events"]!.map((x) => EventModel.fromJson(x))),
      );
}

class EventModel {
  String? name;
  EventType? type;
  String? id;
  bool? test;
  String? url;
  Locale? locale;
  List<ImageView>? images;
  Sales? sales;
  Dates? dates;
  List<Classification>? classifications;
  Promoter? promoter;
  List<Promoter>? promoters;
  String? info;
  String? pleaseNote;
  EventEmbedded? embedded;
  List<Outlet>? outlets;
  List<Product>? products;
  TicketLimit? ticketLimit;

  EventModel({
    this.name,
    this.type,
    this.id,
    this.test,
    this.url,
    this.locale,
    this.images,
    this.sales,
    this.dates,
    this.classifications,
    this.promoter,
    this.embedded,
    this.promoters,
    this.info,
    this.pleaseNote,
    this.outlets,
    this.products,
    this.ticketLimit,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        name: json["name"],
        type: eventTypeValues.map[json["type"]]!,
        id: json["id"],
        test: json["test"],
        url: json["url"],
        locale: localeValues.map[json["locale"]]!,
        images: json["images"] == null
            ? []
            : List<ImageView>.from(json["images"]!.map((x) => ImageView.fromJson(x))),
        sales: json["sales"] == null ? null : Sales.fromJson(json["sales"]),
        dates: json["dates"] == null ? null : Dates.fromJson(json["dates"]),
        classifications: json["classifications"] == null
            ? []
            : List<Classification>.from(json["classifications"]!
                .map((x) => Classification.fromJson(x))),
        promoter: json["promoter"] == null
            ? null
            : Promoter.fromJson(json["promoter"]),
        promoters: json["promoters"] == null
            ? []
            : List<Promoter>.from(
                json["promoters"]!.map((x) => Promoter.fromJson(x))),
        info: json["info"],
        embedded: json["_embedded"] == null
            ? null
            : EventEmbedded.fromJson(json["_embedded"]),
        pleaseNote: json["pleaseNote"],
        outlets: json["outlets"] == null
            ? []
            : List<Outlet>.from(
                json["outlets"]!.map((x) => Outlet.fromJson(x))),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x))),
        ticketLimit: json["ticketLimit"] == null
            ? null
            : TicketLimit.fromJson(json["ticketLimit"]),
      );
}

class Accessibility {
  int? ticketLimit;
  AccessibilityId? id;

  Accessibility({
    this.ticketLimit,
    this.id,
  });

  factory Accessibility.fromJson(Map<String, dynamic> json) => Accessibility(
        ticketLimit: json["ticketLimit"],
        id: accessibilityIdValues.map[json["id"]]!,
      );

  Map<String, dynamic> toJson() => {
        "ticketLimit": ticketLimit,
        "id": accessibilityIdValues.reverse[id],
      };
}

enum AccessibilityId { ACCESSIBILITY }

final accessibilityIdValues =
    EnumValues({"accessibility": AccessibilityId.ACCESSIBILITY});

class AgeRestrictions {
  bool? legalAgeEnforced;
  AgeRestrictionsId? id;

  AgeRestrictions({
    this.legalAgeEnforced,
    this.id,
  });

  factory AgeRestrictions.fromJson(Map<String, dynamic> json) =>
      AgeRestrictions(
        legalAgeEnforced: json["legalAgeEnforced"],
        id: ageRestrictionsIdValues.map[json["id"]]!,
      );

  Map<String, dynamic> toJson() => {
        "legalAgeEnforced": legalAgeEnforced,
        "id": ageRestrictionsIdValues.reverse[id],
      };
}

enum AgeRestrictionsId { AGE_RESTRICTIONS }

final ageRestrictionsIdValues =
    EnumValues({"ageRestrictions": AgeRestrictionsId.AGE_RESTRICTIONS});

class Classification {
  bool? primary;
  Genre? segment;
  Genre? genre;
  Genre? subGenre;
  Genre? type;
  Genre? subType;
  bool? family;

  Classification({
    this.primary,
    this.segment,
    this.genre,
    this.subGenre,
    this.type,
    this.subType,
    this.family,
  });

  factory Classification.fromJson(Map<String, dynamic> json) => Classification(
        primary: json["primary"],
        segment:
            json["segment"] == null ? null : Genre.fromJson(json["segment"]),
        genre: json["genre"] == null ? null : Genre.fromJson(json["genre"]),
        subGenre:
            json["subGenre"] == null ? null : Genre.fromJson(json["subGenre"]),
        type: json["type"] == null ? null : Genre.fromJson(json["type"]),
        subType:
            json["subType"] == null ? null : Genre.fromJson(json["subType"]),
        family: json["family"],
      );

  Map<String, dynamic> toJson() => {
        "primary": primary,
        "segment": segment?.toJson(),
        "genre": genre?.toJson(),
        "subGenre": subGenre?.toJson(),
        "type": type?.toJson(),
        "subType": subType?.toJson(),
        "family": family,
      };
}

class Genre {
  String? id;
  String? name;

  Genre({
    this.id,
    this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Dates {
  Start? start;
  InitialStartDate? initialStartDate;
  Timezone? timezone;
  Status? status;
  bool? spanMultipleDays;

  Dates({
    this.start,
    this.initialStartDate,
    this.timezone,
    this.status,
    this.spanMultipleDays,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        start: json["start"] == null ? null : Start.fromJson(json["start"]),
        initialStartDate: json["initialStartDate"] == null
            ? null
            : InitialStartDate.fromJson(json["initialStartDate"]),
        status: json["status"] == null ? null : Status.fromJson(json["status"]),
        spanMultipleDays: json["spanMultipleDays"],
      );

  Map<String, dynamic> toJson() => {
        "start": start?.toJson(),
        "initialStartDate": initialStartDate?.toJson(),
        "timezone": timezone,
        "status": status?.toJson(),
        "spanMultipleDays": spanMultipleDays,
      };
}

class InitialStartDate {
  DateTime? localDate;
  String? localTime;
  DateTime? dateTime;

  InitialStartDate({
    this.localDate,
    this.localTime,
    this.dateTime,
  });

  factory InitialStartDate.fromJson(Map<String, dynamic> json) =>
      InitialStartDate(
        localDate: json["localDate"] == null
            ? null
            : DateTime.parse(json["localDate"]),
        localTime: json["localTime"],
        dateTime:
            json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "localDate":
            "${localDate!.year.toString().padLeft(4, '0')}-${localDate!.month.toString().padLeft(2, '0')}-${localDate!.day.toString().padLeft(2, '0')}",
        "localTime": localTime,
        "dateTime": dateTime?.toIso8601String(),
      };
}

class Start {
  DateTime? localDate;
  String? localTime;
  DateTime? dateTime;
  bool? dateTbd;
  bool? dateTba;
  bool? timeTba;
  bool? noSpecificTime;

  Start({
    this.localDate,
    this.localTime,
    this.dateTime,
    this.dateTbd,
    this.dateTba,
    this.timeTba,
    this.noSpecificTime,
  });

  factory Start.fromJson(Map<String, dynamic> json) => Start(
        localDate: json["localDate"] == null
            ? null
            : DateTime.parse(json["localDate"]),
        localTime: json["localTime"],
        dateTime:
            json["dateTime"] == null ? null : DateTime.parse(json["dateTime"]),
        dateTbd: json["dateTBD"],
        dateTba: json["dateTBA"],
        timeTba: json["timeTBA"],
        noSpecificTime: json["noSpecificTime"],
      );

  Map<String, dynamic> toJson() => {
        "localDate":
            "${localDate!.year.toString().padLeft(4, '0')}-${localDate!.month.toString().padLeft(2, '0')}-${localDate!.day.toString().padLeft(2, '0')}",
        "localTime": localTime,
        "dateTime": dateTime?.toIso8601String(),
        "dateTBD": dateTbd,
        "dateTBA": dateTba,
        "timeTBA": timeTba,
        "noSpecificTime": noSpecificTime,
      };
}

class Status {
  Code? code;

  Status({
    this.code,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        code: codeValues.map[json["code"]]!,
      );

  Map<String, dynamic> toJson() => {
        "code": codeValues.reverse[code],
      };
}

enum Code { CANCELLED, OFFSALE, ONSALE, RESCHEDULED }

final codeValues = EnumValues({
  "cancelled": Code.CANCELLED,
  "offsale": Code.OFFSALE,
  "onsale": Code.ONSALE,
  "rescheduled": Code.RESCHEDULED
});

enum Timezone { AMERICA_LOS_ANGELES }

class EventEmbedded {
  List<Venue>? venues;
  List<Attraction>? attractions;

  EventEmbedded({
    this.venues,
    this.attractions,
  });

  factory EventEmbedded.fromJson(Map<String, dynamic> json) => EventEmbedded(
        venues: json["venues"] == null
            ? []
            : List<Venue>.from(json["venues"]!.map((x) => Venue.fromJson(x))),
        attractions: json["attractions"] == null
            ? []
            : List<Attraction>.from(
                json["attractions"]!.map((x) => Attraction.fromJson(x))),
      );
}

class Attraction {
  String? name;
  AttractionType? type;
  String? id;
  bool? test;
  String? url;
  Locale? locale;
  AttractionExternalLinks? externalLinks;
  List<ImageView>? images;
  List<Classification>? classifications;
  Map<String, int>? upcomingEvents;
  AttractionLinks? links;
  List<String>? aliases;

  Attraction({
    this.name,
    this.type,
    this.id,
    this.test,
    this.url,
    this.locale,
    this.externalLinks,
    this.images,
    this.classifications,
    this.upcomingEvents,
    this.links,
    this.aliases,
  });

  factory Attraction.fromJson(Map<String, dynamic> json) => Attraction(
        name: json["name"],
        type: attractionTypeValues.map[json["type"]]!,
        id: json["id"],
        test: json["test"],
        url: json["url"],
        locale: localeValues.map[json["locale"]]!,
        externalLinks: json["externalLinks"] == null
            ? null
            : AttractionExternalLinks.fromJson(json["externalLinks"]),
        images: json["images"] == null
            ? []
            : List<ImageView>.from(json["images"]!.map((x) => ImageView.fromJson(x))),
        classifications: json["classifications"] == null
            ? []
            : List<Classification>.from(json["classifications"]!
                .map((x) => Classification.fromJson(x))),
        upcomingEvents: Map.from(json["upcomingEvents"]!)
            .map((k, v) => MapEntry<String, int>(k, v)),
        links: json["_links"] == null
            ? null
            : AttractionLinks.fromJson(json["_links"]),
        aliases: json["aliases"] == null
            ? []
            : List<String>.from(json["aliases"]!.map((x) => x)),
      );
}

class AttractionExternalLinks {
  List<Facebook>? wiki;
  List<Musicbrainz>? musicbrainz;
  List<Facebook>? twitter;
  List<Facebook>? youtube;
  List<Facebook>? itunes;
  List<Facebook>? lastfm;
  List<Facebook>? spotify;
  List<Facebook>? facebook;
  List<Facebook>? instagram;
  List<Facebook>? homepage;
  List<Facebook>? tiktok;

  AttractionExternalLinks({
    this.wiki,
    this.musicbrainz,
    this.twitter,
    this.youtube,
    this.itunes,
    this.lastfm,
    this.spotify,
    this.facebook,
    this.instagram,
    this.homepage,
    this.tiktok,
  });

  factory AttractionExternalLinks.fromJson(Map<String, dynamic> json) =>
      AttractionExternalLinks(
        wiki: json["wiki"] == null
            ? []
            : List<Facebook>.from(
                json["wiki"]!.map((x) => Facebook.fromJson(x))),
        musicbrainz: json["musicbrainz"] == null
            ? []
            : List<Musicbrainz>.from(
                json["musicbrainz"]!.map((x) => Musicbrainz.fromJson(x))),
        twitter: json["twitter"] == null
            ? []
            : List<Facebook>.from(
                json["twitter"]!.map((x) => Facebook.fromJson(x))),
        youtube: json["youtube"] == null
            ? []
            : List<Facebook>.from(
                json["youtube"]!.map((x) => Facebook.fromJson(x))),
        itunes: json["itunes"] == null
            ? []
            : List<Facebook>.from(
                json["itunes"]!.map((x) => Facebook.fromJson(x))),
        lastfm: json["lastfm"] == null
            ? []
            : List<Facebook>.from(
                json["lastfm"]!.map((x) => Facebook.fromJson(x))),
        spotify: json["spotify"] == null
            ? []
            : List<Facebook>.from(
                json["spotify"]!.map((x) => Facebook.fromJson(x))),
        facebook: json["facebook"] == null
            ? []
            : List<Facebook>.from(
                json["facebook"]!.map((x) => Facebook.fromJson(x))),
        instagram: json["instagram"] == null
            ? []
            : List<Facebook>.from(
                json["instagram"]!.map((x) => Facebook.fromJson(x))),
        homepage: json["homepage"] == null
            ? []
            : List<Facebook>.from(
                json["homepage"]!.map((x) => Facebook.fromJson(x))),
        tiktok: json["tiktok"] == null
            ? []
            : List<Facebook>.from(
                json["tiktok"]!.map((x) => Facebook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wiki": wiki == null
            ? []
            : List<dynamic>.from(wiki!.map((x) => x.toJson())),
        "musicbrainz": musicbrainz == null
            ? []
            : List<dynamic>.from(musicbrainz!.map((x) => x.toJson())),
        "twitter": twitter == null
            ? []
            : List<dynamic>.from(twitter!.map((x) => x.toJson())),
        "youtube": youtube == null
            ? []
            : List<dynamic>.from(youtube!.map((x) => x.toJson())),
        "itunes": itunes == null
            ? []
            : List<dynamic>.from(itunes!.map((x) => x.toJson())),
        "lastfm": lastfm == null
            ? []
            : List<dynamic>.from(lastfm!.map((x) => x.toJson())),
        "spotify": spotify == null
            ? []
            : List<dynamic>.from(spotify!.map((x) => x.toJson())),
        "facebook": facebook == null
            ? []
            : List<dynamic>.from(facebook!.map((x) => x.toJson())),
        "instagram": instagram == null
            ? []
            : List<dynamic>.from(instagram!.map((x) => x.toJson())),
        "homepage": homepage == null
            ? []
            : List<dynamic>.from(homepage!.map((x) => x.toJson())),
        "tiktok": tiktok == null
            ? []
            : List<dynamic>.from(tiktok!.map((x) => x.toJson())),
      };
}

class Facebook {
  String? url;

  Facebook({
    this.url,
  });

  factory Facebook.fromJson(Map<String, dynamic> json) => Facebook(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class Musicbrainz {
  String? id;
  String? url;

  Musicbrainz({
    this.id,
    this.url,
  });

  factory Musicbrainz.fromJson(Map<String, dynamic> json) => Musicbrainz(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class ImageView {
  String? ratio;
  String? url;
  int? width;
  int? height;
  bool? fallback;

  ImageView({
    this.ratio,
    this.url,
    this.width,
    this.height,
    this.fallback,
  });

  factory ImageView.fromJson(Map<String, dynamic> json) => ImageView(
        ratio: json["ratio"] ?? "16_9",
        url: json["url"],
        width: json["width"],
        height: json["height"],
        fallback: json["fallback"],
      );
}

class AttractionLinks {
  First? self;

  AttractionLinks({
    this.self,
  });

  factory AttractionLinks.fromJson(Map<String, dynamic> json) =>
      AttractionLinks(
        self: json["self"] == null ? null : First.fromJson(json["self"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self?.toJson(),
      };
}

class First {
  String? href;

  First({
    this.href,
  });

  factory First.fromJson(Map<String, dynamic> json) => First(
        href: json["href"],
      );

  Map<String, dynamic> toJson() => {
        "href": href,
      };
}

enum Locale { EN_US }

final localeValues = EnumValues({"en-us": Locale.EN_US});

enum AttractionType { ATTRACTION }

final attractionTypeValues =
    EnumValues({"attraction": AttractionType.ATTRACTION});

class Venue {
  String? name;
  String? type;
  String? id;
  bool? test;
  String? url;
  Locale? locale;
  List<ImageView>? images;
  String? postalCode;
  String? timezone;
  City? city;
  State? state;
  Country? country;
  Address? address;
  Location? location;
  List<Genre>? markets;
  List<Dma>? dmas;
  UpcomingEvents? upcomingEvents;
  AttractionLinks? links;
  Social? social;
  BoxOfficeInfo? boxOfficeInfo;
  String? parkingDetail;
  GeneralInfo? generalInfo;
  Ada? ada;
  List<String>? aliases;
  String? accessibleSeatingDetail;
  VenueExternalLinks? externalLinks;

  Venue({
    this.name,
    this.type,
    this.id,
    this.test,
    this.url,
    this.locale,
    this.images,
    this.postalCode,
    this.timezone,
    this.city,
    this.state,
    this.country,
    this.address,
    this.location,
    this.markets,
    this.dmas,
    this.upcomingEvents,
    this.links,
    this.social,
    this.boxOfficeInfo,
    this.parkingDetail,
    this.generalInfo,
    this.ada,
    this.aliases,
    this.accessibleSeatingDetail,
    this.externalLinks,
  });

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        name: json["name"],
        type: json["type"],
        id: json["id"],
        test: json["test"],
        url: json["url"],
        locale: localeValues.map[json["locale"]]!,
        images: json["images"] == null
            ? []
            : List<ImageView>.from(json["images"]!.map((x) => ImageView.fromJson(x))),
        postalCode: json["postalCode"],
        timezone: json["timezone"],
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        state: json["state"] == null ? null : State.fromJson(json["state"]),
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        address:
            json["address"] == null ? null : Address.fromJson(json["address"]),
        location: json["location"] == null
            ? null
            : Location.fromJson(json["location"]),
        markets: json["markets"] == null
            ? []
            : List<Genre>.from(json["markets"]!.map((x) => Genre.fromJson(x))),
        dmas: json["dmas"] == null
            ? []
            : List<Dma>.from(json["dmas"]!.map((x) => Dma.fromJson(x))),
        upcomingEvents: json["upcomingEvents"] == null
            ? null
            : UpcomingEvents.fromJson(json["upcomingEvents"]),
        links: json["_links"] == null
            ? null
            : AttractionLinks.fromJson(json["_links"]),
        social: json["social"] == null ? null : Social.fromJson(json["social"]),
        boxOfficeInfo: json["boxOfficeInfo"] == null
            ? null
            : BoxOfficeInfo.fromJson(json["boxOfficeInfo"]),
        parkingDetail: json["parkingDetail"],
        generalInfo: json["generalInfo"] == null
            ? null
            : GeneralInfo.fromJson(json["generalInfo"]),
        ada: json["ada"] == null ? null : Ada.fromJson(json["ada"]),
        aliases: json["aliases"] == null
            ? []
            : List<String>.from(json["aliases"]!.map((x) => x)),
        accessibleSeatingDetail: json["accessibleSeatingDetail"],
        externalLinks: json["externalLinks"] == null
            ? null
            : VenueExternalLinks.fromJson(json["externalLinks"]),
      );
}

class Ada {
  String? adaPhones;
  String? adaCustomCopy;
  String? adaHours;

  Ada({
    this.adaPhones,
    this.adaCustomCopy,
    this.adaHours,
  });

  factory Ada.fromJson(Map<String, dynamic> json) => Ada(
        adaPhones: json["adaPhones"],
        adaCustomCopy: json["adaCustomCopy"],
        adaHours: json["adaHours"],
      );

  Map<String, dynamic> toJson() => {
        "adaPhones": adaPhones,
        "adaCustomCopy": adaCustomCopy,
        "adaHours": adaHours,
      };
}

class Address {
  String? line1;

  Address({
    this.line1,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        line1: json["line1"],
      );

  Map<String, dynamic> toJson() => {
        "line1": line1,
      };
}

class BoxOfficeInfo {
  String? phoneNumberDetail;
  String? openHoursDetail;
  String? acceptedPaymentDetail;
  String? willCallDetail;

  BoxOfficeInfo({
    this.phoneNumberDetail,
    this.openHoursDetail,
    this.acceptedPaymentDetail,
    this.willCallDetail,
  });

  factory BoxOfficeInfo.fromJson(Map<String, dynamic> json) => BoxOfficeInfo(
        phoneNumberDetail: json["phoneNumberDetail"],
        openHoursDetail: json["openHoursDetail"],
        acceptedPaymentDetail: json["acceptedPaymentDetail"],
        willCallDetail: json["willCallDetail"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumberDetail": phoneNumberDetail,
        "openHoursDetail": openHoursDetail,
        "acceptedPaymentDetail": acceptedPaymentDetail,
        "willCallDetail": willCallDetail,
      };
}

class City {
  String? name;

  City({
    this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}

class Country {
  CountryName? name;
  CountryCode? countryCode;

  Country({
    this.name,
    this.countryCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        name: countryNameValues.map[json["name"]]!,
        countryCode: countryCodeValues.map[json["countryCode"]]!,
      );

  Map<String, dynamic> toJson() => {
        "name": countryNameValues.reverse[name],
        "countryCode": countryCodeValues.reverse[countryCode],
      };
}

enum CountryCode { US }

final countryCodeValues = EnumValues({"US": CountryCode.US});

enum CountryName { UNITED_STATES_OF_AMERICA }

final countryNameValues = EnumValues(
    {"United States Of America": CountryName.UNITED_STATES_OF_AMERICA});

class Dma {
  int? id;

  Dma({
    this.id,
  });

  factory Dma.fromJson(Map<String, dynamic> json) => Dma(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class VenueExternalLinks {
  List<Facebook>? appDeepLink;

  VenueExternalLinks({
    this.appDeepLink,
  });

  factory VenueExternalLinks.fromJson(Map<String, dynamic> json) =>
      VenueExternalLinks(
        appDeepLink: json["appDeepLink"] == null
            ? []
            : List<Facebook>.from(
                json["appDeepLink"]!.map((x) => Facebook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "appDeepLink": appDeepLink == null
            ? []
            : List<dynamic>.from(appDeepLink!.map((x) => x.toJson())),
      };
}

class GeneralInfo {
  String? generalRule;
  String? childRule;

  GeneralInfo({
    this.generalRule,
    this.childRule,
  });

  factory GeneralInfo.fromJson(Map<String, dynamic> json) => GeneralInfo(
        generalRule: json["generalRule"],
        childRule: json["childRule"],
      );

  Map<String, dynamic> toJson() => {
        "generalRule": generalRule,
        "childRule": childRule,
      };
}

class Location {
  String? longitude;
  String? latitude;

  Location({
    this.longitude,
    this.latitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}

class Social {
  Twitter? twitter;

  Social({
    this.twitter,
  });

  factory Social.fromJson(Map<String, dynamic> json) => Social(
        twitter:
            json["twitter"] == null ? null : Twitter.fromJson(json["twitter"]),
      );

  Map<String, dynamic> toJson() => {
        "twitter": twitter?.toJson(),
      };
}

class Twitter {
  String? handle;

  Twitter({
    this.handle,
  });

  factory Twitter.fromJson(Map<String, dynamic> json) => Twitter(
        handle: json["handle"],
      );

  Map<String, dynamic> toJson() => {
        "handle": handle,
      };
}

class State {
  String? name;
  String? stateCode;

  State({
    this.name,
    this.stateCode,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        name: json["name"],
        stateCode: json["stateCode"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "stateCode": stateCode,
      };
}

class UpcomingEvents {
  int? ticketmaster;
  int? total;
  int? filtered;
  int? tmr;
  int? archtics;
  int? veeps;

  UpcomingEvents({
    this.ticketmaster,
    this.total,
    this.filtered,
    this.tmr,
    this.archtics,
    this.veeps,
  });

  factory UpcomingEvents.fromJson(Map<String, dynamic> json) => UpcomingEvents(
        ticketmaster: json["ticketmaster"],
        total: json["_total"],
        filtered: json["_filtered"],
        tmr: json["tmr"],
        archtics: json["archtics"],
        veeps: json["veeps"],
      );

  Map<String, dynamic> toJson() => {
        "ticketmaster": ticketmaster,
        "_total": total,
        "_filtered": filtered,
        "tmr": tmr,
        "archtics": archtics,
        "veeps": veeps,
      };
}

class EventLinks {
  First? self;
  List<First>? attractions;
  List<First>? venues;

  EventLinks({
    this.self,
    this.attractions,
    this.venues,
  });

  factory EventLinks.fromJson(Map<String, dynamic> json) => EventLinks(
        self: json["self"] == null ? null : First.fromJson(json["self"]),
        attractions: json["attractions"] == null
            ? []
            : List<First>.from(
                json["attractions"]!.map((x) => First.fromJson(x))),
        venues: json["venues"] == null
            ? []
            : List<First>.from(json["venues"]!.map((x) => First.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "self": self?.toJson(),
        "attractions": attractions == null
            ? []
            : List<dynamic>.from(attractions!.map((x) => x.toJson())),
        "venues": venues == null
            ? []
            : List<dynamic>.from(venues!.map((x) => x.toJson())),
      };
}

class Outlet {
  String? url;
  String? type;

  Outlet({
    this.url,
    this.type,
  });

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
        url: json["url"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
      };
}

class PriceRange {
  double? min;
  double? max;

  PriceRange({
    this.min,
    this.max,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        min: json["min"]?.toDouble(),
        max: json["max"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
      };
}

class Product {
  String? name;
  String? id;
  String? url;
  String? type;
  List<Classification>? classifications;

  Product({
    this.name,
    this.id,
    this.url,
    this.type,
    this.classifications,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        id: json["id"],
        url: json["url"],
        type: json["type"] ?? '',
        classifications: json["classifications"] == null
            ? []
            : List<Classification>.from(json["classifications"]!
                .map((x) => Classification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "url": url,
        "type": productTypeValues.reverse[type],
        "classifications": classifications == null
            ? []
            : List<dynamic>.from(classifications!.map((x) => x.toJson())),
      };
}

enum ProductType { PARKING, UPSELL }

final productTypeValues =
    EnumValues({"Parking": ProductType.PARKING, "Upsell": ProductType.UPSELL});

class Promoter {
  String? id;
  String? name;
  String? description;

  Promoter({
    this.id,
    this.name,
    this.description,
  });

  factory Promoter.fromJson(Map<String, dynamic> json) => Promoter(
        id: json["id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
      };
}

class Sales {
  Public? public;
  List<Presale>? presales;

  Sales({
    this.public,
    this.presales,
  });

  factory Sales.fromJson(Map<String, dynamic> json) => Sales(
        public: json["public"] == null ? null : Public.fromJson(json["public"]),
        presales: json["presales"] == null
            ? []
            : List<Presale>.from(
                json["presales"]!.map((x) => Presale.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "public": public?.toJson(),
        "presales": presales == null
            ? []
            : List<dynamic>.from(presales!.map((x) => x.toJson())),
      };
}

class Presale {
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? name;

  Presale({
    this.startDateTime,
    this.endDateTime,
    this.name,
  });

  factory Presale.fromJson(Map<String, dynamic> json) => Presale(
        startDateTime: json["startDateTime"] == null
            ? null
            : DateTime.parse(json["startDateTime"]),
        endDateTime: json["endDateTime"] == null
            ? null
            : DateTime.parse(json["endDateTime"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "startDateTime": startDateTime?.toIso8601String(),
        "endDateTime": endDateTime?.toIso8601String(),
        "name": name,
      };
}

class Public {
  DateTime? startDateTime;
  bool? startTbd;
  bool? startTba;
  DateTime? endDateTime;

  Public({
    this.startDateTime,
    this.startTbd,
    this.startTba,
    this.endDateTime,
  });

  factory Public.fromJson(Map<String, dynamic> json) => Public(
        startDateTime: json["startDateTime"] == null
            ? null
            : DateTime.parse(json["startDateTime"]),
        startTbd: json["startTBD"],
        startTba: json["startTBA"],
        endDateTime: json["endDateTime"] == null
            ? null
            : DateTime.parse(json["endDateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "startDateTime": startDateTime?.toIso8601String(),
        "startTBD": startTbd,
        "startTBA": startTba,
        "endDateTime": endDateTime?.toIso8601String(),
      };
}

class Seatmap {
  String? staticUrl;
  SeatmapId? id;

  Seatmap({
    this.staticUrl,
    this.id,
  });

  factory Seatmap.fromJson(Map<String, dynamic> json) => Seatmap(
        staticUrl: json["staticUrl"],
        id: seatmapIdValues.map[json["id"]]!,
      );

  Map<String, dynamic> toJson() => {
        "staticUrl": staticUrl,
        "id": seatmapIdValues.reverse[id],
      };
}

enum SeatmapId { SEATMAP }

final seatmapIdValues = EnumValues({"seatmap": SeatmapId.SEATMAP});

class TicketLimit {
  String? info;
  TicketLimitId? id;

  TicketLimit({
    this.info,
    this.id,
  });

  factory TicketLimit.fromJson(Map<String, dynamic> json) => TicketLimit(
        info: json["info"],
        id: ticketLimitIdValues.map[json["id"]]!,
      );

  Map<String, dynamic> toJson() => {
        "info": info,
        "id": ticketLimitIdValues.reverse[id],
      };
}

enum TicketLimitId { TICKET_LIMIT }

final ticketLimitIdValues =
    EnumValues({"ticketLimit": TicketLimitId.TICKET_LIMIT});

class Ticketing {
  SafeTix? safeTix;
  AllInclusivePricing? allInclusivePricing;
  TicketingId? id;

  Ticketing({
    this.safeTix,
    this.allInclusivePricing,
    this.id,
  });

  factory Ticketing.fromJson(Map<String, dynamic> json) => Ticketing(
        safeTix:
            json["safeTix"] == null ? null : SafeTix.fromJson(json["safeTix"]),
        allInclusivePricing: json["allInclusivePricing"] == null
            ? null
            : AllInclusivePricing.fromJson(json["allInclusivePricing"]),
        id: ticketingIdValues.map[json["id"]]!,
      );

  Map<String, dynamic> toJson() => {
        "safeTix": safeTix?.toJson(),
        "allInclusivePricing": allInclusivePricing?.toJson(),
        "id": ticketingIdValues.reverse[id],
      };
}

class AllInclusivePricing {
  bool? enabled;

  AllInclusivePricing({
    this.enabled,
  });

  factory AllInclusivePricing.fromJson(Map<String, dynamic> json) =>
      AllInclusivePricing(
        enabled: json["enabled"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
      };
}

enum TicketingId { TICKETING }

final ticketingIdValues = EnumValues({"ticketing": TicketingId.TICKETING});

class SafeTix {
  bool? enabled;
  bool? inAppOnlyEnabled;

  SafeTix({
    this.enabled,
    this.inAppOnlyEnabled,
  });

  factory SafeTix.fromJson(Map<String, dynamic> json) => SafeTix(
        enabled: json["enabled"],
        inAppOnlyEnabled: json["inAppOnlyEnabled"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
        "inAppOnlyEnabled": inAppOnlyEnabled,
      };
}

enum EventType { EVENT }

final eventTypeValues = EnumValues({"event": EventType.EVENT});

class AllEventLinks {
  First? first;
  First? self;
  First? next;
  First? last;

  AllEventLinks({
    this.first,
    this.self,
    this.next,
    this.last,
  });

  factory AllEventLinks.fromJson(Map<String, dynamic> json) => AllEventLinks(
        first: json["first"] == null ? null : First.fromJson(json["first"]),
        self: json["self"] == null ? null : First.fromJson(json["self"]),
        next: json["next"] == null ? null : First.fromJson(json["next"]),
        last: json["last"] == null ? null : First.fromJson(json["last"]),
      );

  Map<String, dynamic> toJson() => {
        "first": first?.toJson(),
        "self": self?.toJson(),
        "next": next?.toJson(),
        "last": last?.toJson(),
      };
}

class Page {
  int? size;
  int? totalElements;
  int? totalPages;
  int? number;

  Page({
    this.size,
    this.totalElements,
    this.totalPages,
    this.number,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
        size: json["size"],
        totalElements: json["totalElements"],
        totalPages: json["totalPages"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "size": size,
        "totalElements": totalElements,
        "totalPages": totalPages,
        "number": number,
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
