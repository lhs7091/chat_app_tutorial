import 'package:chat_app_tutorial/helper/helperfunctions.dart';
import 'package:chat_app_tutorial/services/auth.dart';
import 'package:chat_app_tutorial/services/database.dart';
import 'package:chat_app_tutorial/views/chatRoomsScreen.dart';
import 'package:chat_app_tutorial/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameTextEdittingController = new TextEditingController();
  TextEditingController emailTextEdittingController = new TextEditingController();
  TextEditingController passwordTextEdittingController = new TextEditingController();

  signMeUp(){
    if(formKey.currentState.validate()){
      //print("${val.uid}");
      Map<String, String> userInfoMap = {
        "name" : userNameTextEdittingController.text,
        "email" : emailTextEdittingController.text
      };

      HelperFunctions.saveUserEmailSharedPreference(emailTextEdittingController.text);
      HelperFunctions.saveUserNameSharedPreference(userNameTextEdittingController.text);

      setState(() {
        isLoading = true;
      });

      authMethods.signUpwithEmailAndPassword(emailTextEdittingController.text, passwordTextEdittingController.text)
        .then((val){
          databaseMethods.uploadUserInfo(userInfoMap);

          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => ChatRoom()
          ));
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child:Center(child: CircularProgressIndicator())
      ) : SingleChildScrollView(
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
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (val){
                              return val.isEmpty || val.length<4 ? "Please Provide UserName": null;
                            },
                            controller: userNameTextEdittingController,
                            style: simpleTextStyle(),
                            decoration: textFieldInputDecoration("username")
                          ),
                          SizedBox(height: 20,),
                          TextFormField(
                              validator: (val){
                                return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
                        //TODO
                        signMeUp();
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
                        child: Text("Sign UP", style: mediumTextStyle(),),
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
                      child: Text("Sign Up with Google", style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20
                      ),),
                    ),
                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account? ", style: mediumTextStyle(),),
                        GestureDetector(
                          onTap: (){
                            widget.toggle();
                          },
                          child:Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child:Text("Sign In now", style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  decoration: TextDecoration.underline
                              ))
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 70,),
                  ],
                ),
              )
          )
      ),
    );
  }
}
