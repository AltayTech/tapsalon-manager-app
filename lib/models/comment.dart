import 'package:flutter/foundation.dart';

import 'user_in_comment.dart';

class Comment with ChangeNotifier {
  final int id;
  final int rate;
  final String content;
  final String created_at;
  final String updated_at;
  final UserInComment user;

  Comment(
      {this.id,
      this.rate,
      this.content,
      this.created_at,
      this.updated_at,
      this.user});

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    return Comment(
        id: parsedJson['id'],
        rate: parsedJson['rate'],
        content: parsedJson['content'],
        created_at: parsedJson['created_at'],
        updated_at: parsedJson['updated_at'],
        user: UserInComment.fromJson(parsedJson['user']));
  }
}
