import 'package:flutter/foundation.dart';

class ImageUrl with ChangeNotifier {
  final String thumb;
  final String medium;
  final String large;

  ImageUrl({this.thumb, this.medium, this.large});

  factory ImageUrl.fromJson(Map<String, dynamic> parsedJson) {
    return ImageUrl(
      thumb: parsedJson['thumb']!=null?parsedJson['thumb']:'',
      medium: parsedJson['medium']!=null?parsedJson['medium']:'',
      large: parsedJson['large']!=null?parsedJson['large']:'',
    );
  }
}
