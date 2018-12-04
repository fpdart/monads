import 'package:monads/monads.dart';
import 'package:test/test.dart';

void main() {
  group('Result class', () {
    var ok =
        Result<Success<String>, Failure<Null>>(Success<String>('Ok'), null);
    var err =
        Result<Success<Null>, Failure<String>>(null, Failure<String>('Error'));
    test('Getters', () {
      expect(ok.isSuccess, true);
      expect(ok.isFailure, false);

      expect(err.isSuccess, false);
      expect(err.isFailure, true);

      expect(ok.success.value, 'Ok');
      expect(ok.failure?.value, null);

      expect(err.success?.value, null);
      expect(err.failure.value, 'Error');
    });

    test('Compare', () {
      expect(ok == 'Ok', true);
      expect(ok == 1, false);

      expect(err == 'Error', true);
      expect(err == 1, false);
    });

    test('Exception when creating object', () {
      try {
        Result<Success<String>, Failure<int>>(
            Success<String>('Ok'), Failure<int>(2));
      } catch (e) {
        expect(e.message, 'Cannot be Success with Failure');
      }
    });

    test('Of method', () {
      var successResult = Result.of(() => 'Ok');
      var failureResult = Result.of(() => throw Exception('Test exception'));

      expect(successResult.isSuccess, true);
      expect(successResult.isFailure, false);
      expect(successResult.success.value, 'Ok');
      expect(successResult == 'Ok', true);

      expect(failureResult.isFailure, true);
      expect(failureResult.isSuccess, false);
      expect(failureResult.failure.value.message, 'Test exception');
    });

    test('onSuccess & onFailure method', () {
      var suc = (_) => 'So good';
      var fail = (_) => 'So bad';

      expect(ok.onFailure(fail), null);
      expect(ok.onSuccess(suc), 'So good');

      expect(err.onSuccess(suc), null);
      expect(err.onFailure(fail), 'So bad');
    });

    test('Match method', () {
      var suc = (_) => 'Success: ${_}';
      var fail = (_) => 'Error: ${_}';

      expect(ok.match<String>(suc, fail), 'Success: Ok');
      expect(err.match<String>(suc, fail), 'Error: Error');
    });
  });

  test('Ok & Err methods', () {
    var fromOk = Ok<String>('My string!');
    var fromErr = Err<int>(1);

    expect(fromOk.isSuccess, true);
    expect(fromOk.isFailure, false);
    expect(fromOk == 'My string!', true);
    expect(fromOk.onSuccess((_) => 'Ok'), 'Ok');
    expect(fromOk.onFailure((_) => 'Not ok'), null);

    expect(fromErr.isSuccess, false);
    expect(fromErr.isFailure, true);
    expect(fromErr == 1, true);
    expect(fromErr.onSuccess((_) => 'Ok'), null);
    expect(fromErr.onFailure((_) => _), 1);
  });

  test('toResultOr method', () {
    var withErr = toResultOr<Null, Exception>(() => throw Exception('q'));
    var withCustomErr = toResultOr<Null, String>(() => throw Exception(1),
        failure: 'My message');

    expect(withErr.isSuccess, false);
    expect(withErr.isFailure, true);
    expect(withErr.onSuccess((_) => 'Ok'), null);
    expect(withErr.onFailure((_) => _.message), 'q');

    expect(withCustomErr.isSuccess, false);
    expect(withCustomErr.isFailure, true);
    expect(withCustomErr == 'My message', true);
    expect(withCustomErr.onSuccess((_) => 'Ok'), null);
    expect(withCustomErr.onFailure((_) => '${_}!'), 'My message!');
  });
}

// Result<Success<String>, Failure<void>> resultValue = Ok<String>('Ok');

// var onSuccess = (_) => print('Success: ${_}');
// var onFailure = (_) => print('Failure: ${_}');

// resultValue.onSuccess(onSuccess);
// resultValue.onFailure(onFailure);

// resultValue.match(onSuccess, onFailure);
