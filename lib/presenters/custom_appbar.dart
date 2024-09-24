import 'package:eraswithu/Screens/profile_screen.dart';
import 'package:eraswithu/data/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key, required this.context, required this.user})
      : super(key: key);

  final BuildContext context;
  final User user;

  @override
  Size get preferredSize => const Size.fromHeight(100.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //leadingWidth: 25,
      //titleSpacing: 30,
      leading: const Padding(
        padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
        child: FittedBox(
          child: Icon(
            Icons.school_outlined,
            color: Color(0xff0077B6),
            //size: 40.0,
          ),
        ),
      ),
      elevation: 0,
      title: const Text(
        'ErasWithU',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Rubik',
            //fontSize: 25,
            //fontWeight: FontWeight.bold,
            color: Color(0xff0077B6)),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          icon: const Icon(
            CupertinoIcons.person_crop_circle,
            color: Color(0xff0077B6),
            //size: 40.0,
          ),
          onPressed: toProfilePage,
        ),
      ],
      bottom: TabBar(
          unselectedLabelColor: Color(0xff0077B6),
          //indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xff0077B6)),
          tabs: [
            Tab(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xff0077B6), width: 2)),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text('Chats',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        //fontSize: 25,
                        //fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xff0077B6), width: 2)),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text('Events',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        //fontSize: 25,
                        //fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xff0077B6), width: 2)),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text('Listings',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        //fontSize: 25,
                        //fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          ]),
      /*bottom: TabBar(
        unselectedLabelColor: Colors.redAccent,

        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xff0077B6),
        ),
        tabs: [
          Tab(child: Text('Chats', style: TextStyle(
              fontFamily: 'Rubik',
              //fontSize: 25,
              //fontWeight: FontWeight.bold,
              color: Color(0xff0077B6)))),
          Tab(child: Text('Events', style: TextStyle(
              fontFamily: 'Rubik',
              //fontSize: 25,
              //fontWeight: FontWeight.bold,
              color: Color(0xff0077B6)))),
          Tab(child: Text('Listings', style: TextStyle(
              fontFamily: 'Rubik',
              //fontSize: 25,
              //fontWeight: FontWeight.bold,
              color: Color(0xff0077B6)))),
        ],
      ),*/
    );
  }

  void toProfilePage() {
    if (!ProfilePage.notGuest(user.userID, context)) {
      return;
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfilePage(user: user)));
  }
}
