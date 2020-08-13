import 'dart:collection';

import 'package:najvaflutter/najvaflutter.dart';

class Najva extends NajvaFlutter {
  /// constructor for Najva
  Najva() {
    init();

    enableLocation();

    getActivityJson().then((json) => print(json));

    setFirebaseEnabled(false);

    //                         ***   only in version 2.2 of flutter    ***
    getSubscribedToken().then((token) => {print("user token: $token")});
  }

  /// json data will be send to this method
  @override
  void onNewJSONDataReceived(String jsonData) {
    // TODO: handle new message from server
    print(jsonData);
  }

  @override
  void onUserSubscribed(String token) {
    // TODO: implement onUserSubscribed
    print(token);
  }

  @override
  void onNotificationClicked(LinkedHashMap<dynamic, dynamic> data) {
    print("notification clicked: $data");
  }

  @override
  void onNotificationReceived(LinkedHashMap<dynamic, dynamic> data) {
    print("notification received: $data");
  }
}
