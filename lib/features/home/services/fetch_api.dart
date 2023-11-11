import 'dart:convert';
import 'package:http/http.dart' as http;

fetchDataFromApi() async {
  final response = await http.get(
    Uri.parse(
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?sort=market_cap&limit=2"),
    headers: {
      'X-CMC_PRO_API_KEY': 'ad649c27-a0dd-47d4-b411-9c9f9bd39cea',
    },
  );

  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);

    var data = responseData['data'];
    return data;
  } else {
    print('Failed to fetch data. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

Future<String> fetchImage(String symbol, int id) async {
  final response = await http.get(
    Uri.parse(
        "https://pro-api.coinmarketcap.com/v2/cryptocurrency/info?symbol=${symbol}"),
    headers: {
      'X-CMC_PRO_API_KEY': 'ad649c27-a0dd-47d4-b411-9c9f9bd39cea',
    },
  );

  if (response.statusCode == 200) {
    var responseBody = json.decode(response.body);

    var logoUrl = responseBody['data'][symbol][0]["logo"];
    print(logoUrl);
    return logoUrl;
  } else {
    print('Failed to fetch data. Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
    // Return a placeholder or handle the error accordingly
    return 'https://example.com/placeholder-image.png';
  }
}
