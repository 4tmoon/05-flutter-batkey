import 'dart:math';

import 'package:batmankey/app_theme.dart';
import 'package:batmankey/password_generator.dart';
import 'package:batmankey/pin_password_generator.dart';
import 'package:batmankey/standard_password_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(BatKeyApp());
}

class BatKeyApp extends StatelessWidget {
  const BatKeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      title: "BatKey",
      home: BatKeyScreen(),
    );
  }
}

class BatKeyScreen extends StatefulWidget {
  const BatKeyScreen({super.key});

  @override
  State<BatKeyScreen> createState() => _IronKeyScreenState();
}

class _IronKeyScreenState extends State<BatKeyScreen> {
  final TextEditingController _passwordController = TextEditingController();

  // controle da opcao selecionada
  PasswordType passwordSelectedType = PasswordType.pin;
  bool isEditable = false;

  @override
  // inicializacao do estado
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  // desconstrucao do estado
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  void copyPassword(String password) {
    Clipboard.setData(ClipboardData(text: password));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Senha copiada!')));
  }

  void generatePassword() {
    // inicializacao tardia
    late final PasswordGenerator generator;

    switch (passwordSelectedType) {
      case PasswordType.pin:
        generator = PinPasswordGenerator();
        break;
      case PasswordType.standart:
        generator = StandardPasswordGenerator();
        break;
    }

    setState(() {
      _passwordController.text = generator.generate(8);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          "assets/images/batman.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Sua senha",
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      enabled: isEditable,
                      controller: _passwordController,
                      maxLength: 12,
                      decoration: InputDecoration(
                        labelText: "Password",
                        border: OutlineInputBorder(),
                        prefix: Icon(Icons.lock),
                        suffix: _passwordController.text.isNotEmpty
                            ? IconButton(
                                onPressed: () {
                                  copyPassword(_passwordController.text);
                                },
                                icon: Icon(Icons.copy),
                              )
                            : null,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Tipo de senha"),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile(
                            value: PasswordType.pin,
                            groupValue: passwordSelectedType,
                            title: Text("Pin"),
                            onChanged: (value) {
                              setState(() {
                                passwordSelectedType = value!;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: RadioListTile(
                            value: PasswordType.standart,
                            groupValue: passwordSelectedType,
                            title: Text("Senha padrão"),
                            onChanged: (value) {
                              setState(() {
                                passwordSelectedType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Divider(color: colorScheme.outline),
                    Row(
                      children: [
                        Icon(isEditable ? Icons.lock_open : Icons.lock),
                        SizedBox(width: 8),
                        Expanded(child: Text("Permitir editar a senha?")),
                        Switch(
                          value: isEditable,
                          onChanged: (value) {
                            setState(() {
                              isEditable = value;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(color: colorScheme.outline),
                    const SizedBox(height: 20),

                    if (isEditable) Text("Senha customizada"),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: generatePassword,
                  child: Text("Gerar senha"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum PasswordType { pin, standart }
