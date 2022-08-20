// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CustomerIDDetails welcomeFromJson(String str) => CustomerIDDetails.fromJson(json.decode(str));

String welcomeToJson(CustomerIDDetails data) => json.encode(data.toJson());

class CustomerIDDetails {
  CustomerIDDetails({
    required this.customerDetails,
  });

  List<CustomerDetail> customerDetails;

  factory CustomerIDDetails.fromJson(Map<String, dynamic> json) => CustomerIDDetails(
    customerDetails: List<CustomerDetail>.from(json["CustomerDetails"].map((x) => CustomerDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "CustomerDetails": List<dynamic>.from(customerDetails.map((x) => x.toJson())),
  };
}

class CustomerDetail {
  CustomerDetail({
    required this.custId,
    this.custName,
    this.custUrl,
    this.appver,
    this.custimageurl,
    this.projectCustUrl,
    this.projectAppver,
    this.projectflag,
    this.serviceflag,
    this.compatibilityflag,
    this.serveripnamewocontext,
  });

  String custId;
  String? custName;
  String? custUrl;
  String? appver;
  String? custimageurl;
  String? projectCustUrl;
  String? projectAppver;
  String? projectflag;
  String? serviceflag;
  String? compatibilityflag;
  String? serveripnamewocontext;

  factory CustomerDetail.fromJson(Map<String, dynamic> json) => CustomerDetail(
    custId: json["CustId"],
    custName: json["CustName"],
    custUrl: json["CustUrl"],
    appver: json["Appver"],
    custimageurl: json["Custimageurl"],
    projectCustUrl: json["ProjectCustUrl"],
    projectAppver: json["ProjectAppver"],
    projectflag: json["Projectflag"],
    serviceflag: json["Serviceflag"],
    compatibilityflag: json["compatibilityflag"],
    serveripnamewocontext: json["serveripnamewocontext"],
  );

  Map<String, dynamic> toJson() => {
    "CustId": custId,
    "CustName": custName,
    "CustUrl": custUrl,
    "Appver": appver,
    "Custimageurl": custimageurl,
    "ProjectCustUrl": projectCustUrl ,
    "ProjectAppver": projectAppver,
    "Projectflag": projectflag,
    "Serviceflag": serviceflag,
    "compatibilityflag": compatibilityflag ,
    "serveripnamewocontext": serveripnamewocontext,
  };
}

// enum Compatibilityflag { YES, EMPTY }

// final compatibilityflagValues = EnumValues({
//   "": Compatibilityflag.EMPTY,
//   "Yes": Compatibilityflag.YES
// });

// enum ProjectAppver { THE_10, EMPTY }

// final projectAppverValues = EnumValues({
//   "": ProjectAppver.EMPTY,
//   "1.0": ProjectAppver.THE_10
// });

// enum Flag { YES, NO }

// final flagValues = EnumValues({
//   "No": Flag.NO,
//   "Yes": Flag.YES
// });

class EnumValues<T> {
  Map<String, T>? map ;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
