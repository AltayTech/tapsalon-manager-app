import 'package:flutter/foundation.dart';

import 'complex.dart';

class MainComplexes with ChangeNotifier {
  final int current_page;
  final List<Complex> data;
  final String first_page_url;
  final int from;
  final int last_page;
  final String last_page_url;
  final String next_page_url;
  final String path;
  final String per_page;
  final String prev_page_url;
  final int to;
  final int total;

  MainComplexes(
      {this.current_page,
      this.data,
      this.first_page_url,
      this.from,
      this.last_page,
      this.last_page_url,
      this.next_page_url,
      this.path,
      this.per_page,
      this.prev_page_url,
      this.to,
      this.total});

  factory MainComplexes.fromJson(Map<String, dynamic> parsedJson) {
    var dataList = parsedJson['data'] as List;
    List<Complex> dataRaw = new List<Complex>();
    dataRaw = dataList.map((i) => Complex.fromJson(i)).toList();

    return MainComplexes(
      current_page: parsedJson['current_page'],
      data: dataRaw,
      from: parsedJson['from'],
      last_page: parsedJson['last_page'],
      last_page_url: parsedJson['last_page_url'],
      next_page_url: parsedJson['next_page_url'],
      path: parsedJson['path'],
      per_page: parsedJson['per_page'],
      prev_page_url: parsedJson['prev_page_url'],
      to: parsedJson['to'],
      total: parsedJson['total'],
    );
  }
}
