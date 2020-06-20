import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:provider/provider.dart';
import 'componets/size_widget.dart';

class ProductScreen extends StatelessWidget {

  // Acessando o produto
  const ProductScreen(this.product);

  final Product product;

  @override
  Widget build(BuildContext context) {

    final primaryColor =  Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: product,
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.name),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1,
              child: Carousel(
                images: product.images.map((url){
                  return NetworkImage(url);
                }).toList(),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                dotColor: primaryColor,
                autoplay: false,
                //autoplayDuration: const Duration(seconds: 4),
                //animationDuration: const Duration(microseconds: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'A partir de',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ 19.99',
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: product.sizes.map((s){
                      return SizeWidget(size: s);
                    }).toList(),
                  ),
                  const SizedBox(height: 20,),
                  if(product.hasStock)
                  Consumer2<UserManeger, Product>(
                    builder: (_, userManager, product, __){
                      return SizedBox(
                        height: 44,
                        child: RaisedButton(
                          onPressed: product.selectedSize != null ? (){
                            if(userManager.isLoggedIn){
                              // TODO: ADICIONAR AO CARRINHO
                            } else {
                              Navigator.of(context).pushNamed('/login');
                            }
                          } : null,
                          color: primaryColor,
                            textColor: Colors.white,
                          child: Text(
                            // Verificando se o usuário estar logado
                            userManager.isLoggedIn
                                ? 'Adicionar ao Carrinho'
                                : 'Entre para Comprar',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      );
                  },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
