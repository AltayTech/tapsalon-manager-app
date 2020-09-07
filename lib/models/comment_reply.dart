import 'package:flutter/foundation.dart';

import '../models/user_models/user_in_comment.dart';

class CommentReply with ChangeNotifier {
  final int id;
  final int place_id;
  final int rate;
  final String content;
  final String createdAt;
  final String updatedAt;
  final UserInComment user;


  CommentReply(
      {this.id,
      this.place_id,
      this.rate,
      this.content,
      this.createdAt,
      this.updatedAt,
      this.user});

  factory CommentReply.fromJson(Map<String, dynamic> parsedJson) {
    return CommentReply(
        id: parsedJson['id'] != null ? parsedJson['id'] : 0,
        place_id: parsedJson['place_id'] != null ? parsedJson['place_id'] : 0,
        rate: parsedJson['rate'] != null ? parsedJson['rate'] : 0,
        content: parsedJson['content'] != null ? parsedJson['content'] : '',
        createdAt:
            parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
        updatedAt:
            parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
        user: parsedJson['user'] != null
            ? UserInComment.fromJson(parsedJson['user'])
            : UserInComment(id: 0));
  }
}
