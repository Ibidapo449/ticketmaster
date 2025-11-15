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

  AllEvent copyWith({
    AllEventEmbedded? embedded,
    AllEventLinks? links,
    Page? page,
  }) =>
      AllEvent(
        embedded: embedded ?? this.embedded,
        links: links ?? this.links,
        page: page ?? this.page,
      );

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

  AllEventEmbedded copyWith({
    List<EventModel>? events,
  }) =>
      AllEventEmbedded(
        events: events ?? this.events,
      );

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

  List<Image>? images;

  EventEmbedded? embedded;

  EventModel({
    this.name,
    this.images,
    this.embedded,
  });

  EventModel copyWith({
    String? name,
    List<Image>? images,
    EventEmbedded? embedded,
  }) =>
      EventModel(
        name: name ?? this.name,
        images: images ?? this.images,
        embedded: embedded ?? this.embedded,
      );

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        name: json["name"],
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        embedded: json["_embedded"] == null
            ? null
            : EventEmbedded.fromJson(json["_embedded"]),
      );
}

class Accessibility {
  int? ticketLimit;
  String? info;
  String? url;
  String? urlText;

  Accessibility({
    this.ticketLimit,
    this.info,
    this.url,
    this.urlText,
  });

  Accessibility copyWith({
    int? ticketLimit,
    String? info,
    String? url,
    String? urlText,
  }) =>
      Accessibility(
        ticketLimit: ticketLimit ?? this.ticketLimit,
        info: info ?? this.info,
        url: url ?? this.url,
        urlText: urlText ?? this.urlText,
      );

  factory Accessibility.fromJson(Map<String, dynamic> json) => Accessibility(
        ticketLimit: json["ticketLimit"],
        info: json["info"],
        url: json["url"],
        urlText: json["urlText"],
      );

  Map<String, dynamic> toJson() => {
        "ticketLimit": ticketLimit,
        "info": info,
        "url": url,
        "urlText": urlText,
      };
}

class AgeRestrictions {
  bool? legalAgeEnforced;

  AgeRestrictions({
    this.legalAgeEnforced,
  });

  AgeRestrictions copyWith({
    bool? legalAgeEnforced,
  }) =>
      AgeRestrictions(
        legalAgeEnforced: legalAgeEnforced ?? this.legalAgeEnforced,
      );

  factory AgeRestrictions.fromJson(Map<String, dynamic> json) =>
      AgeRestrictions(
        legalAgeEnforced: json["legalAgeEnforced"],
      );

