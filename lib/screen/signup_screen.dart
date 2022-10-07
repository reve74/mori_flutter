import 'package:flutter/material.dart';
import 'package:mori/screen/tos_screen.dart';
import 'package:mori/util/colors.dart';
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/main_title.dart';
import 'package:mori/widgets/text_field_input.dart';
import 'package:mori/widgets/validator.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nickNameController = TextEditingController();
  bool _isChecked = false;

  void signUpUser() async {
    String res = await AuthRepository().signUpUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      nickname: _nickNameController.text.trim(),
      context: context,
    );
    if (res != 'success') {
      print('error');
    } else {
      print('signup');
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = MediaQuery.of(context).padding.top - 5;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreyClr,
      ),
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
                    Spacer(flex: 75),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.25 -
                    //       MediaQuery.of(context).padding.top -
                    //       5,
                    // ),
                    MainTitle(),
                    eHeight(40),
                    Form(
                      key: _formKey,
                      child: Column(
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
                            validator: validateNickname(),
                            textEditingController: _nickNameController,
                            hintText: '닉네임',
                            textInputType: TextInputType.text,
                            frefix: const Icon(Icons.account_circle_rounded),
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
                    ),
                    eHeight(10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '이용 약관 및 개인정보 처리 방침',
                              style: TextStyle(fontSize: 13),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TosScreen()));
                              },
                              child: Text(
                                '전문 보기',
                                style:
                                    TextStyle(fontSize: 13, color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '확인했습니다.',
                              style: TextStyle(fontSize: 13),
                            ),
                            Checkbox(
                              value: _isChecked,
                              activeColor: Colors.grey,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                                print(_isChecked);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    eHeight(10),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _isChecked == true) {
                          signUpUser();
                        }
                        if (_formKey.currentState!.validate() &&
                            _isChecked == false) {
                          showSnackBar('이용 약관에 동의해주세요', context);
                        }
                      },
                      child: Text(
                        '회원가입 완료',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Spacer(flex: 160),
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
