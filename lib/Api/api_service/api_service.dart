import 'package:dio/dio.dart';
import 'package:htoochoon_flutter/Api/models/auth_model.dart';

import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

const String baseUrl = "https://htoochoon.kargate.site/";

@RestApi(baseUrl: baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("auth/register")
  Future<RegisterAccountRequest> register(
    @Body() RegisterAccountRequest request,
  );

  @POST("auth/request-otp")
  Future<String> requestOtp(@Body() RequestOtpRequest request);

  @POST("auth/verify-otp")
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST("auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);
}
