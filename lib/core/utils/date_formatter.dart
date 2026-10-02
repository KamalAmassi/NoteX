class DateFormatter {
  DateFormatter._();

  static const List<String> _months = [
    'كانون الثاني',
    'شباط',
    'آذار',
    'نيسان',
    'أيار',
    'حزيران',
    'تموز',
    'آب',
    'أيلول',
    'تشرين الأول',
    'تشرين الثاني',
    'كانون الأول',
  ];

  static String format(DateTime date) {
    final base = '${date.day} ${_months[date.month - 1]}';
    return date.year == DateTime.now().year ? base : '$base ${date.year}';
  }
}