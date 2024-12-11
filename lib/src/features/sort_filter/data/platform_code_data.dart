// ignore_for_file: constant_identifier_names
const Map<String, String> PLATFORM_DATA = {
  'win': 'Windows',
  'mac': 'Mac',
  'lin': 'Linux',
  'ios': 'iOS',
  'psp': 'Playstation Portable',
  'ps1': 'Playstation 1',
  'ps2': 'Playstation 2',
  'ps3': 'Playstation 3',
  'ps4': 'Playstation 4',
  'ps5': 'Playstation 5',
  'and': 'Android',
  'bdp': 'Blu-ray Player',
  'drc': 'Dreamcast',
  'nds': 'Nintendo DS',
  'swi': 'Nintendo Switch',
  'wii': 'Nintendo Wii',
  'n3d': 'Nintendo 3DS',
  'psv': 'Playstation Vita',
  'vnd': 'VNDS',
  'xb3': 'Xbox 360',
  'xbo': 'Xbox One'
};

const List<String> plainColorPlatformIcons = [
  'bdp',
  'dvd',
  'n3d',
  'nds',
  'ps2',
  'ps3',
  'ps4',
  'ps5',
  'psp',
  'psv',
  'web',
  'wii',
];

bool isPlatformIconPlain(String platformCode) {
  return plainColorPlatformIcons.contains(platformCode.toLowerCase());
}
