import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab5/cartItem/cart.dart';
import 'package:lab5/cartItem/productDetails.dart';
import 'package:lab5/cartItem/productPortfolio.dart';
import 'package:lab5/cartItem/searchProducts.dart';
import 'package:lab5/page/menu.dart';
import 'package:lab5/page/notifications.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../changeNotifier/Categories.dart';
import 'package:badges/badges.dart' as badges;
import '../changeNotifier/ProfileUser.dart';

class home extends StatefulWidget {
  const home({super.key});
  @override
  viewHome createState() => viewHome();
}
final CarouselController _controller = CarouselController();
class viewHome extends State<home> with AutomaticKeepAliveClientMixin<home> {
  String? price;
  final NotificationServices _services = NotificationServices();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _services.requestNotificationServices();
    _services.firebaseInit(context);
    _services.getDeviceToken().then((value) {});
    innit();
  }

  void innit(){
    Provider.of<getProducts>(context, listen: false).fetchDataFavorite();
    final item = Provider.of<getProducts>(context, listen: false);
    final itemProduct = Provider.of<categoryProducts>(context, listen: false);
    final itemCart = Provider.of<getCartUser>(context, listen: false);
    final itemUser = Provider.of<getProflieUser>(context, listen: false);
    final itemBander = Provider.of<getBander>(context, listen: false);

    if (item.data.isEmpty) {
      item.fetchDataProducts();
    }
    if (itemProduct.result.isEmpty ) {
      itemProduct.getCategoriesProducts();
    }
    if (itemCart.data.isEmpty) {
      itemUser.fetchData();
      if (itemUser.data.isNotEmpty) {
        itemCart.fetchDataCart(itemUser.data[0]["key"]);
      }
    }
    if (itemBander.data.isEmpty) {
      itemBander.fetchDataBander();
    }
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final item = Provider.of<getProducts>(context);
    final itemProduct = Provider.of<categoryProducts>(context);
    final itemCart = Provider.of<getCartUser>(context);
    final itemBander = Provider.of<getBander>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(top: 15, left: 10, bottom: 10),
                      child: const Text(
                        "Wellcome to Luxury",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            fontFamily: "LibreBodoni-Medium"),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10, right: 15),
                        child: badges.Badge(
                          badgeContent: Text(
                            itemCart.data.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          showBadge: true,
                          ignorePointer: false,
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => const cart(),
                                    ));
                              },
                              child: const Icon(
                                Icons.shopping_cart,
                                size: 30,
                              )),
                        ))
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 30, bottom: 30, right: 10, left: 10),
                      child: Material(
                        elevation: 2,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const search(),
                                ));
                          },
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextField(
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                  hintText: 'Search...',
                                  prefixIcon: const Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Text(
                            "Danh mục",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "LibreBodoni-Medium"),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => const menu()));
                            },
                            child: Row(
                              children: [
                                const Text(
                                  "Xem thêm",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "LibreBodoni-Medium"),
                                ),
                                Image.asset(
                                  "assets/image/right-arrow.png",
                                  width: 15,
                                  height: 15,
                                )
                              ],
                            )),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        height: 140,
                        child: ListView.builder(
                            itemCount: itemProduct.isLoading
                                ? 5
                                : itemProduct.result.length -5,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              if (itemProduct.result.isEmpty &&
                                  itemProduct.isLoading) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Card(
                                    elevation: 3,
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          color: Colors.white,
                                        ),
                                        Container(
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              if (index >= 0 &&
                                  index < itemProduct.result.length) {
                                final getIndex = itemProduct.result[index];
                                final itemData = getIndex["categoryData"];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => productPortfolio(
                                          data: getIndex["productsData"],
                                          Name: itemData["name"],
                                          keyID: getIndex["categoryKey"],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 3,
                                    child: Column(
                                      children: [
                                        Image.network(
                                          itemData["image"] ?? "",
                                          height: 100,
                                          width: 100,
                                        ),
                                        Text(itemData['name'] ?? ""),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            })),
                    Card(
                      color: const Color(0xff6cd347),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 5,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10, left: 10),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Gợi ý hôm nay",
                                  style: TextStyle(
                                      fontFamily: "LibreBodoni-Bold",
                                      fontSize: 18,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  autoPlay: true,
                                  viewportFraction: 1,
                                  enlargeCenterPage: false,
                                ),
                                items: itemBander.data
                                    .map((e) => Center(
                                            child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      productDetails(
                                                          data: e["data"],
                                                          keyId: e["data"]["productsID"],
                                                          keyIdCa: e["data"]
                                                              ["CategoriesID"],
                                                          start: e["data"]
                                                              ["sumStart"]),
                                                ));
                                          },
                                          child: Image.network(
                                            e["data"]["ImageBander"],
                                            fit: BoxFit.fill,
                                            height: 200,
                                          ),
                                        )))
                                    .toList(),
                                carouselController: _controller,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 90),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => _controller.previousPage(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          color: Colors.transparent
                                              .withOpacity(.3),
                                        ),
                                        width: 40,
                                        height: 50,
                                        child: const Icon(
                                          CupertinoIcons.left_chevron,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => _controller.nextPage(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                          color: Colors.transparent
                                              .withOpacity(.3),
                                        ),
                                        width: 40,
                                        height: 50,
                                        child: const Icon(
                                          CupertinoIcons.right_chevron,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomRight,
                              colors: [Color(0xfff67d77), Color(0xfffc2b55)])),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            child: const Text(
                              "Yêu thích nhiều nhất",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "LibreBodoni-Bold",
                                  color: Colors.white),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            child: item.isLoading && item.dataFa.isEmpty
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      height: 300,
                                      color: Colors.white,
                                    ))
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      final itemIndex = item.dataFa[index];
                                      final itemData = itemIndex['data'];
                                      final itemKey = itemIndex['key'];
                                      final keyIdCa = itemIndex["categoryKey"];
                                      String fomatPrice =
                                          NumberFormat.decimalPattern("vi")
                                              .format(itemData["Price  "]);
                                      price = fomatPrice
                                          .toString()
                                          .replaceAll(",", ".");
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (context) =>
                                                    productDetails(
                                                        data: itemData,
                                                        keyId: itemKey,
                                                        keyIdCa: keyIdCa,
                                                        start: itemData[
                                                            'sumStart']),
                                              ));
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          elevation: 10,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Stack(
                                            children: [
                                              Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding: const EdgeInsets.only(
                                                    bottom: 50),
                                                child: Image.network(
                                                  itemData["ImageURL "],
                                                  height: 300,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                child: Container(
                                                  height: 60,
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  decoration: const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      10)),
                                                      color: Color(0xfff1f1f1)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  top: 5),
                                                          width: 300,
                                                          child: Text(
                                                            itemData[
                                                                "ProductName"],
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.left,
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontFamily:
                                                                    "LibreBaskerville-Regular"),
                                                          )),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            10,
                                                                        top: 5),
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                      itemData[
                                                                          "sumStart"],
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Color(0xfffb6e2e)),
                                                                    ),
                                                                    const Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Color(
                                                                          0xfffb6e2e),
                                                                      size: 18,
                                                                    ),
                                                                    const SizedBox(
                                                                      width: 10,
                                                                    ),
                                                                    Text("("
                                                                        "${itemData['sumComment']}"
                                                                        ")")
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            10),
                                                                child: Text(
                                                                  "$price₫",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      color: Color(
                                                                          0xffd0021c),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ]),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: const Color(0xffeaeaea),
                      margin: const EdgeInsets.only(top: 10),
                      elevation: 2,
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: item.isLoading ? 6 : item.data.length,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, mainAxisExtent: 370),
                              itemBuilder: (context, index) {
                                if (item.data.isEmpty) {
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Card(
                                      elevation: 3,
                                      margin: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            height: 200,
                                            color: Colors.white,
                                          ),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: const EdgeInsets.only(
                                                left: 10, top: 5),
                                            child: Container(
                                              width: 100,
                                              height: 35,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: double.infinity,
                                            height: 20,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 20,
                                                color: Colors.white,
                                              ),
                                              Container(
                                                width: 40,
                                                height: 20,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 30,
                                                  height: 20,
                                                  color: Colors.white,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Container(
                                                  width: 40,
                                                  height: 20,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                } else {
                                  final getItem = item.data[index];
                                  final itemData = getItem["data"];
                                  final keyId = getItem["key"];
                                  final keyIdCa = getItem["categoryKey"];
                                  String fomatPrice =
                                      NumberFormat.decimalPattern("vi")
                                          .format(itemData["Price  "]);
                                  price = fomatPrice
                                      .toString()
                                      .replaceAll(",", ".");
                                  return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    productDetails(
                                                      data: itemData,
                                                      keyId: keyId,
                                                      keyIdCa: keyIdCa,
                                                      start:
                                                          itemData['sumStart'],
                                                    )));
                                      },
                                      child: Card(
                                        elevation: 3,
                                        margin: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Image.network(
                                                itemData["ImageURL "],
                                                height: 200,
                                              ),
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              margin: const EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: itemData["Listimages "] !=
                                                          null &&
                                                      itemData["Listimages "]
                                                          .isNotEmpty
                                                  ? Image.network(
                                                      itemData["Listimages "],
                                                      height: 30)
                                                  : null,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Text(
                                                  itemData["ProductName"],
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontFamily:
                                                          "LibreBaskerville-Regular"),
                                                )),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        price!,
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "LibreBodoni-Medium",
                                                            fontSize: 17,
                                                            color: Color(
                                                                0xffd0021c),
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(bottom: 10),
                                                        child: const Text("₫",
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xffd0021c),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    color:
                                                        const Color(0xfffff0e9),
                                                    child: itemData["discount"] !=
                                                                null &&
                                                            itemData["discount"]
                                                                .isNotEmpty
                                                        ? Text(
                                                            // ignore: prefer_interpolation_to_compose_strings
                                                            "${"-" + itemData["discount"]}%",
                                                            style: const TextStyle(
                                                                color: Color(
                                                                    0xffeb5757)),
                                                          )
                                                        : null,
                                                  )
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10, top: 5),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "${itemData['sumStart']}",
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xfffb6e2e)),
                                                  ),
                                                  const Icon(
                                                    Icons.star,
                                                    color: Color(0xfffb6e2e),
                                                    size: 18,
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text("("
                                                      "${itemData['sumComment']}"
                                                      ")")
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                }
                              })),
                    ),
                  ],
                ))),
              ],
            )),
      ),
    );
  }
}

