import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';
import 'home.dart';



class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState() => _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {

    super.initState();

    checkLogin();

  }



  Future<void> checkLogin() async {


    final prefs =
    await SharedPreferences.getInstance();



    bool isLogin =
        prefs.getBool("isLogin") ?? false;



    int userId =
        prefs.getInt("userId") ?? 0;




    Timer(

      const Duration(seconds: 2),

          () {


        if(!mounted) return;



        if(isLogin && userId != 0){



          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (_) => HomePage(

                userId: userId,

              ),

            ),

          );



        }

        else {



          Navigator.pushReplacement(

            context,

            MaterialPageRoute(

              builder: (_) => const LoginPage(),

            ),

          );

        }



      },

    );


  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(

      body: SizedBox.expand(

        child: Image.asset(

          "assets/dp.png",

          fit: BoxFit.cover,

        ),

      ),

    );


  }


}