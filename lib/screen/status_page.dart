import 'package:flutter/material.dart';
import '../login.dart';



class StatusPage extends StatefulWidget {


  const StatusPage({
    super.key,
  });



  @override
  State<StatusPage> createState() => _StatusPageState();


}







class _StatusPageState extends State<StatusPage> {



  void logout() {



    showDialog(



      context: context,



      builder: (context){



        return AlertDialog(



          title: const Text(
              "Logout"
          ),



          content: const Text(
              "Are you sure you want to logout?"
          ),




          actions: [




            TextButton(



              onPressed: (){


                Navigator.pop(context);


              },



              child: const Text(
                  "Cancel"
              ),



            ),






            ElevatedButton(



              onPressed: (){



                Navigator.pop(context);



                Navigator.pushAndRemoveUntil(



                  context,



                  MaterialPageRoute(



                    builder:(context)=> const LoginPage(),


                  ),



                      (route)=>false,



                );



              },



              child: const Text(
                  "Logout"
              ),



            ),




          ],



        );


      },



    );


  }








  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(



        title: const Text(
            "Status"
        ),



        centerTitle:true,



      ),






      body: Center(



        child: Column(



          mainAxisAlignment:
          MainAxisAlignment.center,



          children: [






            CircleAvatar(



              radius:60,



              backgroundColor:
              Colors.green.shade100,



              child: const Icon(



                Icons.person,


                size:70,


                color:Colors.green,



              ),



            ),






            const SizedBox(
              height:30,
            ),






            ElevatedButton.icon(



              onPressed: logout,



              icon: const Icon(

                Icons.logout,

              ),



              label: const Text(



                "Logout",



                style: TextStyle(



                  fontSize:18,



                ),



              ),




              style: ElevatedButton.styleFrom(



                backgroundColor:
                Colors.red,



                foregroundColor:
                Colors.white,



                padding:
                const EdgeInsets.symmetric(



                  horizontal:50,

                  vertical:15,


                ),




                shape:
                RoundedRectangleBorder(



                  borderRadius:
                  BorderRadius.circular(30),



                ),




              ),




            ),





          ],



        ),



      ),



    );


  }



}