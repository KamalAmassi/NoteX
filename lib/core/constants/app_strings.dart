class AppStrings {
  AppStrings._();

  static const String appName = 'NoteX';
  static const String tagline = 'دوّن أفكارك قبل أن تضيع';

  static const String myNotes = 'ملاحظاتي';
  static const String searchHint = 'ابحث في ملاحظاتك...';
  static const String newNote = 'ملاحظة جديدة';
  static const String editNote = 'تعديل الملاحظة';
  static const String titleHint = 'العنوان';
  static const String contentHint = 'اكتب ملاحظتك هنا...';
  static const String save = 'حفظ';
  static const String delete = 'حذف';
  static const String cancel = 'إلغاء';
  static const String untitled = 'بدون عنوان';

  static const String deleteTitle = 'حذف الملاحظة';
  static const String deleteMessage = 'هل أنت متأكد أنك تريد حذف هذه الملاحظة؟';

  static const String emptyTitle = 'لا توجد ملاحظات بعد';
  static const String emptySubtitle =
      'اضغط على «ملاحظة جديدة» وابدأ بتدوين أفكارك';
  static const String noResults = 'لم نجد أي نتائج';
  static const String noResultsSubtitle = 'جرّب كلمات مختلفة في البحث';

  static const String emptyNoteError = 'اكتب شيئًا قبل الحفظ';
  static const String loadError = 'حدث خطأ أثناء تحميل الملاحظات';

  static String notesCount(int n) {
    if (n == 0) return 'لا توجد ملاحظات';
    if (n == 1) return 'ملاحظة واحدة';
    if (n == 2) return 'ملاحظتان';
    if (n <= 10) return '$n ملاحظات';
    return '$n ملاحظة';
  }
}