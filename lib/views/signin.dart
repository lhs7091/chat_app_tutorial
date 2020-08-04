import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRoomsScreen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {

  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEdittingController = new TextEditingController();
  TextEditingController passwordTextEdittingController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot querySnapshotUserInfo;

  signIn(isLoading){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailSharedPreference(emailTextEdittingController.text);

      databaseMethods.getUserByUserEmail(emailTextEdittingController.text).then((val){
        querySnapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(querySnapshotUserInfo.documents[0].data["name"]);
      });

      setState(() {
        isLoading = true;
      });

      authMethods.signInWithEmailAndPassword(emailTextEdittingController.text,
          passwordTextEdittingController.text).then((val){
        if(val != null){

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => ChatRoom()
          ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: SingleChildScrollView(
            child:Container(
                height: MediaQuery.of(context).size.height-200,
                alignment: Alignment.bottomCenter,
                child:Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(children: [
                          TextFormField(
                            validator: (val){
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val) ? null: "Please provide a valid Email address";
                            },
                            controller: emailTextEdittingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("email")
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                            obscureText: true,
                            validator: (val){
                              return val.length > 6 ? null : "Please provide password 6+ character";
                            },
                            controller: passwordTextEdittingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("password")
                          ),
                        ],
                        ),
                      ),
                      SizedBox(height:30,),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text("Forgot Password", style: simpleTextStyle(),),
                        ),
                      ),

                      SizedBox(height: 30,),
                      GestureDetector(
                        onTap: (){
                          signIn(isLoading);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0xff007EF4),
                                    const Color(0xff2A75BC)
                                  ]
                              ),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Text("Sign In", style: mediumTextStyle(),),
                        ),
                      ),

                      SizedBox(height: 16,),
                      Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text("Sign In with Google", style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20
                        ),),
                      ),
                      SizedBox(height: 30,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have account? ", style: mediumTextStyle(),),
                          GestureDetector(
                            onTap: (){
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text("Register now", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration: TextDecoration.underline
                              )),
                            ),
                          ),


                        ],
                      ),
                      SizedBox(height: 70,),
                    ],
                  ),
                )
            )
        )
    );
  }
}

