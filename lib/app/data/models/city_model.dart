import 'package:equatable/equatable.dart';

class CityModel extends Equatable {
  final int id;
  final String name;
  const CityModel({ required this.id, required this.name});

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id,name];
}
List<CityModel> listCities = const [
  CityModel(
      id: 1,
      name: "Jakarta"
  ),
  CityModel(
      id: 2,
      name: "Bandung"
  ),
  CityModel(
      id: 3,
      name: "Cimahi"
  )
];
