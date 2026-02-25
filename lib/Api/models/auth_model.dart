import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/http.dart';
part 'auth_model.g.dart';

@JsonSerializable()
class RegisterAccountRequest {
  final String email;

  final String name;
  final String password;

  RegisterAccountRequest({
    required this.email,
    required this.name,
    required this.password,
  });

  factory RegisterAccountRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountRequestToJson(this);
}

@JsonSerializable()
class RegisterAccountResponse {
  final String userId;
  final String message;

  RegisterAccountResponse({required this.userId, required this.message});

  factory RegisterAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountResponseToJson(this);
}

@JsonSerializable()
class RequestOtpRequest {
  final String email;
  final String action;

  RequestOtpRequest({required this.email, required this.action});

  factory RequestOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$RequestOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestOtpRequestToJson(this);
}

// @JsonSerializable()
// class RequestOtpResponse {
//   final String message;
//
//   RequestOtpResponse({required this.message});
//
//   factory RequestOtpResponse.fromJson(Map<String, dynamic> json) =>
//       _$RequestOtpResponseFromJson(json);
//
//   Map<String, dynamic> toJson() => _$RequestOtpResponseToJson(this);
// }

@JsonSerializable()
class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}

@JsonSerializable()
class VerifyOtpResponse {
  final String message;
  final String action;
  VerifyOtpResponse({required this.message, required this.action});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}

@JsonSerializable()
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}

@JsonSerializable()
class LoginResponse {
  final String? access_token;

  LoginResponse({this.access_token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;
  final String role;
  final bool isActive;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isActive,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
