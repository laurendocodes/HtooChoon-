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
  final bool success;
  final String message;

  RegisterAccountResponse({required this.success, required this.message});

  factory RegisterAccountResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterAccountResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterAccountResponseToJson(this);
}

@JsonSerializable()
class SendOtpRequest {
  final String email;

  SendOtpRequest({required this.email});

  factory SendOtpRequest.fromJson(Map<String, dynamic> json) =>
      _$SendOtpRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpRequestToJson(this);
}

@JsonSerializable()
class SendOtpResponse {
  final bool success;
  final String message;

  SendOtpResponse({required this.success, required this.message});

  factory SendOtpResponse.fromJson(Map<String, dynamic> json) =>
      _$SendOtpResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendOtpResponseToJson(this);
}

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
  final bool success;
  final String message;

  VerifyOtpResponse({required this.success, required this.message});

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
  final bool success;
  final String message;
  final String? token;
  final User? user;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class User {
  final String id;
  final String email;
  final String name;

  User({required this.id, required this.email, required this.name});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
