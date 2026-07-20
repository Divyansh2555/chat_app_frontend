import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;



class ProfilePage extends StatefulWidget {

  final int userId;


  const ProfilePage({

    super.key,

    required this.userId,

  });



  @override
  State<ProfilePage> createState() => _ProfilePageState();

}





class _ProfilePageState extends State<ProfilePage> {



  final String baseUrl =
      "http://192.168.121.43:8000";



  final fullNameController =
  TextEditingController();


  final bioController =
  TextEditingController();


  final phoneController =
  TextEditingController();


  final addressController =
  TextEditingController();




  File? profileImage;



  bool loading = false;



  Map<String,dynamic>? profile;




  final ImagePicker picker = ImagePicker();






  @override
  void initState(){

    super.initState();

    getProfile();

  }









  // PICK IMAGE FROM GALLERY

  Future<void> pickImage() async {


    final XFile? image =
    await picker.pickImage(

      source: ImageSource.gallery,

    );



    if(image != null){


      setState(() {


        profileImage =
            File(image.path);


      });


    }


  }









  // GET PROFILE

  Future<void> getProfile() async {



    setState(() {

      loading=true;

    });




    try{


      final response =
      await http.get(


        Uri.parse(

          "$baseUrl/profiles/${widget.userId}",

        ),


      );





      print(response.body);




      if(response.statusCode == 200){


        setState(() {


          profile =
              jsonDecode(response.body);


        });


      }


      else{


        setState(() {

          profile=null;

        });


      }




    }catch(e){

      print(e);

    }



    setState(() {

      loading=false;

    });



  }












  // CREATE PROFILE

  Future<void> createProfile() async {



    setState(() {

      loading=true;

    });




    try{


      var request =
      http.MultipartRequest(

        "POST",

        Uri.parse(

          "$baseUrl/profiles/${widget.userId}",

        ),

      );





      request.fields["full_name"] =

          fullNameController.text.trim();




      request.fields["bio"] =

          bioController.text.trim();




      request.fields["phone"] =

          phoneController.text.trim();




      request.fields["address"] =

          addressController.text.trim();







      if(profileImage != null){



        request.files.add(



          await http.MultipartFile.fromPath(


            "profile_image",



            profileImage!.path,



            filename:

            path.basename(

                profileImage!.path

            ),



          ),



        );


      }







      final response =
      await request.send();




      print(
          response.statusCode
      );






      if(response.statusCode == 200 ||
          response.statusCode == 201){



        await getProfile();



      }




    }catch(e){


      print(e);


    }






    setState(() {

      loading=false;

    });



  }












  Widget field(

      TextEditingController controller,

      String title

      ){



    return Padding(


      padding:

      const EdgeInsets.only(

          bottom:15

      ),




      child:TextField(



        controller:controller,



        decoration:InputDecoration(



          labelText:title,



          border:

          const OutlineInputBorder(),


        ),



      ),


    );

  }









  @override
  void dispose(){


    fullNameController.dispose();

    bioController.dispose();

    phoneController.dispose();

    addressController.dispose();



    super.dispose();


  }









  @override
  Widget build(BuildContext context){



    return Scaffold(



      appBar:AppBar(


        title:

        const Text(

            "Profile"

        ),


      ),






      body:

      loading



          ?

      const Center(

        child:

        CircularProgressIndicator(),

      )



          : profile == null




          ? createForm()





          : profileDetail(),




    );

  }












  Widget createForm(){



    return SingleChildScrollView(


      padding:

      const EdgeInsets.all(20),




      child:Column(



        children:[




          GestureDetector(



            onTap:pickImage,



            child:Container(



              height:120,

              width:120,



              decoration:BoxDecoration(



                border:

                Border.all(),



                borderRadius:

                BorderRadius.circular(10),



              ),




              child:

              profileImage == null



                  ?

              const Center(

                child:

                Text(

                    "Select Image"

                ),

              )



                  :

              Image.file(

                profileImage!,

                fit:

                BoxFit.cover,

              ),



            ),



          ),






          const SizedBox(

              height:20

          ),






          field(

            fullNameController,

            "Full Name",

          ),





          field(

            bioController,

            "Bio",

          ),





          field(

            phoneController,

            "Phone",

          ),





          field(

            addressController,

            "Address",

          ),






          const SizedBox(

              height:20

          ),





          SizedBox(


            width:

            double.infinity,



            height:

            50,




            child:

            ElevatedButton(



              onPressed:

              createProfile,



              child:

              const Text(

                  "Save Profile"

              ),



            ),


          )



        ],



      ),


    );

  }









  Widget profileDetail(){



    return SingleChildScrollView(


      padding:

      const EdgeInsets.all(20),




      child:Column(



        crossAxisAlignment:

        CrossAxisAlignment.start,




        children:[





          if(profile!["profile_image"] != null)

            Image.network(



              profile!["profile_image"],



              height:120,

              width:120,


            ),





          const SizedBox(

              height:20

          ),






          Text(



            profile!["full_name"] ?? "",




            style:

            const TextStyle(



              fontSize:25,

              fontWeight:

              FontWeight.bold,



            ),



          ),





          const SizedBox(

              height:15

          ),





          Text(

            "Bio : ${profile!["bio"] ?? ""}",

          ),




          const SizedBox(

              height:10

          ),





          Text(

            "Phone : ${profile!["phone"] ?? ""}",

          ),





          const SizedBox(

              height:10

          ),





          Text(

            "Address : ${profile!["address"] ?? ""}",

          ),





          const SizedBox(

              height:10

          ),





          Text(

            "User ID : ${profile!["user_id"]}",

          ),




        ],



      ),


    );

  }



}