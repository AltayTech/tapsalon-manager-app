import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon_manager/models/comment.dart';
import 'package:tapsalon_manager/models/complex.dart';
import 'package:tapsalon_manager/models/complex_search.dart';
import 'package:tapsalon_manager/models/facility.dart';
import 'package:tapsalon_manager/models/field.dart';
import 'package:tapsalon_manager/models/main_comments.dart';
import 'package:tapsalon_manager/models/main_complexes_search.dart';
import 'package:tapsalon_manager/models/main_facilities.dart';
import 'package:tapsalon_manager/models/main_fields.dart';
import 'package:tapsalon_manager/models/main_regions.dart';
import 'package:tapsalon_manager/models/priceRange.dart';
import 'package:tapsalon_manager/models/region.dart';
import 'package:tapsalon_manager/models/searchDetails.dart';
import 'package:tapsalon_manager/models/urls.dart';

class Complexes with ChangeNotifier {
  List<ComplexSearch> _items = [
    ComplexSearch(
      id: 1,
      latitude: 1.0,
      longitude: 1.0,
      name: '',
      excerpt: '',
      about: '',
      address: '',
      img_url: '',
      stars: 5.0,
      phone: '',
      mobile: '',
      created_at: '',
      updated_at: '',
    )
  ];
  List<Region> _itemsRegions = [
    Region(
      id: 1,
      city_id: 1,
      name: '',
      no_users: 1,
    )
  ];
  List<Facility> _itemsFacilities = [
    Facility(
      id: 1,
      name: '',
      excerpt: '',
      description: '',
      icon: '',
    )
  ];
  List<Field> _itemsFields = [
    Field(
      id: 1,
      name: '',
      excerpt: '',
      description: '',
      icon: '',
    )
  ];
  PriceRange _itemPriceRange = PriceRange(
    min: '0',
    max: '200000',
  );
  List<Comment> _itemsComments = [];

  String searchKey = '';
  String searchEndPoint = '';
  var _spage = 1;
  var _sper_page = 10;
  var _sComplexType = '';

  var _sOstanId = '';
  var _sCityId = '';
  var _sField = '';
  var _sFacility = '';
  var _sOrderBy = 'name';
  var _sSort = 'DES';
  var _sType = '';
  var _sRange = '';
  var _sRegion = '';

  List<String> filterTitle = [];
  static SearchDetails _searchDetails_zero = SearchDetails(
    current_page: 1,
    from: 1,
    last_page: 0,
    last_page_url: '',
    next_page_url: '',
    path: '',
    per_page: 10,
    prev_page_url: '',
    to: 10,
    total: 10,
  );
  SearchDetails _complexSearchDetails = _searchDetails_zero;
  SearchDetails _regionSearchDetails = _searchDetails_zero;
  SearchDetails _facilitiesSearchDetails = _searchDetails_zero;
  SearchDetails _fieldsSearchDetails = _searchDetails_zero;

  Complex _itemComplex;

  SearchDetails _commentsSearchDetails;

  ImageSource imageSource;

  Complex get itemComplex => _itemComplex;

  //Methods

  void searchBuilder() {
    if (!(searchKey == '')) {
      searchEndPoint = '';

      searchEndPoint = searchEndPoint + '?name=$searchKey';
      searchEndPoint = searchEndPoint + '&page=$_spage&per_page=$_sper_page';
    } else {
      searchEndPoint = '';

      searchEndPoint = searchEndPoint + '?page=$_spage&per_page=$_sper_page';
    }
    if (!(_sSort == '')) {
      searchEndPoint = searchEndPoint + '&sort=$_sSort';
    }
    if (!(_sOrderBy == '')) {
      searchEndPoint = searchEndPoint + '&orderby=$_sOrderBy';
    }
    if (!(_sType == '')) {
      searchEndPoint = searchEndPoint + '&type=$_sType';
    }

    if (!(_sRange == '' || _sRange == null)) {
      searchEndPoint = searchEndPoint + '&range=$_sRange';
    }
    if (!(_sComplexType == '' || _sComplexType == null)) {
      searchEndPoint = searchEndPoint + '&type=$_sComplexType';
    }
    if (!(_sOstanId == '' || _sOstanId == null)) {
      searchEndPoint = searchEndPoint + '&ostan=$_sOstanId';
    }
    if (!(_sCityId == '' || _sCityId == null)) {
      searchEndPoint = searchEndPoint + '&city=$_sCityId';
    }
    if (!(_sField == '' || _sField == null)) {
      searchEndPoint = searchEndPoint + '&field=$_sField';
    }
    if (!(_sFacility == '' || _sFacility == null)) {
      searchEndPoint = searchEndPoint + '&facility=$_sFacility';
    }
    print(searchEndPoint);
  }

//getters and setters

