
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uno_point_sale/models/customer_id_details.dart';

class LocalPreferences{
  static SharedPreferences? sharedPreferences;

  //static Future init() async => sharedPreferences = await SharedPreferences.getInstance();

  static const keyCustId = "custId";
  static const KeyCustName= "custName";
  static const keyCustUrl = "custUrl";
  static const keyAppVer = "appver";
  static const keyCustImageUrl = "custimageurl";
  static const keyProjectCustUrl = "projectCustUrl";
  static const keyProjectAppver = "projectAppver";
  static const keyProjectFlag = "projectflag";
  static const keyServiceFlag = "serviceflag";
  static const keyCompatibilityFlag = "compatibilityflag";
  static const keyServerIpNameWoContext = "serveripnamewocontext";

  static Future setCustIdDetails(List<CustomerDetail>? list, String enteredCustId) async {
    sharedPreferences = await SharedPreferences.getInstance();
    for(var i = 0 ; i < list!.length ; i++){
      var custId = list[i].custId;
      if(custId.compareTo(enteredCustId)==0){
        await sharedPreferences!.setString(keyCustId, list[i].custId );
        await sharedPreferences!.setString(KeyCustName, list[i].custName ?? '');
        await sharedPreferences!.setString(keyCustUrl, list[i].custUrl ?? '');
        await sharedPreferences!.setString(keyAppVer, list[i].appver ?? '');
        await sharedPreferences!.setString(keyCustImageUrl, list[i].custimageurl ?? '');
        await sharedPreferences!.setString(keyProjectCustUrl, list[i].projectCustUrl ?? '');
        await sharedPreferences!.setString(keyProjectAppver, list[i].projectAppver ?? '');
        await sharedPreferences!.setString(keyProjectFlag, list[i].projectflag ?? '');
        await sharedPreferences!.setString(keyServiceFlag, list[i].serviceflag ?? '');
        await sharedPreferences!.setString(keyCompatibilityFlag, list[i].compatibilityflag ?? '');
        await sharedPreferences!.setString(keyServerIpNameWoContext, list[i].serveripnamewocontext ?? '');
      }
    }
  }

  static Future<String?> getCustIdDetails() async {
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences!.getString(keyCustId);
  }

}