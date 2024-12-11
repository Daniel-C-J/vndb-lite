/// This method is related with sort_filter feature's languages data.
String formatLanguageCode({required String languageCode}) {
  // TODO try to use https://pub.dev/packages/country_flags and https://gist.github.com/jrnk/8eb57b065ea0b098d571 ?
  if (languageCode.contains('br')) return 'BR';
  if (languageCode.contains('pt-pt')) return 'PT';
  if (languageCode.contains('cs')) return 'CZ';
  if (languageCode.contains('en')) return 'US';
  if (languageCode.contains('ja')) return 'JP';
  if (languageCode.contains('zh')) return 'CN';
  if (languageCode.contains('ko')) return 'KR';

  return languageCode.toUpperCase();
}
