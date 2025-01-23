### **Steps to Use Auto OTP Detection with Supabase**

1. **Set Up Supabase Phone Authentication**  
   In your Supabase project, enable phone authentication:
   - Go to your Supabase dashboard.
   - Navigate to **Authentication** → **Settings** → **Phone**.
   - Enable the phone sign-in feature.

2. **Install Required Dependencies**  
   Add these dependencies in your `pubspec.yaml` file:
   ```yaml
   dependencies:
     supabase_flutter: ^1.7.2
     sms_autofill: ^2.0.0
     permission_handler: ^11.0.0
   ```

3. **Request SMS Permissions**  
   Before accessing SMS, request permissions:
   ```dart
   import 'package:permission_handler/permission_handler.dart';

   Future<void> requestSmsPermission() async {
     if (await Permission.sms.isDenied) {
       await Permission.sms.request();
     }
   }
   ```

4. **Send OTP with Supabase**  
   Use Supabase's `signInWithOtp` to send the OTP to the user's phone:
   ```dart
   import 'package:supabase_flutter/supabase_flutter.dart';

   Future<void> sendOtp(String phoneNumber) async {
     final response = await Supabase.instance.client.auth.signInWithOtp(
       phone: phoneNumber,
     );
     if (response.error != null) {
       print('Error sending OTP: ${response.error!.message}');
     } else {
       print('OTP sent successfully!');
     }
   }
   ```

5. **Enable OTP Autofill**  
   Use the `sms_autofill` package to detect and autofill the OTP:
   ```dart
   import 'package:sms_autofill/sms_autofill.dart';

   class OtpScreen extends StatefulWidget {
     final String phoneNumber;

     OtpScreen({required this.phoneNumber});

     @override
     _OtpScreenState createState() => _OtpScreenState();
   }

   class _OtpScreenState extends State<OtpScreen> with CodeAutoFill {
     String? _otpCode;

     @override
     void initState() {
       super.initState();
       listenForCode(); // Start listening for the OTP
     }

     @override
     void codeUpdated() {
       setState(() {
         _otpCode = code; // Automatically populate the OTP
       });
     }

     Future<void> verifyOtp(String otp) async {
       final response = await Supabase.instance.client.auth.verifyOtp(
         phone: widget.phoneNumber,
         token: otp,
         type: OtpType.sms,
       );

       if (response.error != null) {
         print('Error verifying OTP: ${response.error!.message}');
       } else {
         print('OTP verified successfully!');
       }
     }

     @override
     void dispose() {
       cancel(); // Stop listening for the OTP
       super.dispose();
     }

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         appBar: AppBar(title: Text("Verify OTP")),
         body: Padding(
           padding: EdgeInsets.all(16.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               TextField(
                 decoration: InputDecoration(labelText: "OTP"),
                 onChanged: (value) {
                   _otpCode = value;
                 },
                 controller: TextEditingController(text: _otpCode),
               ),
               SizedBox(height: 20),
               ElevatedButton(
                 onPressed: () {
                   if (_otpCode != null) {
                     verifyOtp(_otpCode!);
                   }
                 },
                 child: Text("Verify"),
               ),
             ],
           ),
         ),
       );
     }
   }
   ```

6. **OTP Format**  
   To enable auto OTP detection:
   - Supabase automatically sends an OTP SMS to the user.
   - Customize the SMS format in your backend only if needed (Supabase manages the format automatically).

7. **Testing**  
   - Ensure Supabase is set up correctly to send OTPs.
   - Deploy and test the app on a real device (SMS permissions and auto-fill don't work on emulators).

---

### **Key Notes**
- **Auto OTP Detection:** `sms_autofill` will handle auto-filling if the OTP message is formatted correctly (Supabase typically handles this).
- **Permissions:** Ensure SMS permissions are granted for Android devices. iOS doesn't support SMS auto-detection, so users will need to copy and paste the OTP.
- **Backend Configuration:** Supabase handles OTP sending securely. You don’t need to implement additional SMS services unless you want to customize OTP messages.

This will allow you to combine Supabase's phone auth with Flutter's auto OTP detection seamlessly!