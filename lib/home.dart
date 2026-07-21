import 'package:flutter/material.dart';

import 'package:chatapp/screen/chat_page.dart';
import 'package:chatapp/screen/status_page.dart';
import 'package:chatapp/screen/calls_page.dart';
import 'package:chatapp/screen/profile_page.dart';


class HomePage extends StatefulWidget {

  final int userId;

  const HomePage({

    super.key,

    required this.userId,

  });


  @override
  State<HomePage> createState() => _HomePageState();

}




class _HomePageState extends State<HomePage> {


  int selectedIndex = 0;



  final List<String> titles = [

    "Chats",
    "Status",
    "Calls",
    "Profile",

  ];





  List<Widget> get pages => [


    ChatPage(

      currentUserId: widget.userId,

    ),



    const StatusPage(),



    const CallsPage(),



    ProfilePage(

      userId: widget.userId,

    ),



  ];







  void changePage(int index){


    setState(() {

      selectedIndex = index;

    });


  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(


        title:

        Text(

          titles[selectedIndex],

        ),


        centerTitle:true,


      ),





      body:

      pages[selectedIndex],





      bottomNavigationBar:

      BottomNavigationBar(



        currentIndex:selectedIndex,



        type:

        BottomNavigationBarType.fixed,



        selectedItemColor:

        Colors.green,



        unselectedItemColor:

        Colors.grey,



        onTap:

        changePage,




        items:const [




          BottomNavigationBarItem(


            icon:

            Icon(Icons.chat),


            label:"Chats",


          ),






          BottomNavigationBarItem(


            icon:

            Icon(Icons.circle_outlined),


            label:"Status",


          ),






          BottomNavigationBarItem(


            icon:

            Icon(Icons.call),


            label:"Calls",


          ),






          BottomNavigationBarItem(


            icon:

            Icon(Icons.person),


            label:"Profile",


          ),





        ],



      ),



    );


  }


}