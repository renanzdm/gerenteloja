import 'dart:async';

class LoginValidators{

  final validateEmail = StreamTransformer<String,String>.fromHandlers(
    handleData: (email,sink){
      if(email.contains('@')){
        sink.add(email);
      }else{
        sink.addError('Insira email valido');
      }
    }
  );
  final validatePass = StreamTransformer<String, String>.fromHandlers(
    handleData:(pass,sink) {
    if(pass.length > 4){
      sink.add(pass);
    }else{
      sink.addError('Senha invalida, insira senha com mais de 4 caracteres');
    }
    }
  );


}
