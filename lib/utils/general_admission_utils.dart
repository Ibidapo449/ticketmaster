const Set<String> _generalAdmissionTokens = <String>{
  'GENADM',
  'FLR',
  'FLOOR',
  'PIT',
  'GA2',
  'GA',
  'GA1',
};

String _normalizeAdmissionToken(String value) {
  return value.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
}

bool isGeneralAdmissionLabel(String value) {
  final normalized = _normalizeAdmissionToken(value);
  return normalized.isNotEmpty && _generalAdmissionTokens.contains(normalized);
}

bool hasGeneralAdmissionRule({
  required String section,
  String row = '',
}) {
  return isGeneralAdmissionLabel(section) || isGeneralAdmissionLabel(row);
}

String generalAdmissionSectionDisplay(String section) {
  final normalized = section.trim().toUpperCase();
  if (normalized.isEmpty || normalized == 'N/A') {
    return 'GENADM';
  }
  return normalized;
}
