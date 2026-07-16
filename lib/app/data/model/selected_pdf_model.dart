import 'dart:typed_data';
import 'package:equatable/equatable.dart';

class SelectedPdfModel extends Equatable {
  final String name;
  final Uint8List bytes;
  final int size;

  const SelectedPdfModel({
    required this.name,
    required this.bytes,
    required this.size,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [name,bytes,size];
}