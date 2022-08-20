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
}