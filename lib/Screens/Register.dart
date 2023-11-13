import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:minhas_financas/Database/database_Helper.dart';
import 'package:minhas_financas/Models/Models.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuário'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nome de Usuário'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Senha'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira uma senha';
                } else if (value.length < 6) {
                  return 'A senha deve conter pelo menos 6 caracteres';
                }
                /*Caso deseje validar a senha com caracteres especiais (value.contains(caracter))*/
                return null;
              },
              onSaved: (value) {
                _password = value!;
              },
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, insira um e-mail';
                } else if (!isValidEmail(value!)) {
                  return 'E-mail inválido';
                }
                return null;
              },
              onSaved: (value) {
                _email = value!;
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Implemente a lógica de registro aqui
                Map<String, dynamic> row = {
                  model_usuario.columnUsuario: this._usernameController.text,
                  model_usuario.columnEmail: this._emailController.text,
                  // model_usuario.columnUsuarioId: 1,
                  model_usuario.columnSenha: this._passwordController.text
                };
                var l_Database = DatabaseHelper.instance;
                l_Database.insert(row);
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // Expressão regular para validar um endereço de e-mail
    final emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
}
