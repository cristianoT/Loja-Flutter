import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/cart_product.dart';
import 'package:lojavirtual/models/product.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class CartManager extends ChangeNotifier {
  List<CartProduct> items = [];

  // Salvando o usuário logado
  User user;
  num productsPrice = 0.0;

  // Atualizando o usuário logado
  void updateUser(UserManeger userManeger) {
    user = userManeger.user;
    items.clear();

    // Verificando se o usuário é diferente de nulo
    if (user != null) {
      _loadCartItems();
    }
  }

  // Carregando as informações do carrinho do usuário logado
  Future<void>_loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();

    // Pegando os documentos
    items = cartSnap.documents.map(
            (d) =>
        CartProduct.fromDocument(d)
          ..addListener(_onItemUpdated)
    ).toList();
  }

  // Adicionando produto ao carrinho
  void addToCart(Product product) {
    try {
      // Procurando itens que podem empilhar (sendo iguais e com mesmo tamanho)
      final e = items.firstWhere((p) => p.stackable(product));
      e.increment();
    } catch (e) {
      final cartProduct = CartProduct.fromProduct(product);
      // Atualizando os itens do carrinho
      cartProduct.addListener(_onItemUpdated);
      // Transformando o produto em produto que pode adicionar ao carrinho
      items.add(cartProduct);

      // Salvando o carrinho
      user.cartReference
          .add(cartProduct.toCartItemMap())
          .then((doc) => cartProduct.id = doc.documentID);
      _onItemUpdated();
    }
    notifyListeners();
  }

  // Removendo o item do carrinho
  void removeOfCart(CartProduct cartProduct) {
    items.removeWhere((p) => p.id == cartProduct.id);
    // Removendo do FireBase
    user.cartReference.document(cartProduct.id).delete();
    cartProduct.removeListener(_onItemUpdated);
    notifyListeners();
  }

  // Atualizando a quantidade dos itens no FireBase
  void _onItemUpdated() {
    productsPrice = 0.0;

    // Acessando cada um dos itens no carrinho
    for (int i = 0; i < items.length; i++) {
      final cartProduct = items[i];

      // Verificando se o item é igual a zero
      if (cartProduct.quantity == 0) {
        removeOfCart(cartProduct);
        i--;
        continue;
      }

      productsPrice += cartProduct.totalPrice;

      _updateCartProduct(cartProduct);
    }

    notifyListeners();
  }

  // Função para atualizar o carrinho
  void _updateCartProduct(CartProduct cartProduct) {
    if (cartProduct.id != null) {
      user.cartReference.document(cartProduct.id)
          .updateData(cartProduct.toCartItemMap());
    }
  }

  // Verificando se em todos os carrinho tem estoque o suficiente
  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

}