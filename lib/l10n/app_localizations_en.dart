// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Nova';

  @override
  String get close => 'Close';

  @override
  String get back => 'Back';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get success => 'Success';

  @override
  String get failed => 'Failed';

  @override
  String get loading => 'Loading...';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get settings => 'Settings';

  @override
  String get settingsDescription =>
      'Adjust application settings according to your needs.';

  @override
  String get language => 'Language';

  @override
  String get languageDescription => 'Change application language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectLanguageDescription =>
      'Select the language used in the application.';

  @override
  String get indonesian => 'Bahasa Indonesia';

  @override
  String get english => 'English';

  @override
  String get textSize => 'Text size';

  @override
  String get textSizeDescription => 'Enlarge or reduce text size';

  @override
  String get textSizeAdjustDescription =>
      'Adjust text size for easier reading.';

  @override
  String get currentSize => 'Current size';

  @override
  String get reduceTextSize => 'Reduce text size';

  @override
  String get enlargeTextSize => 'Enlarge text size';

  @override
  String textSizePercent(int percent) {
    return 'Text size $percent percent';
  }

  @override
  String get sampleTextTitle => 'Preview';

  @override
  String get sampleTextBody =>
      'This is sample text to show how it looks with the current size.';

  @override
  String get resetTextScale => 'Reset text size';

  @override
  String get backToSettings => 'Back to settings';

  @override
  String get profile => 'Profile';

  @override
  String get schoolOrigin => 'School Origin : ';

  @override
  String get gradeLevel => 'Grade Level : ';

  @override
  String get studentId => 'NIS/NISN : ';

  @override
  String get logout => 'Log Out';

  @override
  String get leaveClass => 'Leave Class';

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navModule => 'Module';

  @override
  String get navExam => 'Exam Questions';

  @override
  String get navClarifier => 'Clarifier';

  @override
  String get navProfile => 'Profile';

  @override
  String get currentPosition => 'Current position at';

  @override
  String get filterAll => 'All';

  @override
  String get filterNotDone => 'Incomplete';

  @override
  String get filterDone => 'Completed';

  @override
  String get filterNotAttempted => 'Not Attempted';

  @override
  String get filterMaterial => 'Materials';

  @override
  String get filterExam => 'Exams';

  @override
  String get filterPublish => 'Publish';

  @override
  String get filterDraft => 'Draft';

  @override
  String filterLabel(String label) {
    return 'Filter $label';
  }

  @override
  String get learningModules => 'Learning Modules';

  @override
  String get examQuestions => 'Exam Questions';

  @override
  String get examReviewTitle => 'Evaluaizer — Exam Results Review';

  @override
  String get noteAppBarTitle => 'Scriber — Work Notes';

  @override
  String pageOf(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String questionOf(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String chaptersCount(int count) {
    return '$count Chapters';
  }

  @override
  String get uploadModule => '+ Upload Module';

  @override
  String get createExamQuizzer => 'Create Exam (Quizzer)';

  @override
  String get examDetailTitle => 'Exam Details';

  @override
  String get studentProgressTitle => 'Student Progress';

  @override
  String get studentProgressDetailTitle => 'Student Progress Detail';

  @override
  String get generateExamTitle => 'Quizzer — Create Exam';

  @override
  String get splitPagesAndChapters => 'Split Pages & Chapters';

  @override
  String get processingModule => 'Processing Module';

  @override
  String get annotationResult => 'Annotation Results';

  @override
  String get moduleEvaluationTitle => 'Annoter — Module Evaluation';

  @override
  String get beforeAnnotation => 'Before Annotation';

  @override
  String get afterAnnotation => 'After Annotation';

  @override
  String get clarifierSubtitle =>
      'Ask about module materials & concept understanding';

  @override
  String get conversationHistory => 'Conversation History';

  @override
  String get refreshHistory => 'Refresh history';

  @override
  String get loadingTableOfContents => 'Loading Table of Contents...';

  @override
  String get learningMaterials => 'Learning Materials';

  @override
  String get tableOfContents => 'Table of Contents';

  @override
  String get errorOccurred => 'An Error Occurred';

  @override
  String get beforeStartingExam => 'Before Starting the Exam';

  @override
  String get welcomeStudentGreeting => 'Happy learning 👋';

  @override
  String get student => 'Student';

  @override
  String get loadingClassData => 'Loading class data...';

  @override
  String get uncompletedModules => 'Incomplete Modules';

  @override
  String get uncompletedExams => 'Incomplete Exams';

  @override
  String get materialsAndExams => 'Materials and Exams';

  @override
  String get emptyCategoryTasks => 'No materials or exams in this category.';

  @override
  String get material => 'Material';

  @override
  String get exam => 'Exam';

  @override
  String get score => 'Score';

  @override
  String get minutes => 'Minutes';

  @override
  String get questions => 'Questions';

  @override
  String get completedStatus => 'Completed';

  @override
  String get notAttemptedStatus => 'Not attempted';

  @override
  String durationAndQuestions(int minutes, int questions) {
    return '$minutes Minutes • $questions Questions';
  }

  @override
  String get startTask => 'Start';

  @override
  String get examResultEvaluaizer => 'Evaluaizer (Exam Result)';

  @override
  String percentCompleted(int percent) {
    return '$percent% Completed';
  }

  @override
  String get selectToRevisionAI => 'Select for AI Revision';

  @override
  String get selectToRevisionText => 'Select for Manual Edit';

  @override
  String get noModulesInCategory => 'No modules in this category.';

  @override
  String get noExamsInCategory => 'No exams in this category.';

  @override
  String get evaluate => 'Re-evaluate';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get teacher => 'Teacher';

  @override
  String get teacherDashboard => 'Teacher Dashboard';

  @override
  String get totalModules => 'Total Modules';

  @override
  String get totalStudents => 'Total Students';

  @override
  String get classCode => 'Class Code';

  @override
  String get shareCodeDescription => 'Share with students to join';

  @override
  String get copyClassCode => 'Copy Class Code';

  @override
  String get noClassYet => 'No Class Yet';

  @override
  String get newestModules => 'Recent Modules';

  @override
  String get newestExams => 'Recent Exams';

  @override
  String get seeAll => 'See all';

  @override
  String get noModulesCreated => 'No modules created yet.';

  @override
  String get noRecentExams => 'No recent exams.';

  @override
  String get noModulesForClass => 'No modules for this class yet';

  @override
  String get noExamsForClass => 'No exams for this class yet';

  @override
  String get searchModuleHint => 'Search module...';

  @override
  String get searchModuleLabel => 'Search module by title';

  @override
  String get inclusiveMathApp => 'Inclusive Mathematics App';

  @override
  String get joinClass => 'Join Class';

  @override
  String get enterClassCodeFromTeacher => 'Enter class code from your teacher';

  @override
  String get createClass => 'Create Your Class';

  @override
  String get classCreatedSuccess => 'Class Successfully Created!';

  @override
  String get shareCodeWithStudents => 'Share the code below with your students';

  @override
  String get joinedClassSuccess => 'You have joined the class';

  @override
  String get forgotPassword => 'Forgot Password';

  @override
  String get registerAccount => 'Register Account';

  @override
  String get startInclusiveLearning => 'Start your inclusive learning journey';

  @override
  String get viewModule => 'View Module';

  @override
  String get publishModule => 'Publish Module';

  @override
  String get published => 'Published';

  @override
  String get deleteModule => 'Delete Module';

  @override
  String deleteModuleConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"? All chapters and annotations inside will be permanently deleted.';
  }

  @override
  String get moduleDetail => 'Module Detail';

  @override
  String get chapterDetail => 'Chapter Detail';

  @override
  String get chapterList => 'Chapter / Material List';

  @override
  String get noChaptersInModule =>
      'No chapters or materials have been added to this module yet.';

  @override
  String get chapter => 'Chapter';

  @override
  String chapterNumber(String number) {
    return 'Chapter $number';
  }

  @override
  String learningContentBlocks(int count) {
    return 'Learning Content ($count blocks)';
  }

  @override
  String get noContentBlocksInChapter =>
      'No content blocks in this chapter yet.';

  @override
  String get moduleInfo => 'Module Information';

  @override
  String get splitChapters => 'Split Chapters';

  @override
  String pdfPagesDetected(int count) {
    return 'PDF file detected: $count pages';
  }

  @override
  String get moduleTitleField => 'Module Title *';

  @override
  String get moduleTitleHint => 'Enter Module Title';

  @override
  String get moduleDescriptionField => 'Description (optional) *';

  @override
  String get moduleDescriptionHint => 'Enter module description...';

  @override
  String get fase => 'Phase';

  @override
  String get selectFase => 'Select Phase';

  @override
  String get loadingFases => 'Loading phases...';

  @override
  String totalDocPages(int count) {
    return 'Total Document: $count Pages';
  }

  @override
  String get chapterSplitConfig => 'Chapter Split Configuration';

  @override
  String get chapterSplitDesc =>
      'Enter page ranges to split into a new Chapter.';

  @override
  String get chapterTitleField => 'Chapter Title *';

  @override
  String get startPageField => 'Start Page *';

  @override
  String get endPageField => 'End Page *';

  @override
  String get learningCompetency => 'Learning Objectives';

  @override
  String get selectCompetency => 'Select Learning Objectives';

  @override
  String get loadingCompetency => 'Loading learning objectives...';

  @override
  String get processAndCreateChapter => 'Process & Create Chapter';

  @override
  String createdChaptersList(int count) {
    return 'Created Chapters List ($count):';
  }

  @override
  String pagesRange(int start, int end) {
    return 'Page $start - $end';
  }

  @override
  String get needsReview => 'Needs Review';

  @override
  String get reviewed => 'Reviewed';

  @override
  String processingProgress(int progress) {
    return 'Processing: $progress%';
  }

  @override
  String get saveModule => 'Save Module';

  @override
  String get finish => 'Finish';

  @override
  String get tapToUploadFile => 'Tap to upload file';

  @override
  String get loadingModuleExtraction =>
      'Annoter is extracting and creating linear text annotations for screen readers';

  @override
  String get statusWait => 'Waiting...';

  @override
  String get statusProcess => 'Processing...';

  @override
  String get evaluatingAnnotationUpdating => 'Annoter is Updating Annotations';

  @override
  String get stopUpdatingConfirm => 'Stop update? Unsaved changes may be lost.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get evaluationInstruction =>
      'Select blocks: Text for direct edit, or Special Blocks (Image, Table, Formula) for AI revision.';

  @override
  String get selectAll => 'Select All';

  @override
  String get deselectAll => 'Deselect';

  @override
  String get editAnnotation => 'Edit Annotation';

  @override
  String get editTextAnnotation => 'Edit Text Annotation';

  @override
  String get editTextAnnotationHeader => 'Edit Text Annotation';

  @override
  String reviseWithAi(int count) {
    return 'Revise ($count) with AI';
  }

  @override
  String get saveToModule => 'Save to Module';

  @override
  String get directEdit => 'Direct Edit';

  @override
  String get originalText => 'Original Text:';

  @override
  String get changeAnnotationText => 'Change Annotation Text';

  @override
  String get saveAnnotation => 'Save Annotation';

  @override
  String get correctionAnnotation => 'Annotation Correction';

  @override
  String get enterCorrectionAdvice => 'Enter improvement suggestions';

  @override
  String get explainAiCorrection =>
      'Explain how AI should improve this annotation';

  @override
  String get promptClarifyForBlind => 'Clarify for screen reader';

  @override
  String get promptSimplifyLanguage => 'Simplify language';

  @override
  String get promptDetailRowsCols => 'Detail rows & columns of table';

  @override
  String get promptExplainFormulaSteps => 'Explain formula steps';

  @override
  String get sendToAi => 'Send to AI →';

  @override
  String get moduleImage => 'Module Image';

  @override
  String get moduleTable => 'Module Table';

  @override
  String get moduleFormula => 'Formula / Math';

  @override
  String get moduleDiagram => 'Diagram / Graph';

  @override
  String get textBlock => 'Text';

  @override
  String get viewExamQuestions => 'View Questions';

  @override
  String get viewStudentProgress => 'View Student Progress';

  @override
  String get deleteExam => 'Delete Exam Questions';

  @override
  String deleteExamConfirm(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String get publishExam => 'Publish Exam';

  @override
  String get delete => 'Delete';

  @override
  String get regenerateAiStimulus => 'Regenerate AI Stimulus';

  @override
  String get aiStimulusFeedbackDesc =>
      'Provide specific feedback to AI to revise this question\'s reading stimulus:';

  @override
  String get sendAndRegenerate => 'Send & Regenerate';

  @override
  String get readingStimulus => 'Reading Stimulus';

  @override
  String get regenerateStimulus => 'Regenerate Stimulus';

  @override
  String get question => 'Question';

  @override
  String get answerOptions => 'Answer Options';

  @override
  String get justificationSteps => 'Justification & Solution Steps';

  @override
  String answerKey(String key) {
    return 'Answer Key: $key';
  }

  @override
  String get addStep => 'Add Step';

  @override
  String get conclusion => 'Conclusion';

  @override
  String get noExamData => 'No exam data';

  @override
  String get noExamReviewResultsYet =>
      'No exam evaluation results available yet.';

  @override
  String get stepPickModule => 'Select Module';

  @override
  String get stepConfig => 'Configuration';

  @override
  String get stepReviewSave => 'Review & Save';

  @override
  String get selectSourceModule => 'Select Source Module';

  @override
  String get selectSourceModuleDesc =>
      'Select one module to be the source for exam questions.';

  @override
  String get noModulesAvailable => 'No modules available yet.';

  @override
  String get reload => 'Reload';

  @override
  String get examTitleField => 'Exam Title *';

  @override
  String get examTitleHint => 'Example: Chapter 1 Daily Assessment';

  @override
  String get examDurationField => 'Duration *';

  @override
  String get examScheduleField => 'Schedule *';

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get maxAttempts => 'Max Attempts';

  @override
  String get selectChaptersDistribution =>
      'Select Chapters & Question Distribution *';

  @override
  String totalQuestionsCount(int count) {
    return 'Total: $count Questions';
  }

  @override
  String get distributionDesc =>
      'Determine the number of HOTS (higher order thinking) and LOTS (basic understanding) questions for each chapter.';

  @override
  String get errorExamReviewDefault => 'No exam review results available yet';

  @override
  String get noChaptersFoundInModule => 'No chapters found in this module.';

  @override
  String get hotsQuestions => 'HOTS Questions';

  @override
  String get hotsDesc => 'Analysis, evaluation, synthesis';

  @override
  String get lotsQuestions => 'LOTS Questions';

  @override
  String get lotsDesc => 'Basic understanding & recall';

  @override
  String get questionsCreatedSuccess => 'Questions Successfully Created!';

  @override
  String get aiGeneratingQuestions => 'AI is Generating Questions';

  @override
  String get saveDraft => 'Save Draft';

  @override
  String get saveAndPublish => 'Save & Publish';

  @override
  String get nextStep => 'Next';

  @override
  String get createQuestions => 'Create Questions';

  @override
  String get welcomeTitle => 'Welcome';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get emailField => 'Email *';

  @override
  String get emailLabel => 'Email';

  @override
  String get enterEmail => 'Enter Email';

  @override
  String get passwordField => 'Password *';

  @override
  String get passwordLabel => 'Password';

  @override
  String get enterPassword => 'Enter Password';

  @override
  String get confirmPasswordField => 'Confirm Password *';

  @override
  String get enterConfirmPassword => 'Enter Confirm Password';

  @override
  String get forgotPasswordQuestion => 'Forgot password?';

  @override
  String get signIn => 'Sign In';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get fullNameField => 'Full Name *';

  @override
  String get enterFullName => 'Enter Full Name';

  @override
  String get createAccount => 'Create Account';

  @override
  String get enterClassCode => 'Enter Class Code';

  @override
  String get joinClassButton => 'Join class';

  @override
  String get askTeacherForCode => 'Ask for this code from your teacher';

  @override
  String examSubtitleFormat(int questions, int minutes) {
    return '$questions questions · Duration $minutes minutes';
  }

  @override
  String examSubtitleWithRetries(int questions, int minutes, int retries) {
    return '$questions questions · Duration $minutes minutes · Max ${retries}x attempts';
  }

  @override
  String get enterExamTitle => 'Enter exam title';

  @override
  String get mixedDifficulty => 'Mixed';

  @override
  String get chapterEvaluationQuiz => 'Chapter Evaluation Quiz';

  @override
  String questionsGeneratedStatus(int count, String module) {
    return 'Generating $count questions from $module...';
  }

  @override
  String questionsCreatedCount(int current, int total) {
    return '$current / $total questions created';
  }

  @override
  String questionsCreatedDone(int count) {
    return '$count questions created successfully.';
  }

  @override
  String minuteShort(int count) {
    return '$count min';
  }

  @override
  String timesCount(int count) {
    return '$count Times';
  }

  @override
  String get exampleChapterRangeHint =>
      'Example: Pages 1 - 44 will be converted to Chapter I.';

  @override
  String get annotationProgressNotice =>
      'Annotation process is running. The finish button will activate after all chapters are completed and reviewed.';

  @override
  String get reviewChaptersNotice =>
      'Please click chapters with \"Needs Review\" status to check and confirm annotation results before publishing.';

  @override
  String get questionList => 'Question List';

  @override
  String questionItem(int number) {
    return 'Question $number';
  }

  @override
  String questionOfTotal(int current, int total) {
    return 'Question $current of $total';
  }

  @override
  String get startExamButton => 'Start Exam';

  @override
  String get submitExamConfirmTitle => 'Are you sure you want to submit now?';

  @override
  String get submitExamConfirmDesc => 'Submitted answers cannot be changed.';

  @override
  String get sendButton => 'Submit';

  @override
  String get timeUpTitle => 'Time is Up!';

  @override
  String get timeUpDesc =>
      'Exam time has run out. Your answers have been automatically submitted.';

  @override
  String get examSubmittedTitle => 'Successfully Submitted!';

  @override
  String get examSubmittedDesc => 'Your answers have been successfully saved.';

  @override
  String examInstructionsParagraph1(int count, int duration) {
    return 'This exam consists of $count questions including multiple choice and short answers, and you have $duration minutes to complete it.';
  }

  @override
  String get examInstructionsParagraph2 =>
      'Read each question carefully, work calmly, and ensure all answers are submitted before time runs out.';

  @override
  String get examStartsAt => 'Exam starts at : ';

  @override
  String get examEndsAt => 'Exam ends at : ';

  @override
  String get goodLuck => 'Good luck and all the best!';

  @override
  String get learningProgress => 'Learning Progress';

  @override
  String get moduleNotFound => 'Module not found.';

  @override
  String completedChapterTitle(int number) {
    return 'Congratulations on completing Chapter $number';
  }

  @override
  String get searchPageHint => 'Search page...';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get correctAnswerBanner => 'Your Answer is Correct!';

  @override
  String get unansweredBanner => 'Question not answered';

  @override
  String get wrongAnswerBanner => 'Your Answer is Incorrect';

  @override
  String get answersLabel => 'Answers';

  @override
  String get justificationDiscussion => 'Justification & Discussion';

  @override
  String get yourSolutionSteps => 'Your solution steps:';

  @override
  String get improvementNotes => 'Improvement notes:';

  @override
  String get discussionSteps => 'Discussion Steps:';

  @override
  String get saveStep => 'Save Step';

  @override
  String get workingSteps => 'Working Steps';

  @override
  String get noConversationsYet => 'No Conversations Yet';

  @override
  String get startNewConversation => 'Start New Conversation';

  @override
  String get emptyConversationDesc =>
      'Start asking math topics or discussing questions by tapping the (+) button above!';

  @override
  String get referenceSources => 'Reference Sources:';

  @override
  String get aiThinking => 'NovaSight AI is thinking...';

  @override
  String get suggestedFollowUpQuestions => 'Suggested Follow-up Questions:';

  @override
  String get askQuestionHint => 'Ask about materials or questions...';
}
