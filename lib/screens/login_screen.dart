import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/login_bloc.dart';
import 'package:gerenteloja/screens/home_screen.dart';
import 'package:gerenteloja/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();

  @override
  void initState() {
    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
          break;
        case LoginState.FAIL:
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Erro'),
                    content: Text('Você não possui os privilégios necessários'),
                  ));
          break;
        case LoginState.IDLE:
        case LoginState.LOADING:
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _loginBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case LoginState.LOADING:
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
                ),
              );

            case LoginState.FAIL:
            case LoginState.IDLE:
            case LoginState.SUCCESS:
              return Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                            Icons.store_mall_directory,
                            size: 160,
                            color: Colors.pinkAccent,
                          ),
                          InputField(
                            icon: Icons.person_outline,
                            hint: 'Usuario',
                            obscure: false,
                            stream: _loginBloc.outEmail,
                            onChanged: _loginBloc.changedEmail,
                          ),
                          InputField(
                            icon: Icons.lock_outline,
                            hint: 'Senha',
                            obscure: true,
                            stream: _loginBloc.outPass,
                            onChanged: _loginBloc.changedPass,
                          ),
                          SizedBox(
                            height: 24,
                          ),
                          StreamBuilder<bool>(
                            stream: _loginBloc.outSubmited,
                            builder: (context, snapshot) {
                              return SizedBox(
                                height: 40,
                                child: RaisedButton(
                                  color: Colors.pinkAccent,
                                  child: Text('Entrar'),
                                  textColor: Colors.white,
                                  onPressed: snapshot.hasData
                                      ? _loginBloc.submited
                                      : null,
                                  disabledColor:
                                      Colors.pinkAccent.withAlpha(140),
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
