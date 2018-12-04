E map<T, E>(T value, Function f /* E f(T _) | E f(K, V) */) {
  if (null == value) return null;

  if (value is List) return value.map(f) as E;

  if (value is Map) return value.map(f) as E;

  return f(value);
}
