import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'coins.dart';

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
  Future getCoinsData() async {
    List<Coins> coins = [];

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
          priceUsd: c['price_usd']);
      coins.add(coin);
    }
    print(coins.length);
    return coins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kripto'),
      ),
      body: Container(
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
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Text(
                          snapshot.data[index].rank.toString(),
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        // add if-else to check whether the image is null or not
                        // backgroundImage: NetworkImage(
                        //     'https://s2.coinmarketcap.com/static/img/coins/32x32/${snapshot.data[index].id}.png'),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.3), width: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].symbol),
                      // put $ after price
                      trailing: Text('\$ ${snapshot.data[index].priceUsd}'),
                      // trailing: Text(snapshot.data[index].priceUsd + ' USD'),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
