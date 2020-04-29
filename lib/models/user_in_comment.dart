import 'package:flutter/foundation.dart';

class UserInComment with ChangeNotifier {
  final int id;
  final String fname;
  final String lname;
  final int role_id;
  final int gender;
  final String phone;
  final String mobile;
  final int no_comments;
  final int no_likes;
  final int no_reserves;
  final String wallet;
  final String created_at;
  final String updated_at;

  UserInComment({
    this.id,
    this.fname,
    this.lname,
    this.role_id,
    this.gender,
    this.phone,
    this.mobile,
    this.no_comments,
    this.no_likes,
    this.no_reserves,
    this.wallet,
    this.created_at,
    this.updated_at,
  });

  factory UserInComment.fromJson(Map<String, dynamic> parsedJson) {
    return UserInComment(
      id: parsedJson['id'],
      fname: parsedJson['fname'],
      lname: parsedJson['lname'],
      role_id: parsedJson['role_id'],
      gender: parsedJson['gender'],
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      no_comments: parsedJson['no_comments'],
      no_likes: parsedJson['no_likes'],
      no_reserves: parsedJson['no_reserves'],
      wallet: parsedJson['wallet'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
    );
  }
}
