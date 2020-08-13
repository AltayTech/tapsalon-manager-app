import 'package:flutter/foundation.dart';

import '../models/image_url.dart';

class ImageObj with ChangeNotifier {
  final int id;
  final String filename;
  final String extension;

  final ImageUrl url;

  ImageObj({this.id, this.filename, this.extension, this.url});

  factory ImageObj.fromJson(Map<String, dynamic> parsedJson) {
    return ImageObj(
      id: parsedJson['id']!=null?parsedJson['id']:0,
      filename: parsedJson['filename']!=null?parsedJson['filename']:'',
      extension: parsedJson['extension']!=null?parsedJson['extension']:'',
      url: parsedJson['url']!=null?ImageUrl.fromJson(parsedJson['url']):ImageUrl(),
    );
  }
}
