class Urls {
  static const rootUrl = 'https://rest.tapsalon.ir';
  static const citiesEndPoint = '/api/cities';
  static const provincesEndPoint = '/api/ostans';
  static const placesEndPoint = '/api/places';
  static const userPlacesEndPoint = '/api/user/places';

//  static const placesEndPoint = '/api/places';
  static const usersEndPoint = '/api/users';
  static const facilitiesEndPoint = '/api/facilities';
  static const fieldsEndPoint = '/api/fields';
  static const regionsEndPoint = '/api/regions';
  static const getPriceRangeEndPoint = '/api/complexes/search/range';
  static const loginEndPoint = '/oauth/token';
  static const sendSMSEndPoint = '/api/sms';
  static const userEndPoint = '/api/user';
  static const commentEndPoint = '/api/comments';
  static const imageUploadEndPoint = '/api/images';


  static const userLikesEndPoint = '/api/user/likes';
  static const likePlaceEndPoint = '/api/likes';
  static const versionCode = '4';
  static const requestHeader = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'version': versionCode
  };
}
