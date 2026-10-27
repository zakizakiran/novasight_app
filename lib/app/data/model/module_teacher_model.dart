import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import 'package:lydera_app/app/data/model/class_model.dart';

import '../../core/styles/img/img_constant.dart';

sealed class ModuleChunk extends Equatable {
  final int id;
  final String? annotation;
  const ModuleChunk({this.annotation, required this.id});

  // Base signature
  ModuleChunk copyWith({int? id, String? annotation});
}

class TextChunk extends ModuleChunk {
  final String text;
  const TextChunk({required this.text, super.annotation, required super.id});

  @override
  TextChunk copyWith({int? id, String? annotation, String? text}) {
    return TextChunk(
      id: id ?? this.id,
      annotation: annotation ?? this.annotation,
      text: text ?? this.text,
    );
  }

  @override
  List<Object?> get props => [id, annotation, text];
}

class ImageChunk extends ModuleChunk {
  final String imagePath;
  final Uint8List? imageBytes;
  final int? page;
  final String blockType;
  final String? sourceMarkup;

  const ImageChunk({
    required this.imagePath,
    this.imageBytes,
    this.page,
    this.blockType = 'picture',
    this.sourceMarkup,
    super.annotation,
    required super.id,
  });

  bool get isTable => blockType.toLowerCase().contains('table');
  bool get isFormula =>
      blockType.toLowerCase().contains('formula') ||
      blockType.toLowerCase().contains('equation');
  bool get isDiagram =>
      blockType.toLowerCase().contains('diagram') ||
      blockType.toLowerCase().contains('chart');

  String get displayTypeLabel {
    if (isTable) return 'Tabel';
    if (isFormula) return 'Formula';
    if (isDiagram) return 'Diagram';
    return 'Gambar';
  }

  @override
  ImageChunk copyWith({
    int? id,
    String? annotation,
    String? imagePath,
    Uint8List? imageBytes,
    int? page,
    String? blockType,
    String? sourceMarkup,
  }) {
    return ImageChunk(
      id: id ?? this.id,
      annotation: annotation ?? this.annotation,
      imagePath: imagePath ?? this.imagePath,
      imageBytes: imageBytes ?? this.imageBytes,
      page: page ?? this.page,
      blockType: blockType ?? this.blockType,
      sourceMarkup: sourceMarkup ?? this.sourceMarkup,
    );
  }

  @override
  List<Object?> get props => [
        id,
        annotation,
        imagePath,
        imageBytes,
        page,
        blockType,
        sourceMarkup,
      ];
}

class ModuleTeacherModel extends Equatable {
  final int id;
  final String name;
  final ModuleTeacherType type;
  final ModuleTeacherStatus status;
  final ClassGradeType gradeType;
  final List<ModuleChunk> listChunks;

  const ModuleTeacherModel({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.gradeType,
    required this.listChunks,
  });

  @override
  List<Object?> get props => [id, name, type, status, gradeType, listChunks];

  ModuleTeacherModel copyWith({
    int? id,
    String? name,
    ModuleTeacherType? type,
    ModuleTeacherStatus? status,
    ClassGradeType? gradeType,
    List<ModuleChunk>? listChunks,
  }) {
    return ModuleTeacherModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      gradeType: gradeType ?? this.gradeType,
      listChunks: listChunks ?? this.listChunks,
    );
  }
}

enum ModuleTeacherType {
  pdf("PDF");

  final String name;
  const ModuleTeacherType(this.name);
}

enum ModuleTeacherStatus {
  all("Semua"),
  publish("Publish"),
  draft("Draft");

  final String name;
  const ModuleTeacherStatus(this.name);
}

