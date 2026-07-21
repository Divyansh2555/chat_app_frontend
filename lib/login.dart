import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/services/auth_service.dart';
import 'home.dart';
import 'signup.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({
    super.key,
  });


  @override
  State<LoginPage> createState() => _LoginPageState();

}



class _LoginPageState extends State<LoginPage> {


  final AuthService _authService = AuthService();


  final TextEditingController emailController =
  TextEditingController();


  final TextEditingController passwordController =
  TextEditingController();



  bool loading = false;



  Future<void> login() async {


    if(emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content: Text("Please fill all fields"),
        ),

      );


      return;

    }



    setState(() {

      loading = true;

    });



    try {


      final response = await _authService.login({

        "email": emailController.text.trim(),

        "password": passwordController.text.trim(),

      });



      if(!mounted) return;



      setState(() {

        loading = false;

      });



      if(response.statusCode == 200){


        final data = jsonDecode(response.body);


        final user = data["user"];



        // SAVE LOGIN DATA

        final prefs =
        await SharedPreferences.getInstance();



        await prefs.setBool(
          "isLogin",
          true,
        );



        await prefs.setInt(
          "userId",
          user["id"],
        );



        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) => HomePage(

              userId: user["id"],

            ),

          ),

        );



      }

      else{


        String message = "Login Failed";


        try{


          final error = jsonDecode(response.body);


          message = error["detail"] ?? message;


        }

        catch(_){}



        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(

            content: Text(message),

          ),

        );


      }




    }

    catch(e){



      if(!mounted) return;



      setState(() {

        loading = false;

      });



      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),

        ),

      );


    }


  }





  @override
  void dispose() {

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title: const Text("Login"),

        centerTitle: true,

      ),



      body: SingleChildScrollView(


        padding: const EdgeInsets.all(20),


        child: SizedBox(


          height: MediaQuery.of(context).size.height - 150,


          child: Column(


            mainAxisAlignment: MainAxisAlignment.center,


            children: [



              TextField(

                controller: emailController,

                keyboardType: TextInputType.emailAddress,


                decoration: const InputDecoration(

                  labelText: "Email",

                  border: OutlineInputBorder(),

                ),

              ),



              const SizedBox(height:20),




              TextField(

                controller: passwordController,

                obscureText:true,


                decoration: const InputDecoration(

                  labelText:"Password",

                  border:OutlineInputBorder(),

                ),

              ),



              const SizedBox(height:30),




              SizedBox(

                width:double.infinity,

                height:50,


                child: ElevatedButton(


                  onPressed: loading ? null : login,


                  child: loading

                      ? const SizedBox(

                    width:24,

                    height:24,

                    child:CircularProgressIndicator(

                      strokeWidth:2,

                      color:Colors.white,

                    ),

                  )


                      : const Text(

                    "Login",

                    style:TextStyle(

                      fontSize:16,

                    ),

                  ),


                ),

              ),




              const SizedBox(height:20),




              TextButton(


                onPressed: (){


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder: (_) => const SignupPage(),

                    ),

                  );


                },


                child: const Text(

                  "Don't have an account? Sign Up",

                ),


              ),



            ],


          ),


        ),


      ),


    );


  }


}