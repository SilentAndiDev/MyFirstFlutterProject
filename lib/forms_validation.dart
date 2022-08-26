
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FormsValidation(),
    );
  }
}

class FormsValidation extends StatefulWidget{
  const FormsValidation({Key? key}) : super(key: key);

  @override
  State<FormsValidation> createState() => _MyFirstFrom();

}

class _MyFirstFrom extends State<FormsValidation>{

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formCheckListKey = new GlobalKey<FormState>();
  late String _name;
  late String _mobileNo;
  late String _email;
  late String _date;
  late String _age;
  late String _password;
  ScrollController? _listController;

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildName(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Name"),
      validator: (value){
        if(value == null|| value.isEmpty){
          return "Name is required";
        }
        if(RegExp("[0-9]").hasMatch(value)){
          return "Name can not contains number";
        }

        return null;
      },
      onSaved: (value){
        _name = value!;
      },
    );
  }

  Widget _buildMobileNo(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Number"),
      keyboardType: TextInputType.number,
      validator: (value){
        if(value == null|| value.isEmpty){
          return "Mobile number is filed is empty";
        }
        if(RegExp("[A-Za-z]").hasMatch(value)){
          return "Mobile number don't contains alphabet ";
        }
        return null;
      },
      onSaved: (value){
        _mobileNo = value!;
      },
    );
  }

  Widget _buildEmailId(){
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      validator: (value){
        if(value == null|| value.isEmpty){
          return "Email id is filed is empty";
        }
        if(RegExp("/\S+@\S+\.\S+/").hasMatch(value)){
          return "Invalid email id";
        }
        return null;
      },
      onSaved: (value){
        _email = value!;
      },
    );
  }

  Widget _formUI(){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildName(),
          _buildEmailId(),
          _buildMobileNo(),
          OutlinedButton(onPressed: (){
            if(!_formKey.currentState!.validate()){
              return;
            }
            _formKey.currentState!.save();

            print(_name);
            print(_mobileNo);
            print(_email);
          }, child: const Text("Submit"))
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Form Validation"),),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: _ListViewUI()
      ),
    );
  }

  late List<MyData> dataList = [];

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();


  Widget _ListViewUI(){

    dataList.clear();
    dataList.add(MyData(1, "", "Text", "Power Cut",""));
    dataList.add(MyData(2, "", "DropDown", "Charger","1,2,3,4,5"));
    dataList.add(MyData(3, "", "Text", "New Battery",""));
    dataList.add(MyData(4, "", "Text", "Car",""));
    dataList.add(MyData(5, "", "Text", "Mobile",""));
    dataList.add(MyData(6, "", "DropDown", "IPhone","Cake,Iec-Cream,Falooda"));
    dataList.add(MyData(7, "", "Text", "Bag",""));
    dataList.add(MyData(8, "", "Text", "AC",""));
    dataList.add(MyData(9, "", "Text", "Owen",""));
    dataList.add(MyData(10, "", "DropDown", "Dustbin","Shirt,T-Shirt,Jacket"));
    dataList.add(MyData(11, "", "Text", "Local Area Clear",""));
    dataList.add(MyData(12, "", "Text", "Pen",""));

    return Form(
      key: _formCheckListKey,
      child: Column(
          children:[
          Expanded(
            child: ScrollablePositionedList.builder(
              itemCount : dataList.length,
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              itemBuilder: (context,index){
                return  _ViewItem(index);
              },
            ),
          ),
          OutlinedButton(onPressed: (){
            /*if(!_formCheckListKey.currentState!.validate()){
              return;
            }*/

            _scrollToIndex();
           // _formCheckListKey.currentState!.save();

            print("save and done");
          }, child: Text("Submit"))
        ]
      ),
    );
  }

  var test;

  _ViewItem(index){
    return Card(
      child: Column(
        children: [
          if(dataList[index].labelType == "Text")
            _buildLabelTypeText(index)
          else if(dataList[index].labelType == "DropDown")
            _buildLabelTypeDropDown(index)
        ],
      ),
    );
  }

  var newvalue;

  _buildLabelTypeDropDown(index){
      return Padding(
        padding: EdgeInsets.all(18.0),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          items: _createDropDownList(dataList[index].dropDownList),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(labelText : dataList[index].labelValue),
          value: dataList[index].inputValue.isEmpty ? null : dataList[index].inputValue  ,
          validator: (value){
            if(value == null || value.isEmpty || value == dataList[index].labelValue ){
              return dataList[index].labelValue;
            }
            return null;
          },
          onChanged: (value){
            if(value != null && value.isNotEmpty) {
              dataList[index].inputValue = value.toString();
            }
          }    ,

        ),
      );

  }

  /*DropdownButton<String>(
  items: <String>['A', 'B', 'C', 'D'].map((String value) {
  return DropdownMenuItem<String>(
  value: value,
  child: Text(value),
  );
  }).toList(),
  onChanged: (_) {},
  );*/

  List<DropdownMenuItem<String>> _createDropDownList(commaDelimitedList){
    
     var list = commaDelimitedList.split(",");
      List<DropdownMenuItem<String>> dropdownItems = [];

      for (String currency in list){
        var newItem = DropdownMenuItem(
          child: Text(currency),
          value: currency,
        );
        dropdownItems.add(newItem);
      }
      return dropdownItems.toList();
  }

  // return DropdownButton(
  // items: snapGenre.data.genres.map((map) => DropdownMenuItem(
  // child: Text(map.name),
  // value: map.id,
  // ),
  // ).toList(),
  // );

  _buildLabelTypeText(index){
    return Padding(
      padding: const EdgeInsets.all(18.0),


        child: TextFormField(
          initialValue: dataList[index].inputValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(labelText: dataList[index].labelValue),
          validator: (value){
            if(value == null || value.isEmpty){
              return dataList[index].labelValue;
            }
            return null;
          },
          onSaved: (value) {
            dataList[index].inputValue =  value!;
          },
          onChanged: (text){
            dataList[index].inputValue =  text;
          },
        ),

    );
  }

  Future _scrollToIndex() async {
    var position = 0;
    for(int i = 0; i < dataList.length; i++){
      if(dataList[i].inputValue.isEmpty){
        position = i;
        if(dataList[i].labelType == "DropDown" ){
          if(dataList[i].inputValue == dataList[i].labelValue){
            await itemScrollController.scrollTo(
                index: position,
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutCubic);
          }
        }
        await itemScrollController.scrollTo(
            index: position,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOutCubic);
        break;
      }
    }


    if(!_formCheckListKey.currentState!.validate()){
      return;
    }
    //print(_listController!.position.);
    // _formCheckListKey.currentContext!.size!.height;
    // await _listController!.position.ensureVisible(
    //   _formCheckListKey.currentContext!.findRenderObject()!,
    // );
    /*await _listController!.animateTo(50 * 6, duration: const Duration(milliseconds: 300), curve: Curves.elasticOut);
    if(!_formCheckListKey.currentState!.validate()){
      return;
    }*/
  }




}



class MyData{
  int id = 0;
  String inputValue ="";
  String labelType = "";
  String labelValue = "";
  String dropDownList = "";

  MyData(this.id, this.inputValue, this.labelType, this.labelValue, this.dropDownList);
}