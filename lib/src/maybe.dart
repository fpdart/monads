import 'map.dart' as _;
import 'filter.dart' as _;

class Nothing {
  bool get isSome => false;

  @override
  String toString() => 'Nothing';

  /**
   * 
   *      Nothing().fold(-1)((v) => v + 1); // -1
   * 
   */
  E Function(E Function(T _)) fold<E, T>(E defaultValue) =>
      (E f(T _)) => defaultValue;

  /**
   * 
   *      Nothing().orJust(2); // Just(2)
   * 
   */
  Just<T> orJust<T>(T _) => Just<T>(_);

  /**
   * 
   *      Nothing().getOrElse('q'); // Just('q')
   * 
   */
  Just<T> getOrElse<T>(T _) => orJust<T>(_);
}

class Just<T> {
  T _value;

  T get just => _value;

  /**
   * 
   *      Just(123).isNothing; // false
   *      Just(null).isNothing; // true
   *      Just(Nothing()).isNothing; // true
   * 
   */
  bool get isNothing => _value is Nothing || null == _value;

  Just(this._value);

  /**
   * 
   *      var a = new Just([5, 4, 1, 4, 3]);
   * 
   *      a.map((v) => v + 1).just; // [6, 5, 2, 5, 4]
   * 
   */
  Just<E> map<E>(f) => new Just<E>(_.map<T, E>(_value, f));

  /**
   * 
   *      var a = new Just(123);
   *      var b = new Just(null);
   * 
   *      a.fold(1)((v) => v + 1); // 124
   *      b.fold('ha')((v) => v + 1); // ha
   * 
   */
  /* E || V  */ dynamic Function(V Function(dynamic _)) fold<E, V>(
          E defaultValue) =>
      (V f(T _)) => isNothing ? defaultValue : f(_value);

  /* T | E */ orJust<E>(E _) => isNothing ? _ : _value;

  /* T | E */ getOrElse<E>(E _) => orJust<E>(_);

  /**
   * 
   *      var a = new Just(123);
   *      var b = new Just(null);
   *      var c = new Just([5, 4, 1, 4, 3]);
   * 
   *      a.filter((v) => v > 1); // Just(123)
   *      b.filter((v) => v + 3); // Just(null);
   *      c.filter((v) => 2 < v).just; // [5, 4, 4, 3]
   * 
   */
  Just<E> filter<E>(f) =>
      isNothing ? this : new Just<E>(_.filter<T, E>(f, _value));

  @override
  bool operator ==(Object a) => a is Just ? _value == a.just : _value == a;

  @override
  int get hashCode => super.hashCode;
}

class Maybe<T> {
  T _value;

  T get value => _value;

  bool get isJust => _value is Just;

  bool get isNothing => _value is Nothing || null == _value;

  Just get just => new Just<T>(_value);

  Maybe(this._value);

  Maybe<E> map<E>(f) => new Maybe<E>(_.map<T, E>(value, f));

  /**
   * 
   *      var a = new Maybe([5, 4, 1, 4, 3]);
   *      var b = new Maybe(Just(null));
   *      var c = new Maybe(new Nothing());
   *
   *      a.cata(() => false, (v) => v); // false
   *      b.cata(() => false, (v) => v) == new Just(null); // true
   *      c.cata(() => 'q', (v) => v); // 'q'
   * 
   */
  cata<E, V>(E f(), V fn(T _)) => isJust ? fn(_value) : f();

  /* E || V  */ dynamic Function(V Function(dynamic _)) fold<E, V>(
          E defaultValue) =>
      (V f(T)) => isNothing ? defaultValue : f(_value);

  /* T || E */ Just orJust<E>(E a) =>
      isNothing || null == _value ? new Just<E>(a) : just;

  Just getOrElse<E>(E a) => orJust<E>(a);

  /**
   * 
   *      var a = new Maybe(null);
   *      var b = new Maybe(123);
   *      
   *      a.orNull(); // null
   *      b.orNull(); // 123
   * 
   */
  /* T | Null */ orNull() => null == _value ? null : _value;

  /* T || E */ Maybe orElse<E>(E a) => isNothing ? new Maybe(a) : this;

  Maybe<E> filter<E>(f) => new Maybe<E>(_.filter<T, E>(f, _value));

  @override
  bool operator ==(Object a) {
    if (a is Maybe) return _value == a.value;

    if (a is Just) return a == just;

    return a == _value;
  }

  @override
  int get hashCode => super.hashCode;
}
