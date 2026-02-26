import 'package:dio/dio.dart';
import 'package:htoochoon_flutter/Api/models/auth_model.dart';
import 'package:htoochoon_flutter/Api/models/user_model.dart';
import 'package:htoochoon_flutter/Providers/user_provider.dart';

import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

const String baseUrl = "https://htoochoon.kargate.site/";

@RestApi(baseUrl: baseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("auth/me")
  Future<AuthMeResponse> getMe();

  @POST("auth/register")
  Future<RegisterAccountResponse> register(
    @Body() RegisterAccountRequest request,
  );

  @POST("auth/request-otp")
  Future<RequestOtpResponse> requestOtp(@Body() RequestOtpRequest request);

  @POST("auth/verify-otp")
  Future<VerifyOtpResponse> verifyOtp(@Body() VerifyOtpRequest request);

  @POST("auth/login")
  Future<LoginResponse> login(@Body() LoginRequest request);

  // ================= STUDENT =================

  @GET("student/classes")
  Future<List<StudentClass>> getStudentClasses();

  @POST("student/classes/join")
  Future<void> joinClass(@Body() JoinClassRequest request);

  @GET("student/classes/{id}/content")
  Future<dynamic> getClassContent(@Path("id") String id);

  @POST("student/submit")
  Future<void> submitAssignment(@Body() SubmitRequest request);

  @PATCH("student/invitations/{id}/{status}")
  Future<void> handleInvitation(
    @Path("id") String id,
    @Path("status") String status,
  );
}
