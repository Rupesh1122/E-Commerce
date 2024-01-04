import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:revision/core/store.dart';
import 'package:revision/models/cart_Mode.dart';
import 'package:revision/models/catalog.dart';
import 'package:revision/models/themes.dart';
import 'package:velocity_x/velocity_x.dart';

final cart = (VxState.store as MyStore).cart;
final catalog = (VxState.store as MyStore).catalog;

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        title: "Cart".text.make(),
      ),
      backgroundColor: MyTheme.creamColor,
      body: Column(children: [
        _CartList().px16().expand(),
        Divider(),
        _CartTotal(),
      ]),
    );
  }
}

class _CartTotal extends StatefulWidget {
  const _CartTotal({super.key});

  @override
  State<_CartTotal> createState() => _CartTotalState();
}

class _CartTotalState extends State<_CartTotal> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VxConsumer(
            builder: (context, store, status) => "\$${cart.totalPrice}"
                .text
                .color(MyTheme.darkBluishColor)
                .xl4
                .make(),
            mutations: {RemoveMutaion},
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: "Buying not supported yet".text.make()));
            },
            child: "Buy".text.make(),
          )
        ],
      ).px12(),
    );
  }
}

class _CartList extends StatelessWidget {
  const _CartList({super.key});
  @override
  Widget build(BuildContext context) {
    VxState.watch(context, on: [RemoveMutaion]);
    return ListView.builder(
      itemCount: cart.cartItems.length,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.done),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            RemoveMutaion(cart.cartItems[index]);
            // setState(() {});
          },
        ),
        title: Text(cart.cartItems[index].name.toString()),
      ),
    );
  }
}
