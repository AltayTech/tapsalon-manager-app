import 'package:tapsalon_manager/models/places_models/place.dart';
import 'package:tapsalon_manager/models/places_models/place_in_send.dart';

class CreatePlaceObject {
  PlaceInSend convertPlace(Place place) {
    PlaceInSend placeInSend;

    placeInSend = PlaceInSend(
      id: place.id,
      name: place.name,
      about: place.about,
      excerpt: place.excerpt,
      timings_excerpt: place.timings_excerpt,
      price: place.price,
      phone: place.phone,
      mobile: place.mobile,
      address: place.address,
      longitude: place.longitude,
      latitude: place.latitude,
      fields: getIdList(place.fields),
      facilities: getIdList(place.facilities),
      city: place.id,
      province: place.province.id,
      image: place.image.id,
      region: place.region.id,
      gallery: getIdList(place.gallery),
      placeType: place.placeType.id,
    );

    return placeInSend;
  }

  List<int> getIdList(List<dynamic> list) {
    List<int> idList = [];

    for (int i; i < list.length; i++) {
      idList.add(list[i].id);
    }
    return idList;
  }
}
