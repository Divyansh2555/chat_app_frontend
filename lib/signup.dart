import 'dart:convert';

import 'package:chatapp/screen/profile_page.dart';
import 'package:flutter/material.dart';

import 'core/api/services/auth_service.dart';



class SignupPage extends StatefulWidget {

  const SignupPage({super.key});


  @override
  State<SignupPage> createState() => _SignupPageState();

}






class _SignupPageState extends State<SignupPage> {



  final AuthService _authService = AuthService();



  final usernameController =
  TextEditingController();


  final emailController =
  TextEditingController();


  final passwordController =
  TextEditingController();



  bool loading = false;







  Future<void> signup() async {



    if(
    usernameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty
    ){


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(

          content:

          Text(
              "Please fill all fields"
          ),

        ),

      );


      return;


    }






    setState(() {

      loading=true;

    });






    try{



      final response =
      await _authService.signup(



        {


          "username":

          usernameController.text.trim(),



          "email":

          emailController.text.trim(),




          "password":

          passwordController.text.trim(),



        },


      );







      print(response.statusCode);

      print(response.body);







      if(!mounted)return;






      if(response.statusCode == 200 ||
          response.statusCode == 201){



        final data =

        jsonDecode(response.body);





        int userId = data["id"];







        ScaffoldMessenger.of(context).showSnackBar(



          const SnackBar(

            content:

            Text(
                "Signup Successful"
            ),


          ),


        );









        Navigator.pushReplacement(



          context,



          MaterialPageRoute(



            builder: (_) =>

                ProfilePage(



                  userId:userId,



                ),



          ),



        );





      }

      else{



        String message =
            "Signup Failed";




        try{


          final error =

          jsonDecode(response.body);



          message =
              error["detail"] ?? message;



        }

        catch(e){}





        ScaffoldMessenger.of(context).showSnackBar(



          SnackBar(



            content:

            Text(message),



          ),



        );




      }







    }

    catch(e){



      ScaffoldMessenger.of(context).showSnackBar(



        SnackBar(



          content:

          Text(
              e.toString()
          ),



        ),



      );



    }







    setState(() {


      loading=false;


    });




  }










  Widget field(

      TextEditingController controller,

      String title,

      ){



    return Padding(



      padding:

      const EdgeInsets.only(

          bottom:15

      ),





      child:

      TextField(



        controller:

        controller,





        decoration:

        InputDecoration(



          labelText:title,



          border:

          const OutlineInputBorder(),



        ),



      ),



    );


  }










  @override
  void dispose(){



    usernameController.dispose();


    emailController.dispose();


    passwordController.dispose();



    super.dispose();


  }









  @override
  Widget build(BuildContext context){



    return Scaffold(




      appBar:

      AppBar(


        title:

        const Text(

            "Sign Up"

        ),


        centerTitle:true,


      ),






      body:

      SingleChildScrollView(



        padding:

        const EdgeInsets.all(20),




        child:

        Column(



          children:[





            field(

              usernameController,

              "Username",

            ),





            field(

              emailController,

              "Email",

            ),






            field(

              passwordController,

              "Password",

            ),






            const SizedBox(

                height:30

            ),






            SizedBox(



              width:

              double.infinity,



              height:

              50,





              child:

              ElevatedButton(



                onPressed:

                loading

                    ?

                null

                    :

                signup,





                child:

                loading



                    ?

                const CircularProgressIndicator(

                  color:Colors.white,

                )



                    :



                const Text(

                    "Sign Up"

                ),



              ),



            )







          ],



        ),



      ),



    );


  }



}