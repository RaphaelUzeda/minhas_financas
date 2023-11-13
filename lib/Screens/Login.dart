import 'package:flutter/material.dart';
import 'package:minhas_financas/Database/database_Helper.dart';
import 'package:minhas_financas/Models/Models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late int userId;

  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.monetization_on_outlined,
              color: Colors.green,
              size: 100,
            ),
            Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.green,
                      Colors.white,
                    ],
                  ),
                  border: Border.all(
                      color: const Color(0xFF000000),
                      width: 2.0,
                      style: BorderStyle.solid), //Border.all
                  /*** The BorderRadius widget  is here ***/
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ), //BorderRadius.all
                ), //BoxDecoration
                child: Column(
                  children: [
                    TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Nome de Usuário',
                          floatingLabelAlignment: FloatingLabelAlignment.center,
                          contentPadding: EdgeInsets.fromLTRB(20, 19, 20, 10),
                        ),
                        textAlign: TextAlign.center,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor, insira uma senha';
                          }
                        }),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        floatingLabelAlignment: FloatingLabelAlignment.center,
                        contentPadding: EdgeInsets.fromLTRB(20, 19, 20, 10),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.center,
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
                  ],
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    var l_Database = DatabaseHelper.instance;

                    final l_user = await l_Database.getUsuario(
                        _usernameController.text, _passwordController.text);
                    var teste = await l_Database.getProfile();
                    if (l_user != null || l_user != '') {
                      saveUserId(int.parse(l_user.usuarioId.toString()));
                      Navigator.pushNamed(context, '/home');
                    }
                  },
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Text('Registrar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('user_id');
    setState(() {
      userId = storedUserId!;
    });
  }

  Future<void> saveUserId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', id);
  }
}
