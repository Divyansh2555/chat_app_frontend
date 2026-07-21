import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'message_page.dart';


class ChatPage extends StatefulWidget {

  final int currentUserId;

  const ChatPage({
    super.key,
    required this.currentUserId,
  });


  @override
  State<ChatPage> createState() => _ChatPageState();

}



class _ChatPageState extends State<ChatPage>{


  final String baseUrl =
      "http://10.56.28.43:8000";


  final searchController =
  TextEditingController();


  List users=[];

  List chats=[];

  bool loading=false;

  bool isSearching=false;




  @override
  void initState(){

    super.initState();

    loadChats();

  }






  Future<void> loadChats() async{


    try{


      final response =
      await http.get(

        Uri.parse(
          "$baseUrl/chats/${widget.currentUserId}",
        ),

      );



      if(response.statusCode==200){


        setState((){

          chats =
              jsonDecode(response.body);

        });


      }


    }catch(e){

      print(e);

    }


  }







  Future<void> searchUser() async{


    String search =
    searchController.text.trim().toLowerCase();



    if(search.isEmpty){


      setState((){


        isSearching=false;

        users=[];


      });


      loadChats();


      return;

    }





    setState(() {

      loading=true;

      isSearching=true;

    });




    try{


      final response =
      await http.get(

        Uri.parse(
            "$baseUrl/users/"
        ),

      );



      if(response.statusCode==200){


        List data =
        jsonDecode(response.body);



        List result =
        data.where((user){


          return user["id"]
              .toString()
              .contains(search)

              ||

              user["username"]
                  .toString()
                  .toLowerCase()
                  .contains(search);



        }).toList();



        await loadProfile(result);



      }


    }catch(e){

      print(e);

    }



    setState(() {

      loading=false;

    });


  }







  Future<void> loadProfile(List data) async{


    for(var user in data){


      try{


        final response =
        await http.get(

          Uri.parse(
              "$baseUrl/profiles/${user["id"]}"
          ),

        );



        if(response.statusCode==200){


          final profile =
          jsonDecode(response.body);



          user["profile_image"] =
          profile["profile_image"];


        }



      }catch(e){

        print(e);

      }



    }



    setState(() {

      users=data;


    });


  }









  Future<void> openChat(
      int receiverId,
      String username,
      String? image
      )async{



    final response =
    await http.post(


      Uri.parse(
          "$baseUrl/chats/"
      ),


      headers:{

        "Content-Type":
        "application/json"

      },


      body:jsonEncode({


        "sender_id":
        widget.currentUserId,


        "receiver_id":
        receiverId,


      }),


    );



    if(response.statusCode==200 ||
        response.statusCode==201){


      final data =
      jsonDecode(response.body);



      await loadChats();



      Navigator.push(


        context,


        MaterialPageRoute(


          builder:(context)=>

              MessagePage(


                chatId:
                data["id"],


                senderId:
                widget.currentUserId,


                receiverId:
                receiverId,


                username:
                username,


                profileImage:
                image,


              ),


        ),


      );


    }


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:AppBar(

        title:
        const Text(
            "WhatsApp"
        ),

      ),





      body:Column(

        children:[



          Padding(

            padding:
            const EdgeInsets.all(10),


            child:TextField(


              controller:
              searchController,


              onChanged:(value){

                searchUser();

              },


              decoration:
              InputDecoration(


                hintText:
                "Search user",



                suffixIcon:

                const Icon(
                  Icons.search,
                ),



                border:
                const OutlineInputBorder(),


              ),


            ),


          ),






          Expanded(


            child:


            loading


                ?

            const Center(

              child:
              CircularProgressIndicator(),

            )


                :



            ListView.builder(



              itemCount:

              isSearching

                  ?

              users.length

                  :

              chats.length,




              itemBuilder:(context,index){



                final user =

                isSearching

                    ?

                users[index]

                    :

                chats[index];





                return ListTile(



                  onTap:(){



                    openChat(


                      user["id"],


                      user["username"],


                      user["profile_image"],


                    );



                  },




                  leading:

                  CircleAvatar(



                    radius:28,



                    backgroundImage:


                    user["profile_image"] != null


                        ?


                    NetworkImage(

                      "$baseUrl/${user["profile_image"]}",

                    )


                        :

                    null,




                    child:


                    user["profile_image"] == null


                        ?


                    Text(

                      user["username"]

                          .toString()

                          .substring(0,1)

                          .toUpperCase(),


                    )


                        :

                    null,


                  ),





                  title:

                  Text(

                    user["username"].toString(),


                    style:

                    const TextStyle(

                      fontWeight:

                      FontWeight.bold,

                    ),


                  ),





                  subtitle:

                  Text(

                    user["email"]?.toString() ?? "",


                  ),






                  trailing:

                  const Icon(

                    Icons.chat,


                    color:

                    Colors.green,


                  ),




                );


              },


            ),



          )



        ],


      ),


    );


  }






  @override
  void dispose(){


    searchController.dispose();


    super.dispose();


  }



}