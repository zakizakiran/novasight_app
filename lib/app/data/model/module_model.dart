import 'package:equatable/equatable.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';
import 'package:novasight_app/app/data/model/subject_model.dart';
import 'package:novasight_app/app/data/model/subject_page_module.dart';

class ModuleModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final List<SubjectModel> subjects;
  final ModuleStatus status;
  const ModuleModel({required this.id, required this.title, required this.description, required this.subjects, this.status = ModuleStatus.notDone});

  ModuleModel copyWith({
    int? id,
    String? title,
    String? description,
    List<SubjectModel>? subjects,
    ModuleStatus? status
  }){
    return ModuleModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        subjects: subjects ?? this.subjects
    );
  }
  int toPercentageDone() {
    return subjects.isEmpty
        ? 0
        : ((subjects.where((s) => s.isDone).length / subjects.length) * 100)
        .round();
  }

  @override
  List<Object?> get props => [id,title,description,subjects,status];
}

// ==========================
// MODULE 1 : EKSPONEN & LOGARITMA
// ==========================

List<ModuleModel> listModule = [moduleEksponen, moduleHimpunan];

ModuleModel moduleEksponen = ModuleModel(
  id: 1,
  title: "BAB 1 : Eksponen dan Logaritma",
  description: "Bab Eksponen dan Logaritma",
  subjects: [
    subjectModel1,
    subjectModel2,
    subjectModel3,
    subjectModel4,
    subjectModel5,
  ],
);

// Pengertian Eksponen
SubjectModel subjectModel1 = const SubjectModel(
  id: 1,
  title: "Pengertian Eksponen",
  isDone: true,
  pages: [
    SubjectPageModel(
      title: "Pengertian Eksponen",
      subject: '''
Eksponen adalah suatu bentuk perkalian berulang dari suatu bilangan yang sama.

Dalam bentuk umum, eksponen ditulis sebagai:

a pangkat n

dengan:
• a adalah bilangan pokok atau basis.
• n adalah nilai pangkat.

Artinya, a dikalikan dengan dirinya sendiri sebanyak n kali.
''',
    ),
    SubjectPageModel(
      title: "Penerapan Eksponen",
      subject: '''
Eksponen digunakan dalam berbagai bidang, seperti:

• Menyatakan bilangan besar dan kecil.
• Perhitungan bunga majemuk.
• Pertumbuhan populasi.
• Ilmu fisika dan komputer.

Contoh:
10 pangkat 6 sama dengan 1.000.000.
2 pangkat 5 sama dengan 32.
''',
    ),
  ],
);

// Sifat-sifat Eksponen
SubjectModel subjectModel2 = const SubjectModel(
  id: 2,
  title: "Sifat-sifat Eksponen",
  isDone: true,
  pages: [
    SubjectPageModel(
      title: "Sifat-sifat Eksponen",
      subject: '''
Beberapa sifat dasar eksponen:

• a pangkat m dikali a pangkat n sama dengan a pangkat m ditambah n.

• a pangkat m dibagi a pangkat n sama dengan a pangkat m dikurangi n.

• Buka kurung a pangkat m tutup kurung, kemudian dipangkatkan n, sama dengan a pangkat m dikali n.
''',
    ),
    SubjectPageModel(
      title: "Contoh Penerapan Sifat Eksponen",
      subject: '''
Contoh penggunaan:

2 pangkat 3 dikali 2 pangkat 2 sama dengan 2 pangkat 5.

Hasil akhirnya adalah 32.

5 pangkat 7 dibagi 5 pangkat 3 sama dengan 5 pangkat 4.

Hasil akhirnya adalah 625.

Buka kurung 3 pangkat 2 tutup kurung dipangkatkan 3 sama dengan 3 pangkat 6.

Hasil akhirnya adalah 729.
''',
    ),
  ],
);

// Pengertian Logaritma
SubjectModel subjectModel3 = const SubjectModel(
  id: 3,
  title: "Pengertian Logaritma",
  isDone: true,
  pages: [
    SubjectPageModel(
      title: "Pengertian Logaritma",
      subject: '''
Logaritma merupakan operasi kebalikan dari eksponen.

Jika:

a pangkat n sama dengan b.

maka dapat ditulis:

Log basis a dari b sama dengan n.
''',
    ),
    SubjectPageModel(
      title: "Contoh Bentuk Logaritma",
      subject: '''
Contoh:

2 pangkat 3 sama dengan 8.

maka:

Log basis 2 dari 8 sama dengan 3.

Artinya, logaritma mencari nilai pangkat dari suatu bilangan.
''',
    ),
  ],
);

// Hubungan Logaritma dengan Eksponen
SubjectModel subjectModel4 = const SubjectModel(
  id: 4,
  title: "Hubungan Logaritma dengan Eksponen",
  isDone: false,
  pages: [
    SubjectPageModel(
      title: "Hubungan Logaritma dengan Eksponen",
      subject: '''
Eksponen dan logaritma saling berkebalikan.

Jika diketahui bentuk eksponen,
maka dapat diubah menjadi bentuk logaritma, begitu juga sebaliknya.
''',
    ),
    SubjectPageModel(
      title: "Konversi Bentuk Eksponen dan Logaritma",
      subject: '''
Contoh:

3 pangkat 4 sama dengan 81.

Bentuk tersebut setara dengan.

Log basis 3 dari 81 sama dengan 4.

Artinya, angka 4 adalah pangkat yang harus diberikan kepada angka 3 sehingga menghasilkan 81.

Keduanya menyatakan informasi yang sama dalam bentuk berbeda.
''',
    ),
  ],
);

