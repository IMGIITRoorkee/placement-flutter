import 'package:flutter/material.dart';
import 'package:placement/screens/home/screens_for_apply/bottomModalApplySheet.dart';
import 'package:placement/services/api_models/deleteService.dart';

class ProfilePage extends StatefulWidget {
  final args;
  ProfilePage({Key key, this.args}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  DeleteService _deleteService;

  @override
  void initState() {
    _deleteService = DeleteService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.args);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Company Details"),
      ),
      body: Container(
        width: _width,
        height: _height,
        color: Colors.red,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                width: _width*0.8,
                child: Text(
                  widget.args.companyName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                width: _width*0.8,
                child: Text(
                  widget.args.companySector,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: _width*0.8,
                child: Text(
                  widget.args.companyDescription,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 5,),
              Container(
                width: _width*0.8,
                child: _profileStatus(context,_width,_height),
              ),
              SizedBox(height: 5,),
              Container(
                color: Colors.blue,
                height: 200,
                width: 200,
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileStatus(BuildContext context, double _width, double _height) {
    switch (widget.args.status) {
      case 'branch_not_eligible' :
          return Card(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                title: Text(
                  "This Company is Incompatilble with you branch",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                leading: Icon(Icons.highlight_off,color: Colors.red,),
              ),
            ),
          );
        break;
      case 'expired' :
          return Card(
            child: Container(
              width: _width*0.8,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListTile(
                title: Text(
                  "This Deadline for application has expired",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                leading: Icon(Icons.highlight_off,color: Colors.red,),
              ),
            ),
          );
        break;
      case 'open' :
        return RaisedButton(
          child: Text("Apply",style: TextStyle(color: Colors.white),),
          color: Colors.blue,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return BottomModalApplySheet(
                  profile: widget.args,
                );
              }
            );
          },
        );
        break;
      case 'withdrawable' :
        return RaisedButton(
          child: Text("Withdraw",style: TextStyle(color: Colors.white),),
          color: Colors.red,
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (_) => AlertDialog(
                content: Text("Do you wish to withdraw your resume from this Company?"),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Sure"),
                    onPressed: () async {
                      _deleteService.deleteApplicationService(widget.args.application['id']);
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ], 
              )
            );
          },
        );
        break;
      default:
    }
  }
}