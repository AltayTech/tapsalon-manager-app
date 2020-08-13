import 'package:flutter/foundation.dart';

class SearchArgument with ChangeNotifier {
  final int tabIndex;

  final String sortValue;


  SearchArgument({
    this.tabIndex,
    this.sortValue,

  });

  factory SearchArgument.fromJson(Map<String, dynamic> parsedJson) {
    return SearchArgument(
      tabIndex: parsedJson['tabIndex'] != null ? parsedJson['tabIndex'] : 0,
      sortValue: parsedJson['sortValue'] != null ? parsedJson['sortValue'] : '',

    );
  }
}
