import 'package:deal_cart/db/item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:deal_cart/db/dbHelper.dart';

class ItemDetails extends StatefulWidget {
  final Item item;
  const ItemDetails({Key key, this.item}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ItemDetailState(item);
  }
}

class ItemDetailState extends State<ItemDetails> {
  final Item item;

  DealCartDBHelper db;
  bool isFavorite = false;
  ItemDetailState(this.item);

  addToFavorite(context, item) async {
    if (isFavorite) {
      await db.removeFavorite(item);
    } else {
      await db.addToFavorite(item);
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  getItemFav() async {
    var favitems = await db.isFavoriteItem(item);
    setState(() {
      isFavorite = favitems.length > 0;
    });
  }

  @override
  void initState() {
    db = DealCartDBHelper();
    getItemFav();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        primary: true,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: 24.0,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_horiz,
              color: Colors.black,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Hero(tag: item.title, child: Image.network(item.image)),
              SizedBox(height: 10.0),
              Container(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(item.category,
                        style: TextStyle(
                          color: Colors.indigo,
                        )),
                    _renderTitleRow(),
                    Text(
                      item.price,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 18.0),
                    ),
                    SizedBox(height: 10.0),
                    _renderColors(item.colors),
                    _renderActions(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _renderColors(String itemcolors) {
    var colors = itemcolors.replaceAll('[', '').replaceAll(']', '').split(",");
    return Row(
      children: List.generate(colors.length, (int i) {
        var color = colors[i].replaceAll('#', '').trim();
        return Container(
          decoration: BoxDecoration(
            color: Color(int.parse('FF' + color, radix: 16)),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          margin: EdgeInsets.all(5.0),
          width: 30.0,
          height: 30.0,
        );
      }),
    );
  }

  Row _renderTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          item.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32.0),
        ),
        IconButton(
          icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          onPressed: () {
            addToFavorite(context, item);
          },
          color: Colors.indigo,
        )
      ],
    );
  }

  Row _renderActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Expanded(
          child: MaterialButton(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
            ),
            textColor: Colors.white,
            color: Colors.indigo,
            padding: EdgeInsets.all(12.0),
            onPressed: () => null,
            child: Text(
              'Add to Cart',
              textScaleFactor: 1.2,
            ),
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Expanded(
          child: MaterialButton(
            shape: new RoundedRectangleBorder(
              side: BorderSide(width: 2.0, color: Colors.indigo),
              borderRadius: new BorderRadius.circular(8.0),
            ),
            padding: EdgeInsets.all(12.0),
            onPressed: () => null,
            child: Text(
              'Buy Now',
              textScaleFactor: 1.2,
            ),
          ),
        )
      ],
    );
  }
}
