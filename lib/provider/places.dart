import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tapsalon_manager/models/city.dart';
import 'package:tapsalon_manager/models/imageObj.dart';
import 'package:tapsalon_manager/models/image_url.dart';
import 'package:tapsalon_manager/models/places_models/main_places.dart';
import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/models/places_models/place_in_search.dart';
import 'package:tapsalon_manager/models/places_models/place_in_send.dart';
import 'package:tapsalon_manager/models/timing.dart';

import '../models/comment.dart';
import '../models/facility.dart';
import '../models/field.dart';
import '../models/main_comments.dart';
import '../models/searchDetails.dart';
import '../provider/urls.dart';

class Places with ChangeNotifier {
//parameter definition

  List<PlaceInSearch> _items = [];

  List<Facility> _itemsFacilities = [];

  List<Field> _itemsFields = [];

  String _token;

  PlaceInSend placeInSend;

  List<Comment> _itemsComments = [];

  List<List<Timing>> timingListTable = [[]];

  ImageObj _placeDefaultImage = ImageObj(
      id: 0,
      filename: '',
      url: ImageUrl(
        medium: 'assets/images/place_placeholder.jpeg',
        large: 'assets/images/place_placeholder.jpeg',
        thumb: 'assets/images/place_placeholder.jpeg',
      ));
  ImageObj _gymDefaultImage = ImageObj(
      id: 0,
      filename: '',
      url: ImageUrl(
        medium: 'assets/images/gym_placeholder.jpg',
        large: 'assets/images/gym_placeholder.jpg',
        thumb: 'assets/images/gym_placeholder.jpg',
      ));

  ImageObj _entDefaultImage = ImageObj(
      id: 0,
      filename: '',
      url: ImageUrl(
        medium: 'assets/images/ent_placeholder.jpg',
        large: 'assets/images/ent_placeholder.jpg',
        thumb: 'assets/images/ent_placeholder.jpg',
      ));
  ImageSource imageSource;

  //search parameters
  String searchKey = '';
  var _sPage = 1;
  var _sPerPage = 10;
  var _sPlaceType = '';

  var _sProvinceId = '';
  var _sCityId = '';
  var _sField = '';
  var _sFacility = '';
  var _sOrderBy = 'name';
  var _sSort = 'DESC';
  var _sRange = '';
  var _sRegion = '';

