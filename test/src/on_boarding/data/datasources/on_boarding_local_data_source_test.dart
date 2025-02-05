import 'package:education_app/core/errors/exceptions.dart';
import 'package:education_app/src/on_boarding/data/datasources/on_boarding_local_data_source.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test/test.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late SharedPreferences prefs;
  late OnBoardingLocalDataSource localDataSource;

  setUp(() {
    prefs = MockSharedPreferences();
    localDataSource = OnBoardingLocalDataSourceImpl(prefs);
  });

  group('cacheFirstTimer', () {
    test('should call [SharedPreference] to cache the data', () async {
      when(() => prefs.setBool(any(), any())).thenAnswer((_) async => true);

      await localDataSource.cacheFirstTimer();

      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);

      verifyNoMoreInteractions(prefs);
    });

    test(
        'should throw a [Cache Exception when there is a error caching the data]',
        () async {
      when(() => prefs.setBool(any(), any())).thenThrow(Exception());

      final methodCall = localDataSource.cacheFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));
      verify(() => prefs.setBool(kFirstTimerKey, false)).called(1);
      verifyNoMoreInteractions(prefs);
    });
  });

  group('checkIfUserIsFirstTimer', () {
    test(
        'should call [SHARED PREFERENCES] to check if user is first timer and return the right response from storage when data exists',
        () async {

          when(()=> prefs.getBool(any())).thenReturn(false);

          final result = await localDataSource.checkIfUserIsFirstTimer();

          expect(result, false);

          verify(()=> prefs.getBool(kFirstTimerKey)).called(1);

          verifyNoMoreInteractions(prefs);

        });

    test('should return true if there is no data in storage', ()async{

      when(()=> prefs.getBool(any())).thenReturn(null);

      final result = await localDataSource.checkIfUserIsFirstTimer();

      expect(result , true);

      verify(()=> prefs.getBool(kFirstTimerKey)).called(1);

      verifyNoMoreInteractions(prefs);

    });

    test('should throw a [CatchException] when there is an error', ()async{

      when(()=> prefs.getBool(any())).thenThrow(Exception());

      final methodCall = localDataSource.checkIfUserIsFirstTimer;

      expect(methodCall, throwsA(isA<CacheException>()));

      verify(()=> prefs.getBool(kFirstTimerKey)).called(1);

      verifyNoMoreInteractions(prefs);


    });
  });
}
