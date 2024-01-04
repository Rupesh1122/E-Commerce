import 'package:flutter/material.dart';
import 'package:revision/core/store.dart';
import 'package:velocity_x/velocity_x.dart';
import 'catalog.dart';

class CartModel {
  static final cartModel = CartModel._internal();

  CartModel._internal();

  factory CartModel() => cartModel;
  List<Item> cartItems = [];
  final catalog = CatalogModel();

  addItem(int id) {
    cartItems.add(catalog.getById(id));
  }

  removeItem(int index) {
    cartItems.removeAt(index);
  }

  set totalPrice(num value) {
    totalPrice = value;
  }

  num get totalPrice =>
      cartItems.fold(0, (total, current) => total + current.price);
}

class RemoveMutaion extends VxMutation<MyStore> {
  final Item item;

  RemoveMutaion(this.item);
  @override
  perform() {
    store!.cart.cartItems.remove(item);
  }
}
