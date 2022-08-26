import 'dart:io';

import 'package:http/io_client.dart';
import 'package:uno_point_sale/models/customer_id_details.dart';
import 'package:http/http.dart' as http;

class CustomerIdDetailsService{
  Future<CustomerIDDetails?> getCustomerIdDetails() async{
    var client = http.Client();
    var uri = Uri.parse('https://keystone1.intelli.uno/upsdinf/jsp/MDMappingNew.html');
    var response = await client.get(uri);
    if(response.statusCode == 200){
      var json = response.body;
      return welcomeFromJson(json);
    }
  }
  Future asyncFileUpload(String text, File file) async{
    //create multipart request for POST or PATCH method
    var uri = Uri.parse('https://test1.intelli.uno:18443/erprmwise/MobileDeviceFileupload.do');
    var request = http.MultipartRequest("POST", uri);
    //add text fields
    request.fields["action"] = "submit";
    request.fields["imei"] = "519090904789302";
    request.fields["ver"] = "2.0";
    request.fields["m_strTicketID"] = "26237";
    request.fields["FileCategoryID"] = "1";
    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("thefile", file.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
  }
}