import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lab5/User/password.dart';
import 'package:lab5/user/address.dart';
import 'package:lab5/user/myprofile.dart';
import 'package:lab5/user/verifyAccount.dart';
import 'package:provider/provider.dart';
import '../changeNotifier/ProfileUser.dart';
class user extends StatefulWidget {
  const user({super.key});

  @override
  viewUser createState() => viewUser();
}
class viewUser extends State<user> {
  @override
  Widget build(BuildContext context) {
    final item = Provider.of<getProflieUser>(context);
    item.fetchData();
    final itemData = item.data.isNotEmpty? item.data[0]:null;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 15, top: 15),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: const Color(0xFFB0AEAE)),
                        child: Image.asset(
                          "assets/image/left-chevron.png",
                          width: 20,
                          height: 20,
                        )),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "Thiết lập tài khoản",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        fontFamily: "LibreBodoni-BoldItalic"),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width,
              height: 5,
              color: const Color(0xffe7e6e6),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => myProfile(
                              data: itemData!["data"], keyId: itemData["key"])));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            color: Colors.grey.withOpacity(.5))
                      ]),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Hồ sơ của tôi",
                          style: TextStyle(
                              fontSize: 18, fontFamily: "LibreBodoni-Medium"),
                        ),
                        Image.asset(
                          "assets/image/next.png",
                          height: 20,
                          width: 20,
                        )
                      ],
                    ),
                  ),
                )),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => myAddress(
                              data: itemData!["data"],
                              keyId: itemData["key"],
                            )));
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          color: Colors.grey.withOpacity(.5))
                    ]),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Địa chỉ",
                        style: TextStyle(
                            fontSize: 18, fontFamily: "LibreBodoni-Medium"),
                      ),
                      Image.asset(
                        "assets/image/next.png",
                        height: 20,
                        width: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => verifyAccount()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 10,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                            color: Colors.grey.withOpacity(.5))
                      ]),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Đổi mật khẩu",
                          style: TextStyle(
                              fontSize: 18, fontFamily: "LibreBodoni-Medium"),
                        ),
                        Image.asset(
                          "assets/image/next.png",
                          height: 20,
                          width: 20,
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

class mypass extends StatefulWidget {
  const mypass({super.key});

  @override
  viewPass createState() => viewPass();
}
