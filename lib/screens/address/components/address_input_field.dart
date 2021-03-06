import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lojavirtual/models/address.dart';
import 'package:lojavirtual/models/cart_manager.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField(this.address);

  final Address address;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    // Validador dos compos do endereço
    String emptyValidator(String text) =>
        text.isEmpty ? 'Campo obrigatório' : null;

    // Verificando se o CEP foi preenchido
    if (address.zipCode != null && cartManager.deliveryPrince == null) {
      return GestureDetector(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Campo da Rua
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av.Brasil',
            ),
            validator: emptyValidator,
            onSaved: (t) => address.street = t,
          ),

          Row(
            children: <Widget>[
              Expanded(
                // Campo do Número
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.number,
                  decoration: const InputDecoration(
                      isDense: true, labelText: 'Número', hintText: '123'),
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidator,
                  onSaved: (t) => address.number = t,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                // Campo complemento
                child: TextFormField(
                  enabled: !cartManager.loading,
                  initialValue: address.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (t) => address.complement = t,
                ),
              )
            ],
          ),

          // Campo do Bairro
          TextFormField(
            enabled: !cartManager.loading,
            initialValue: address.district,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Bairro',
              hintText: 'Bom Sucesso',
            ),
            validator: emptyValidator,
            onSaved: (t) => address.district = t,
          ),

          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                // Campo Cidade
                child: TextFormField(
                  enabled: false,
                  initialValue: address.city,
                  decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Cidade',
                      hintText: 'Rio de Janeiro'),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                // Campo da UF do Estado
                child: TextFormField(
                  autocorrect: false,
                  enabled: false,
                  textCapitalization: TextCapitalization.characters,
                  initialValue: address.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'RJ',
                    counterText: '',
                  ),
                  maxLength: 2,
                  validator: (e) {
                    // Verificando se o campo foi preenchido
                    if (e.isEmpty) {
                      return 'Campo obrigatório';
                    } else if (e.length != 2) {
                      return 'Inválido';
                    }
                    return null;
                  },
                  onSaved: (t) => address.state = t,
                ),
              )
            ],
          ),

          const SizedBox(
            height: 8,
          ),

          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.transparent,
            ),

          // Botão Calcular Frete
          RaisedButton(
            color: primaryColor,
            disabledColor: primaryColor.withAlpha(100),
            textColor: Colors.white,
            onPressed: !cartManager.loading
                ? () async {
                    // Validando os campos
                    if (Form.of(context).validate()) {}
                    // Salvando as informações nos campos correpontendes
                    Form.of(context).save();
                    // Acessando o CartManager para informa o endereço que ire utilizar
                    try {
                      await context.read<CartManager>().setAddress(address);
                    } catch (e) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('$e'),
                        backgroundColor: Colors.red,
                      ));
                    }
                    FocusScope.of(context).requestFocus(FocusNode());
                  }
                : null,

            // Widget do botão do Calcular Frete
            child: const Text('Calcular Frete'),
          )
        ],
      ));

      // Widget da informação do endereço do delivery
    } else if (address.zipCode != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child:
        Text('${address.street}, ${address.number}\n${address.district}\n'
            '${address.city} - ${address.state}'),
      );
    } else {
      return Container();
    }
  }
}