// Sifat-sifat Logaritma
SubjectModel subjectModel5 = const SubjectModel(
  id: 5,
  title: "Sifat-sifat Logaritma",
  isDone: false,
  pages: [
    SubjectPageModel(
      title: "Sifat-sifat Logaritma",
      subject: '''
Beberapa sifat logaritma:

• Log basis a dari x dikali y sama dengan log basis a dari x ditambah log basis a dari y.

• Log basis a dari x dibagi y sama dengan log basis a dari x dikurangi log basis a dari y.

• Log basis a dari x pangkat n sama dengan n dikali log basis a dari x.
''',
    ),
    SubjectPageModel(
      title: "Contoh Penggunaan Sifat Logaritma",
      subject: '''
Contoh:

Sama dengan log basis 2 dari 8 ditambah log basis 2 dari 4.

Sama dengan 3 ditambah 2.

Hasil akhirnya adalah 5.
''',
    ),
  ],
);

// ==========================
// MODULE 2 : HIMPUNAN
// ==========================

ModuleModel moduleHimpunan = ModuleModel(
  id: 2,
  title: "BAB 2 : Himpunan",
  description: "Bab Himpunan dan Operasi Himpunan",
  subjects: [
    subjectModel6,
    subjectModel7,
    subjectModel8,
    subjectModel9,
    subjectModel10,
  ],
);

// Pengertian Himpunan
SubjectModel subjectModel6 = const SubjectModel(
  id: 6,
  title: "Pengertian Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      title: "Pengertian Himpunan",
      subject: '''
Himpunan adalah kumpulan objek yang terdefinisi dengan jelas.

Anggota himpunan ditulis di dalam kurung kurawal.

Contoh:

Himpunan A berisi angka 1, 2, 3, dan 4.
''',
    ),
    SubjectPageModel(
      title: "Contoh Himpunan",
      subject: '''
Contoh himpunan:

• Himpunan huruf vokal terdiri dari huruf A, I, U, E, dan O.

• Himpunan bilangan genap kurang dari 10 terdiri dari angka 2, 4, 6, dan 8.
''',
    ),
  ],
);

// Jenis-jenis Himpunan
SubjectModel subjectModel7 = const SubjectModel(
  id: 7,
  title: "Jenis-jenis Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      title: "Jenis-jenis Himpunan",
      subject: '''
Beberapa jenis himpunan:

• Himpunan kosong
• Himpunan semesta
• Himpunan bagian
• Himpunan sama
''',
    ),
    SubjectPageModel(
      title: "Contoh Jenis Himpunan",
      subject: '''
Contoh:

Himpunan kosong adalah himpunan yang tidak memiliki anggota.

Himpunan semesta dapat berupa seluruh siswa kelas sepuluh.

Jika A merupakan himpunan bagian dari B, maka semua anggota A juga terdapat di dalam himpunan B.
''',
    ),
  ],
);

// Irisan Himpunan
SubjectModel subjectModel8 = const SubjectModel(
  id: 8,
  title: "Irisan Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      title: "Irisan Himpunan",
      subject: '''
Irisan adalah anggota yang terdapat pada dua himpunan sekaligus.

Ditulis:

A irisan B.
''',
    ),
    SubjectPageModel(
      title: "Contoh Irisan Himpunan",
      subject: '''
Contoh:

Himpunan A berisi angka 1, 2, 3, dan 4.

Himpunan B berisi angka 3, 4, dan 5.

A irisan B menghasilkan himpunan yang berisi angka 3 dan 4.
''',
    ),
  ],
);

// Gabungan Himpunan
SubjectModel subjectModel9 = const SubjectModel(
  id: 9,
  title: "Gabungan Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      title: "Gabungan Himpunan",
      subject: '''
Gabungan merupakan semua anggota dari dua himpunan tanpa pengulangan.

Ditulis:

A union B.
Artinya, semua anggota yang terdapat di himpunan A maupun himpunan B digabung menjadi satu himpunan baru.
''',
    ),
    SubjectPageModel(
      title: "Contoh Gabungan Himpunan",
      subject: '''
Contoh:

Himpunan A berisi angka 1, 2, dan 3.

Himpunan B berisi angka 3, 4, dan 5.

A union B menghasilkan himpunan yang berisi angka 1, 2, 3, 4, dan 5.

Perhatikan bahwa angka 3 hanya ditulis satu kali karena anggota yang sama tidak diulang pada gabungan himpunan.
''',
    ),
  ],
);

// Selisih Himpunan
SubjectModel subjectModel10 = const SubjectModel(
  id: 10,
  title: "Selisih Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      title: "Selisih Himpunan",
      subject: '''
Selisih himpunan adalah anggota suatu himpunan yang tidak dimiliki himpunan lainnya.

Ditulis:

A dikurangi B.
''',
    ),
    SubjectPageModel(
      title: "Contoh Selisih Himpunan",
      subject: '''
Contoh:

Himpunan A berisi angka 1, 2, 3, dan 4.

Himpunan B berisi angka 3, 4, dan 5.

A dikurangi B menghasilkan himpunan yang berisi angka 1 dan 2.

Sedangkan B dikurangi A menghasilkan himpunan yang berisi angka 5.

Perhatikan bahwa hasil selisih bergantung pada urutan himpunan yang dikurangi.
''',
    ),
  ],
);
