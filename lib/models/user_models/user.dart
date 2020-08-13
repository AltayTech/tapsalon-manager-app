import 'package:flutter/foundation.dart';

import '../city.dart';
import '../province.dart';
import '../role.dart';

class User with ChangeNotifier {
  final int id;
  final String fname;
  final String lname;
  final String address;
  final int gender;
  final String phone;
  final String mobile;
  final int no_comments;
  final int no_likes;
  final int no_reserves;
  final String wallet;
  final String email;
  final String created_at;
  final String updated_at;
  final Province ostan;
  final City city;
  final Role role;

  User({
    this.id,
    this.fname,
    this.lname,
    this.address,
    this.gender,
    this.phone,
    this.mobile,
    this.no_comments,
    this.no_likes,
    this.no_reserves,
    this.wallet,
    this.email,
    this.created_at,
    this.updated_at,
    this.ostan,
    this.city,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      id: parsedJson['id'] != null ? parsedJson['id'] : 0,
      fname: parsedJson['fname'] != null ? parsedJson['fname'] : '',
      lname: parsedJson['lname'] != null ? parsedJson['lname'] : '',
      address: parsedJson['address'] != null ? parsedJson['address'] : '',
      gender: parsedJson['gender'] != null ? parsedJson['gender'] : 0,
      phone: parsedJson['phone'] != null ? parsedJson['phone'] : '',
      mobile: parsedJson['mobile'] != null ? parsedJson['mobile'] : '',
      no_comments:
          parsedJson['no_comments'] != null ? parsedJson['no_comments'] : 0,
      no_likes: parsedJson['no_likes'] != null ? parsedJson['no_likes'] : 0,
      no_reserves:
          parsedJson['no_reserves'] != null ? parsedJson['no_reserves'] : 0,
      wallet: parsedJson['wallet'] != null ? parsedJson['wallet'] : '',
      email: parsedJson['email'] != null ? parsedJson['email'] : '',
      created_at:
          parsedJson['created_at'] != null ? parsedJson['created_at'] : '',
      updated_at:
          parsedJson['updated_at'] != null ? parsedJson['updated_at'] : '',
      ostan: Province.fromJson(parsedJson['ostan']),
      city: City.fromJson(parsedJson['city']),
      role: Role.fromJson(parsedJson['role']),
    );
  }
}
