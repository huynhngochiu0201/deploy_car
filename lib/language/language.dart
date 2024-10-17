enum Language {
  english(flag: 'assets/images/usa.png', name: 'English', code: 'en'),
  vn(flag: 'assets/images/vietnam.png', name: 'Việt Nam', code: 'vn');

  const Language({required this.flag, required this.name, required this.code});

  final String flag;
  final String name;
  final String code;
}
