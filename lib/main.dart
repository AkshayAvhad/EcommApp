import 'package:ecomm/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecomm/features/products/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:ecomm/core/di/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => di.sl<CartBloc>())],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
        home: const ProductListPage(),
      ),
    );
  }
}
