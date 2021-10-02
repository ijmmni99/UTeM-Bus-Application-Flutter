// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utem_bus_app/components/not_sign_up_yet.dart';
import 'package:utem_bus_app/components/rounded_button.dart';
import 'package:utem_bus_app/components/rounded_input_field.dart';
import 'package:utem_bus_app/components/rounded_password_field.dart';
import 'package:utem_bus_app/components/text_field_container.dart';
import 'package:utem_bus_app/pages/sign_up.dart';
import 'package:utem_bus_app/services/authentication_service.dart';
import 'package:utem_bus_app/shared/loading.dart';
import 'package:video_player/video_player.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginWidget> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //VideoPlayerController _controller;
  //Future<void> _initializeVideoPlayerFuture;

  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  String videoUrl;
  bool loading = false;

  @override
  void initState() {
    super.initState();

    // _controller = VideoPlayerController.asset('assets/bus.gif');
    // _controller.initialize().then((value) {
    //   _controller.play();
    //   _controller.setLooping(true);
    //   setState(() {});
    // });
    //setState(() {
    //  loading = true;
    //});

    // FirebaseFirestore.instance
    //     .collection('mainvideo')
    //     .get()
    //     .then((QuerySnapshot query) => {
    //           query.docs.forEach((doc) {
    //             videoUrl = doc["url"];
    //             _controller = VideoPlayerController.network(videoUrl);
    //             _initializeVideoPlayerFuture =
    //                 _controller.initialize().then((value) {
    //               _controller.play();
    //               _controller.setLooping(true);
    //               setState(() {
    //                 loading = false;
    //               });
    //             });
    //           })
    //         });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          // SizedBox.expand(
          //   child: loading
          //       ? Loading()
          //       : Container(
          //         margin: EdgeInsets.symmetric(vertical: 200.0, horizontal: 10),
          //         alignment: FractionalOffset.centerLeft,
          //         decoration: BoxDecoration(
          //           image: DecorationImage(
          //             image: AssetImage('assets/bus.gif'),
          //             fit: BoxFit.cover,
          //           ),
          //         ),

          //           // child: SizedBox(
          //           //   width: _controller.value.size?.width ?? 0,
          //           //   height: _controller.value.size?.height ?? 0,
          //           //   child: VideoPlayer(_controller),
          //           // ),
          //         ),
          // ),
          Form(
            key: loginKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Container(
                //   child: Center(
                //     child: Image(
                //       image: AssetImage("assets/bus.png"),
                //       width: size.width * 0.5,
                //       height: size.height * 0.35,
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/bus.gif"),
                      width: size.width,
                      height: size.height * 0.35,
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                // child: SizedBox(
                //   width: _controller.value.size?.width ?? 0,
                //   height: _controller.value.size?.height ?? 0,
                //   child: VideoPlayer(_controller),
                // ),
                RoundedInputField(
                  hinText: "E-mail Anda",
                  icon: Icons.person,
                  controller: emailController,
                  validator: (value) { 
                    if(value.isEmpty)
                    return "Required";
                  },
                  onChanged: (value) {
                    //do something
                  },
                ),
                RoundedPasswordField(
                  validator: (value) { 
                    if(value.isEmpty)
                    return "Required";
                  },
                  controller: passwordController,
                  onChanged: (value) {},
                ),
                RoundedButton(
                  text: 'Log Masuk',
                  press: () {
                    if(loginKey.currentState.validate()){
                        context.read<AuthenticationService>().signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim()).then((value) {
                          print(value);
                          if(value != "Signed in"){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value)));
                          }
                        });
                    }
                    else{
                      return;
                    }
                  },
                ),
                SizedBox(height: size.height * 0.05),
                NotSignUpTextButton(
                  press: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return SignUpScreen();
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: size.height * 0.08),
                
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }
}
