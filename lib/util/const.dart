import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

const API_KEY = 'API_KEY';
const LANGUAGE = 'ko-KR';

const Poster = 'https://image.tmdb.org/t/p/w500/';
const EmailAdress = 'revev99@gmail.com';

const Inquire = '[Mori] 문의사항';
const InquireMessage = '가입한 이메일 계정과 \n문의사항을 입력해주세요';

const Report = '[Mori] 신고';
// const ReportMessage = '';


FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseStorage firebaseStorage = FirebaseStorage.instance;
