
import 'package:novasight_app/app/data/model/city_model.dart';

class RegionService {
  Future<List<CityModel>> getCities() async {
    try{
      return listCities;
    }catch(e){
      rethrow;
    }
  }

}