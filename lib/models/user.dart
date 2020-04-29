import 'package:flutter/foundation.dart';

import 'city.dart';
import 'ostan.dart';
import 'role.dart';

class User with ChangeNotifier {
  final int id;
  final String fname;
  final String lname;
  final int gender;
  final String phone;
  final String mobile;
  final int no_comments;
  final int no_likes;
  final int no_reserves;
  final String wallet;
  final String created_at;
  final String updated_at;
  final Ostan ostan;
  final City city;
  final Role role;

  User(
      {this.id,
      this.fname,
      this.lname,
      this.gender,
      this.phone,
      this.mobile,
      this.no_comments,
      this.no_likes,
      this.no_reserves,
      this.wallet,
      this.created_at,
      this.updated_at,
      this.ostan,
      this.city,
      this.role});

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['id'],
      fname: parsedJson['fname'],
      lname: parsedJson['lname'],
      gender: parsedJson['gender'],
      phone: parsedJson['phone'],
      mobile: parsedJson['mobile'],
      no_comments: parsedJson['no_comments'],
      no_likes: parsedJson['no_likes'],
      no_reserves: parsedJson['no_reserves'],
      wallet: parsedJson['wallet'],
      created_at: parsedJson['created_at'],
      updated_at: parsedJson['updated_at'],
      ostan: Ostan.fromJson(parsedJson['ostan']),
      city: City.fromJson(parsedJson['city']),
      role: Role.fromJson(parsedJson['role']),
    );
  }
}
