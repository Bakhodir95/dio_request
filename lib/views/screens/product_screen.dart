import 'package:dio_request/models/product.dart';
import 'package:dio_request/services/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductService productService = ProductService();
  final _titleController = TextEditingController();
  final _subtitleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: FutureBuilder<List<Product>>(
        future: productService.listProducts(),
        // wscfvfgfhjkl
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Product> products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                var product = products[index];
                return ListTile(
                  title: Text(product.title),
                  subtitle: Text(product.price.toString()),
                  leading: Image.network(product.images[0]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(product.title),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: _titleController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "New Title..."),
                                    ),
                                    const Gap(10),
                                    TextField(
                                      controller: _subtitleController,
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: "New Subtitle..."),
                                    )
                                  ],
                                ),
                                actions: [
                                  OutlinedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                  FilledButton(
                                      onPressed: () {
                                        productService.updateProduct(
                                            product.id.toString(), {
                                          "title": _titleController.text,
                                          "price": _subtitleController.text
                                        });
                                        setState(() {});
                                        Navigator.of(context).pop();
                                        _titleController.clear();
                                        _subtitleController.clear();
                                      },
                                      child: const Text("Save"))
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          productService.deleteProduct(product.id.toString());
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }
}
