import 'package:flutter/material.dart';
import 'package:mori/provider/bottom_navigation_provider.dart';
import 'package:mori/screen/resetPassword_screen.dart';
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/screen/signup_screen.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/main_title.dart';
import 'package:mori/widgets/text_field_input.dart';
import 'package:mori/widgets/validator.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthRepository().loginUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    if (res != 'success') {
      res = '이메일 또는 비밀번호를 확인해주세요.';
      showSnackBar(res, context);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: FocusScope.of(context).unfocus,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Spacer(flex: 160),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.25,
                    // ),
                    MainTitle(),
                    eHeight(40),
                    Column(
                      children: [
                        TextFieldInput(
                          textStyle: textStyle,
                          hintStyle: hintStyle,
                          validator: validateEmail(),
                          textEditingController: _emailController,
                          hintText: '이메일',
                          textInputType: TextInputType.emailAddress,
                          frefix: const Icon(Icons.email_rounded),
                        ),
                        const SizedBox(height: 10),
                        TextFieldInput(
                          textStyle: textStyle,
                          hintStyle: hintStyle,
                          validator: validatePassword(),
                          textEditingController: _passwordController,
                          hintText: '비밀번호',
                          textInputType: TextInputType.text,
                          frefix: const Icon(Icons.lock),
                          isPass: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        loginUser();
                      },
                      child: const Text(
                        '로그인',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              AuthRepository().signInWithGoogle(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset('assets/img/google.png',
                                    height: 25),
                                const Text(
                                  '구글 로그인',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                          ),
                        ),
                        eWidth(10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              AuthRepository().signIngWithFacebook(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image.asset(
                                  'assets/img/facebook.png',
                                  height: 25,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  '페이스북 로그인',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ResetPasswordScreen()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              '비밀번호 찾기',
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacer(flex: 160),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            '계정이 없으신가요?  ',
                            // style: authText,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => SignupScreen()));
                          },
                          child: Container(
                            child: Text(
                              '회원가입',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              // style: authText.copyWith(
                              //   fontWeight: FontWeight.bold,
                              // ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
