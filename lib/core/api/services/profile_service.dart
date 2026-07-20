import 'dart:io';

import 'package:http/http.dart' as http;



class ProfileService {


  final String baseUrl =
      "http://192.168.121.43:8000";





  // CREATE PROFILE WITH IMAGE

  Future<http.StreamedResponse> createProfile(

      int userId,

      Map<String, String> data,

      File? image,

      ) async {



    var request = http.MultipartRequest(


      "POST",


      Uri.parse(

        "$baseUrl/profiles/$userId",

      ),


    );




    // Text Fields

    request.fields.addAll(data);






    // Image Upload

    if(image != null){


      request.files.add(

        await http.MultipartFile.fromPath(

          "profile_image",

          image.path,

        ),

      );


    }





    request.headers.addAll({

      "Accept":"application/json",

    });





    return await request.send();


  }









  // GET PROFILE

  Future<http.Response> getProfile(

      int userId,

      ) async {



    return await http.get(



      Uri.parse(

        "$baseUrl/profiles/$userId",

      ),



      headers: {


        "Accept":"application/json",


      },


    );



  }





}