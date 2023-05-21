class VerificationCodeArguments {
  final String? email;
  final String? phone;
  final int userID;
  VerificationCodeArguments({
    required this.userID,
    this.email,
    this.phone,
  });
}
