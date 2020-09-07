import 'package:flutter/foundation.dart';

class ManagerStats with ChangeNotifier {
  final int places;
  final int comments;
  final int likes;
  final int visits;

  ManagerStats({
    this.places,
    this.comments,
    this.likes,
    this.visits,
  });

  factory ManagerStats.fromJson(Map<String, dynamic> parsedJson) {
    return ManagerStats(
      places: parsedJson['places'] != null ? parsedJson['places'] : 0,
      comments: parsedJson['comments'] != null
          ? int.parse(parsedJson['comments'].toString())
          : 0,
      likes: parsedJson['likes'] != null ? parsedJson['likes'] : 0,
      visits: parsedJson['visits'] != null
          ? int.parse(parsedJson['visits'].toString())
          : 0,
    );
  }
}
