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

aⁿ

dengan:
• a = bilangan pokok (basis)
• n = pangkat

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
10⁶ = 1.000.000
2⁵ = 32
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

• aᵐ × aⁿ = aᵐ⁺ⁿ
• aᵐ ÷ aⁿ = aᵐ⁻ⁿ
• (aᵐ)ⁿ = aᵐⁿ
''',
    ),
    SubjectPageModel(
      title: "Contoh Penerapan Sifat Eksponen",
      subject: '''
Contoh penggunaan:

2³ × 2² = 2⁵ = 32

5⁷ ÷ 5³ = 5⁴ = 625

(3²)³ = 3⁶ = 729
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

aⁿ = b

maka dapat ditulis:

logₐ(b) = n
''',
    ),
    SubjectPageModel(
      title: "Contoh Bentuk Logaritma",
      subject: '''
Contoh:

2³ = 8

maka:

log₂(8) = 3

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

3⁴ = 81

⇔

log₃(81) = 4

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

• logₐ(xy) = logₐx + logₐy

• logₐ(x/y) = logₐx − logₐy

• logₐ(xⁿ) = n logₐx
''',
    ),
    SubjectPageModel(
      title: "Contoh Penggunaan Sifat Logaritma",
      subject: '''
Contoh:

log₂(8 × 4)

= log₂8 + log₂4

= 3 + 2

= 5
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

A = {1,2,3,4}
''',
    ),
    SubjectPageModel(
      title: "Contoh Himpunan",
      subject: '''
Contoh himpunan:

• Himpunan huruf vokal
{a, i, u, e, o}

• Himpunan bilangan genap kurang dari 10
{2,4,6,8}
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

∅ = himpunan kosong

S = himpunan semua siswa kelas X

A ⊂ B berarti A merupakan bagian dari B.
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

A ∩ B
''',
    ),
    SubjectPageModel(
      title: "Contoh Irisan Himpunan",
      subject: '''
Contoh:

A = {1,2,3,4}

B = {3,4,5}

A ∩ B = {3,4}
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

A ∪ B
''',
    ),
    SubjectPageModel(
      title: "Contoh Gabungan Himpunan",
      subject: '''
Contoh:

A = {1,2,3}

B = {3,4,5}

A ∪ B = {1,2,3,4,5}
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

A − B
''',
    ),
    SubjectPageModel(
      title: "Contoh Selisih Himpunan",
      subject: '''
Contoh:

A = {1,2,3,4}

B = {3,4,5}

A − B = {1,2}

B − A = {5}
''',
    ),
  ],
);
