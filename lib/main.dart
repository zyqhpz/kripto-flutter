import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'model/coins.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kripto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CoinsApi(),
    );
  }
}

class CoinsApi extends StatefulWidget {
  @override
  CoinsApiState createState() => CoinsApiState();
}

class CoinsApiState extends State<CoinsApi> {
  List<Coins> coinsFiltered = [];
  List<Coins> coins = [];

  TextEditingController _searchCoinController = TextEditingController();

  Future getCoinsData() async {
    var headers = {
      'x-rapidapi-host': 'coinlore-cryptocurrency.p.rapidapi.com',
      'x-rapidapi-key': '558fb3798cmsh92294f8271efaa3p1c6064jsnc33e1d3545fb'
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://coinlore-cryptocurrency.p.rapidapi.com/api/tickers/'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var jsonData = jsonDecode(responseBody);

    for (var c in jsonData['data']) {
      Coins coin = Coins(
          id: c['id'],
          name: c['name'],
          symbol: c['symbol'],
          rank: c['rank'],
          priceUsd: c['price_usd'],
          percentChange1h: c['percent_change_1h']);
      coins.add(coin);
    }
    print(coins.length);
    return coins;
  }

  Future searchCoin(String searchText) async {
    searchText = searchText.toLowerCase();

    List<Coins> coins;
    List<Coins> coinsFiltered = [];
    if (searchText.isEmpty) {
      coins = getCoinsData() as List<Coins>;
    } else {
      coins = getCoinsData() as List<Coins>;
      for (Coins coin in coins) {
        if (coin.name.toLowerCase().contains(searchText.toLowerCase())) {
          coinsFiltered.add(coin);
        }
      }
      // print(coinsFiltered.length);
    }

    // setState(() {
    //   this.coins = coinsFiltered;
    // });

    // return coinsFiltered;

    // final coins;
    // final coins = getCoinsData().whenComplete(() => );

    // lowercase the searchText

    // lowercase the coins name
  }

  // Widget searchBar() {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: TextField(
  //       decoration: InputDecoration(
  //         border: OutlineInputBorder(),
  //         labelText: 'Search',
  //       ),
  //       // filter the coins based on the search text
  //       onChanged: (value) {
  //         coins = coins.name.where(element);
  //       },
  //     ),
  //   );
  // }

  // Widget searchCoin() => SearchWidget(getCoinsData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kripto'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchCoinController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
              ),
              // filter the coins based on the search text
              onChanged: (value) {
                // coins = coins.name.where(element);
                if (value.isEmpty) {
                  setState(() {
                    coinsFiltered.clear();
                    _searchCoinController.clear();
                    setState(() {
                      _searchCoinController.text = '';
                    });
                    // coins = getCoinsData() as List<Coins>;
                  });
                } else {
                  value = value.toLowerCase();
                  setState(() {
                    coinsFiltered = coins.where((coin) {
                      return coin.name
                          .toLowerCase()
                          .contains(value.toLowerCase());
                    }).toList();
                  });
                  print(coinsFiltered.length);
                }
              },
            ),
          ),
          Expanded(
            child: Card(
              child: FutureBuilder(
                future: getCoinsData(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: _searchCoinController.text.isNotEmpty
                          ? coinsFiltered.length
                          : coins.length,
                      itemBuilder: (BuildContext context, int index) {
                        var coinPercent = _searchCoinController.text.isNotEmpty
                            ? coinsFiltered[index].percentChange1h
                            : coins[index].percentChange1h;
                        var colorPercent = coinPercent.contains('-')
                            ? Colors.red
                            : Colors.green;
                        var text = RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${_searchCoinController.text.isNotEmpty ? coinsFiltered[index].symbol : coins[index].symbol}',
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                  text:
                                      ' ${_searchCoinController.text.isNotEmpty ? coinsFiltered[index].percentChange1h : coins[index].percentChange1h} %',
                                  style: TextStyle(color: colorPercent)),
                            ],
                          ),
                        );
                        var textPercentPrice = RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '\$ ${snapshot.data[index].priceUsd}',
                              ),
                              TextSpan(
                                  text:
                                      ' ${snapshot.data[index].percentChange1h} %',
                                  style: TextStyle(color: colorPercent)),
                            ],
                          ),
                        );
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Text(
                              _searchCoinController.text.isNotEmpty
                                  ? coinsFiltered[index].rank.toString()
                                  : snapshot.data[index].rank.toString(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            // add if-else to check whether the image is null or not
                            // backgroundImage: NetworkImage(
                            //     'https://s2.coinmarketcap.com/static/img/coins/32x32/${snapshot.data[index].id}.png'),
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(0, 0, 0, 0.3),
                                width: 0.5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          // title: Text(snapshot.data[index].name),
                          title: Text(_searchCoinController.text.isNotEmpty
                              ? coinsFiltered[index].name
                              : snapshot.data[index].name),
                          // subtitle: Text(snapshot.data[index].symbol),
                          subtitle: text,
                          // put $ after price
                          trailing: Text(
                              '\$ ${_searchCoinController.text.isNotEmpty ? coinsFiltered[index].priceUsd : snapshot.data[index].priceUsd}'),
                          // trailing: textPercentPrice,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget searchBar() {
  return Container(
    child: TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Search',
      ),
    ),
  );
}
