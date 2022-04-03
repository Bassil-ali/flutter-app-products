import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_products.dart';
import 'product_details.dart';
import 'products.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider<Products>(
      create: (_) => Products(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.orange,
          canvasColor: Color.fromRGBO(255, 238, 219, 1)),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Product> prodList =
        Provider.of<Products>(context, listen: true).productsList;

    Widget detailCard(id, tile, desc, price, imageUrl, ctx) {
      return FlatButton(
        onPressed: () {
          Navigator.push(
            ctx,
            MaterialPageRoute(builder: (_) => ProductDetails(id)),
          ).then((id) =>
              Provider.of<Products>(context, listen: false).delete(id));
        },
        child: Column(
          children: [
            SizedBox(height: 5),
            Card(
              elevation: 10,
              color: Color.fromRGBO(115, 138, 119, 1),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: EdgeInsets.only(right: 10),
                      width: 130,
                      child: Hero(
                        tag: id,
                        child: Image.network(imageUrl, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 10),
                        Text(
                          tile,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        Divider(color: Colors.white),
                        Container(
                          width: 200,
                          child: Text(
                            desc,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                            textAlign: TextAlign.justify,
                            maxLines: 3,
                          ),
                        ),
                        Divider(color: Colors.white),
                        Text(
                          "\$$price",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        SizedBox(height: 13),
                      ],
                    ),
                  ),
                  Expanded(flex: 1, child: Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('My Products')),
      body: prodList.isEmpty
          ? Center(
              child: Text('No Products Added.', style: TextStyle(fontSize: 22)))
          : ListView(
              children: prodList
                  .map(
                    (item) => Builder(
                        builder: (ctx) => detailCard(item.id, item.title,
                            item.description, item.price, item.imageUrl, ctx)),
                  )
                  .toList(),
            ),
      floatingActionButton: Container(
        width: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).primaryColor,
        ),
        child: FlatButton.icon(
          label: Text("Add Product",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
          icon: Icon(Icons.add),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddProduct())),
        ),
      ),
    );
  }
}
