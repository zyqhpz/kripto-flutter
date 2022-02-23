class Coins {
  final String id;
  final String name;
  final String symbol;
  // final String rank;
  final int rank;
  final String priceUsd;
  final String percentChange1h;

  Coins({
    required this.id,
    required this.name,
    required this.symbol,
    required this.rank,
    required this.priceUsd,
    required this.percentChange1h,
  });

  // Coins(
  //     {required this.id,
  //     required this.name,
  //     required this.symbol,
  //     required this.rank,
  //     required this.priceUsd});
}

class CryptoCoins {
  final String id;
  final String name;
  final String symbol;
  final String rank;
  final String priceUsd;
  final String image;

  CryptoCoins({
    required this.id,
    required this.name,
    required this.symbol,
    required this.rank,
    required this.priceUsd,
    required this.image,
  });
}
