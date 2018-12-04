E filter<T, E>(Function predicate /* bool (T || K, V) */, T value) {
  if (value is List) return value.where(predicate) as E;

  if (value is Map) return value.removeWhere((k, v) => !predicate(k, v)) as E;

  return value as E;
}
