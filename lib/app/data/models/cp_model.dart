import 'package:equatable/equatable.dart';

class CpModel extends Equatable{
  final int id;
  final int faseId;
  final String domain;
  final String cpText;

  const CpModel({required this.id, required this.faseId, required this.domain, required this.cpText});

  @override
  List<Object?> get props => [
    id,faseId,domain,cpText
  ];

  factory CpModel.fromJson(Map<String, dynamic> json) {
    return CpModel(
      id: json['id'] as int,
      faseId: json['fase_id'] as int,
      domain: json['domain'] as String,
      cpText: json['cp_text'] as String,
    );
  }

  @override
  String toString() => domain;
}