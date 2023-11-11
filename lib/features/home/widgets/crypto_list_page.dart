import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gweiland_flutter/features/home/services/fetch_api.dart';
import 'package:http/http.dart' as http;

class Crypto {
  int id;
  String symbol;
  String name;
  String price;
  String percent_change_24hr;
  String image = "";

  Crypto({
    required this.id,
    required this.name,
    required this.price,
    required this.symbol,
    required this.percent_change_24hr,
  });
}

class CryptoListPage extends StatefulWidget {
  @override
  _CryptoListPageState createState() => _CryptoListPageState();
}

class _CryptoListPageState extends State<CryptoListPage> {
  Future<dynamic>? coinsListFuture;
  var positive = false;

  @override
  void initState() {
    super.initState();
    coinsListFuture = fetchDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: coinsListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          return FutureBuilder<List<Crypto>>(
            future: fetchCryptoList(snapshot.data!),
            builder: (context, snapshotCrypto) {
              if (snapshotCrypto.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (snapshotCrypto.hasError) {
                return Center(
                  child: Text('Error: ${snapshotCrypto.error}'),
                );
              } else if (snapshotCrypto.hasData) {
                List<Crypto> coins = snapshotCrypto.data!;
                return Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: coins.length,
                    itemBuilder: (context, index) {

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  (coins[index].image.isNotEmpty)
                                      ? Image.network(
                                          coins[index].image,
                                          height: 70,
                                          width: 70,
                                        )
                                      : Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            '${coins[index].symbol}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Image.network(
                                           'https://www.cambridgemaths.org/Images/The-trouble-with-graphs.jpg',
                                            height: 30,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        coins[index].name,
                                        style: const TextStyle(
                                            fontSize: 16, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${coins[index].price} USD',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "${coins[index].percent_change_24hr} %",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else {
                return const Center(
                  child: Text('No data available'),
                );
              }
            },
          );
        } else {
          return const Center(
            child: Text('No data available'),
          );
        }
      },
    );
  }

  Future<List<Crypto>> fetchCryptoList(dynamic data) async {
    List<Crypto> cryptoList = [];
    for (var coin in data) {
      String imageUrl = await fetchImage(coin['symbol'], coin['id']);
      cryptoList.add(
        Crypto(
          id: coin['id'],
          name: coin['name'],
          price: double.parse(coin['quote']['USD']['price'].toString())
              .toStringAsFixed(2),
          symbol: coin['symbol'],
          percent_change_24hr: double.parse(
                  coin['quote']['USD']['percent_change_24h'].toString())
              .toStringAsFixed(2),
        )..image = imageUrl,
      );
    }
    return cryptoList;
  }
}
