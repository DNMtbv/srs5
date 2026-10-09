import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'user_info_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _storyFocus = FocusNode();
  final _passFocus = FocusNode();
  final _confirmPassFocus = FocusNode();

  final List<String> _countries = const [
    'Kazakhstan',
    'Russia',
    'Uzbekistan',
    'Kyrgyzstan',
    'USA',
    'Germany',
  ];
  String? _selectedCountry;

  bool _hidePass = true;
  bool _hideConfirmPass = true;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  // Заполняем форму ранее сохранёнными данными (кроме пароля)
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _phoneController.text = prefs.getString('phone') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _storyController.text = prefs.getString('story') ?? '';
      final country = prefs.getString('country');
      if (_countries.contains(country)) _selectedCountry = country;
    });
  }

  @override
  void dispose() {
    for (final c in [
      _nameController,
      _phoneController,
      _emailController,
      _storyController,
      _passController,
      _confirmPassController,
    ]) {
      c.dispose();
    }
    for (final f in [
      _nameFocus,
      _phoneFocus,
      _emailFocus,
      _storyFocus,
      _passFocus,
      _confirmPassFocus,
    ]) {
      f.dispose();
    }
    super.dispose();
  }

  void _fieldFocusChange(FocusNode current, FocusNode next) {
    current.unfocus();
    FocusScope.of(context).requestFocus(next);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      _showMessage('Форма заполнена неверно! Проверьте поля.');
      return;
    }
    _formKey.currentState!.save();

    final user = User(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      country: _selectedCountry!,
      story: _storyController.text.trim(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user.name);
    await prefs.setString('phone', user.phone);
    await prefs.setString('email', user.email);
    await prefs.setString('country', user.country);
    await prefs.setString('story', user.story);

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => UserInfoPage(user: user)),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  String? _validateName(String? value) {
    final nameExp = RegExp(r'^[A-Za-zА-Яа-яЁё ]+$');
    if (value == null || value.trim().isEmpty) return 'Имя обязательно.';
    if (!nameExp.hasMatch(value)) return 'Введите только буквы.';
    return null;
  }

  String? _validatePhone(String? value) {
    final phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d-\d\d\d\d$');
    if (value == null || value.isEmpty) return 'Телефон обязателен.';
    if (!phoneExp.hasMatch(value)) return 'Формат: (XXX)XXX-XXXX';
    return null;
  }

  String? _validateEmail(String? value) {
    final emailExp = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (value == null || value.isEmpty) return 'Email обязателен.';
    if (!emailExp.hasMatch(value)) return 'Неверный адрес email.';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Пароль обязателен.';
    if (value.length < 8) return 'Минимум 8 символов.';
    return null;
  }

  String? _validateConfirm(String? value) {
    if (value != _passController.text) return 'Пароли не совпадают.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Form'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocus,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _fieldFocusChange(_nameFocus, _phoneFocus),
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'What do people call you?',
                prefixIcon: const Icon(Icons.person),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _nameController.clear(),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                errorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _fieldFocusChange(_phoneFocus, _emailFocus),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d()\-]')),
              ],
              decoration: InputDecoration(
                labelText: 'Phone Number *',
                hintText: 'Where can we reach you?',
                helperText: 'Phone format: (XXX)XXX-XXXX',
                prefixIcon: const Icon(Icons.call),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _phoneController.clear(),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: _validatePhone,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) => _fieldFocusChange(_emailFocus, _storyFocus),
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'Enter an email address',
                icon: Icon(Icons.mail),
              ),
              validator: _validateEmail,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _selectedCountry,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.map),
                labelText: 'Country?',
              ),
              items: _countries
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCountry = value),
              validator: (value) => value == null ? 'Выберите страну.' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _storyController,
              focusNode: _storyFocus,
              maxLines: 3,
              maxLength: 100,
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              decoration: const InputDecoration(
                labelText: 'Life Story',
                hintText: 'Tell us about yourself',
                helperText: 'Keep it short, this is just a demo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passController,
              focusNode: _passFocus,
              obscureText: _hidePass,
              maxLength: 8,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) =>
                  _fieldFocusChange(_passFocus, _confirmPassFocus),
              decoration: InputDecoration(
                labelText: 'Password *',
                hintText: 'Enter the password',
                icon: const Icon(Icons.security),
                suffixIcon: IconButton(
                  icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _hidePass = !_hidePass),
                ),
              ),
              validator: _validatePassword,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmPassController,
              focusNode: _confirmPassFocus,
              obscureText: _hideConfirmPass,
              maxLength: 8,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submitForm(),
              decoration: InputDecoration(
                labelText: 'Confirm Password *',
                hintText: 'Confirm the password',
                icon: const Icon(Icons.border_color),
                suffixIcon: IconButton(
                  icon: Icon(
                      _hideConfirmPass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () =>
                      setState(() => _hideConfirmPass = !_hideConfirmPass),
                ),
              ),
              validator: _validateConfirm,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Submit Form', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