  Map<String, dynamic> toJson() => {
        "legalAgeEnforced": legalAgeEnforced,
      };
}

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

  Classification copyWith({
    bool? primary,
    Genre? segment,
    Genre? genre,
    Genre? subGenre,
    Genre? type,
    Genre? subType,
    bool? family,
  }) =>
      Classification(
        primary: primary ?? this.primary,
        segment: segment ?? this.segment,
        genre: genre ?? this.genre,
        subGenre: subGenre ?? this.subGenre,
        type: type ?? this.type,
        subType: subType ?? this.subType,
        family: family ?? this.family,
      );

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

  Genre copyWith({
    String? id,
    String? name,
  }) =>
      Genre(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class DoorsTimes {
  DateTime? localDate;
  String? localTime;
  DateTime? dateTime;

  DoorsTimes({
    this.localDate,
    this.localTime,
    this.dateTime,
  });

  DoorsTimes copyWith({
    DateTime? localDate,
    String? localTime,
    DateTime? dateTime,
  }) =>
      DoorsTimes(
        localDate: localDate ?? this.localDate,
        localTime: localTime ?? this.localTime,
        dateTime: dateTime ?? this.dateTime,
      );

  factory DoorsTimes.fromJson(Map<String, dynamic> json) => DoorsTimes(
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

  Start copyWith({
    DateTime? localDate,
    String? localTime,
    DateTime? dateTime,
    bool? dateTbd,
    bool? dateTba,
    bool? timeTba,
    bool? noSpecificTime,
  }) =>
      Start(
        localDate: localDate ?? this.localDate,
        localTime: localTime ?? this.localTime,
        dateTime: dateTime ?? this.dateTime,
        dateTbd: dateTbd ?? this.dateTbd,
        dateTba: dateTba ?? this.dateTba,
        timeTba: timeTba ?? this.timeTba,
        noSpecificTime: noSpecificTime ?? this.noSpecificTime,
      );

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

class EventEmbedded {
  List<Venue>? venues;

  EventEmbedded({
    this.venues,
  });

  EventEmbedded copyWith({
    List<Venue>? venues,
  }) =>
      EventEmbedded(
        venues: venues ?? this.venues,
      );

  factory EventEmbedded.fromJson(Map<String, dynamic> json) => EventEmbedded(
        venues: json["venues"] == null
            ? []
            : List<Venue>.from(json["venues"]!.map((x) => Venue.fromJson(x))),
      );
}

class ExternalLinks {
  List<Facebook>? youtube;
  List<Facebook>? twitter;
  List<Facebook>? itunes;
  List<Facebook>? lastfm;
  List<Facebook>? spotify;
  List<Facebook>? facebook;
  List<Facebook>? wiki;
  List<Facebook>? instagram;
  List<Musicbrainz>? musicbrainz;
  List<Facebook>? homepage;

  ExternalLinks({
    this.youtube,
    this.twitter,
    this.itunes,
    this.lastfm,
    this.spotify,
    this.facebook,
    this.wiki,
    this.instagram,
    this.musicbrainz,
    this.homepage,
  });

  ExternalLinks copyWith({
    List<Facebook>? youtube,
    List<Facebook>? twitter,
    List<Facebook>? itunes,
    List<Facebook>? lastfm,
    List<Facebook>? spotify,
    List<Facebook>? facebook,
    List<Facebook>? wiki,
    List<Facebook>? instagram,
    List<Musicbrainz>? musicbrainz,
    List<Facebook>? homepage,
  }) =>
      ExternalLinks(
        youtube: youtube ?? this.youtube,
        twitter: twitter ?? this.twitter,
        itunes: itunes ?? this.itunes,
        lastfm: lastfm ?? this.lastfm,
        spotify: spotify ?? this.spotify,
        facebook: facebook ?? this.facebook,
        wiki: wiki ?? this.wiki,
        instagram: instagram ?? this.instagram,
        musicbrainz: musicbrainz ?? this.musicbrainz,
        homepage: homepage ?? this.homepage,
      );

  factory ExternalLinks.fromJson(Map<String, dynamic> json) => ExternalLinks(
        youtube: json["youtube"] == null
            ? []
            : List<Facebook>.from(
                json["youtube"]!.map((x) => Facebook.fromJson(x))),
        twitter: json["twitter"] == null
            ? []
            : List<Facebook>.from(
                json["twitter"]!.map((x) => Facebook.fromJson(x))),
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
        wiki: json["wiki"] == null
            ? []
            : List<Facebook>.from(
                json["wiki"]!.map((x) => Facebook.fromJson(x))),
        instagram: json["instagram"] == null
            ? []
            : List<Facebook>.from(
                json["instagram"]!.map((x) => Facebook.fromJson(x))),
        musicbrainz: json["musicbrainz"] == null
            ? []
            : List<Musicbrainz>.from(
                json["musicbrainz"]!.map((x) => Musicbrainz.fromJson(x))),
        homepage: json["homepage"] == null
            ? []
            : List<Facebook>.from(
                json["homepage"]!.map((x) => Facebook.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "youtube": youtube == null
            ? []
            : List<dynamic>.from(youtube!.map((x) => x.toJson())),
        "twitter": twitter == null
            ? []
            : List<dynamic>.from(twitter!.map((x) => x.toJson())),
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
        "wiki": wiki == null
            ? []
            : List<dynamic>.from(wiki!.map((x) => x.toJson())),
        "instagram": instagram == null
            ? []
            : List<dynamic>.from(instagram!.map((x) => x.toJson())),
        "musicbrainz": musicbrainz == null
            ? []
            : List<dynamic>.from(musicbrainz!.map((x) => x.toJson())),
        "homepage": homepage == null
            ? []
            : List<dynamic>.from(homepage!.map((x) => x.toJson())),
      };
}

class Facebook {
  String? url;

  Facebook({
    this.url,
  });

  Facebook copyWith({
    String? url,
  }) =>
      Facebook(
        url: url ?? this.url,
      );

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

  Musicbrainz copyWith({
    String? id,
    String? url,
  }) =>
      Musicbrainz(
        id: id ?? this.id,
        url: url ?? this.url,
      );

  factory Musicbrainz.fromJson(Map<String, dynamic> json) => Musicbrainz(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}

class Image {
  String? ratio;
  String? url;
  int? width;
  int? height;
  bool? fallback;

  Image({
    this.ratio,
    this.url,
    this.width,
    this.height,
    this.fallback,
  });

  Image copyWith({
    String? ratio,
    String? url,
    int? width,
    int? height,
    bool? fallback,
  }) =>
      Image(
        ratio: ratio ?? this.ratio,
        url: url ?? this.url,
        width: width ?? this.width,
        height: height ?? this.height,
        fallback: fallback ?? this.fallback,
      );

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        ratio: json["ratio"],
        url: json["url"],
        width: json["width"],
        height: json["height"],
        fallback: json["fallback"],
      );

  Map<String, dynamic> toJson() => {
        "ratio": ratio,
        "url": url,
        "width": width,
        "height": height,
        "fallback": fallback,
      };
}

enum Ratio { THE_169, THE_32, THE_43 }

final ratioValues = EnumValues(
    {"16_9": Ratio.THE_169, "3_2": Ratio.THE_32, "4_3": Ratio.THE_43});

class AttractionLinks {
  First? self;

  AttractionLinks({
    this.self,
  });

  AttractionLinks copyWith({
    First? self,
  }) =>
      AttractionLinks(
        self: self ?? this.self,
      );

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

  First copyWith({
    String? href,
  }) =>
      First(
        href: href ?? this.href,
      );

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

class UpcomingEvents {
  int? ticketmaster;
  int? total;
  int? filtered;
  int? tmr;
  int? archtics;

  UpcomingEvents({
    this.ticketmaster,
    this.total,
    this.filtered,
    this.tmr,
    this.archtics,
  });

  UpcomingEvents copyWith({
    int? ticketmaster,
    int? total,
    int? filtered,
    int? tmr,
    int? archtics,
  }) =>
      UpcomingEvents(
        ticketmaster: ticketmaster ?? this.ticketmaster,
        total: total ?? this.total,
        filtered: filtered ?? this.filtered,
        tmr: tmr ?? this.tmr,
        archtics: archtics ?? this.archtics,
      );

  factory UpcomingEvents.fromJson(Map<String, dynamic> json) => UpcomingEvents(
        ticketmaster: json["ticketmaster"],
        total: json["_total"],
        filtered: json["_filtered"],
        tmr: json["tmr"],
        archtics: json["archtics"],
      );

  Map<String, dynamic> toJson() => {
        "ticketmaster": ticketmaster,
        "_total": total,
        "_filtered": filtered,
        "tmr": tmr,
        "archtics": archtics,
      };
}

class Venue {
  String? name;
  VenueType? type;
  String? id;
  bool? test;
  String? url;
  Locale? locale;
  List<Image>? images;
  String? postalCode;

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
  String? accessibleSeatingDetail;
  GeneralInfo? generalInfo;
  Ada? ada;

  Venue({
    this.name,
    this.type,
    this.id,
    this.test,
    this.url,
    this.locale,
    this.images,
    this.postalCode,
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
    this.accessibleSeatingDetail,
    this.generalInfo,
    this.ada,
  });

  Venue copyWith({
    String? name,
    VenueType? type,
    String? id,
    bool? test,
    String? url,
    Locale? locale,
    List<Image>? images,
    String? postalCode,
    City? city,
    State? state,
    Country? country,
    Address? address,
    Location? location,
    List<Genre>? markets,
    List<Dma>? dmas,
    UpcomingEvents? upcomingEvents,
    AttractionLinks? links,
    Social? social,
    BoxOfficeInfo? boxOfficeInfo,
    String? parkingDetail,
    String? accessibleSeatingDetail,
    GeneralInfo? generalInfo,
    Ada? ada,
  }) =>
      Venue(
        name: name ?? this.name,
        type: type ?? this.type,
        id: id ?? this.id,
        test: test ?? this.test,
        url: url ?? this.url,
        locale: locale ?? this.locale,
        images: images ?? this.images,
        postalCode: postalCode ?? this.postalCode,
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
        address: address ?? this.address,
        location: location ?? this.location,
        markets: markets ?? this.markets,
        dmas: dmas ?? this.dmas,
        upcomingEvents: upcomingEvents ?? this.upcomingEvents,
        links: links ?? this.links,
        social: social ?? this.social,
        boxOfficeInfo: boxOfficeInfo ?? this.boxOfficeInfo,
        parkingDetail: parkingDetail ?? this.parkingDetail,
        accessibleSeatingDetail:
            accessibleSeatingDetail ?? this.accessibleSeatingDetail,
        generalInfo: generalInfo ?? this.generalInfo,
        ada: ada ?? this.ada,
      );

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        name: json["name"],
        type: venueTypeValues.map[json["type"]]!,
        id: json["id"],
        test: json["test"],
        url: json["url"],
        locale: localeValues.map[json["locale"]]!,
        images: json["images"] == null
            ? []
            : List<Image>.from(json["images"]!.map((x) => Image.fromJson(x))),
        postalCode: json["postalCode"],
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
        accessibleSeatingDetail: json["accessibleSeatingDetail"],
        generalInfo: json["generalInfo"] == null
            ? null
            : GeneralInfo.fromJson(json["generalInfo"]),
        ada: json["ada"] == null ? null : Ada.fromJson(json["ada"]),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": venueTypeValues.reverse[type],
        "id": id,
        "test": test,
        "url": url,
        "locale": localeValues.reverse[locale],
        "images": images == null
            ? []
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "postalCode": postalCode,
        "city": city?.toJson(),
        "state": state?.toJson(),
        "country": country?.toJson(),
        "address": address?.toJson(),
        "location": location?.toJson(),
        "markets": markets == null
            ? []
            : List<dynamic>.from(markets!.map((x) => x.toJson())),
        "dmas": dmas == null
            ? []
            : List<dynamic>.from(dmas!.map((x) => x.toJson())),
        "upcomingEvents": upcomingEvents?.toJson(),
        "_links": links?.toJson(),
        "social": social?.toJson(),
        "boxOfficeInfo": boxOfficeInfo?.toJson(),
        "parkingDetail": parkingDetail,
        "accessibleSeatingDetail": accessibleSeatingDetail,
        "generalInfo": generalInfo?.toJson(),
        "ada": ada?.toJson(),
      };
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

  Ada copyWith({
    String? adaPhones,
    String? adaCustomCopy,
    String? adaHours,
  }) =>
      Ada(
        adaPhones: adaPhones ?? this.adaPhones,
        adaCustomCopy: adaCustomCopy ?? this.adaCustomCopy,
        adaHours: adaHours ?? this.adaHours,
      );

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

  Address copyWith({
    String? line1,
  }) =>
      Address(
        line1: line1 ?? this.line1,
      );

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

  BoxOfficeInfo copyWith({
    String? phoneNumberDetail,
    String? openHoursDetail,
    String? acceptedPaymentDetail,
    String? willCallDetail,
  }) =>
      BoxOfficeInfo(
        phoneNumberDetail: phoneNumberDetail ?? this.phoneNumberDetail,
        openHoursDetail: openHoursDetail ?? this.openHoursDetail,
        acceptedPaymentDetail:
            acceptedPaymentDetail ?? this.acceptedPaymentDetail,
        willCallDetail: willCallDetail ?? this.willCallDetail,
      );

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

  City copyWith({
    String? name,
  }) =>
      City(
        name: name ?? this.name,
      );

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

  Country copyWith({
    CountryName? name,
    CountryCode? countryCode,
  }) =>
      Country(
        name: name ?? this.name,
        countryCode: countryCode ?? this.countryCode,
      );

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

  Dma copyWith({
    int? id,
  }) =>
      Dma(
        id: id ?? this.id,
      );

  factory Dma.fromJson(Map<String, dynamic> json) => Dma(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}

class GeneralInfo {
  String? generalRule;
  String? childRule;

  GeneralInfo({
    this.generalRule,
    this.childRule,
  });

  GeneralInfo copyWith({
    String? generalRule,
    String? childRule,
  }) =>
      GeneralInfo(
        generalRule: generalRule ?? this.generalRule,
        childRule: childRule ?? this.childRule,
      );

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

  Location copyWith({
    String? longitude,
    String? latitude,
  }) =>
      Location(
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
      );

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

  Social copyWith({
    Twitter? twitter,
  }) =>
      Social(
        twitter: twitter ?? this.twitter,
      );

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

  Twitter copyWith({
    String? handle,
  }) =>
      Twitter(
        handle: handle ?? this.handle,
      );

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

  State copyWith({
    String? name,
    String? stateCode,
  }) =>
      State(
        name: name ?? this.name,
        stateCode: stateCode ?? this.stateCode,
      );

  factory State.fromJson(Map<String, dynamic> json) => State(
        name: json["name"],
        stateCode: json["stateCode"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "stateCode": stateCode,
      };
}

enum VenueType { VENUE }

final venueTypeValues = EnumValues({"venue": VenueType.VENUE});

class EventLinks {
  First? self;
  List<First>? attractions;
  List<First>? venues;

  EventLinks({
    this.self,
    this.attractions,
    this.venues,
  });

  EventLinks copyWith({
    First? self,
    List<First>? attractions,
    List<First>? venues,
  }) =>
      EventLinks(
        self: self ?? this.self,
        attractions: attractions ?? this.attractions,
        venues: venues ?? this.venues,
      );

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

enum NameOrigin { CUSTOM }

final nameOriginValues = EnumValues({"custom": NameOrigin.CUSTOM});

class Outlet {
  String? url;
  String? type;

  Outlet({
    this.url,
    this.type,
  });

  Outlet copyWith({
    String? url,
    String? type,
  }) =>
      Outlet(
        url: url ?? this.url,
        type: type ?? this.type,
      );

  factory Outlet.fromJson(Map<String, dynamic> json) => Outlet(
        url: json["url"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "type": type,
      };
}

class Product {
  String? name;
  String? id;
  String? url;
  ProductType? type;
  List<Classification>? classifications;

  Product({
    this.name,
    this.id,
    this.url,
    this.type,
    this.classifications,
  });

  Product copyWith({
    String? name,
    String? id,
    String? url,
    ProductType? type,
    List<Classification>? classifications,
  }) =>
      Product(
        name: name ?? this.name,
        id: id ?? this.id,
        url: url ?? this.url,
        type: type ?? this.type,
        classifications: classifications ?? this.classifications,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        id: json["id"],
        url: json["url"],
        type: productTypeValues.map[json["type"]]!,
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

enum ProductType { PARKING, SPECIAL_ENTRY, UPSELL }

final productTypeValues = EnumValues({
  "Parking": ProductType.PARKING,
  "Special Entry": ProductType.SPECIAL_ENTRY,
  "Upsell": ProductType.UPSELL
});

class Promoter {
  String? id;
  PromoterName? name;
  Description? description;

  Promoter({
    this.id,
    this.name,
    this.description,
  });

  Promoter copyWith({
    String? id,
    PromoterName? name,
    Description? description,
  }) =>
      Promoter(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
      );

  factory Promoter.fromJson(Map<String, dynamic> json) => Promoter(
        id: json["id"],
        name: promoterNameValues.map[json["name"]]!,
        description: descriptionValues.map[json["description"]]!,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": promoterNameValues.reverse[name],
        "description": descriptionValues.reverse[description],
      };
}

enum Description {
  AEG_LIVE_NTL_USA,
  AEG_PRESENTS_NTL_GBR,
  LIVE_NATION_MUSIC_NTL_USA,
  PROMOTED_BY_VENUE_NTL_USA
}

final descriptionValues = EnumValues({
  "AEG LIVE / NTL / USA": Description.AEG_LIVE_NTL_USA,
  "AEG PRESENTS / NTL / GBR": Description.AEG_PRESENTS_NTL_GBR,
  "LIVE NATION MUSIC / NTL / USA": Description.LIVE_NATION_MUSIC_NTL_USA,
  "PROMOTED BY VENUE / NTL / USA": Description.PROMOTED_BY_VENUE_NTL_USA
});

enum PromoterName {
  AEG_LIVE,
  AEG_PRESENTS,
  LIVE_NATION_MUSIC,
  PROMOTED_BY_VENUE
}

final promoterNameValues = EnumValues({
  "AEG LIVE": PromoterName.AEG_LIVE,
  "AEG PRESENTS": PromoterName.AEG_PRESENTS,
  "LIVE NATION MUSIC": PromoterName.LIVE_NATION_MUSIC,
  "PROMOTED BY VENUE": PromoterName.PROMOTED_BY_VENUE
});

class Sales {
  Public? public;
  List<Presale>? presales;

  Sales({
    this.public,
    this.presales,
  });

  Sales copyWith({
    Public? public,
    List<Presale>? presales,
  }) =>
      Sales(
        public: public ?? this.public,
        presales: presales ?? this.presales,
      );

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

  Presale copyWith({
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? name,
  }) =>
      Presale(
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
        name: name ?? this.name,
      );

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

  Public copyWith({
    DateTime? startDateTime,
    bool? startTbd,
    bool? startTba,
    DateTime? endDateTime,
  }) =>
      Public(
        startDateTime: startDateTime ?? this.startDateTime,
        startTbd: startTbd ?? this.startTbd,
        startTba: startTba ?? this.startTba,
        endDateTime: endDateTime ?? this.endDateTime,
      );

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

  Seatmap({
    this.staticUrl,
  });

  Seatmap copyWith({
    String? staticUrl,
  }) =>
      Seatmap(
        staticUrl: staticUrl ?? this.staticUrl,
      );

  factory Seatmap.fromJson(Map<String, dynamic> json) => Seatmap(
        staticUrl: json["staticUrl"],
      );

  Map<String, dynamic> toJson() => {
        "staticUrl": staticUrl,
      };
}

class TicketLimit {
  String? info;

  TicketLimit({
    this.info,
  });

  TicketLimit copyWith({
    String? info,
  }) =>
      TicketLimit(
        info: info ?? this.info,
      );

  factory TicketLimit.fromJson(Map<String, dynamic> json) => TicketLimit(
        info: json["info"],
      );

  Map<String, dynamic> toJson() => {
        "info": info,
      };
}

class Ticketing {
  AllInclusivePricing? safeTix;
  AllInclusivePricing? allInclusivePricing;

  Ticketing({
    this.safeTix,
    this.allInclusivePricing,
  });

  Ticketing copyWith({
    AllInclusivePricing? safeTix,
    AllInclusivePricing? allInclusivePricing,
  }) =>
      Ticketing(
        safeTix: safeTix ?? this.safeTix,
        allInclusivePricing: allInclusivePricing ?? this.allInclusivePricing,
      );

  factory Ticketing.fromJson(Map<String, dynamic> json) => Ticketing(
        safeTix: json["safeTix"] == null
            ? null
            : AllInclusivePricing.fromJson(json["safeTix"]),
        allInclusivePricing: json["allInclusivePricing"] == null
            ? null
            : AllInclusivePricing.fromJson(json["allInclusivePricing"]),
      );

  Map<String, dynamic> toJson() => {
        "safeTix": safeTix?.toJson(),
        "allInclusivePricing": allInclusivePricing?.toJson(),
      };
}

class AllInclusivePricing {
  bool? enabled;

  AllInclusivePricing({
    this.enabled,
  });

  AllInclusivePricing copyWith({
    bool? enabled,
  }) =>
      AllInclusivePricing(
        enabled: enabled ?? this.enabled,
      );

  factory AllInclusivePricing.fromJson(Map<String, dynamic> json) =>
      AllInclusivePricing(
        enabled: json["enabled"],
      );

  Map<String, dynamic> toJson() => {
        "enabled": enabled,
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

  AllEventLinks copyWith({
    First? first,
    First? self,
    First? next,
    First? last,
  }) =>
      AllEventLinks(
        first: first ?? this.first,
        self: self ?? this.self,
        next: next ?? this.next,
        last: last ?? this.last,
      );

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

  Page copyWith({
    int? size,
    int? totalElements,
    int? totalPages,
    int? number,
  }) =>
      Page(
        size: size ?? this.size,
        totalElements: totalElements ?? this.totalElements,
        totalPages: totalPages ?? this.totalPages,
        number: number ?? this.number,
      );

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
