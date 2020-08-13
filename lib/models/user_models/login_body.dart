import 'package:flutter/foundation.dart';

class LoginBody with ChangeNotifier {
  final String grant_type;
  final String client_id;
  final String client_secret;
  final String username;
  final String password;

  LoginBody(
      {this.grant_type,
      this.client_id,
      this.client_secret,
      this.username,
      this.password});

  factory LoginBody.fromJson(Map<String, dynamic> parsedJson) {
    return LoginBody(
      grant_type: parsedJson['grant_type'],
      client_id: parsedJson['client_id'],
      client_secret: parsedJson['client_secret'],
      username: parsedJson['username'],
      password: parsedJson['password'],
    );
  }
}
