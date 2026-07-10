import 'package:equatable/equatable.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';

class ModuleModel extends Equatable {
  final int id;
  final String title;
  final String description;
  final List<SubjectModel> subjects;
  final ModuleStatus status;
  const ModuleModel({required this.title, required this.id, required this.description, required this.subjects, this.status = ModuleStatus.notDone});

  int toPercentageDone() {
    return subjects.isEmpty
        ? 0
        : ((subjects.where((s) => s.isDone).length / subjects.length) * 100)
        .round();
  }

  @override
  List<Object?> get props => [id,title,description,subjects,status];
}

class SubjectModel extends Equatable {
  final String title;
  final bool isDone;
  final List<SubjectPageModel> pages;
  const SubjectModel({required this.title, required this.isDone, required this.pages});

  @override
  List<Object?> get props => [title,isDone,pages];
}

class SubjectPageModel extends Equatable{
  final String subject;

  const SubjectPageModel({required this.subject});

  @override
  // TODO: implement props
  List<Object?> get props => [subject];
}

// ==========================
// MODULE 1 : EKSPONEN & LOGARITMA
// ==========================

List<ModuleModel> listModule = [moduleEksponen,moduleHimpunan];
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
SubjectModel subjectModel1 = SubjectModel(
  title: "Pengertian Eksponen",
  isDone: true,
  pages: [
    SubjectPageModel(
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

// Sifat Eksponen
SubjectModel subjectModel2 = SubjectModel(
  title: "Sifat-sifat Eksponen",
  isDone: true,
  pages: [
    SubjectPageModel(
      subject: '''
Beberapa sifat dasar eksponen:

• aᵐ × aⁿ = aᵐ⁺ⁿ
• aᵐ ÷ aⁿ = aᵐ⁻ⁿ
• (aᵐ)ⁿ = aᵐⁿ
''',
    ),
    SubjectPageModel(
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
SubjectModel subjectModel3 = SubjectModel(
  title: "Pengertian Logaritma",
  isDone: true,
  pages: [
    SubjectPageModel(
      subject: '''
Logaritma merupakan operasi kebalikan dari eksponen.

Jika:

aⁿ = b

maka dapat ditulis:

logₐ(b) = n
''',
    ),
    SubjectPageModel(
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

// Hubungan Eksponen dan Logaritma
SubjectModel subjectModel4 = SubjectModel(
  title: "Hubungan Logaritma dengan Eksponen",
  isDone: false,
  pages: [
    SubjectPageModel(
      subject: '''
Eksponen dan logaritma saling berkebalikan.

Jika diketahui bentuk eksponen,
maka dapat diubah menjadi bentuk logaritma, begitu juga sebaliknya.
''',
    ),
    SubjectPageModel(
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

// Sifat Logaritma
SubjectModel subjectModel5 = SubjectModel(
  title: "Sifat-sifat Logaritma",
  isDone: false,
  pages: [
    SubjectPageModel(
      subject: '''
Beberapa sifat logaritma:

• logₐ(xy) = logₐx + logₐy

• logₐ(x/y) = logₐx − logₐy

• logₐ(xⁿ) = n logₐx
''',
    ),
    SubjectPageModel(
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
SubjectModel subjectModel6 = SubjectModel(
  title: "Pengertian Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      subject: '''
Himpunan adalah kumpulan objek yang terdefinisi dengan jelas.

Anggota himpunan ditulis di dalam kurung kurawal.
Contoh:

A = {1,2,3,4}
''',
    ),
    SubjectPageModel(
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

// Jenis Himpunan
SubjectModel subjectModel7 = SubjectModel(
  title: "Jenis-jenis Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      subject: '''
Beberapa jenis himpunan:

• Himpunan kosong
• Himpunan semesta
• Himpunan bagian
• Himpunan sama
''',
    ),
    SubjectPageModel(
      subject: '''
Contoh:

∅ = himpunan kosong

S = himpunan semua siswa kelas X

A ⊂ B berarti A merupakan bagian dari B.
''',
    ),
  ],
);

// Irisan
SubjectModel subjectModel8 = SubjectModel(
  title: "Irisan Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      subject: '''
Irisan adalah anggota yang terdapat pada dua himpunan sekaligus.

Ditulis:

A ∩ B
''',
    ),
    SubjectPageModel(
      subject: '''
Contoh:

A = {1,2,3,4}

B = {3,4,5}

A ∩ B = {3,4}
''',
    ),
  ],
);

// Gabungan
SubjectModel subjectModel9 = SubjectModel(
  title: "Gabungan Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      subject: '''
Gabungan merupakan semua anggota dari dua himpunan tanpa pengulangan.

Ditulis:

A ∪ B
''',
    ),
    SubjectPageModel(
      subject: '''
Contoh:

A = {1,2,3}

B = {3,4,5}

A ∪ B = {1,2,3,4,5}
''',
    ),
  ],
);

// Selisih
SubjectModel subjectModel10 = SubjectModel(
  title: "Selisih Himpunan",
  isDone: false,
  pages: [
    SubjectPageModel(
      subject: '''
Selisih himpunan adalah anggota suatu himpunan yang tidak dimiliki himpunan lainnya.

Ditulis:

A − B
''',
    ),
    SubjectPageModel(
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