  get spage => _spage;

  set spage(value) {
    _spage = value;
  }

  get sper_page => _sper_page;

  set sper_page(value) {
    _sper_page = value;
  }

  get sComplexType => _sComplexType;

  set sComplexType(value) {
    _sComplexType = value;
  }

  get sOstanId => _sOstanId;

  set sOstanId(value) {
    _sOstanId = value;
  }

  get sCityId => _sCityId;

  set sCityId(value) {
    _sCityId = value;
  }

  get sField => _sField;

  set sField(value) {
    _sField = value;
  }

  get sFacility => _sFacility;

  set sFacility(value) {
    _sFacility = value;
  }

  get sOrderBy => _sOrderBy;

  set sOrderBy(value) {
    _sOrderBy = value;
  }

  get sSort => _sSort;

  set sSort(value) {
    _sSort = value;
  }

  get sType => _sType;

  set sType(value) {
    _sType = value;
  }

  get sRange => _sRange;

  set sRange(value) {
    _sRange = value;
  }

  List<ComplexSearch> get items => _items;

  List<Region> get itemsRegions => _itemsRegions;

  set itemsRegions(List<Region> value) {
    _itemsRegions = value;
  }

  SearchDetails get complexSearchDetails =>
      _complexSearchDetails; //data transportation

  List<Facility> get itemsFacilities => _itemsFacilities;

  set itemsFacilities(List<Facility> value) {
    _itemsFacilities = value;
  }

  List<Field> get itemsFields => _itemsFields;

  set itemsFields(List<Field> value) {
    _itemsFields = value;
  }

  SearchDetails get regionSearchDetails => _regionSearchDetails;

  set regionSearchDetails(SearchDetails value) {
    _regionSearchDetails = value;
  }

  SearchDetails get facilitiesSearchDetails => _facilitiesSearchDetails;

  set facilitiesSearchDetails(SearchDetails value) {
    _facilitiesSearchDetails = value;
  }

  SearchDetails get fieldsSearchDetails => _fieldsSearchDetails;

  set fieldsSearchDetails(SearchDetails value) {
    _fieldsSearchDetails = value;
  }

  PriceRange get itemPriceRange => _itemPriceRange;

  set itemPriceRange(PriceRange value) {
    _itemPriceRange = value;
  }

  get sRegion => _sRegion;

  set sRegion(value) {
    _sRegion = value;
  }

  SearchDetails get commentsSearchDetails => _commentsSearchDetails;

  set commentsSearchDetails(SearchDetails value) {
    _commentsSearchDetails = value;
  }

  List<Comment> get itemsComments => _itemsComments;

