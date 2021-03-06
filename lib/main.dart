import 'package:flutter/material.dart';
import 'package:lojavirtual/models/admin_user_manager.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/models/order.dart';
import 'package:lojavirtual/models/order_manager.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/product_manager.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:lojavirtual/screens/base/base_screen.dart';
import 'package:lojavirtual/screens/cart/cart_sreen.dart';
import 'package:lojavirtual/screens/checkout/checkout_screen.dart';
import 'package:lojavirtual/screens/confirmation/confirmation_screen.dart';
import 'package:lojavirtual/screens/edit_product/edit_prodcut_screen.dart';
import 'package:lojavirtual/screens/login/login_screen.dart';
import 'package:lojavirtual/screens/product/product_screen.dart';
import 'package:lojavirtual/screens/select_product/select_product_screen.dart';
import 'package:lojavirtual/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';
import 'screens/address/address_screen.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Tela USUÁRIO
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManeger(),
          lazy: false,
        ),

        // Tela de PRODUTOS
        ChangeNotifierProvider(
          create: (_) => ProductManager(),
          lazy: false,
        ),

        // Tela HOME
        ChangeNotifierProvider(
          create: (_) => HomeManager(),
          lazy: false,
        ),

        // Tela do CARRINHO
        ChangeNotifierProxyProvider<UserManeger, CartManager>(
          create: (_) => CartManager(),
          lazy: false,
          update: (_, userManager, cartManager) =>
              cartManager..updateUser(userManager),
        ),

        // Gerenciador de pedidos
        ChangeNotifierProxyProvider<UserManeger, OrdersManager>(
          create: (_) => OrdersManager(),
          lazy: false,
          update: (_, userManager, ordersManager) =>
              ordersManager..updateUser(userManager.user),
        ),

        // Tela ADMINISTRADOR
        ChangeNotifierProxyProvider<UserManeger, AdminUserManager>(
          create: (_) => AdminUserManager(),
          lazy: false,
          update: (_, userManager, adminUserManager) =>
              adminUserManager..updateUser(userManager),
        )
      ],
      child: MaterialApp(
        title: 'Lock da Vez',
        // Retirando o icone do debug
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Definindo uma cor primária
          primaryColor: const Color.fromARGB(255, 4, 125, 141),
          // Definindo a cor do background
          scaffoldBackgroundColor: const Color.fromARGB(255, 4, 125, 141),
          // Retirando a elevação da AppBar
          appBarTheme: const AppBarTheme(elevation: 0
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        initialRoute: '/base',
        onGenerateRoute: (settings){
          switch(settings.name){
            case '/login' :
              return MaterialPageRoute(
                  builder: (_) => LoginScreen()
              );

              case '/signup' :
              return MaterialPageRoute(
                builder: (_) => SignUpScreen()
              );

            case '/product':
              return MaterialPageRoute(
                  builder: (_) => ProductScreen(settings.arguments as Product));

            case '/cart':
              return MaterialPageRoute(
                  builder: (_) => CartScreen(), settings: settings);

            case '/address':
              return MaterialPageRoute(builder: (_) => AddressScreen());

            case '/checkoud':
              return MaterialPageRoute(builder: (_) => CheckoutScreen());

            case '/edit_product':
              return MaterialPageRoute(
                  builder: (_) =>
                      EditProductScreen(settings.arguments as Product));

            case '/select_product':
              return MaterialPageRoute(builder: (_) => SelectProdutScreen());

            case '/confirmation':
              return MaterialPageRoute(builder: (_) =>
                  ConfirmationScreen(
                      settings.arguments as Order
                  ));

            case '/base':
            default:
              return MaterialPageRoute(
                  builder: (_) => BaseScreen(), settings: settings);
          }
        },
      ),
    );
  }
}


