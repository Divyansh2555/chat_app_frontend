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
      "http://10.56.28.43:8000";



  final fullNameController =
  TextEditingController();

  final bioController =
  TextEditingController();

  final phoneController =
  TextEditingController();

  final addressController =
  TextEditingController();



  File? profileImage;


  Map<String,dynamic>? profile;


  bool loading=false;



  final ImagePicker picker =
  ImagePicker();





  @override
  void initState(){

    super.initState();

    getProfile();

  }







  Future<void> pickImage() async{


    final XFile? image =
    await picker.pickImage(

      source: ImageSource.gallery,

      imageQuality: 70,

    );



    if(image != null){

      setState(() {

        profileImage =
            File(image.path);

      });

    }


  }








  Future<void> getProfile() async{


    setState(() {

      loading=true;

    });



    try{


      final response =
      await http.get(

        Uri.parse(

            "$baseUrl/profiles/${widget.userId}"

        ),

      );



      if(response.statusCode==200){


        final data =
        jsonDecode(response.body);



        setState(() {


          profile=data;


          fullNameController.text =
              data["full_name"] ?? "";


          bioController.text =
              data["bio"] ?? "";


          phoneController.text =
              data["phone"] ?? "";


          addressController.text =
              data["address"] ?? "";


        });



      }

      else{


        setState(() {

          profile=null;

        });


      }



    }

    catch(e){

      print(e);

    }



    setState(() {

      loading=false;

    });


  }









  Future<void> createProfile() async{


    setState(() {

      loading=true;

    });



    try{



      var request =
      http.MultipartRequest(

        "POST",

        Uri.parse(

            "$baseUrl/profiles/${widget.userId}"

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



      if(response.statusCode==200 ||

          response.statusCode==201){


        await getProfile();


      }




    }

    catch(e){

      print(e);

    }



    setState(() {

      loading=false;

    });


  }









  String imageUrl(){


    if(profile == null ||

        profile!["profile_image"] == null){

      return "";

    }



    String image =
    profile!["profile_image"].toString();



    if(image.startsWith("http")){

      return image;

    }


    return "$baseUrl/$image";


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



      child:

      TextField(

        controller:controller,


        decoration:

        InputDecoration(

          labelText:title,


          border:

          const OutlineInputBorder(),

        ),


      ),


    );


  }











  Widget profileImageView(){


    return GestureDetector(


      onTap:pickImage,



      child:

      CircleAvatar(


        radius:60,



        backgroundImage:


        profileImage != null


            ?


        FileImage(profileImage!)



            :


        imageUrl().isNotEmpty


            ?


        NetworkImage(

            imageUrl()

        )

            :

        null,




        child:


        profileImage==null &&

            imageUrl().isEmpty



            ?


        const Icon(

          Icons.camera_alt,

          size:50,

        )


            :

        null,


      ),


    );


  }









  Widget createForm(){


    return SingleChildScrollView(


      padding:

      const EdgeInsets.all(20),



      child:

      Column(


        children:[



          profileImageView(),




          const SizedBox(

              height:20

          ),





          field(

              fullNameController,

              "Full Name"

          ),



          field(

              bioController,

              "Bio"

          ),



          field(

              phoneController,

              "Phone"

          ),



          field(

              addressController,

              "Address"

          ),





          SizedBox(


            width:

            double.infinity,



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



      child:

      Column(


        children:[




          profileImageView(),





          const SizedBox(

              height:20

          ),





          Text(

            profile!["full_name"] ?? "",


            style:

            const TextStyle(

              fontSize:26,

              fontWeight:

              FontWeight.bold,

            ),


          ),





          const SizedBox(

              height:15

          ),




          Text(

              "Bio : ${profile!["bio"] ?? ""}"

          ),



          Text(

              "Phone : ${profile!["phone"] ?? ""}"

          ),



          Text(

              "Address : ${profile!["address"] ?? ""}"

          ),



          Text(

              "User ID : ${profile!["user_id"]}"

          ),




        ],


      ),


    );


  }









  @override
  Widget build(BuildContext context){


    return Scaffold(



      appBar:

      AppBar(

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

          :


      profile==null


          ?


      createForm()


          :


      profileDetail(),



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



}