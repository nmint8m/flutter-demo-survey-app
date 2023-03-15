import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kayla_flutter_ic/api/exception/network_exceptions.dart';
import 'package:kayla_flutter_ic/api/repository/oauth_repository.dart';
import 'package:kayla_flutter_ic/api/response/forget_password_meta_response.dart';
import 'package:kayla_flutter_ic/api/response/forget_password_response.dart';
import 'package:kayla_flutter_ic/api/response/oauth_login_response.dart';
import 'package:kayla_flutter_ic/api/response/oauth_refresh_token_response.dart';
import 'package:kayla_flutter_ic/model/oauth_login.dart';
import 'package:kayla_flutter_ic/model/oauth_refresh_token.dart';
import 'package:mockito/mockito.dart';
import '../../mocks/generate_mocks.mocks.dart';

void main() {
  FlutterConfig.loadValueForTesting({
    'CLIENT_ID': 'CLIENT_ID',
    'CLIENT_SECRET': 'CLIENT_SECRET',
  });
  group("Oauth repository", () {
    late MockOAuthService mockOauthService;
    late OAuthRepository oauthRepository;

    setUp(() async {
      mockOauthService = MockOAuthService();
      oauthRepository = OAuthRepositoryImpl(mockOauthService);
    });

    test('When calling login successfully, it returns corresponding response',
        () async {
      final oauthLoginResponse = OAuthLoginResponse(
        id: '',
        type: '',
        accessToken: '',
        tokenType: '',
        expiresIn: -1,
        refreshToken: '',
        createdAt: -2,
      );
      const oauthLogin = OAuthLogin(
        id: '',
        accessToken: '',
        tokenType: '',
        expiresIn: -1,
        refreshToken: '',
      );
      when(mockOauthService.login(any))
          .thenAnswer((_) async => oauthLoginResponse);
      final result = await oauthRepository.login(
        email: 'test@email.com',
        password: 'password',
      );
      expect(result, oauthLogin);
    });

    test('When calling login failed, it returns error', () async {
      when(mockOauthService.login(any))
          .thenAnswer((_) => Future.error(MockDioError()));
      try {
        await oauthRepository.login(
          email: 'test@email.com',
          password: 'password',
        );
      } catch (e) {
        expect(e, isInstanceOf<NetworkExceptions>());
      }
    });

    test(
        'When calling refresh token successfully, it returns corresponding response',
        () async {
      final oauthRefreshTokenResponse = OAuthRefreshTokenResponse(
        id: '',
        type: '',
        accessToken: '',
        tokenType: '',
        expiresIn: -1,
        refreshToken: '',
        createdAt: -2,
      );
      const oauthRefreshToken = OAuthRefreshToken(
        id: '',
        accessToken: '',
        tokenType: '',
        expiresIn: -1,
        refreshToken: '',
      );
      when(mockOauthService.refreshToken(any))
          .thenAnswer((_) async => oauthRefreshTokenResponse);
      final result = await oauthRepository.refreshToken(refreshToken: '');
      expect(result, oauthRefreshToken);
    });

    test('When calling refresh token failed, it returns error', () async {
      when(mockOauthService.refreshToken(any))
          .thenAnswer((_) => Future.error(MockDioError()));
      try {
        await oauthRepository.refreshToken(refreshToken: '');
      } catch (e) {
        expect(e, isInstanceOf<NetworkExceptions>());
      }
    });

    test(
        'When calling forget password successfully, it returns corresponding response',
        () async {
      final forgetPasswordResponse = ForgetPasswordResponse(
        meta: ForgetPasswordMetaResponse(message: 'testmessage'),
      );
      const forgetPassword = 'testmessage';
      when(mockOauthService.forgetPassword(any))
          .thenAnswer((_) async => forgetPasswordResponse);
      final result =
          await oauthRepository.forgetPassword(email: 'test@email.com');
      expect(result, forgetPassword);
    });

    test('When calling forget password failed, it returns error', () async {
      when(mockOauthService.forgetPassword(any))
          .thenAnswer((_) => Future.error(MockDioError()));
      try {
        await oauthRepository.forgetPassword(email: 'test@email.com');
      } catch (e) {
        expect(e, isInstanceOf<NetworkExceptions>());
      }
    });
  });
}
