import 'package:ecomm/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ecomm/features/auth/presentation/bloc/auth_event.dart';
import 'package:ecomm/features/auth/presentation/bloc/auth_state.dart';
import 'package:ecomm/features/products/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => ProductListPage()),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: .all(20),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              TextField(
                controller: _userController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    LoginRequested(_userController.text, _passController.text),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
