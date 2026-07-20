import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;


  // अपना PC IP यहां डालें
  final String apiUrl =
      "http://192.168.1.5:8000/user/login";


  Future<void> loginUser() async {

    setState(() {
      isLoading = true;
    });


    try {

      final response = await http.post(

        Uri.parse(apiUrl),

        headers: {
          "Content-Type": "application/json",
        },

        body: jsonEncode({

          "email": emailController.text.trim(),

          "password": passwordController.text.trim(),

        }),

      );


      if(response.statusCode == 200){

        var data = jsonDecode(response.body);


        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(
            content: Text("Login Successful"),
          ),

        );


        print(data);


        // यहां HomePage पर भेज सकते हैं
        // Navigator.pushReplacement(
        // context,
        // MaterialPageRoute(
        // builder: (_) => HomePage()
        // ));

      }


      else {

        var error = jsonDecode(response.body);


        ScaffoldMessenger.of(context).showSnackBar(

          SnackBar(
            content: Text(
                error["detail"] ?? "Invalid Login"
            ),
          ),

        );

      }


    }

    catch(e){

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content: Text(
              "Server Error : $e"
          ),
        ),

      );

    }


    setState(() {

      isLoading = false;

    });

  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,


      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(25),


          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,


            children: [


              const Text(

                "Login",

                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),

              ),


              const SizedBox(height:40),



              TextField(

                controller: emailController,

                keyboardType: TextInputType.emailAddress,


                decoration: const InputDecoration(

                  prefixIcon: Icon(Icons.email),

                  labelText: "Email",

                  border: OutlineInputBorder(),

                ),

              ),



              const SizedBox(height:20),



              TextField(

                controller: passwordController,

                obscureText: true,


                decoration: const InputDecoration(

                  prefixIcon: Icon(Icons.lock),

                  labelText: "Password",

                  border: OutlineInputBorder(),

                ),

              ),



              const SizedBox(height:30),



              SizedBox(

                width: double.infinity,


                height:50,


                child: ElevatedButton(


                  onPressed: isLoading
                      ? null
                      : loginUser,


                  child: isLoading

                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )

                      : const Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize:18,
                    ),
                  ),


                ),

              )

            ],

          ),

        ),

      ),

    );

  }

}