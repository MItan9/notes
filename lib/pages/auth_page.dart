import 'package:flutter/material.dart';
import 'package:notes/pages/home.dart';

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _surnameController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true; // Флаг для переключения между режимами входа и регистрации

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submitForm() {
    final name = _nameController.text;
    final surname = _surnameController.text;
    final birthdate = _birthdateController.text;
    final login = _loginController.text;
    final password = _passwordController.text;

    if (_isLogin) {
      // Вход существующего пользователя
      // Пример: Проверяем, что логин и пароль не пустые
      if (login.isNotEmpty && password.isNotEmpty) {
        // Выполняем вход
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Home(), // Переход к окну категорий
        ));
      }
    } else {
      // Регистрация нового пользователя
      // Пример: Проверяем, что все необходимые поля заполнены
      if (name.isNotEmpty && surname.isNotEmpty && birthdate.isNotEmpty && login.isNotEmpty && password.isNotEmpty) {
        // Создайте новый аккаунт с введенными данными

        // Здесь вы можете добавить код для регистрации с помощью Google

        // После успешной регистрации:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registration Successful'),
            content: Text('You have successfully registered an account.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => AuthPage(), // Переход к окну входа
                  ));
                },
                child: Text('OK', style: TextStyle(color: Colors.black)), // Изменить цвет текста
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Welcome to the Note application!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              if (!_isLogin)
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
              if (!_isLogin)
                TextFormField(
                  controller: _surnameController,
                  decoration: InputDecoration(labelText: 'Surname'),
                ),
              if (!_isLogin)
                TextFormField(
                  controller: _birthdateController,
                  decoration: InputDecoration(labelText: 'Birthdate'),
                ),
              TextFormField(
                controller: _loginController,
                decoration: InputDecoration(labelText: 'Login'),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(_isLogin ? 'Login' : 'Register'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber, // Изменить цвет кнопки
                ),
              ),
              TextButton(
                onPressed: _toggleMode,
                child: Text(
                  _isLogin ? 'Create an account' : 'I already have an account',
                  style: TextStyle(color: Colors.black), // Изменить цвет текста
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
