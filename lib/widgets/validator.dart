import 'package:flutter/cupertino.dart';
import 'package:mori/utils.dart';
import 'package:validators/validators.dart';

Function validateNickname() {
  return (String? value) {
    if(value!.isEmpty) {
      return "닉네임을 입력해주세요";
    }else if(value.length < 2 || value.length > 12) {
      return "닉네임의 길이를 확인해주세요.";
    }else {
      return null;
    }
  };
}

Function validatePassword() {
  return (String? value) {
    if(value!.isEmpty) {
      return "비밀번호를 입력해주세요.";
    }else if(value.length < 6 || value.length >12) {
      return "비밀번호는 6 -12자리여아 합니다.";
    }else {
      return null;
    }
  };
}

Function validateEmail() {
  return (String? value) {
    if(value!.isEmpty) {
      return "이메일을 입력해주세요";
    }else if(!isEmail(value)) {
      return "이메일 형식에 맞지 않습니다.";
    }else {
      return null;
    }
  };
}

Function validateReview(BuildContext context) {
  return (String? value) {
    if(value!.isEmpty || value.length < 2) {
      return showSnackBar('2글자 이상 입력해주세요', context);
    }else {
      return null;
    }
  };
}