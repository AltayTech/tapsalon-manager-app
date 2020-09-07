import 'package:flutter/foundation.dart';
import 'package:tapsalon_manager/models/comment_reply.dart';

import '../models/user_models/user_in_comment.dart';

class Comment with ChangeNotifier {
  final int id;
  final int place_id;
  final int rate;
  final String content;
  final String createdAt;
  final String updatedAt;
  final UserInComment user;
  final List<CommentReply> replies;

  Comment({
    this.id,
    this.place_id,
    this.rate,
    this.content,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> parsedJson) {
    List<CommentReply> repliesRaw = [];

    if (parsedJson['replies'] != null) {
      var repliesList = parsedJson['replies'] as List;
      repliesRaw = new List<CommentReply>();
      repliesRaw = repliesList.map((i) => CommentReply.fromJson(i)).toList();
    }

    return Comment(
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
          : UserInComment(id: 0),
      replies: repliesRaw,
    );
  }
}
