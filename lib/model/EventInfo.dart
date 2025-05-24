class EventInfo {
  final String artistName;
  final String eventName;
  final String section;
  final String row;
  final String seat;
  final String date;
  final String location;
  final String time;
  final String imageUrl;
  final String ticketType;
  final String level;
  final int ticketCount;

  const EventInfo({
    required this.artistName,
    required this.eventName,
    required this.section,
    required this.row,
    required this.seat,
    required this.date,
    required this.location,
    required this.time,
    required this.imageUrl,
    required this.ticketType,
    required this.level,
    required this.ticketCount,
  });
}
