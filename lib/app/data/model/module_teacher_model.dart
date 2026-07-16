import 'package:equatable/equatable.dart';
import 'package:novasight_app/app/data/model/class_model.dart';

import '../../core/styles/img/img_constant.dart';

sealed class ModuleChunk extends Equatable {
  final String? annotation;
  const ModuleChunk({this.annotation});
}

class TextChunk extends ModuleChunk {
  final String text;

  const TextChunk({required this.text, super.annotation});

  @override
  List<Object?> get props => [text,annotation];
}

class ImageChunk extends ModuleChunk {
  final String imagePath;

  const ImageChunk({required this.imagePath, super.annotation});

  @override
  List<Object?> get props => [imagePath, annotation];
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
    required this.listChunks});

  @override
  List<Object?> get props => [id,name,type,status,gradeType,listChunks];

  ModuleTeacherModel copyWith({
    int? id,
    String? name,
    ModuleTeacherType? type,
    ModuleTeacherStatus? status,
    ClassGradeType? gradeType,
    List<ModuleChunk>? listChunks
}){
    return ModuleTeacherModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      gradeType: gradeType ?? this.gradeType,
      listChunks: listChunks ?? this.listChunks
    );
}
}

enum ModuleTeacherType {
  pdf("PDF");
  // docs("DOCX");

  final String name;
  const ModuleTeacherType(this.name);
}

enum ModuleTeacherStatus{
  all("Semua"),
  publish("Publish"),
  draft("Draft");

  final String name;
  const ModuleTeacherStatus(this.name);
}


final List<ModuleTeacherModel> listDummyModuleTeacher = [
  const ModuleTeacherModel(
    id: 1,
    name: "Pengenalan Himpunan",
    type: ModuleTeacherType.pdf,
    status: ModuleTeacherStatus.publish,
    gradeType: ClassGradeType.classTen,
    listChunks: [
      TextChunk(
        text:
        "Himpunan adalah kumpulan objek atau anggota yang didefinisikan dengan jelas sehingga dapat ditentukan apakah suatu objek termasuk ke dalam himpunan tersebut atau tidak.",
        annotation:
        "Bagian ini menjelaskan pengertian dasar himpunan sebagai konsep utama dalam materi.",
      ),
      ImageChunk(
        imagePath: ImgConstant.diagramHimpunan,
        annotation:
        "Diagram memperlihatkan hubungan antarhimpunan menggunakan diagram Venn. Diagram ini membantu memahami konsep irisan (∩), gabungan (∪), dan himpunan semesta (U).",
      ),
      TextChunk(
        text:
        "Misalnya, A = {1, 2, 3, 4} dan B = {3, 4, 5, 6}. Irisan kedua himpunan tersebut adalah {3, 4}, sedangkan gabungannya adalah {1, 2, 3, 4, 5, 6}.",
        annotation:
        "Contoh ini menunjukkan cara menentukan irisan dan gabungan dua himpunan berdasarkan anggota yang dimiliki.",
      ),
    ],
  ),
  const ModuleTeacherModel(
    id: 2,
    name: "Persamaan Linear",
    type: ModuleTeacherType.pdf,
    status: ModuleTeacherStatus.draft,
    gradeType: ClassGradeType.classEleven,
    listChunks: [
      TextChunk(
        text:
        "Persamaan linear satu variabel adalah persamaan yang hanya memiliki satu variabel berpangkat satu.",
        annotation:
        "Memperkenalkan definisi persamaan linear satu variabel.",
      ),
      TextChunk(
        text:
        "Contoh: x + 5 = 12, maka nilai x adalah 7.",
        annotation:
        "Memberikan contoh sederhana penyelesaian persamaan linear.",
      ),
      TextChunk(
        text:
        "Untuk menyelesaikan persamaan linear, lakukan operasi yang sama pada kedua ruas persamaan.",
        annotation:
        "Menjelaskan prinsip dasar menjaga kesetaraan kedua ruas persamaan.",
      ),
    ],
  ),
];

const ModuleTeacherModel newModuleTeacher = ModuleTeacherModel(
  id: 3,
  name: "Sistem Persamaan Linear Dua Variabel (SPLDV)",
  type: ModuleTeacherType.pdf,
  status: ModuleTeacherStatus.draft,
  gradeType: ClassGradeType.classTen, // Or classEleven depending on your curriculum layout
  listChunks: [
    TextChunk(
      text:
      "Sistem Persamaan Linear Dua Variabel (SPLDV) adalah kumpulan dua atau lebih persamaan linear yang memiliki dua variabel yang sama.",
      annotation:
      "Menjelaskan pengertian dasar SPLDV dan karakteristik variabelnya.",
    ),
    TextChunk(
      text:
      "Metode penyelesaian SPLDV yang umum digunakan antara lain adalah metode substitusi, eliminasi, campuran, dan grafik.",
      annotation:
      "Mengidentifikasi berbagai macam strategi pemecahan masalah untuk menemukan nilai variabel.",
    ),
    TextChunk(
      text:
      "Contoh: Diberikan x + y = 5 dan 2x - y = 4. Dengan menjumlahkan kedua persamaan (eliminasi y), didapat 3x = 9, sehingga x = 3. Substitusi x ke persamaan pertama menghasilkan 3 + y = 5, sehingga y = 2.",
      annotation:
      "Memberikan contoh langkah demi langkah penyelesaian SPLDV menggunakan metode campuran (eliminasi-substitusi).",
    ),
    TextChunk(
      text:
      "Dalam kehidupan sehari-hari, SPLDV sering digunakan untuk memodelkan masalah kontekstual, seperti menentukan harga satuan barang atau memprediksi kombinasi keuntungan maksimal.",
      annotation:
      "Menghubungkan konsep abstrak matematika dengan aplikasi atau implementasi di dunia nyata.",
    ),
  ],
);