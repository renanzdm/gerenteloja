import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerenteloja/validators/login_validators.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState { IDLE, LOADING, SUCCESS, FAIL }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _passController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail =>_emailController.stream.transform(validateEmail);
  Stream<String> get outPass => _passController.stream.transform(validatePass);
  Stream<LoginState> get outState => _stateController.stream;
  Stream<bool> get outSubmited => Observable.combineLatest2(outEmail, outPass, (a, b) => true);

  StreamSubscription _streamSubscription;

  LoginBloc() {

    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user) async {
      if (user != null) {
        if (await verifyPrivileges(user)) {
          _stateController.sink.add(LoginState.SUCCESS);
        } else {
          FirebaseAuth.instance.signOut();
          _stateController.sink.add(LoginState.FAIL);
        }
      } else {
        _stateController.sink.add(LoginState.IDLE);
      }
    });
  }

  void submited() {
    final email = _emailController.value;
    final pass = _passController.value;

    _stateController.sink.add(LoginState.LOADING);

    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass)
        .catchError((e) {
      _stateController.sink.add(LoginState.FAIL);
    });
  }

  Future<bool> verifyPrivileges(FirebaseUser user) async {
    return await Firestore.instance
        .collection('admins')
        .document(user.uid)
        .get()
        .then((doc) {
      if (doc.data != null) {
        return true;
      } else {
        return false;
      }
    }).catchError((e) {
      return false;
    });
  }

  Function(String) get changedEmail => _emailController.sink.add;
  Function(String) get changedPass => _passController.sink.add;

  @override
  void dispose() {
    _emailController.close();
    _passController.close();
    _stateController.close();
    _streamSubscription.cancel();
    super.dispose();
  }
}
