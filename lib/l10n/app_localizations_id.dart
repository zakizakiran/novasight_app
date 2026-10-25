// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'Nova';

  @override
  String get close => 'Tutup';

  @override
  String get back => 'Kembali';

  @override
  String get save => 'Simpan';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get success => 'Sukses';

  @override
  String get failed => 'Gagal';

  @override
  String get loading => 'Memuat...';

  @override
  String get tryAgain => 'Coba Lagi';

  @override
  String get saveChanges => 'Simpan Perubahan';

  @override
  String get settings => 'Pengaturan';

  @override
  String get settingsDescription =>
      'Sesuaikan pengaturan aplikasi sesuai kebutuhan Anda.';

  @override
  String get language => 'Bahasa';

  @override
  String get languageDescription => 'Ubah bahasa aplikasi';

  @override
  String get selectLanguage => 'Pilih Bahasa';

  @override
  String get selectLanguageDescription =>
      'Pilih bahasa yang digunakan pada aplikasi.';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get english => 'English';

  @override
  String get textSize => 'Ukuran teks';

  @override
  String get textSizeDescription => 'Perbesar atau perkecil teks';

  @override
  String get textSizeAdjustDescription =>
      'Sesuaikan ukuran teks agar lebih mudah dibaca.';

  @override
  String get currentSize => 'Ukuran saat ini';

  @override
  String get reduceTextSize => 'Perkecil ukuran teks';

  @override
  String get enlargeTextSize => 'Perbesar ukuran teks';

  @override
  String textSizePercent(int percent) {
    return 'Ukuran teks $percent persen';
  }

  @override
  String get sampleTextTitle => 'Contoh Tampilan';

  @override
  String get sampleTextBody =>
      'Ini adalah teks contoh untuk melihat bagaimana tampilan teks saat ukurannya diubah.';

  @override
  String get resetTextScale => 'Atur ulang ukuran teks';

  @override
  String get backToSettings => 'Kembali ke pengaturan';

  @override
  String get profile => 'Profil';

  @override
  String get schoolOrigin => 'Asal Sekolah : ';

  @override
  String get gradeLevel => 'Tingkat Kelas : ';

  @override
  String get studentId => 'NIS/NISN : ';

  @override
  String get logout => 'Logout';

  @override
  String get leaveClass => 'Keluar Kelas';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navModule => 'Modul';

  @override
  String get navExam => 'Soal Ujian';

  @override
  String get navClarifier => 'Clarifier';

  @override
  String get navProfile => 'Profil';

  @override
  String get currentPosition => 'Posisi di';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterNotDone => 'Belum Selesai';

  @override
  String get filterDone => 'Selesai';

  @override
  String get filterNotAttempted => 'Belum Dikerjakan';

  @override
  String get filterMaterial => 'Materi';

  @override
  String get filterExam => 'Soal Ujian';

  @override
  String get filterPublish => 'Publish';

  @override
  String get filterDraft => 'Draft';

  @override
  String filterLabel(String label) {
    return 'Filter $label';
  }

  @override
  String get learningModules => 'Modul Pembelajaran';

  @override
  String get examQuestions => 'Soal Ujian';

  @override
  String get examReviewTitle => 'Evaluaizer — Review Hasil Ujian';

  @override
  String get noteAppBarTitle => 'Scriber — Catatan Pengerjaan';

  @override
  String pageOf(int current, int total) {
    return 'Halaman $current dari $total';
  }

  @override
  String questionOf(int current, int total) {
    return 'Soal $current dari $total';
  }

  @override
  String chaptersCount(int count) {
    return '$count Bab Materi';
  }

  @override
  String get uploadModule => '+ Unggah Modul';

  @override
  String get createExamQuizzer => 'Buat Soal (Quizzer)';

  @override
  String get examDetailTitle => 'Detail Soal Ujian';

  @override
  String get studentProgressTitle => 'Progres Murid';

  @override
  String get studentProgressDetailTitle => 'Detail Progres Murid';

  @override
  String get generateExamTitle => 'Quizzer — Buat Soal Ujian';

  @override
  String get splitPagesAndChapters => 'Potong Halaman & BAB';

  @override
  String get processingModule => 'Memproses Modul';

  @override
  String get annotationResult => 'Hasil Annotasi';

  @override
  String get moduleEvaluationTitle => 'Annoter — Evaluasi Modul';

  @override
  String get beforeAnnotation => 'Sebelum Anotasi';

  @override
  String get afterAnnotation => 'Sesudah Anotasi';

  @override
  String get clarifierSubtitle => 'Tanya materi modul & pemahaman konsep';

  @override
  String get conversationHistory => 'Riwayat Percakapan';

  @override
  String get refreshHistory => 'Segarkan riwayat';

  @override
  String get loadingTableOfContents => 'Memuat Daftar Isi...';

  @override
  String get learningMaterials => 'Materi Pembelajaran';

  @override
  String get tableOfContents => 'Daftar Isi';

  @override
  String get errorOccurred => 'Terjadi Kesalahan';

  @override
  String get beforeStartingExam => 'Sebelum Memulai Ujian';

  @override
  String get welcomeStudentGreeting => 'Selamat belajar 👋';

  @override
  String get student => 'Siswa';

  @override
  String get loadingClassData => 'Memuat data kelas...';

  @override
  String get uncompletedModules => 'Modul Belum Selesai';

  @override
  String get uncompletedExams => 'Ujian Belum Selesai';

  @override
  String get materialsAndExams => 'Materi dan Soal Ujian';

  @override
  String get emptyCategoryTasks =>
      'Belum ada materi atau soal ujian pada kategori ini.';

  @override
  String get material => 'Materi';

  @override
  String get exam => 'Ujian';

  @override
  String get score => 'Nilai';

  @override
  String get minutes => 'Menit';

  @override
  String get questions => 'Soal';

  @override
  String get completedStatus => 'Selesai dikerjakan';

  @override
  String get notAttemptedStatus => 'Belum dikerjakan';

  @override
  String durationAndQuestions(int minutes, int questions) {
    return '$minutes Menit • $questions Soal';
  }

  @override
  String get startTask => 'Kerjakan';

  @override
  String get examResultEvaluaizer => 'Evaluaizer (Hasil Ujian)';

  @override
  String percentCompleted(int percent) {
    return '$percent% Selesai';
  }

  @override
  String get noModulesInCategory => 'Belum ada modul pada kategori ini.';

  @override
  String get noExamsInCategory => 'Belum ada soal ujian pada kategori ini.';

  @override
  String get greetingMorning => 'Selamat pagi';

  @override
  String get teacher => 'Guru';

  @override
  String get teacherDashboard => 'Dashboard Pengajar';

  @override
  String get totalModules => 'Total Modul';

  @override
  String get totalStudents => 'Total Siswa';

  @override
  String get classCode => 'Kode Kelas';

  @override
  String get shareCodeDescription => 'Bagikan ke siswa agar bisa bergabung';

  @override
  String get copyClassCode => 'Salin Kode Kelas';

  @override
  String get noClassYet => 'Belum Ada Kelas';

  @override
  String get newestModules => 'Modul Terbaru';

  @override
  String get newestExams => 'Soal Ujian Terbaru';

  @override
  String get seeAll => 'Lihat semua';

  @override
  String get noModulesCreated => 'Belum ada modul yang dibuat.';

  @override
  String get noRecentExams => 'Belum ada soal ujian terbaru.';

  @override
  String get noModulesForClass => 'Belum ada modul untuk kelas ini';

  @override
  String get noExamsForClass => 'Belum ada soal ujian untuk kelas ini';

  @override
  String get searchModuleHint => 'Cari modul...';

  @override
  String get searchModuleLabel => 'Cari modul berdasarkan judul';

  @override
  String get inclusiveMathApp => 'Aplikasi Matematika Inklusif';

  @override
  String get joinClass => 'Masuk ke Kelas';

  @override
  String get enterClassCodeFromTeacher => 'Masukkan kode kelas dari gurumu';

  @override
  String get createClass => 'Buat Kelas Kamu';

  @override
  String get classCreatedSuccess => 'Kelas Berhasil Dibuat!';

  @override
  String get shareCodeWithStudents => 'Bagikan kode dibawah ke siswamu';

  @override
  String get joinedClassSuccess => 'Kamu sudah bergabung ke kelas';

  @override
  String get forgotPassword => 'Lupa Password';

  @override
  String get registerAccount => 'Daftar Akun';

  @override
  String get startInclusiveLearning => 'Mulai perjalanan belajar inklusifmu';

  @override
  String get viewModule => 'Lihat Modul';

  @override
  String get publishModule => 'Publish Modul';

  @override
  String get published => 'Terpublikasi';

  @override
  String get deleteModule => 'Hapus Modul';

  @override
  String deleteModuleConfirm(String title) {
    return 'Anda yakin ingin menghapus \"$title\"? Seluruh bab dan anotasi di dalamnya akan terhapus secara permanen.';
  }

  @override
  String get moduleDetail => 'Detail Modul';

  @override
  String get chapterDetail => 'Detail Bab';

  @override
  String get chapterList => 'Daftar Bab / Materi';

  @override
  String get noChaptersInModule =>
      'Belum ada bab atau materi yang ditambahkan pada modul ini.';

  @override
  String get chapter => 'Bab';

  @override
  String chapterNumber(String number) {
    return 'Bab $number';
  }

  @override
  String learningContentBlocks(int count) {
    return 'Konten Pembelajaran ($count blok)';
  }

  @override
  String get noContentBlocksInChapter => 'Belum ada blok konten pada bab ini.';

  @override
  String get moduleInfo => 'Informasi Modul';

  @override
  String get splitChapters => 'Potong BAB';

  @override
  String pdfPagesDetected(int count) {
    return 'File PDF terdeteksi: $count halaman';
  }

  @override
  String get moduleTitleField => 'Judul Modul *';

  @override
  String get moduleTitleHint => 'Masukkan Judul Modul';

  @override
  String get moduleDescriptionField => 'Deskripsi (opsional) *';

  @override
  String get moduleDescriptionHint => 'Masukkan deskripsi modul...';

  @override
  String get fase => 'Fase';

  @override
  String get selectFase => 'Pilih Fase';

  @override
  String get loadingFases => 'Memuat fase...';

  @override
  String totalDocPages(int count) {
    return 'Total Dokumen: $count Halaman';
  }

  @override
  String get chapterSplitConfig => 'Konfigurasi Pemotongan BAB';

  @override
  String get chapterSplitDesc =>
      'Masukkan rentang halaman yang akan dipotong menjadi BAB baru.';

  @override
  String get chapterTitleField => 'Judul BAB *';

  @override
  String get startPageField => 'Halaman Awal *';

  @override
  String get endPageField => 'Halaman Akhir *';

  @override
  String get learningCompetency => 'Capaian Pembelajaran';

  @override
  String get selectCompetency => 'Pilih Capaian Pembelajaran';

  @override
  String get loadingCompetency => 'Memuat capaian pembelajaran...';

  @override
  String get processAndCreateChapter => 'Proses & Buat Chapter';

  @override
  String createdChaptersList(int count) {
    return 'Daftar BAB Berhasil Dibuat ($count):';
  }

  @override
  String pagesRange(int start, int end) {
    return 'Halaman $start - $end';
  }

  @override
  String get needsReview => 'Perlu Ditinjau';

  @override
  String get reviewed => 'Sudah Ditinjau';

  @override
  String processingProgress(int progress) {
    return 'Proses: $progress%';
  }

  @override
  String get saveModule => 'Simpan Modul';

  @override
  String get finish => 'Selesai';

  @override
  String get tapToUploadFile => 'Ketuk untuk unggah file';

  @override
  String get loadingModuleExtraction =>
      'Annoter sedang mengekstrak dan membuat anotasi\nlinear teks untuk pembaca layar';

  @override
  String get statusWait => 'Tunggu...';

  @override
  String get statusProcess => 'Proses...';

  @override
  String get evaluatingAnnotationUpdating =>
      'Annoter Sedang Memperbarui Anotasi';

  @override
  String get stopUpdatingConfirm =>
      'Hentikan pembaruan? Perubahan yang belum tersimpan mungkin akan hilang.';

  @override
  String get yes => 'Iya';

  @override
  String get no => 'Tidak';

  @override
  String get evaluationInstruction =>
      'Centang blok: Teks untuk edit langsung, atau Blok Khusus (Gambar, Tabel, Formula) untuk revisi AI.';

  @override
  String get selectAll => 'Pilih Semua';

  @override
  String get deselectAll => 'Batal Pilih';

  @override
  String get editAnnotation => 'Ubah Anotasi';

  @override
  String get editTextAnnotation => 'Edit Teks Anotasi';

  @override
  String get editTextAnnotationHeader => 'Edit Anotasi Teks';

  @override
  String reviseWithAi(int count) {
    return 'Revisi ($count) dengan AI';
  }

  @override
  String get saveToModule => 'Simpan ke Modul';

  @override
  String get directEdit => 'Edit Langsung';

  @override
  String get originalText => 'Teks Asal:';

  @override
  String get changeAnnotationText => 'Ubah Teks Anotasi';

  @override
  String get saveAnnotation => 'Simpan Anotasi';

  @override
  String get correctionAnnotation => 'Koreksi Anotasi';

  @override
  String get enterCorrectionAdvice => 'Masukkan saran perbaikan';

  @override
  String get explainAiCorrection =>
      'Jelaskan bagaimana AI harus memperbaiki anotasi ini';

  @override
  String get promptClarifyForBlind => 'Perjelas untuk tunanetra';

  @override
  String get promptSimplifyLanguage => 'Sederhanakan bahasa';

  @override
  String get promptDetailRowsCols => 'Rinci baris & kolom tabel';

  @override
  String get promptExplainFormulaSteps => 'Jelaskan langkah rumus';

  @override
  String get sendToAi => 'Kirim ke AI →';

  @override
  String get moduleImage => 'Gambar Modul';

  @override
  String get moduleTable => 'Tabel Modul';

  @override
  String get moduleFormula => 'Formula / Rumus';

  @override
  String get moduleDiagram => 'Diagram / Grafik';

  @override
  String get textBlock => 'Teks';

  @override
  String get viewExamQuestions => 'Lihat Soal';

  @override
  String get viewStudentProgress => 'Lihat Progres Murid';

  @override
  String get deleteExam => 'Hapus Soal Ujian';

  @override
  String deleteExamConfirm(String title) {
    return 'Anda yakin ingin menghapus \"$title\"?';
  }

  @override
  String get publishExam => 'Publish Soal';

  @override
  String get delete => 'Hapus';

  @override
  String get regenerateAiStimulus => 'Regenerasi Stimulus AI';

  @override
  String get aiStimulusFeedbackDesc =>
      'Berikan masukan spesifik kepada AI untuk merevisi teks stimulus soal ini:';

  @override
  String get sendAndRegenerate => 'Kirim & Regenerasi';

  @override
  String get readingStimulus => 'Stimulus Bacaan';

  @override
  String get regenerateStimulus => 'Regenerasi Stimulus';

  @override
  String get question => 'Pertanyaan';

  @override
  String get answerOptions => 'Pilihan Jawaban';

  @override
  String get justificationSteps => 'Justifikasi & Langkah Penyelesaian';

  @override
  String answerKey(String key) {
    return 'Kunci Jawaban: $key';
  }

  @override
  String get addStep => 'Tambah Langkah';

  @override
  String get conclusion => 'Kesimpulan';

  @override
  String get noExamData => 'Tidak ada data ujian';

  @override
  String get noExamReviewResultsYet =>
      'Belum ada hasil evaluasi ujian yang tersedia.';

  @override
  String get stepPickModule => 'Pilih Modul';

  @override
  String get stepConfig => 'Konfigurasi';

  @override
  String get stepReviewSave => 'Review & Simpan';

  @override
  String get selectSourceModule => 'Pilih Modul Sumber';

  @override
  String get selectSourceModuleDesc =>
      'Pilih satu modul untuk dijadikan sumber soal ujian.';

  @override
  String get noModulesAvailable => 'Belum ada modul yang tersedia.';

  @override
  String get reload => 'Muat Ulang';

  @override
  String get examTitleField => 'Judul Ujian *';

  @override
  String get examTitleHint => 'Contoh: Penilaian Harian Bab 1';

  @override
  String get examDurationField => 'Durasi Pengerjaan *';

  @override
  String get examScheduleField => 'Jadwal Pengerjaan *';

  @override
  String get startTime => 'Waktu Mulai';

  @override
  String get endTime => 'Waktu Selesai';

  @override
  String get maxAttempts => 'Maksimal Percobaan Pengerjaan';

  @override
  String get selectChaptersDistribution => 'Pilih Bab & Distribusi Soal *';

  @override
  String totalQuestionsCount(int count) {
    return 'Total: $count Soal';
  }

  @override
  String get distributionDesc =>
      'Tentukan jumlah soal HOTS (analisis tingkat tinggi) dan LOTS (pemahaman dasar) untuk masing-masing bab.';

  @override
  String get noChaptersFoundInModule =>
      'Tidak ada bab yang ditemukan dalam modul ini.';

  @override
  String get hotsQuestions => 'Soal HOTS';

  @override
  String get hotsDesc => 'Analisis, evaluasi, sintesis';

  @override
  String get lotsQuestions => 'Soal LOTS';

  @override
  String get lotsDesc => 'Pemahaman & ingatan dasar';

  @override
  String get questionsCreatedSuccess => 'Soal Berhasil Dibuat!';

  @override
  String get aiGeneratingQuestions => 'AI Sedang Membuat Soal';

  @override
  String get saveDraft => 'Simpan Draft';

  @override
  String get saveAndPublish => 'Simpan & Publish';

  @override
  String get nextStep => 'Selanjutnya';

  @override
  String get createQuestions => 'Buat Soal';

  @override
  String get welcomeTitle => 'Selamat Datang';

  @override
  String get signInToContinue => 'Masuk untuk lanjutkan';

  @override
  String get emailField => 'Email *';

  @override
  String get emailLabel => 'Email';

  @override
  String get enterEmail => 'Masukkan Email';

  @override
  String get passwordField => 'Kata Sandi *';

  @override
  String get passwordLabel => 'Kata Sandi';

  @override
  String get enterPassword => 'Masukkan Kata Sandi';

  @override
  String get confirmPasswordField => 'Konfirmasi Kata Sandi *';

  @override
  String get enterConfirmPassword => 'Masukkan Konfirmasi Kata Sandi';

  @override
  String get forgotPasswordQuestion => 'Lupa kata sandi?';

  @override
  String get signIn => 'Masuk';

  @override
  String get dontHaveAccount => 'Belum punya akun? ';

  @override
  String get register => 'Daftar';

  @override
  String get alreadyHaveAccount => 'Sudah punya akun? ';

  @override
  String get fullNameField => 'Nama Lengkap *';

  @override
  String get enterFullName => 'Masukkan Nama Lengkap';

  @override
  String get createAccount => 'Buat Akun';

  @override
  String get enterClassCode => 'Masukkan Kode Kelas';

  @override
  String get joinClassButton => 'Bergabung ke kelas';

  @override
  String get askTeacherForCode => 'Minta kode ini dari gurumu';

  @override
  String examSubtitleFormat(int questions, int minutes) {
    return '$questions soal · Durasi $minutes menit';
  }

  @override
  String examSubtitleWithRetries(int questions, int minutes, int retries) {
    return '$questions soal · Durasi $minutes menit · Maks ${retries}x percobaan';
  }

  @override
  String get enterExamTitle => 'Masukkan judul ujian';

  @override
  String get mixedDifficulty => 'Campuran';

  @override
  String get chapterEvaluationQuiz => 'Kuis Evaluasi Bab';

  @override
  String questionsGeneratedStatus(int count, String module) {
    return 'Membuat $count soal dari $module...';
  }

  @override
  String questionsCreatedCount(int current, int total) {
    return '$current / $total soal dibuat';
  }

  @override
  String questionsCreatedDone(int count) {
    return '$count soal telah selesai dibuat.';
  }

  @override
  String minuteShort(int count) {
    return '$count mnt';
  }

  @override
  String timesCount(int count) {
    return '$count Kali';
  }

  @override
  String get exampleChapterRangeHint =>
      'Contoh: Halaman 1 - 44 akan diubah menjadi BAB I.';

  @override
  String get annotationProgressNotice =>
      'Proses anotasi sedang berjalan. Tombol selesai akan aktif setelah seluruh bab selesai dan ditinjau.';

  @override
  String get reviewChaptersNotice =>
      'Silakan klik bab dengan status \"Perlu Ditinjau\" untuk memeriksa dan mengonfirmasi hasil anotasi sebelum mempublikasikan modul.';

  @override
  String get questionList => 'Daftar Soal';

  @override
  String questionItem(int number) {
    return 'Soal $number';
  }

  @override
  String questionOfTotal(int current, int total) {
    return 'Soal $current dari $total';
  }

  @override
  String get startExamButton => 'Mulai Ujian';

  @override
  String get submitExamConfirmTitle =>
      'Apakah Kamu Yakin Mengumpulkan Sekarang?';

  @override
  String get submitExamConfirmDesc =>
      'Jawaban yang sudah dikirim tidak bisa diubah.';

  @override
  String get sendButton => 'Kirim';

  @override
  String get timeUpTitle => 'Waktu Habis!';

  @override
  String get timeUpDesc =>
      'Waktu pengerjaan ujian telah habis. Jawaban Anda telah otomatis dikirimkan.';

  @override
  String get examSubmittedTitle => 'Berhasil Dikirim!';

  @override
  String get examSubmittedDesc => 'Jawaban Anda telah berhasil disimpan.';

  @override
  String examInstructionsParagraph1(int count, int duration) {
    return 'Ujian ini terdiri dari $count soal yang mencakup pilihan ganda dan isian singkat, dan kamu memiliki waktu $duration menit untuk menyelesaikannya.';
  }

  @override
  String get examInstructionsParagraph2 =>
      'Bacalah setiap soal dengan cermat, kerjakan dengan tenang, dan pastikan semua jawaban dikirim sebelum waktu habis.';

  @override
  String get examStartsAt => 'Ujian dimulai pada : ';

  @override
  String get examEndsAt => 'Ujian selesai pada : ';

  @override
  String get goodLuck => 'Selamat mengerjakan dan semoga sukses!';

  @override
  String get learningProgress => 'Progres Pembelajaran';

  @override
  String get moduleNotFound => 'Modul tidak ditemukan.';

  @override
  String completedChapterTitle(int number) {
    return 'Selamat Telah Menyelesaikan Materi $number';
  }

  @override
  String get searchPageHint => 'Cari halaman...';

  @override
  String get previous => 'Sebelumnya';

  @override
  String get next => 'Selanjutnya';

  @override
  String get correctAnswerBanner => 'Jawabanmu Benar!';

  @override
  String get unansweredBanner => 'Soal tidak terjawab';

  @override
  String get wrongAnswerBanner => 'Jawabanmu Kurang Tepat';

  @override
  String get answersLabel => 'Jawaban';

  @override
  String get justificationDiscussion => 'Justifikasi & Pembahasan';

  @override
  String get yourSolutionSteps => 'Langkah pengerjaan kamu:';

  @override
  String get improvementNotes => 'Catatan perbaikan:';

  @override
  String get discussionSteps => 'Langkah Pembahasan:';

  @override
  String get saveStep => 'Simpan Langkah';

  @override
  String get workingSteps => 'Langkah Pengerjaan';

  @override
  String get noConversationsYet => 'Belum Ada Percakapan';

  @override
  String get startNewConversation => 'Mulai Percakapan Baru';

  @override
  String get emptyConversationDesc =>
      'Mulai tanya materi matematika atau diskusikan soal dengan menekan tombol (+) di atas!';

  @override
  String get referenceSources => 'Sumber Referensi:';

  @override
  String get aiThinking => 'NovaSight AI sedang berpikir...';

  @override
  String get suggestedFollowUpQuestions =>
      'Pertanyaan Lanjutan yang Disarankan:';

  @override
  String get askQuestionHint => 'Tanya materi atau soal...';
}
