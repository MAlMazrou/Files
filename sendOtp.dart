// Import the necessary package
import 'package:firebase_auth/firebase_auth.dart';

// Flag to track verification request status (optional)
bool isVerificationRequested = false;

Future<String?> sendOtp(String phoneNumber) async {
  final auth = FirebaseAuth.instance;

  if (!isVerificationRequested) {
    isVerificationRequested = true;

    String? verificationId;

    void verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
// Verification logic can be implemented here if desired (optional)
      print(
          'Verification completed (handled in verifyOTP): ${phoneAuthCredential.verificationId}');
      verificationId = phoneAuthCredential.verificationId;
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: (FirebaseAuthException error) =>
            print('Verification failed: ${error.code}'),
        codeSent: (verificationIdParam, resendToken) {
          print('Code sent');
          verificationId = verificationIdParam; // Save the verificationId
        },
        codeAutoRetrievalTimeout: (String verificationIdParam) {
          verificationId =
              verificationIdParam; // Handle automatic retrieval (optional)
        },
      );
    } catch (error) {
      print('Error sending OTP: $error');
      return null; // Indicate error
    } finally {
      isVerificationRequested = false;
    }

    return verificationId; // Return verificationId if successful
  } else {
    print('Verification already requested. Please wait for the OTP.');
    return null; // Indicate request already in progress (optional)
  }
}
