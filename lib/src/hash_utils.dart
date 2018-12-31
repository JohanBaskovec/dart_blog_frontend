import 'dart:html';

/// Returns all the parameters from the current hash.
/// Each parameter is separated with '?'
/// Example: example.com/#hash
/// Return an empty array when no parameter is present.
Map<String, String> getHashParameters() {
  final hash = window.location.hash;
  final hashSplitByAnd = hash.split('?');
  if (hashSplitByAnd.length == 1) {
    return {};
  }
  final parametersWithoutPath = hashSplitByAnd.sublist(1);
  // if window.location.hash is 'test?one=test1&two=test2' then
  // parametersWithoutPath is ['one=test1', 'two=test2']
  final Map<String, String> parametersMap = {};
  for (final parameter in parametersWithoutPath) {
    final List<String> keyAndValue = parameter.split('=');
    final String key = keyAndValue[0];
    final String value = keyAndValue[1];
    parametersMap[key] = value;
  }
  return parametersMap;
}