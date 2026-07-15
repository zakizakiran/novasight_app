import 'package:get/get.dart';
import 'package:novasight_app/app/core/utils/module_status.dart';

class ExamDummyModel {
  final String id;
  final String title;
  final String subtitle;
  final String statusText;
  final String nilai;
  final ModuleStatus status;

  ExamDummyModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.statusText,
    required this.nilai,
    required this.status,
  });
}

class ExamController extends GetxController {
  final selectedStatus = ModuleStatus.all.obs;

  final exams = <ExamDummyModel>[
    ExamDummyModel(
      id: '1',
      title: 'UTS Kelas X',
      subtitle: 'Bab Eksponen dan Logaritma',
      statusText: 'Belum dikerjakan',
      nilai: '-',
      status: ModuleStatus.notDone,
    ),
    ExamDummyModel(
      id: '2',
      title: 'UH 1 — Himpunan dan Operasinya',
      subtitle: 'Bab Himpunan dan Operasinya',
      statusText: 'Belum dikerjakan',
      nilai: '-',
      status: ModuleStatus.notDone,
    ),
    ExamDummyModel(
      id: '3',
      title: 'UAS Semester 1',
      subtitle: 'Semua Bab',
      statusText: 'Selesai dikerjakan',
      nilai: '90',
      status: ModuleStatus.done,
    ),
    ExamDummyModel(
      id: '4',
      title: 'Kuis Singkat — Aljabar',
      subtitle: 'Bab Aljabar',
      statusText: 'Selesai dikerjakan',
      nilai: '85',
      status: ModuleStatus.done,
    ),
  ];

  List<ExamDummyModel> get filteredExams {
    return switch (selectedStatus.value) {
      ModuleStatus.all => exams.toList(),
      ModuleStatus.notDone =>
        exams.where((e) => e.status == ModuleStatus.notDone).toList(),
      ModuleStatus.done =>
        exams.where((e) => e.status == ModuleStatus.done).toList(),
    };
  }

  void onChangeStatus(ModuleStatus status) {
    selectedStatus.value = status;
  }
}
