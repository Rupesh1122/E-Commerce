// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:revision/Pages/home_detail_page.dart';
import 'package:revision/models/cart_Mode.dart';
import 'package:revision/utils/routs.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:revision/models/catalog.dart';
import 'package:revision/models/themes.dart';
import 'package:revision/utils/drawer.dart';
import 'package:revision/utils/item_widget.dart';
import 'package:cupertino_icons/cupertino_icons.dart';

import '../core/store.dart';

final cart = (VxState.store as MyStore).cart;
final catalog = (VxState.store as MyStore).catalog;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    loadData();
    setState(() {});
  }

  loadData() async {
    var catalogJson = await rootBundle.loadString("assets/files/catalog.json");
    var decodedData = jsonDecode(catalogJson);
    var productsData = decodedData["products"];
    CatalogModel.items = List.from(productsData)
        .map<Item>((item) => Item.fromMap(item))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int days = 23;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRouts.cartRount);
        },
        child: Icon(CupertinoIcons.cart),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              CatalogHeader(),
              if (CatalogModel.items.isNotEmpty && CatalogModel.items != null)
                CatalogList().py20().expand()
              else
                CircularProgressIndicator().centered().expand()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}

class CatalogList extends StatelessWidget {
  const CatalogList({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final catalog = CatalogModel.items[index];
        return InkWell(
          child: CatalogItem(catalog: catalog),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeDetailPage(catalog: catalog),
              )),
        );
      },
      itemCount: CatalogModel.items.length,
    );
  }
}

class CatalogHeader extends StatelessWidget {
  const CatalogHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: Vx.m32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Catalog App".text.xl5.semiBold.color(MyTheme.darkBluishColor).make(),
          "Trending Products".text.xl2.color(MyTheme.darkBluishColor).make()
        ],
      ),
    );
  }
}

class CatalogItem extends StatefulWidget {
  const CatalogItem({
    Key? key,
    required this.catalog,
  }) : super(key: key);
  final Item catalog;

  @override
  State<CatalogItem> createState() => _CatalogItemState();
}

class _CatalogItemState extends State<CatalogItem> {
  @override
  Widget build(BuildContext context) {
    bool isCarted = false;
    return VxBox(
      child: Row(
        children: [
          Hero(
              tag: Key(widget.catalog.id.toString()),
              child: CatalogImage(catalog: widget.catalog)
                  .box
                  .rounded
                  .color(MyTheme.creamColor)
                  .p8
                  .make()
                  .p16()
                  .w40(context)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.catalog.name.text.lg
                  .color(MyTheme.darkBluishColor)
                  .semiBold
                  .make(),
              widget.catalog.desc.text.caption(context).make(),
              ButtonBar(
                alignment: MainAxisAlignment.spaceBetween,
                children: [
                  "\$${widget.catalog.price}".text.bold.xl.red400.make(),
                  ElevatedButton(
                    onPressed: () {
                      cart.addItem(widget.catalog.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              "${widget.catalog.name} is added to your cart"
                                  .text
                                  .make(),
                          duration: Duration(milliseconds: 500),
                        ),
                      );
                      setState(() {});
                    },
                    child: "Add to Cart".text.make(),
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    ).white.rounded.square(150).make().p12();
  }
}

class CatalogImage extends StatelessWidget {
  const CatalogImage({
    super.key,
    required this.catalog,
  });

  final Item catalog;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      catalog.image,
    );
  }
}
