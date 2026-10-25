import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Nova'**
  String get appName;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust application settings according to your needs.'**
  String get settingsDescription;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Change application language'**
  String get languageDescription;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the language used in the application.'**
  String get selectLanguageDescription;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get indonesian;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get textSize;

  /// No description provided for @textSizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Enlarge or reduce text size'**
  String get textSizeDescription;

  /// No description provided for @textSizeAdjustDescription.
  ///
  /// In en, this message translates to:
  /// **'Adjust text size for easier reading.'**
  String get textSizeAdjustDescription;

  /// No description provided for @currentSize.
  ///
  /// In en, this message translates to:
  /// **'Current size'**
  String get currentSize;

  /// No description provided for @reduceTextSize.
  ///
  /// In en, this message translates to:
  /// **'Reduce text size'**
  String get reduceTextSize;

  /// No description provided for @enlargeTextSize.
  ///
  /// In en, this message translates to:
  /// **'Enlarge text size'**
  String get enlargeTextSize;

  /// No description provided for @textSizePercent.
  ///
  /// In en, this message translates to:
  /// **'Text size {percent} percent'**
  String textSizePercent(int percent);

  /// No description provided for @sampleTextTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get sampleTextTitle;

  /// No description provided for @sampleTextBody.
  ///
  /// In en, this message translates to:
  /// **'This is sample text to show how it looks with the current size.'**
  String get sampleTextBody;

  /// No description provided for @resetTextScale.
  ///
  /// In en, this message translates to:
  /// **'Reset text size'**
  String get resetTextScale;

  /// No description provided for @backToSettings.
  ///
  /// In en, this message translates to:
  /// **'Back to settings'**
  String get backToSettings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @schoolOrigin.
  ///
  /// In en, this message translates to:
  /// **'School Origin : '**
  String get schoolOrigin;

  /// No description provided for @gradeLevel.
  ///
  /// In en, this message translates to:
  /// **'Grade Level : '**
  String get gradeLevel;

  /// No description provided for @studentId.
  ///
  /// In en, this message translates to:
  /// **'NIS/NISN : '**
  String get studentId;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @leaveClass.
  ///
  /// In en, this message translates to:
  /// **'Leave Class'**
  String get leaveClass;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navModule.
  ///
  /// In en, this message translates to:
  /// **'Module'**
  String get navModule;

  /// No description provided for @navExam.
  ///
  /// In en, this message translates to:
  /// **'Exam Questions'**
  String get navExam;

  /// No description provided for @navClarifier.
  ///
  /// In en, this message translates to:
  /// **'Clarifier'**
  String get navClarifier;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @currentPosition.
  ///
  /// In en, this message translates to:
  /// **'Current position at'**
  String get currentPosition;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterNotDone.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get filterNotDone;

  /// No description provided for @filterDone.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterDone;

  /// No description provided for @filterNotAttempted.
  ///
  /// In en, this message translates to:
  /// **'Not Attempted'**
  String get filterNotAttempted;

  /// No description provided for @filterMaterial.
  ///
  /// In en, this message translates to:
  /// **'Materials'**
  String get filterMaterial;

  /// No description provided for @filterExam.
  ///
  /// In en, this message translates to:
  /// **'Exams'**
  String get filterExam;

  /// No description provided for @filterPublish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get filterPublish;

  /// No description provided for @filterDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get filterDraft;

  /// No description provided for @filterLabel.
  ///
  /// In en, this message translates to:
  /// **'Filter {label}'**
  String filterLabel(String label);

  /// No description provided for @learningModules.
  ///
  /// In en, this message translates to:
  /// **'Learning Modules'**
  String get learningModules;

  /// No description provided for @examQuestions.
  ///
  /// In en, this message translates to:
  /// **'Exam Questions'**
  String get examQuestions;

  /// No description provided for @examReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Evaluaizer — Exam Results Review'**
  String get examReviewTitle;

  /// No description provided for @noteAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Scriber — Work Notes'**
  String get noteAppBarTitle;

  /// No description provided for @pageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String pageOf(int current, int total);

  /// No description provided for @questionOf.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionOf(int current, int total);

  /// No description provided for @chaptersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Chapters'**
  String chaptersCount(int count);

  /// No description provided for @uploadModule.
  ///
  /// In en, this message translates to:
  /// **'+ Upload Module'**
  String get uploadModule;

  /// No description provided for @createExamQuizzer.
  ///
  /// In en, this message translates to:
  /// **'Create Exam (Quizzer)'**
  String get createExamQuizzer;

  /// No description provided for @examDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam Details'**
  String get examDetailTitle;

  /// No description provided for @studentProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Student Progress'**
  String get studentProgressTitle;

  /// No description provided for @studentProgressDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Student Progress Detail'**
  String get studentProgressDetailTitle;

  /// No description provided for @generateExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Quizzer — Create Exam'**
  String get generateExamTitle;

  /// No description provided for @splitPagesAndChapters.
  ///
  /// In en, this message translates to:
  /// **'Split Pages & Chapters'**
  String get splitPagesAndChapters;

  /// No description provided for @processingModule.
  ///
  /// In en, this message translates to:
  /// **'Processing Module'**
  String get processingModule;

  /// No description provided for @annotationResult.
  ///
  /// In en, this message translates to:
  /// **'Annotation Results'**
  String get annotationResult;

  /// No description provided for @moduleEvaluationTitle.
  ///
  /// In en, this message translates to:
  /// **'Annoter — Module Evaluation'**
  String get moduleEvaluationTitle;

  /// No description provided for @beforeAnnotation.
  ///
  /// In en, this message translates to:
  /// **'Before Annotation'**
  String get beforeAnnotation;

  /// No description provided for @afterAnnotation.
  ///
  /// In en, this message translates to:
  /// **'After Annotation'**
  String get afterAnnotation;

  /// No description provided for @clarifierSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask about module materials & concept understanding'**
  String get clarifierSubtitle;

  /// No description provided for @conversationHistory.
  ///
  /// In en, this message translates to:
  /// **'Conversation History'**
  String get conversationHistory;

  /// No description provided for @refreshHistory.
  ///
  /// In en, this message translates to:
  /// **'Refresh history'**
  String get refreshHistory;

  /// No description provided for @loadingTableOfContents.
  ///
  /// In en, this message translates to:
  /// **'Loading Table of Contents...'**
  String get loadingTableOfContents;

  /// No description provided for @learningMaterials.
  ///
  /// In en, this message translates to:
  /// **'Learning Materials'**
  String get learningMaterials;

  /// No description provided for @tableOfContents.
  ///
  /// In en, this message translates to:
  /// **'Table of Contents'**
  String get tableOfContents;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An Error Occurred'**
  String get errorOccurred;

  /// No description provided for @beforeStartingExam.
  ///
  /// In en, this message translates to:
  /// **'Before Starting the Exam'**
  String get beforeStartingExam;

  /// No description provided for @welcomeStudentGreeting.
  ///
  /// In en, this message translates to:
  /// **'Happy learning 👋'**
  String get welcomeStudentGreeting;

  /// No description provided for @student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get student;

  /// No description provided for @loadingClassData.
  ///
  /// In en, this message translates to:
  /// **'Loading class data...'**
  String get loadingClassData;

  /// No description provided for @uncompletedModules.
  ///
  /// In en, this message translates to:
  /// **'Incomplete Modules'**
  String get uncompletedModules;

  /// No description provided for @uncompletedExams.
  ///
  /// In en, this message translates to:
  /// **'Incomplete Exams'**
  String get uncompletedExams;

  /// No description provided for @materialsAndExams.
  ///
  /// In en, this message translates to:
  /// **'Materials and Exams'**
  String get materialsAndExams;

  /// No description provided for @emptyCategoryTasks.
  ///
  /// In en, this message translates to:
  /// **'No materials or exams in this category.'**
  String get emptyCategoryTasks;

  /// No description provided for @material.
  ///
  /// In en, this message translates to:
  /// **'Material'**
  String get material;

  /// No description provided for @exam.
  ///
  /// In en, this message translates to:
  /// **'Exam'**
  String get exam;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @questions.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get questions;

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatus;

  /// No description provided for @notAttemptedStatus.
  ///
  /// In en, this message translates to:
  /// **'Not attempted'**
  String get notAttemptedStatus;

  /// No description provided for @durationAndQuestions.
  ///
  /// In en, this message translates to:
  /// **'{minutes} Minutes • {questions} Questions'**
  String durationAndQuestions(int minutes, int questions);

  /// No description provided for @startTask.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startTask;

  /// No description provided for @examResultEvaluaizer.
  ///
  /// In en, this message translates to:
  /// **'Evaluaizer (Exam Result)'**
  String get examResultEvaluaizer;

  /// No description provided for @percentCompleted.
  ///
  /// In en, this message translates to:
  /// **'{percent}% Completed'**
  String percentCompleted(int percent);

  /// No description provided for @noModulesInCategory.
  ///
  /// In en, this message translates to:
  /// **'No modules in this category.'**
  String get noModulesInCategory;

  /// No description provided for @noExamsInCategory.
  ///
  /// In en, this message translates to:
  /// **'No exams in this category.'**
  String get noExamsInCategory;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @teacher.
  ///
  /// In en, this message translates to:
  /// **'Teacher'**
  String get teacher;

  /// No description provided for @teacherDashboard.
  ///
  /// In en, this message translates to:
  /// **'Teacher Dashboard'**
  String get teacherDashboard;

  /// No description provided for @totalModules.
  ///
  /// In en, this message translates to:
  /// **'Total Modules'**
  String get totalModules;

  /// No description provided for @totalStudents.
  ///
  /// In en, this message translates to:
  /// **'Total Students'**
  String get totalStudents;

  /// No description provided for @classCode.
  ///
  /// In en, this message translates to:
  /// **'Class Code'**
  String get classCode;

  /// No description provided for @shareCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Share with students to join'**
  String get shareCodeDescription;

  /// No description provided for @copyClassCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Class Code'**
  String get copyClassCode;

  /// No description provided for @noClassYet.
  ///
  /// In en, this message translates to:
  /// **'No Class Yet'**
  String get noClassYet;

  /// No description provided for @newestModules.
  ///
  /// In en, this message translates to:
  /// **'Recent Modules'**
  String get newestModules;

  /// No description provided for @newestExams.
  ///
  /// In en, this message translates to:
  /// **'Recent Exams'**
  String get newestExams;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @noModulesCreated.
  ///
  /// In en, this message translates to:
  /// **'No modules created yet.'**
  String get noModulesCreated;

  /// No description provided for @noRecentExams.
  ///
  /// In en, this message translates to:
  /// **'No recent exams.'**
  String get noRecentExams;

  /// No description provided for @noModulesForClass.
  ///
  /// In en, this message translates to:
  /// **'No modules for this class yet'**
  String get noModulesForClass;

  /// No description provided for @noExamsForClass.
  ///
  /// In en, this message translates to:
  /// **'No exams for this class yet'**
  String get noExamsForClass;

  /// No description provided for @searchModuleHint.
  ///
  /// In en, this message translates to:
  /// **'Search module...'**
  String get searchModuleHint;

  /// No description provided for @searchModuleLabel.
  ///
  /// In en, this message translates to:
  /// **'Search module by title'**
  String get searchModuleLabel;

  /// No description provided for @inclusiveMathApp.
  ///
  /// In en, this message translates to:
  /// **'Inclusive Mathematics App'**
  String get inclusiveMathApp;

  /// No description provided for @joinClass.
  ///
  /// In en, this message translates to:
  /// **'Join Class'**
  String get joinClass;

  /// No description provided for @enterClassCodeFromTeacher.
  ///
  /// In en, this message translates to:
  /// **'Enter class code from your teacher'**
  String get enterClassCodeFromTeacher;

  /// No description provided for @createClass.
  ///
  /// In en, this message translates to:
  /// **'Create Your Class'**
  String get createClass;

  /// No description provided for @classCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Class Successfully Created!'**
  String get classCreatedSuccess;

  /// No description provided for @shareCodeWithStudents.
  ///
  /// In en, this message translates to:
  /// **'Share the code below with your students'**
  String get shareCodeWithStudents;

  /// No description provided for @joinedClassSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have joined the class'**
  String get joinedClassSuccess;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPassword;

  /// No description provided for @registerAccount.
  ///
  /// In en, this message translates to:
  /// **'Register Account'**
  String get registerAccount;

  /// No description provided for @startInclusiveLearning.
  ///
  /// In en, this message translates to:
  /// **'Start your inclusive learning journey'**
  String get startInclusiveLearning;

  /// No description provided for @viewModule.
  ///
  /// In en, this message translates to:
  /// **'View Module'**
  String get viewModule;

  /// No description provided for @publishModule.
  ///
  /// In en, this message translates to:
  /// **'Publish Module'**
  String get publishModule;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @deleteModule.
  ///
  /// In en, this message translates to:
  /// **'Delete Module'**
  String get deleteModule;

  /// No description provided for @deleteModuleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"? All chapters and annotations inside will be permanently deleted.'**
  String deleteModuleConfirm(String title);

  /// No description provided for @moduleDetail.
  ///
  /// In en, this message translates to:
  /// **'Module Detail'**
  String get moduleDetail;

  /// No description provided for @chapterDetail.
  ///
  /// In en, this message translates to:
  /// **'Chapter Detail'**
  String get chapterDetail;

  /// No description provided for @chapterList.
  ///
  /// In en, this message translates to:
  /// **'Chapter / Material List'**
  String get chapterList;

  /// No description provided for @noChaptersInModule.
  ///
  /// In en, this message translates to:
  /// **'No chapters or materials have been added to this module yet.'**
  String get noChaptersInModule;

  /// No description provided for @chapter.
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get chapter;

  /// No description provided for @chapterNumber.
  ///
  /// In en, this message translates to:
  /// **'Chapter {number}'**
  String chapterNumber(String number);

  /// No description provided for @learningContentBlocks.
  ///
  /// In en, this message translates to:
  /// **'Learning Content ({count} blocks)'**
  String learningContentBlocks(int count);

  /// No description provided for @noContentBlocksInChapter.
  ///
  /// In en, this message translates to:
  /// **'No content blocks in this chapter yet.'**
  String get noContentBlocksInChapter;

  /// No description provided for @moduleInfo.
  ///
  /// In en, this message translates to:
  /// **'Module Information'**
  String get moduleInfo;

  /// No description provided for @splitChapters.
  ///
  /// In en, this message translates to:
  /// **'Split Chapters'**
  String get splitChapters;

  /// No description provided for @pdfPagesDetected.
  ///
  /// In en, this message translates to:
  /// **'PDF file detected: {count} pages'**
  String pdfPagesDetected(int count);

  /// No description provided for @moduleTitleField.
  ///
  /// In en, this message translates to:
  /// **'Module Title *'**
  String get moduleTitleField;

  /// No description provided for @moduleTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter Module Title'**
  String get moduleTitleHint;

  /// No description provided for @moduleDescriptionField.
  ///
  /// In en, this message translates to:
  /// **'Description (optional) *'**
  String get moduleDescriptionField;

  /// No description provided for @moduleDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter module description...'**
  String get moduleDescriptionHint;

  /// No description provided for @fase.
  ///
  /// In en, this message translates to:
  /// **'Phase'**
  String get fase;

  /// No description provided for @selectFase.
  ///
  /// In en, this message translates to:
  /// **'Select Phase'**
  String get selectFase;

  /// No description provided for @loadingFases.
  ///
  /// In en, this message translates to:
  /// **'Loading phases...'**
  String get loadingFases;

  /// No description provided for @totalDocPages.
  ///
  /// In en, this message translates to:
  /// **'Total Document: {count} Pages'**
  String totalDocPages(int count);

  /// No description provided for @chapterSplitConfig.
  ///
  /// In en, this message translates to:
  /// **'Chapter Split Configuration'**
  String get chapterSplitConfig;

  /// No description provided for @chapterSplitDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter page ranges to split into a new Chapter.'**
  String get chapterSplitDesc;

  /// No description provided for @chapterTitleField.
  ///
  /// In en, this message translates to:
  /// **'Chapter Title *'**
  String get chapterTitleField;

  /// No description provided for @startPageField.
  ///
  /// In en, this message translates to:
  /// **'Start Page *'**
  String get startPageField;

  /// No description provided for @endPageField.
  ///
  /// In en, this message translates to:
  /// **'End Page *'**
  String get endPageField;

  /// No description provided for @learningCompetency.
  ///
  /// In en, this message translates to:
  /// **'Learning Objectives'**
  String get learningCompetency;

  /// No description provided for @selectCompetency.
  ///
  /// In en, this message translates to:
  /// **'Select Learning Objectives'**
  String get selectCompetency;

  /// No description provided for @loadingCompetency.
  ///
  /// In en, this message translates to:
  /// **'Loading learning objectives...'**
  String get loadingCompetency;

  /// No description provided for @processAndCreateChapter.
  ///
  /// In en, this message translates to:
  /// **'Process & Create Chapter'**
  String get processAndCreateChapter;

  /// No description provided for @createdChaptersList.
  ///
  /// In en, this message translates to:
  /// **'Created Chapters List ({count}):'**
  String createdChaptersList(int count);

  /// No description provided for @pagesRange.
  ///
  /// In en, this message translates to:
  /// **'Page {start} - {end}'**
  String pagesRange(int start, int end);

  /// No description provided for @needsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs Review'**
  String get needsReview;

  /// No description provided for @reviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get reviewed;

  /// No description provided for @processingProgress.
  ///
  /// In en, this message translates to:
  /// **'Processing: {progress}%'**
  String processingProgress(int progress);

  /// No description provided for @saveModule.
  ///
  /// In en, this message translates to:
  /// **'Save Module'**
  String get saveModule;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @tapToUploadFile.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload file'**
  String get tapToUploadFile;

  /// No description provided for @loadingModuleExtraction.
  ///
  /// In en, this message translates to:
  /// **'Annoter is extracting and creating linear text annotations for screen readers'**
  String get loadingModuleExtraction;

  /// No description provided for @statusWait.
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get statusWait;

  /// No description provided for @statusProcess.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get statusProcess;

  /// No description provided for @evaluatingAnnotationUpdating.
  ///
  /// In en, this message translates to:
  /// **'Annoter is Updating Annotations'**
  String get evaluatingAnnotationUpdating;

  /// No description provided for @stopUpdatingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Stop update? Unsaved changes may be lost.'**
  String get stopUpdatingConfirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @evaluationInstruction.
  ///
  /// In en, this message translates to:
  /// **'Select blocks: Text for direct edit, or Special Blocks (Image, Table, Formula) for AI revision.'**
  String get evaluationInstruction;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect'**
  String get deselectAll;

  /// No description provided for @editAnnotation.
  ///
  /// In en, this message translates to:
  /// **'Edit Annotation'**
  String get editAnnotation;

  /// No description provided for @editTextAnnotation.
  ///
  /// In en, this message translates to:
  /// **'Edit Text Annotation'**
  String get editTextAnnotation;

  /// No description provided for @editTextAnnotationHeader.
  ///
  /// In en, this message translates to:
  /// **'Edit Text Annotation'**
  String get editTextAnnotationHeader;

  /// No description provided for @reviseWithAi.
  ///
  /// In en, this message translates to:
  /// **'Revise ({count}) with AI'**
  String reviseWithAi(int count);

  /// No description provided for @saveToModule.
  ///
  /// In en, this message translates to:
  /// **'Save to Module'**
  String get saveToModule;

  /// No description provided for @directEdit.
  ///
  /// In en, this message translates to:
  /// **'Direct Edit'**
  String get directEdit;

  /// No description provided for @originalText.
  ///
  /// In en, this message translates to:
  /// **'Original Text:'**
  String get originalText;

  /// No description provided for @changeAnnotationText.
  ///
  /// In en, this message translates to:
  /// **'Change Annotation Text'**
  String get changeAnnotationText;

  /// No description provided for @saveAnnotation.
  ///
  /// In en, this message translates to:
  /// **'Save Annotation'**
  String get saveAnnotation;

  /// No description provided for @correctionAnnotation.
  ///
  /// In en, this message translates to:
  /// **'Annotation Correction'**
  String get correctionAnnotation;

  /// No description provided for @enterCorrectionAdvice.
  ///
  /// In en, this message translates to:
  /// **'Enter improvement suggestions'**
  String get enterCorrectionAdvice;

  /// No description provided for @explainAiCorrection.
  ///
  /// In en, this message translates to:
  /// **'Explain how AI should improve this annotation'**
  String get explainAiCorrection;

  /// No description provided for @promptClarifyForBlind.
  ///
  /// In en, this message translates to:
  /// **'Clarify for screen reader'**
  String get promptClarifyForBlind;

  /// No description provided for @promptSimplifyLanguage.
  ///
  /// In en, this message translates to:
  /// **'Simplify language'**
  String get promptSimplifyLanguage;

  /// No description provided for @promptDetailRowsCols.
  ///
  /// In en, this message translates to:
  /// **'Detail rows & columns of table'**
  String get promptDetailRowsCols;

  /// No description provided for @promptExplainFormulaSteps.
  ///
  /// In en, this message translates to:
  /// **'Explain formula steps'**
  String get promptExplainFormulaSteps;

  /// No description provided for @sendToAi.
  ///
  /// In en, this message translates to:
  /// **'Send to AI →'**
  String get sendToAi;

  /// No description provided for @moduleImage.
  ///
  /// In en, this message translates to:
  /// **'Module Image'**
  String get moduleImage;

  /// No description provided for @moduleTable.
  ///
  /// In en, this message translates to:
  /// **'Module Table'**
  String get moduleTable;

  /// No description provided for @moduleFormula.
  ///
  /// In en, this message translates to:
  /// **'Formula / Math'**
  String get moduleFormula;

  /// No description provided for @moduleDiagram.
  ///
  /// In en, this message translates to:
  /// **'Diagram / Graph'**
  String get moduleDiagram;

  /// No description provided for @textBlock.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get textBlock;

  /// No description provided for @viewExamQuestions.
  ///
  /// In en, this message translates to:
  /// **'View Questions'**
  String get viewExamQuestions;

  /// No description provided for @viewStudentProgress.
  ///
  /// In en, this message translates to:
  /// **'View Student Progress'**
  String get viewStudentProgress;

  /// No description provided for @deleteExam.
  ///
  /// In en, this message translates to:
  /// **'Delete Exam Questions'**
  String get deleteExam;

  /// No description provided for @deleteExamConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{title}\"?'**
  String deleteExamConfirm(String title);

  /// No description provided for @publishExam.
  ///
  /// In en, this message translates to:
  /// **'Publish Exam'**
  String get publishExam;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @regenerateAiStimulus.
  ///
  /// In en, this message translates to:
  /// **'Regenerate AI Stimulus'**
  String get regenerateAiStimulus;

  /// No description provided for @aiStimulusFeedbackDesc.
  ///
  /// In en, this message translates to:
  /// **'Provide specific feedback to AI to revise this question\'s reading stimulus:'**
  String get aiStimulusFeedbackDesc;

  /// No description provided for @sendAndRegenerate.
  ///
  /// In en, this message translates to:
  /// **'Send & Regenerate'**
  String get sendAndRegenerate;

  /// No description provided for @readingStimulus.
  ///
  /// In en, this message translates to:
  /// **'Reading Stimulus'**
  String get readingStimulus;

  /// No description provided for @regenerateStimulus.
  ///
  /// In en, this message translates to:
  /// **'Regenerate Stimulus'**
  String get regenerateStimulus;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @answerOptions.
  ///
  /// In en, this message translates to:
  /// **'Answer Options'**
  String get answerOptions;

  /// No description provided for @justificationSteps.
  ///
  /// In en, this message translates to:
  /// **'Justification & Solution Steps'**
  String get justificationSteps;

  /// No description provided for @answerKey.
  ///
  /// In en, this message translates to:
  /// **'Answer Key: {key}'**
  String answerKey(String key);

  /// No description provided for @addStep.
  ///
  /// In en, this message translates to:
  /// **'Add Step'**
  String get addStep;

  /// No description provided for @conclusion.
  ///
  /// In en, this message translates to:
  /// **'Conclusion'**
  String get conclusion;

  /// No description provided for @noExamData.
  ///
  /// In en, this message translates to:
  /// **'No exam data'**
  String get noExamData;

  /// No description provided for @noExamReviewResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No exam evaluation results available yet.'**
  String get noExamReviewResultsYet;

  /// No description provided for @stepPickModule.
  ///
  /// In en, this message translates to:
  /// **'Select Module'**
  String get stepPickModule;

  /// No description provided for @stepConfig.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get stepConfig;

  /// No description provided for @stepReviewSave.
  ///
  /// In en, this message translates to:
  /// **'Review & Save'**
  String get stepReviewSave;

  /// No description provided for @selectSourceModule.
  ///
  /// In en, this message translates to:
  /// **'Select Source Module'**
  String get selectSourceModule;

  /// No description provided for @selectSourceModuleDesc.
  ///
  /// In en, this message translates to:
  /// **'Select one module to be the source for exam questions.'**
  String get selectSourceModuleDesc;

  /// No description provided for @noModulesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No modules available yet.'**
  String get noModulesAvailable;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @examTitleField.
  ///
  /// In en, this message translates to:
  /// **'Exam Title *'**
  String get examTitleField;

  /// No description provided for @examTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Chapter 1 Daily Assessment'**
  String get examTitleHint;

  /// No description provided for @examDurationField.
  ///
  /// In en, this message translates to:
  /// **'Duration *'**
  String get examDurationField;

  /// No description provided for @examScheduleField.
  ///
  /// In en, this message translates to:
  /// **'Schedule *'**
  String get examScheduleField;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @maxAttempts.
  ///
  /// In en, this message translates to:
  /// **'Max Attempts'**
  String get maxAttempts;

  /// No description provided for @selectChaptersDistribution.
  ///
  /// In en, this message translates to:
  /// **'Select Chapters & Question Distribution *'**
  String get selectChaptersDistribution;

  /// No description provided for @totalQuestionsCount.
  ///
  /// In en, this message translates to:
  /// **'Total: {count} Questions'**
  String totalQuestionsCount(int count);

  /// No description provided for @distributionDesc.
  ///
  /// In en, this message translates to:
  /// **'Determine the number of HOTS (higher order thinking) and LOTS (basic understanding) questions for each chapter.'**
  String get distributionDesc;

  /// No description provided for @noChaptersFoundInModule.
  ///
  /// In en, this message translates to:
  /// **'No chapters found in this module.'**
  String get noChaptersFoundInModule;

  /// No description provided for @hotsQuestions.
  ///
  /// In en, this message translates to:
  /// **'HOTS Questions'**
  String get hotsQuestions;

  /// No description provided for @hotsDesc.
  ///
  /// In en, this message translates to:
  /// **'Analysis, evaluation, synthesis'**
  String get hotsDesc;

  /// No description provided for @lotsQuestions.
  ///
  /// In en, this message translates to:
  /// **'LOTS Questions'**
  String get lotsQuestions;

  /// No description provided for @lotsDesc.
  ///
  /// In en, this message translates to:
  /// **'Basic understanding & recall'**
  String get lotsDesc;

  /// No description provided for @questionsCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Questions Successfully Created!'**
  String get questionsCreatedSuccess;

  /// No description provided for @aiGeneratingQuestions.
  ///
  /// In en, this message translates to:
  /// **'AI is Generating Questions'**
  String get aiGeneratingQuestions;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @saveAndPublish.
  ///
  /// In en, this message translates to:
  /// **'Save & Publish'**
  String get saveAndPublish;

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextStep;

  /// No description provided for @createQuestions.
  ///
  /// In en, this message translates to:
  /// **'Create Questions'**
  String get createQuestions;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeTitle;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @emailField.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailField;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @passwordField.
  ///
  /// In en, this message translates to:
  /// **'Password *'**
  String get passwordField;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @confirmPasswordField.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password *'**
  String get confirmPasswordField;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Confirm Password'**
  String get enterConfirmPassword;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @fullNameField.
  ///
  /// In en, this message translates to:
  /// **'Full Name *'**
  String get fullNameField;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Full Name'**
  String get enterFullName;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @enterClassCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Class Code'**
  String get enterClassCode;

  /// No description provided for @joinClassButton.
  ///
  /// In en, this message translates to:
  /// **'Join class'**
  String get joinClassButton;

  /// No description provided for @askTeacherForCode.
  ///
  /// In en, this message translates to:
  /// **'Ask for this code from your teacher'**
  String get askTeacherForCode;

  /// No description provided for @examSubtitleFormat.
  ///
  /// In en, this message translates to:
  /// **'{questions} questions · Duration {minutes} minutes'**
  String examSubtitleFormat(int questions, int minutes);

  /// No description provided for @examSubtitleWithRetries.
  ///
  /// In en, this message translates to:
  /// **'{questions} questions · Duration {minutes} minutes · Max {retries}x attempts'**
  String examSubtitleWithRetries(int questions, int minutes, int retries);

  /// No description provided for @enterExamTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter exam title'**
  String get enterExamTitle;

  /// No description provided for @mixedDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get mixedDifficulty;

  /// No description provided for @chapterEvaluationQuiz.
  ///
  /// In en, this message translates to:
  /// **'Chapter Evaluation Quiz'**
  String get chapterEvaluationQuiz;

  /// No description provided for @questionsGeneratedStatus.
  ///
  /// In en, this message translates to:
  /// **'Generating {count} questions from {module}...'**
  String questionsGeneratedStatus(int count, String module);

  /// No description provided for @questionsCreatedCount.
  ///
  /// In en, this message translates to:
  /// **'{current} / {total} questions created'**
  String questionsCreatedCount(int current, int total);

  /// No description provided for @questionsCreatedDone.
  ///
  /// In en, this message translates to:
  /// **'{count} questions created successfully.'**
  String questionsCreatedDone(int count);

  /// No description provided for @minuteShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minuteShort(int count);

  /// No description provided for @timesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Times'**
  String timesCount(int count);

  /// No description provided for @exampleChapterRangeHint.
  ///
  /// In en, this message translates to:
  /// **'Example: Pages 1 - 44 will be converted to Chapter I.'**
  String get exampleChapterRangeHint;

  /// No description provided for @annotationProgressNotice.
  ///
  /// In en, this message translates to:
  /// **'Annotation process is running. The finish button will activate after all chapters are completed and reviewed.'**
  String get annotationProgressNotice;

  /// No description provided for @reviewChaptersNotice.
  ///
  /// In en, this message translates to:
  /// **'Please click chapters with \"Needs Review\" status to check and confirm annotation results before publishing.'**
  String get reviewChaptersNotice;

  /// No description provided for @questionList.
  ///
  /// In en, this message translates to:
  /// **'Question List'**
  String get questionList;

  /// No description provided for @questionItem.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String questionItem(int number);

  /// No description provided for @questionOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Question {current} of {total}'**
  String questionOfTotal(int current, int total);

  /// No description provided for @startExamButton.
  ///
  /// In en, this message translates to:
  /// **'Start Exam'**
  String get startExamButton;

  /// No description provided for @submitExamConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to submit now?'**
  String get submitExamConfirmTitle;

  /// No description provided for @submitExamConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'Submitted answers cannot be changed.'**
  String get submitExamConfirmDesc;

  /// No description provided for @sendButton.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get sendButton;

  /// No description provided for @timeUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Time is Up!'**
  String get timeUpTitle;

  /// No description provided for @timeUpDesc.
  ///
  /// In en, this message translates to:
  /// **'Exam time has run out. Your answers have been automatically submitted.'**
  String get timeUpDesc;

  /// No description provided for @examSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Successfully Submitted!'**
  String get examSubmittedTitle;

  /// No description provided for @examSubmittedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your answers have been successfully saved.'**
  String get examSubmittedDesc;

  /// No description provided for @examInstructionsParagraph1.
  ///
  /// In en, this message translates to:
  /// **'This exam consists of {count} questions including multiple choice and short answers, and you have {duration} minutes to complete it.'**
  String examInstructionsParagraph1(int count, int duration);

  /// No description provided for @examInstructionsParagraph2.
  ///
  /// In en, this message translates to:
  /// **'Read each question carefully, work calmly, and ensure all answers are submitted before time runs out.'**
  String get examInstructionsParagraph2;

  /// No description provided for @examStartsAt.
  ///
  /// In en, this message translates to:
  /// **'Exam starts at : '**
  String get examStartsAt;

  /// No description provided for @examEndsAt.
  ///
  /// In en, this message translates to:
  /// **'Exam ends at : '**
  String get examEndsAt;

  /// No description provided for @goodLuck.
  ///
  /// In en, this message translates to:
  /// **'Good luck and all the best!'**
  String get goodLuck;

  /// No description provided for @learningProgress.
  ///
  /// In en, this message translates to:
  /// **'Learning Progress'**
  String get learningProgress;

  /// No description provided for @moduleNotFound.
  ///
  /// In en, this message translates to:
  /// **'Module not found.'**
  String get moduleNotFound;

  /// No description provided for @completedChapterTitle.
  ///
  /// In en, this message translates to:
  /// **'Congratulations on completing Chapter {number}'**
  String completedChapterTitle(int number);

  /// No description provided for @searchPageHint.
  ///
  /// In en, this message translates to:
  /// **'Search page...'**
  String get searchPageHint;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @correctAnswerBanner.
  ///
  /// In en, this message translates to:
  /// **'Your Answer is Correct!'**
  String get correctAnswerBanner;

  /// No description provided for @unansweredBanner.
  ///
  /// In en, this message translates to:
  /// **'Question not answered'**
  String get unansweredBanner;

  /// No description provided for @wrongAnswerBanner.
  ///
  /// In en, this message translates to:
  /// **'Your Answer is Incorrect'**
  String get wrongAnswerBanner;

  /// No description provided for @answersLabel.
  ///
  /// In en, this message translates to:
  /// **'Answers'**
  String get answersLabel;

  /// No description provided for @justificationDiscussion.
  ///
  /// In en, this message translates to:
  /// **'Justification & Discussion'**
  String get justificationDiscussion;

  /// No description provided for @yourSolutionSteps.
  ///
  /// In en, this message translates to:
  /// **'Your solution steps:'**
  String get yourSolutionSteps;

  /// No description provided for @improvementNotes.
  ///
  /// In en, this message translates to:
  /// **'Improvement notes:'**
  String get improvementNotes;

  /// No description provided for @discussionSteps.
  ///
  /// In en, this message translates to:
  /// **'Discussion Steps:'**
  String get discussionSteps;

  /// No description provided for @saveStep.
  ///
  /// In en, this message translates to:
  /// **'Save Step'**
  String get saveStep;

  /// No description provided for @workingSteps.
  ///
  /// In en, this message translates to:
  /// **'Working Steps'**
  String get workingSteps;

  /// No description provided for @noConversationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Conversations Yet'**
  String get noConversationsYet;

  /// No description provided for @startNewConversation.
  ///
  /// In en, this message translates to:
  /// **'Start New Conversation'**
  String get startNewConversation;

  /// No description provided for @emptyConversationDesc.
  ///
  /// In en, this message translates to:
  /// **'Start asking math topics or discussing questions by tapping the (+) button above!'**
  String get emptyConversationDesc;

  /// No description provided for @referenceSources.
  ///
  /// In en, this message translates to:
  /// **'Reference Sources:'**
  String get referenceSources;

  /// No description provided for @aiThinking.
  ///
  /// In en, this message translates to:
  /// **'NovaSight AI is thinking...'**
  String get aiThinking;

  /// No description provided for @suggestedFollowUpQuestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested Follow-up Questions:'**
  String get suggestedFollowUpQuestions;

  /// No description provided for @askQuestionHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about materials or questions...'**
  String get askQuestionHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
