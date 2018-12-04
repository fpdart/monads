Null _nullValue = null;

///     Ok<String>('My string!')
Result<Success<T>, Failure<void>> Ok<T>(T _) =>
    Result<Success<T>, Failure<void>>(Success<T>(_), _nullValue);

///     Err<int>(1)
Result<Success<void>, Failure<T>> Err<T>(T _) =>
    Result<Success<void>, Failure<T>>(_nullValue, Failure<T>(_));

/**
 * 
 *     toResultOr<Null, Exception>(() => throw Exception('q')); // Failure<Exception<String>>
 *     toResultOr<Null, String>(() => throw Exception(1), failure: 'My message'); // Success<String> 
 * 
 */
Result<Success<S>, Failure<F>> toResultOr<S, F>(Function f, {F failure: null}) {
  try {
    return Result<Success<S>, Failure<F>>(Success(f()), _nullValue);
  } catch (e) {
    return Result<Success<S>, Failure<F>>(_nullValue, Failure(failure ?? e));
  }
}

class Result<S extends Success, F extends Failure> {
  S _success;
  F _failure;

  S get success => _success;
  bool get isSuccess => _nullValue != _success;

  F get failure => _failure;
  bool get isFailure => _nullValue != _failure;

  Result(S success, F failure) {
    if (_nullValue != success && _nullValue != failure) {
      throw Exception('Cannot be Success with Failure');
    }

    _success = success;
    _failure = failure;
  }

  /**
   * 
   *      Result.of(() => 'Ok'); // Result<Success<String, null>
   *      Result.of(() => throw Exception('Test exception')); // Result<null, Failure<Exception<String>>
   * 
   */
  factory Result.of(Function f) => toResultOr(f);

  /* T | Null */ onSuccess<T>(T f(/* Success -> T */ _)) {
    if (isSuccess) return f(_success.value);
  }

  /* T | Null */ onFailure<T>(T f(/* Failure -> T */ _)) {
    if (isFailure) return f(_failure.value);
  }

  /**
   * 
   *      var ok = Result<Success<String>, Failure<Null>>(Success<String>('Ok'), null);
   *      var err = Result<Success<Null>, Failure<String>>(null, Failure<String>('Error'));
   *      
   *      var suc = (_) => 'Success: ${_}';
   *      var fail = (_) => 'Error: ${_}';
   *
   *      ok.match<String>(suc, fail); // 'Success: Ok'
   *      err.match<String>(suc, fail); // 'Error: Error'
   * 
   */
  T match<T>(Function suc, Function fail /* T | E (S | F) */) =>
      isSuccess ? onSuccess(suc) : onFailure(fail);

  /**
   * 
   * [ok], [err] - Look up to [match]
   *      ok == 'Ok'; // true
   *      ok == 1; // false
   *
   *      err == 'Error'; // true
   *      err == 1; // false
   * 
   */
  @override
  bool operator ==(Object _) => isSuccess ? _success == _ : _failure == _;

  @override
  int get hashCode => super.hashCode;
}

class Success<T> {
  T value;

  // @todo: toEither with Right
  Success(this.value);

  @override
  bool operator ==(Object _) => _ == value;

  @override
  int get hashCode => super.hashCode;
}

class Failure<T> {
  T value;

  // @todo: toEither with Left
  Failure(this.value);

  @override
  bool operator ==(Object _) => _ == value;

  @override
  int get hashCode => super.hashCode;
}
