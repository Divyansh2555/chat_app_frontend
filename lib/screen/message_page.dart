import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class MessagePage extends StatefulWidget {


  final int chatId;
  final int senderId;
  final int receiverId;
  final String username;
  final String? profileImage;



  const MessagePage({

    super.key,

    required this.chatId,

    required this.senderId,

    required this.receiverId,

    required this.username,

    required this.profileImage,

  });



  @override
  State<MessagePage> createState() => _MessagePageState();

}







class _MessagePageState extends State<MessagePage>{



  final String baseUrl =
      "http://10.56.28.43:8000";



  final TextEditingController messageController =
  TextEditingController();



  final ScrollController scrollController =
  ScrollController();



  List messages=[];



  @override
  void initState(){

    super.initState();

    getMessages();

  }








  Future<void> getMessages() async{


    try{


      final response = await http.get(


        Uri.parse(

            "$baseUrl/messages/${widget.chatId}/${widget.senderId}"

        ),

      );




      if(response.statusCode==200){


        setState((){


          messages=jsonDecode(response.body);


        });



        scrollBottom();


      }


    }
    catch(e){

      print(e);

    }


  }









  void scrollBottom(){


    Future.delayed(

        const Duration(milliseconds:300),

            (){


          if(scrollController.hasClients){


            scrollController.animateTo(


              0,

              duration:
              const Duration(milliseconds:300),

              curve:
              Curves.easeOut,


            );


          }


        }

    );


  }









  String timeFormat(String time){


    try{


      DateTime date =
      DateTime.parse(time).toLocal();



      int hour=date.hour;


      String ampm =
      hour>=12 ? "PM":"AM";



      hour =
          hour%12;



      if(hour==0){

        hour=12;

      }



      String min =
      date.minute.toString().padLeft(2,"0");



      return "$hour:$min $ampm";


    }

    catch(e){

      return "";

    }

  }









  Future<void> sendMessage() async{


    String text =
    messageController.text.trim();



    if(text.isEmpty){

      return;

    }





    final response =
    await http.post(



      Uri.parse(

          "$baseUrl/messages/"

      ),



      headers:{


        "Content-Type":
        "application/json"

      },



      body:jsonEncode({



        "chat_id":
        widget.chatId,



        "sender_id":
        widget.senderId,



        "message":
        text,



      }),



    );






    if(response.statusCode==200 ||
        response.statusCode==201){


      messageController.clear();


      getMessages();


    }



  }









  @override
  Widget build(BuildContext context){


    return Scaffold(



      backgroundColor:
      const Color(0xffefeae2),




      appBar:AppBar(



        backgroundColor:
        Colors.green.shade700,



        title:Row(



          children:[



            CircleAvatar(



              radius:20,



              backgroundImage:

              widget.profileImage!=null &&
                  widget.profileImage!.isNotEmpty


                  ?

              NetworkImage(

                  "$baseUrl/${widget.profileImage}"

              )


                  :

              null,



              child:

              widget.profileImage==null ||
                  widget.profileImage!.isEmpty


                  ?

              Text(

                  widget.username[0]
                      .toUpperCase()

              )


                  :

              null,


            ),




            const SizedBox(
              width:10,
            ),



            Text(

                widget.username

            )



          ],


        ),



      ),






      body:Column(



        children:[





          Expanded(



              child:ListView.builder(



                reverse:true,



                controller:
                scrollController,



                padding:
                const EdgeInsets.all(10),



                itemCount:
                messages.length,



                itemBuilder:(context,index){



                  final msg =

                  messages[
                  messages.length-1-index
                  ];



                  bool isMe =

                      msg["sender_id"] ==
                          widget.senderId;





                  return Align(



                    alignment:



                    isMe

                        ?

                    Alignment.centerRight

                        :

                    Alignment.centerLeft,






                    child:Container(



                      margin:

                      const EdgeInsets.only(
                          bottom:8
                      ),




                      padding:

                      const EdgeInsets.all(10),





                      constraints:

                      BoxConstraints(

                        maxWidth:

                        MediaQuery.of(context)
                            .size
                            .width*
                            .75,

                      ),





                      decoration:

                      BoxDecoration(



                        color:

                        isMe

                            ?


                        (

                            msg["is_read"]==true


                                ?

                            Colors.blue


                                :

                            Colors.green

                        )


                            :


                        Colors.white,





                        borderRadius:

                        BorderRadius.circular(15),


                      ),





                      child:Column(



                        crossAxisAlignment:

                        CrossAxisAlignment.end,



                        children:[





                          Text(



                            msg["message"]
                                .toString(),



                            style:

                            TextStyle(



                              fontSize:16,


                              color:


                              isMe

                                  ?

                              Colors.white

                                  :

                              Colors.black,


                            ),



                          ),





                          const SizedBox(
                            height:5,
                          ),





                          Row(



                            mainAxisSize:
                            MainAxisSize.min,



                            children:[



                              Text(



                                timeFormat(

                                    msg["created_at"]

                                ),



                                style:

                                const TextStyle(

                                  fontSize:11,

                                  color:
                                  Colors.white70,

                                ),



                              ),




                              if(isMe)

                                const SizedBox(
                                  width:5,
                                ),





                              if(isMe)

                                Icon(



                                  Icons.done_all,



                                  size:15,



                                  color:

                                  Colors.white,



                                )



                            ],



                          )





                        ],



                      ),



                    ),



                  );



                },



              )


          ),







          Container(



            padding:
            const EdgeInsets.all(8),



            color:
            Colors.white,



            child:Row(



              children:[





                Expanded(



                  child:TextField(



                    controller:
                    messageController,



                    decoration:

                    InputDecoration(



                      hintText:
                      "Message",



                      filled:true,



                      fillColor:
                      Colors.grey.shade200,



                      border:

                      OutlineInputBorder(



                        borderRadius:

                        BorderRadius.circular(30),



                        borderSide:
                        BorderSide.none,



                      ),



                    ),



                  ),



                ),






                CircleAvatar(



                  backgroundColor:
                  Colors.green,



                  child:IconButton(



                    icon:

                    const Icon(

                      Icons.send,

                      color:Colors.white,

                    ),



                    onPressed:

                    sendMessage,



                  ),



                )





              ],



            ),



          )





        ],



      ),



    );

  }








  @override
  void dispose(){


    messageController.dispose();

    scrollController.dispose();


    super.dispose();


  }


}