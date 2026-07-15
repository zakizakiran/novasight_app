import 'package:equatable/equatable.dart';

class SchoolModel extends Equatable {
  final int id;
  final String name;
  final int cityId;

  const SchoolModel({required this.id, required this.name, required this.cityId});

  @override
  List<Object?> get props => [id,name,cityId];
}

List<SchoolModel> listSchool = const [
  SchoolModel(id: 1, name: "SLBN-J Jakarta", cityId: 1),
  SchoolModel(id: 2, name: "SLBN-B Dipatiukur", cityId: 2),
  SchoolModel(id: 3, name: "SLBN-A Citeureup", cityId: 3)
];