  Future<void> searchItem() async {
    print('searchItem');

    final url =
        Urls.rootUrl + Urls.complexesEndPoint + '/search' + '$searchEndPoint';
    print(url);

    print(searchEndPoint.toString());

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainComplexesSearch mainComplexesSearch =
            MainComplexesSearch.fromJson(extractedData);
        print(response.headers.toString());
        _items.clear();
        _items.addAll(mainComplexesSearch.data);

        _complexSearchDetails = SearchDetails(
          current_page: mainComplexesSearch.current_page,
          first_page_url: mainComplexesSearch.first_page_url,
          from: mainComplexesSearch.from,
          last_page: mainComplexesSearch.last_page,
          last_page_url: mainComplexesSearch.last_page_url,
          next_page_url: mainComplexesSearch.next_page_url,
          path: mainComplexesSearch.path,
          per_page: int.parse(mainComplexesSearch.per_page),
          prev_page_url: mainComplexesSearch.prev_page_url,
          to: mainComplexesSearch.to,
          total: mainComplexesSearch.total,
        );
        print(_complexSearchDetails.total.toString());
      } else {
        _items = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveCityComplexes(int cityId) async {
    print('retrieveRegions');

    final url = Urls.rootUrl + '/api/cities/$cityId/complexes';
    print(url);

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainRegions mainRegions = MainRegions.fromJson(extractedData);
        print(response.headers.toString());
        _itemsRegions.clear();
        _itemsRegions.addAll(mainRegions.data);

        _regionSearchDetails = SearchDetails(
          current_page: mainRegions.current_page,
          first_page_url: mainRegions.first_page_url,
          from: mainRegions.from,
          last_page: mainRegions.last_page,
          last_page_url: mainRegions.last_page_url,
          next_page_url: mainRegions.next_page_url,
          path: mainRegions.path,
          per_page: mainRegions.per_page,
          prev_page_url: mainRegions.prev_page_url,
          to: mainRegions.to,
          total: mainRegions.total,
        );
        print(_complexSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveRegions(int cityId) async {
    print('retrieveRegions');

    final url = Urls.rootUrl + '/api/cities/$cityId/regions';
    print(url);

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainRegions mainRegions = MainRegions.fromJson(extractedData);
        print(response.headers.toString());
        _itemsRegions.clear();
        _itemsRegions.addAll(mainRegions.data);

        _regionSearchDetails = SearchDetails(
          current_page: mainRegions.current_page,
          first_page_url: mainRegions.first_page_url,
          from: mainRegions.from,
          last_page: mainRegions.last_page,
          last_page_url: mainRegions.last_page_url,
          next_page_url: mainRegions.next_page_url,
          path: mainRegions.path,
          per_page: mainRegions.per_page,
          prev_page_url: mainRegions.prev_page_url,
          to: mainRegions.to,
          total: mainRegions.total,
        );
        print(_complexSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveComment(int complexId) async {
    print('retrieveRegions');

    final url = Urls.rootUrl + '/api/complexes/$complexId/comments';
    print(url);

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainComments mainComments = MainComments.fromJson(extractedData);
        print(response.headers.toString());
        _itemsComments.clear();
        _itemsComments.addAll(mainComments.data);
//        print(_itemsComments[0].rate.toString());

        _commentsSearchDetails = SearchDetails(
          current_page: mainComments.current_page,
          first_page_url: mainComments.first_page_url,
          from: mainComments.from,
          last_page: mainComments.last_page,
          last_page_url: mainComments.last_page_url,
          next_page_url: mainComments.next_page_url,
          path: mainComments.path,
          per_page: mainComments.per_page,
          prev_page_url: mainComments.prev_page_url,
          to: mainComments.to,
          total: mainComments.total,
        );
        print(_complexSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> sendComment(int complexId, String content, double rate) async {
    print('sendComment');

    final url = Urls.rootUrl + Urls.commentEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'complex_id': complexId,
            'content': content,
            'rate': rate,
          }));
      print(response.body);

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveLikes(int complexId) async {
    print('retrieveRegions');

    final url = Urls.rootUrl + '/api/complexes/$complexId/comments';
    print(url);

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainComments mainComments = MainComments.fromJson(extractedData);
        print(response.headers.toString());
        _itemsComments.clear();
        _itemsComments.addAll(mainComments.data);
//        print(_itemsComments[0].rate.toString());

        _commentsSearchDetails = SearchDetails(
          current_page: mainComments.current_page,
          first_page_url: mainComments.first_page_url,
          from: mainComments.from,
          last_page: mainComments.last_page,
          last_page_url: mainComments.last_page_url,
          next_page_url: mainComments.next_page_url,
          path: mainComments.path,
          per_page: mainComments.per_page,
          prev_page_url: mainComments.prev_page_url,
          to: mainComments.to,
          total: mainComments.total,
        );
        print(_complexSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<bool> sendLike(int complexId) async {
    print('sendLike');

    final url = Urls.rootUrl + Urls.userLikesEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'complex_id': complexId,
          }));
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrievefacilities() async {
    print('retrievefacilities');

    final url = Urls.rootUrl + Urls.facilitiesEndPoint;
    print(url);

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainFacilities mainFacilities = MainFacilities.fromJson(extractedData);
        print(response.headers.toString());
        _itemsFacilities.clear();
        _itemsFacilities.addAll(mainFacilities.data);
        print(_itemsFacilities[0].name.toString());

        _facilitiesSearchDetails = SearchDetails(
          current_page: mainFacilities.current_page,
          first_page_url: mainFacilities.first_page_url,
          from: mainFacilities.from,
          last_page: mainFacilities.last_page,
          last_page_url: mainFacilities.last_page_url,
          next_page_url: mainFacilities.next_page_url,
          path: mainFacilities.path,
          per_page: mainFacilities.per_page,
          prev_page_url: mainFacilities.prev_page_url,
          to: mainFacilities.to,
          total: mainFacilities.total,
        );
        print(_complexSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveFields() async {
    print('retrieveFields');

    final url = Urls.rootUrl + Urls.fieldsEndPoint;
    print(url);

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainFields mainFields = MainFields.fromJson(extractedData);
        print(response.headers.toString());
        _itemsFields.clear();
        _itemsFields.addAll(mainFields.data);
        print(_itemsFields[0].name.toString());

        _fieldsSearchDetails = SearchDetails(
          current_page: mainFields.current_page,
          first_page_url: mainFields.first_page_url,
          from: mainFields.from,
          last_page: mainFields.last_page,
          last_page_url: mainFields.last_page_url,
          next_page_url: mainFields.next_page_url,
          path: mainFields.path,
          per_page: mainFields.per_page,
          prev_page_url: mainFields.prev_page_url,
          to: mainFields.to,
          total: mainFields.total,
        );
        print(_complexSearchDetails.total.toString());
      } else {
        _itemsRegions = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrievePriceRange() async {
    print('retrieveFields');

    final url = Urls.rootUrl + Urls.getPriceRangeEndPoint;
    print(url);

    try {
      final response = await get(url);
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        PriceRange priceRange = PriceRange.fromJson(extractedData);
        print(response.headers.toString());
        _itemPriceRange = priceRange;
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrieveComplex(int complexId) async {
    print('retrieveComplex');

    final url = Urls.rootUrl + Urls.complexesEndPoint + '/$complexId';
    print(url);

    try {
      final response = await get(url);

      final extractedData = json.decode(response.body);

      print(extractedData);

      Complex complex = Complex.fromJson(extractedData);
      print(complex.name);

      _itemComplex = complex;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> createComplex(
      int ostan_id,
      int city_id,
      int region_id,
      String name,
      String excerpt,
      String about,
      String address,
      String phone,
      String mobile) async {
    print('createComplex');

    final url = Urls.rootUrl + Urls.complexesEndPoint;
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();

      var _token = prefs.getString('tokenM');
      final response = await post(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'ostan_id': ostan_id,
            'city_id': city_id,
            'region_id': region_id,
            'name': name,
            'excerpt': excerpt,
            'about': about,
            'address': address,
            'phone': phone,
            'mobile': mobile,
          }));
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> editComplex({
    int complex_id,
    int ostan_id,
    int city_id,
    int region_id,
    String name,
    String excerpt,
    String about,
    String address,
    String phone,
    String mobile,
    double latitude,
    double longitude,
    int image_id,
  }) async {
    print('editComplex');

    final url = Urls.rootUrl + Urls.complexesEndPoint + '/$complex_id';
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();

      var _token = prefs.getString('tokenM');
      final response = await put(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'ostan_id': ostan_id,
            'city_id': city_id,
            'region_id': region_id,
            'name': name,
            'excerpt': excerpt,
            'about': about,
            'address': address,
            'phone': phone,
            'mobile': mobile,
            'latitude': latitude,
            'longitude': longitude,
            'image_id': image_id,
          }));
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> createPlace(
    int complex_id,
    String name,
    String excerpt,
    String about,
    String price,
    List<int> fields,
    List<int> facilities,
    int place_type_id,
  ) async {
    print('createPlace');

    final url = Urls.rootUrl + Urls.placesEndPoint;
    print(url);

    try {
      final prefs = await SharedPreferences.getInstance();

      var _token = prefs.getString('tokenM');
      final response = await post(url,
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode({
            'title': name,
            'excerpt': excerpt,
            'about': about,
            'complex_id': complex_id,
            'place_type_id': place_type_id,
            'fields': fields,
            'facilities': facilities,
            'price': price,
          }));
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> Upload(
      File imageFile, int place_id, int complex_id, String title) async {
    print('Upload');

    var stream = new ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    final url = Uri.parse(Urls.rootUrl + Urls.imageUploadEndPoint);

    var request = new MultipartRequest(
      "POST",
      url,
    );
    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('tokenM');
    print(place_id.toString());
    print(_token.toString());

    Map<String, String> header1 = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
    };
    Map<String, String> fields = {
      'place_id': '$place_id',
      'complex_id': '$complex_id',
      'title': '$title',
    };
    request.headers.addAll(header1);
    request.fields.addAll(fields);
    var multipartFile = new MultipartFile('photo', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.toString());
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<void> deleteImage(int imageId) async {
    print('deleteImage');
    final url = Urls.rootUrl + Urls.imageUploadEndPoint + '/$imageId';
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('tokenM');
    print(_token);

    try {
      final response = await delete(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        notifyListeners();

        return true;
      } else {
        notifyListeners();

        return false;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }
}