// ignore: camel_case_types
class search extends StatefulWidget {
  const search({super.key});

  @override
  TextSearchState createState() => TextSearchState();
}

class TextSearchState extends State<search> {
  final containerSearch = TextEditingController();
  bool showClearButton = false;

  @override
  void initState() {
    super.initState();
    containerSearch.addListener(() {
      showClearButton = containerSearch.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    super.dispose();
    containerSearch.clear();
  }

  @override
  Widget build(BuildContext context) {
    final categoryData = Provider.of<categoryProducts>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 60,
                    height: 80,
                    child: TextField(
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        setState(() {
                          showClearButton = value.isNotEmpty;
                        });
                      },
                      onSubmitted: (value) async {
                        if (value.isNotEmpty) {
                          await categoryData.searchProducts(value);
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    searchProducts(searchKeyword: value),
                              ));
                          containerSearch.clear();
                        }
                      },
                      autofocus: true,
                      controller: containerSearch,
                      style: const TextStyle(fontSize: 18),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 10,
                        ),
                        hintText: "Search...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: showClearButton
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    containerSearch.clear();
                                    showClearButton = false;
                                  });
                                },
                                child: const Icon(Icons.clear),
                              )
                            : null,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              if (containerSearch.text.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: categoryData.result.length,
                  itemBuilder: (context, index) {
                    final category = categoryData.result[index];
                    final categoryName = category["categoryData"]["name"]
                        .toString()
                        .toLowerCase();
                    if (removeAccents(categoryName)
                        .contains(containerSearch.text)) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(categoryName),
                            onTap: () {
                              containerSearch.clear();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => searchProducts(
                                      searchKeyword: categoryName),
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

String removeAccents(String input) {
  final accentMap = {
    'àáảãạăắằẳẵặâấầẩẫậ': 'a',
    'Cc': 'c',
    'Gg': "g",
    'Hh': 'h',
    'Kk': 'k',
    'Ll': 'l',
    'Mm': 'm',
    "Nn": 'n',
    "Pp": 'p',
    "Qq": 'q',
    "Rr": 'r',
    "Ss": 's',
    "Tt": 't',
    "Vv": 'v',
    "Xx": 'x',
    'èéẻẽẹêếềểễệ': 'e',
    'ìíỉĩị': 'i',
    'òóỏõọôốồổỗộơớờởỡợ': 'o',
    'ùúủũụưứừửữự': 'u',
    'ỳýỷỹỵ': 'y',
    'đĐDd': 'd',
    'ÀÁẢÃẠĂẮằẲẴẶÂẤẦẨẪẬ': 'A',
    'ÈÉẺẼẸÊẾỀỂỄỆ': 'E',
    'ÌÍỈĨỊ': 'I',
    'ÒÓỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢ': 'O',
    'ÙÚỦŨỤƯỨỪỬỮỰ': 'U',
    'ỲÝỶỸỴ': 'Y',
    'Bb': "b"
  };
  String result = input.toLowerCase();
  for (var pattern in accentMap.keys) {
    for (var accentChar in pattern.characters) {
      result = result.replaceAll(accentChar, accentMap[pattern]!);
    }
  }
  return result;
}
