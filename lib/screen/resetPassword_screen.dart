import 'package:flutter/material.dart';
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/main_title.dart';
import 'package:mori/widgets/text_field_input.dart';
import 'package:mori/widgets/validator.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  void sendEmail() async {
    String res = await AuthRepository().resetPassword(
      email: _emailController.text.trim(),
    );
    if (res != 'success') {
      res = '이메일 형식을 확인해주세요.';
      showSnackBar(res, context);
    } else {
      res = '이메일을 확인하여 비밀번호를 변경해주세요.';
      showSnackBar(res, context);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(flex: 75),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.25,
                // ),
                MainTitle(),
                eHeight(40),
                TextFieldInput(
                  textStyle: textStyle,
                  hintStyle: hintStyle,
                  validator: validateEmail(),
                  textEditingController: _emailController,
                  hintText: '이메일',
                  textInputType: TextInputType.emailAddress,
                  frefix: const Icon(Icons.email_rounded),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    sendEmail();
                  },
                  child: const Text(
                    '비밀번호 재발급',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Spacer(flex: 220),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
