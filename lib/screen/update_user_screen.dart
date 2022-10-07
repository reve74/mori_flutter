import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mori/provider/user_provider.dart';
import 'package:mori/repository/auth_repository.dart';
import 'package:mori/util/size_helper.dart';
import 'package:mori/utils.dart';
import 'package:mori/widgets/text_field_input.dart';
import 'package:mori/widgets/validator.dart';
import 'package:provider/provider.dart';
import 'package:mori/models/user.dart' as model;

class UpdateUserScreen extends StatefulWidget {
  final String uid;
  UpdateUserScreen({
    required this.uid,
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateUserScreen> createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final TextEditingController _nickNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Uint8List? _image;
  UserProvider? _userProvider;
  String? nickname;
  var profImage;

  // var userData = {};
  // bool _isLoading = false;

  void _selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void _deleteProfImage() {
    setState(() {
      profImage = '';
      _image = null;
    });
  }

  void updateUser() async {
    // if (_nickNameController.text == null) {
    //   _nickNameController.text = nickname!;
    // }
    if (_image != null || _nickNameController.text.isNotEmpty) {
      await AuthRepository().updateUser(
        _nickNameController.text,
        // _passwordController.text.trim(),
        _image,
        context,
      );

      Navigator.of(context).pop();
    } else if (_image == null && _nickNameController.text.isEmpty) {
      showSnackBar('프로필 사진 또는 닉네임을 변경해주세요!', context);
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider!.initialize();

    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 수정'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: updateUser,
            child: Text(
              '완료',
              style: ts,
            ),
          ),
        ],
      ),
      body: StreamBuilder<model.User>(
          stream: _userProvider!.currentUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasError) {
                return const Center(child: Text('에러가 있습니다'));
              }
              if (snapshot.hasData) {
                nickname = snapshot.data!.nickname;
                profImage = snapshot.data!.profImage;
                // List<int> list = snapshot.data!.profImage!.codeUnits;
                // Uint8List bytes = Uint8List.fromList(list);
                //
                // profImage = bytes;
                // String string = String.fromCharCodes(bytes);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: _image != null
                            ? CircleAvatar(
                                radius: 50,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : profImage != ''
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(snapshot.data!.profImage!),
                                  )
                                : _image != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: MemoryImage(_image!),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: ExactAssetImage(
                                            'assets/img/user.png'),
                                      ),
                      ),
                      TextButton(
                        onPressed: _selectImage,
                        child: const Text(
                          '프로필 사진 변경',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      TextFieldInput(
                        enable: false,
                        hintStyle: TextStyle(color: Colors.white38),
                        textStyle: textStyle,
                        hintText: snapshot.data!.email,
                        textInputType: TextInputType.text,
                        frefix: const Icon(Icons.email_rounded),
                      ),
                      eHeight(10),
                      TextFieldInput(
                        textStyle: textStyle,
                        hintStyle: hintStyle,
                        validator: validateNickname(),
                        textEditingController: _nickNameController,
                        hintText: snapshot.data!.nickname,
                        textInputType: TextInputType.text,
                        frefix: const Icon(Icons.account_circle_rounded),
                      ),
                      eHeight(10),
                      // TextFieldInput(
                      //   validator: validatePassword(),
                      //   textEditingController: _passwordController,
                      //   hintText: '비밀번호',
                      //   textInputType: TextInputType.text,
                      //   frefix: const Icon(Icons.lock),
                      //   isPass: true,
                      // ),
                    ],
                  ),
                );
              }
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Container();
          }),
    );
  }
}
