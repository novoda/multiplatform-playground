import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:news/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfo networkInfo;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfo = NetworkInfo(mockInternetConnectionChecker);
  });

  group("isConnected", () {
    test(
      'should forward the call to InternetConnectChecker.hasConnection',
      () async {
        final hasConnectionFuture = Future.value(true);
        when(mockInternetConnectionChecker.hasConnection)
            .thenAnswer((_) => hasConnectionFuture);

        final result = networkInfo.isConnected;

        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, hasConnectionFuture);
      },
    );

    test(
      'should return true if the device has connection',
      () async {
        when(mockInternetConnectionChecker.hasConnection)
            .thenAnswer((_) async => true);

        final result = await networkInfo.isConnected;

        verify(mockInternetConnectionChecker.hasConnection);
        expect(result, true);
      },
    );
  });

  test(
    'should return false if the device has connection',
    () async {
      when(mockInternetConnectionChecker.hasConnection)
          .thenAnswer((_) async => false);

      final result = await networkInfo.isConnected;

      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, false);
    },
  );
}