  static SearchDetails _searchDetailsZero = SearchDetails(
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
  SearchDetails _placeSearchDetails = _searchDetailsZero;
  SearchDetails _favoriteComplexSearchDetails = _searchDetailsZero;
  SearchDetails _facilitiesSearchDetails = _searchDetailsZero;
  SearchDetails _fieldsSearchDetails = _searchDetailsZero;

  Place _itemPlace;

  SearchDetails _commentsSearchDetails;

  Map<String, String> searchBody = {};

  Place get itemPlace => _itemPlace;

  SearchDetails get favoriteComplexSearchDetails =>
      _favoriteComplexSearchDetails;

  //Methods

  void searchBuilder() {
    searchBody = {
      'name': searchKey,
      'page': _sPage.toString(),
      'per_page': _sPerPage.toString(),
      'order': _sSort,
      'orderby': _sOrderBy,
      'range': _sRange,
      'place_type_id': _sPlaceType,
      'ostan_id': _sProvinceId,
      'city_id': _sCityId,
      'region_id': _sRegion,
      'fields': _sField,
      'facilities': _sFacility,
    };
    removeNullAndEmptyParams(searchBody);
  }

  void removeNullAndEmptyParams(Map<String, Object> mapToEdit) {
// Remove all null values; they cause validation errors
    final keys = mapToEdit.keys.toList(growable: false);
    for (String key in keys) {
      final value = mapToEdit[key];
      if (value == null) {
        mapToEdit.remove(key);
      } else if (value is String) {
        if (value.isEmpty) {
          mapToEdit.remove(key);
        }
      } else if (value is Map) {
        removeNullAndEmptyParams(value);
      }
    }
  }

//getters and setters

  get sPage => _sPage;

  set sPage(value) {
    _sPage = value;
  }

  get sPerPage => _sPerPage;

  set sPerPage(value) {
    _sPerPage = value;
  }

  get sPlaceType => _sPlaceType;

  set sPlaceType(value) {
    _sPlaceType = value;
  }

  get sProvinceId => _sProvinceId;

  set sProvinceId(value) {
    _sProvinceId = value;
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

  get sRange => _sRange;

  set sRange(value) {
    _sRange = value;
  }

  List<PlaceInSearch> get items => _items;

  SearchDetails get placeSearchDetails =>
      _placeSearchDetails; //data transportation

  List<Facility> get itemsFacilities => _itemsFacilities;

  List<Field> get itemsFields => _itemsFields;

  SearchDetails get facilitiesSearchDetails => _facilitiesSearchDetails;

  SearchDetails get fieldsSearchDetails => _fieldsSearchDetails;

  get sRegion => _sRegion;

  set sRegion(value) {
    _sRegion = value;
  }

  SearchDetails get commentsSearchDetails => _commentsSearchDetails;

  List<Comment> get itemsComments => _itemsComments;

  ImageObj get placeDefaultImage => _placeDefaultImage;

  ImageObj get gymDefaultImage => _gymDefaultImage;

  ImageObj get entDefaultImage => _entDefaultImage;

  Future<void> searchItem() async {
    print('searchItem');

    final url = Urls.rootUrl + Urls.userPlacesEndPoint;
    Uri uri = Uri.parse(url);
    final newUrl = uri.replace(queryParameters: searchBody);
    print(url);
    print(newUrl.queryParameters.toString());
    final prefs = await SharedPreferences.getInstance();

    _token = prefs.getString('token');
    print(_token);

    try {
      final response = await get(
        newUrl,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );

      print(response.statusCode.toString());
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainPlaces mainPlaces = MainPlaces.fromJson(extractedData);
        print(response.headers.toString());
        _items.clear();
        _items = mainPlaces.data;
        print('searchItem' + _items.length.toString());

        _placeSearchDetails = SearchDetails(
          current_page: mainPlaces.current_page,
          first_page_url: mainPlaces.first_page_url,
          from: mainPlaces.from,
          last_page: mainPlaces.last_page,
          last_page_url: mainPlaces.last_page_url,
          next_page_url: mainPlaces.next_page_url,
          path: mainPlaces.path,
          per_page: mainPlaces.per_page,
          prev_page_url: mainPlaces.prev_page_url,
          to: mainPlaces.to,
          total: mainPlaces.total,
        );
        print(_placeSearchDetails.total.toString());
        print('searchItem' + _items.length.toString());
      } else {
        _items = [];
        print('_items errrorrr' + _items.length.toString());
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    print('searchItem ffff' + _items.length.toString());
  }

  Future<List<PlaceInSearch>> retrieveCityPlaces(int cityId,
      String orderby) async {
    print('retrieveCityPlaces');
    String url = '';
    if (cityId == 0) {
      url = Urls.rootUrl + Urls.placesEndPoint;
    } else if (orderby != '') {
      url = Urls.rootUrl +
          Urls.placesEndPoint +
          '?city_id=$cityId' +
          '&orderby=$orderby';
    } else {
      url = Urls.rootUrl + Urls.placesEndPoint + '?city_id=$cityId';
    }
    print(url);
    List<PlaceInSearch> loadedPlaces = [];

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainPlaces mainPlaces = MainPlaces.fromJson(extractedData);
        print(response.headers.toString());
        loadedPlaces.clear();
        loadedPlaces = mainPlaces.data;

        print(_placeSearchDetails.total.toString());
      } else {
        loadedPlaces = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
    return loadedPlaces;
  }

  Future<List<PlaceInSearch>> retrieveNewItemInCity(City selectedCity,
      String orderby) async {
    List<PlaceInSearch> loadedPlaces = [];

    loadedPlaces = await retrieveCityPlaces(selectedCity.id, orderby);

    return loadedPlaces;
  }

  Future<void> retrieveComment(int placeId) async {
    print('retrieveComment');
    final url = Urls.rootUrl + Urls.placesEndPoint + '/$placeId/comments';
    print(url);
    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        print(extractedData.toString());

        MainComments mainComments = MainComments.fromJson(extractedData);
        print(response.headers.toString());
        _itemsComments.clear();
        _itemsComments.addAll(mainComments.data);

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
        print(_placeSearchDetails.total.toString());
      } else {
        _itemsComments = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<int> sendPlace(String placeName, int provinceId, int cityId) async {
    print('sendPlace');

    final url = Urls.rootUrl + Urls.userPlacesEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {

      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
        body: json.encode(
          PlaceInSend(
            name: placeName,
            province: provinceId,
            city: cityId,
            status: 2,
          ),
        ),
      );
      print('ccccccnnnooot send');

      print(response.body.toString());


      if (response.statusCode >= 200 && response.statusCode < 300) {

        final extractedData = json.decode(response.body);
        print(extractedData.toString());
        PlaceInSend mainPlaces = PlaceInSend.fromJson(extractedData);
        print(response.headers.toString());
        notifyListeners();

        return mainPlaces.id;
      } else {
        notifyListeners();
        print('ccccccnnnooot send');

        return 0;
      }
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<int> modifyPlace() async {
    print('modifyPlace');

    final url = Urls.rootUrl + Urls.userPlacesEndPoint + '/${placeInSend.id}';
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await put(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
        body: json.encode(
          placeInSend,
        ),
      );

      print(response.statusCode);

      print(response.body);

      print('response.body');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('response.body2');

        final extractedData = json.decode(response.body);

        print(extractedData.toString());

        PlaceInSend placeInSendEditied = PlaceInSend.fromJson(extractedData);

        print(response.headers.toString());

        placeInSend.id = placeInSendEditied.id;
        notifyListeners();

        print('ccccccnnn send');

        return placeInSendEditied.id;
      } else {
        notifyListeners();

        print('ccccccnnnooot send');

        return 0;
      }
    } catch (error) {
      print(error.toString());

      throw (error);
    }
  }

  Future<void> sendCommentReply(int placeId, String content,
      int parentId) async {
    print('sendCommentReplay');

    final url = Urls.rootUrl + Urls.commentEndPoint + '/$parentId' + '/reply';
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
        body: json.encode(
          {
            'place_id': placeId,
            'content': content,
            'rate': null,
            'subject': 'جواب',
          },
        ),
      );
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

  Future<void> sendCommentReport(int placeId,
      int commentId,) async {
    print('sendCommentReport');

    final url = Urls.rootUrl + Urls.commentEndPoint;
    print(url);

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await post(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
        body: json.encode(
          {
            'place_id': placeId,
            'comment_ir': commentId,
          },
        ),
      );

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

  Future<void> retrieveFacilities() async {
    print('retrieveFacilities');

    final url = Urls.rootUrl + Urls.facilitiesEndPoint;
    print(url);

    try {
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List;
        print(extractedData.toString());

        List<Facility> dataRaw = new List<Facility>();
        dataRaw = extractedData.map((i) => Facility.fromJson(i)).toList();

        _itemsFacilities.clear();
        _itemsFacilities.addAll(dataRaw);
        print(_itemsFacilities[0].name.toString());
      } else {
        _itemsFacilities = [];
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
      final response = await get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List;
        print(extractedData.toString());

        List<Field> dataRaw = new List<Field>();
        dataRaw = extractedData.map((i) => Field.fromJson(i)).toList();

        _itemsFields.clear();
        _itemsFields.addAll(dataRaw);
      } else {
        _itemsFields = [];
      }
      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> retrievePlace(int placeId) async {
    print('retrievePlace');

    final url = Urls.rootUrl + Urls.userPlacesEndPoint + '/$placeId';
    print(url);
    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);
    try {
      final response = await get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
        },
      );

      final extractedData = json.decode(response.body);

      print(extractedData);

      Place place = Place.fromJson(extractedData);
      print(place.name);

      _itemPlace = place;

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw (error);
    }
  }

  Future<void> uploadImage(File imageFile, int placeId) async {
    print('Upload');

    var stream = new ByteStream(DelegatingStream(imageFile.openRead()));

    var length = await imageFile.length();

    final url = Uri.parse(Urls.rootUrl + Urls.imageUploadEndPoint);

    var request = new MultipartRequest(
      "POST",
      url,
    );

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');

    Map<String, String> header1 = {
      'Authorization': 'Bearer $_token',
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'version': Urls.versionCode
    };

    Map<String, String> fields = {
      'place_id': '$placeId',
    };

    request.headers.addAll(header1);

    request.fields.addAll(fields);

    var multipartFile = MultipartFile('images[]', stream, length,
        filename: basename(imageFile.path));

    request.files.add(multipartFile);

    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) {

      print(value);
    });
  }

  Future<void> deleteImage(int imageId) async {
    print('deleteImage');

    final url = Urls.rootUrl + Urls.imageUploadEndPoint + '/$imageId';

    final prefs = await SharedPreferences.getInstance();

    var _token = prefs.getString('token');
    print(_token);

    try {
      final response = await delete(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'version': Urls.versionCode
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
