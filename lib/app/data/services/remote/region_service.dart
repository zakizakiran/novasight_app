
import 'package:lydera_app/app/data/models/city_model.dart';

class RegionService {
  Future<List<CityModel>> getCities() async {
    try{
      return listCities;
    }catch(e){
      rethrow;
    }
  }

}