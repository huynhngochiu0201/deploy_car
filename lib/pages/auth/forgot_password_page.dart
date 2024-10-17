import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_app/components/button/cr_elevated_button.dart';
import 'package:car_app/components/text_field/cr_text_field.dart';
import 'package:car_app/constants/app_color.dart';
import '../../components/snack_bar/td_snack_bar.dart';
import '../../components/snack_bar/top_snack_bar.dart';
import '../../gen/assets.gen.dart';
import '../../utils/validator.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  Future<void> _onSubmit(BuildContext context) async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));

    _auth
        .sendPasswordResetEmail(email: emailController.text.trim())
        .then((value) {
      showTopSnackBar(
        context,
        const TDSnackBar.success(
            message: 'Please check email to create password 😍'),
      );

      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => LoginPage(email: emailController.text.trim()),
        ),
        (Route<dynamic> route) => false,
      );
    }).catchError((onError) {
      FirebaseAuthException a = onError as FirebaseAuthException;
      showTopSnackBar(
        context,
        TDSnackBar.error(message: a.message ?? ''),
      );
    }).whenComplete(() {
      setState(() => isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: MediaQuery.of(context).padding.top + 38.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const Text('Forgot Password',
                      style: TextStyle(color: AppColor.red, fontSize: 24.0)),
                  const SizedBox(height: 2.0),
                  Text('Enter Your Email',
                      style: TextStyle(
                          color: AppColor.brown.withOpacity(0.8),
                          fontSize: 18.6)),
                  const SizedBox(height: 38.0),
                  Image.asset(
                    Assets.images.autocarlogo.path,
                    width: 90.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 36.0),
                  CrTextField(
                    controller: emailController,
                    hintText: 'Email',
                    prefixIcon: const Icon(Icons.email, color: AppColor.orange),
                    validator: Validator.email,
                    onFieldSubmitted: (_) => _onSubmit(context),
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 68.0),
                  CrElevatedButton.outline(
                    onPressed: () => _onSubmit(context),
                    text: 'Next',
                    isDisable: isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
