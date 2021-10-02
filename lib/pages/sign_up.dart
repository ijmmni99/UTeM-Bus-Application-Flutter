import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utem_bus_app/components/rounded_input_field.dart';
import 'package:utem_bus_app/services/authentication_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => new _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  final TextEditingController sigUpEmailController = TextEditingController();
  final TextEditingController signUppasswordController =
      TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController staffNumber = TextEditingController();
  final TextEditingController icNumber = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController licenseNumber = TextEditingController();
  final TextEditingController faculty = TextEditingController();
  final TextEditingController course = TextEditingController();
  final TextEditingController matric = TextEditingController();

  GlobalKey<FormState> signUpPemanduKey = new GlobalKey<FormState>();
  GlobalKey<FormState> signUpPelajarKey = new GlobalKey<FormState>();
  int currentStep = 0;
  bool complete = false;
  bool type = false;
  String finalText;

  next() {
    goTo(currentStep + 1);
  }

  _submit(){
    setState(() {
          if(type == false){
            if (signUpPemanduKey.currentState.validate()) {
              context
                  .read<AuthenticationService>()
                  .signUp(
                      email: sigUpEmailController.text.trim(),
                      password: signUppasswordController.text.trim(),
                      firstName: firstName.text,
                      lastName: lastName.text,
                      icNumber: icNumber.text,
                      fonNumber: phoneNumber.text,
                      licenseNumber: licenseNumber.text,
                      staffNumber: staffNumber.text,
                      type: type)
                  .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value)));
                //Navigator.pop(context);
              });
            } else {
              currentStep = 0;
            }
          }
          else {
            if (signUpPelajarKey.currentState.validate()) {
              context
                  .read<AuthenticationService>()
                  .signUp(
                      email: sigUpEmailController.text.trim(),
                      password: signUppasswordController.text.trim(),
                      firstName: firstName.text,
                      lastName: lastName.text,
                      icNumber: faculty.text,
                      fonNumber: course.text,
                      staffNumber: matric.text,
                      type: type)
                  .then((value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(value)));
                //Navigator.pop(context);
              });
            } else {
              currentStep = 0;
            }
          }
            
          });
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    } else {
      Navigator.pop(context);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: <Widget>[
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Pendaftaran Akaun Baru',
                        style: TextStyle(
                            fontSize: size.height * 0.03,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ))
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -5),
                      blurRadius: 9,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                ),
                child: complete
                    ? Center(
                        child: AlertDialog(
                          title: Text(finalText),
                        ),
                      )
                    : Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    type = false;
                                    setState(() {
                                      currentStep = 0;
                                    });
                                  },
                                  child:Container(
                                margin: EdgeInsets.all(20),
                                height: size.height * 0.05,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).accentColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          blurRadius: 20,
                                          offset: Offset.zero,
                                          color: Colors.grey.withOpacity(0.5))
                                    ]),
                                  child: Center(
                                    child: Text(
                                      'Pemandu',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    type = true;
                                    setState(() {
                                      currentStep = 0;
                                    });
                                  },
                                  child:Container(
                                margin: EdgeInsets.all(20),
                                height: size.height * 0.05,
                                width: size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.blueAccent,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          blurRadius: 20,
                                          offset: Offset.zero,
                                          color: Colors.grey.withOpacity(0.5))
                                    ]),
                                  child: Center(
                                    child: Text(
                                      'Pelajar',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Expanded(
                              child: type ? Form(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              key: signUpPelajarKey,

                                  child: Stepper(
                                    controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            currentStep == 2 // this is the last step
                                            ? 
                                              ElevatedButton.icon(
                                              icon: Icon(Icons.create,color: Theme.of(context).accentColor,),
                                              onPressed: _submit,
                                              label: Text('DAFTAR', style: TextStyle(color: Theme.of(context).accentColor),),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.greenAccent
                                              ),
                                            )
                                            : ElevatedButton.icon(
                                              icon: Icon(Icons.navigate_next),
                                              onPressed: onStepContinue,
                                              label: Text('SETERUSNYA'),
                                              style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context).accentColor
                                              )
                                            ),
                                            ElevatedButton.icon(
                                              icon: Icon(Icons.delete_forever,color: Colors.redAccent,),
                                              label: Text('KEMBALI', style: TextStyle(color: Colors.redAccent)),
                                              onPressed: onStepCancel,
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.transparent, shadowColor: Colors.transparent,
                                              )
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    steps: <Step>[
                                      Step(
                                          title: const Text('Biodata'),
                                          content: Column(
                                            children: <Widget>[
                                              RoundedInputField(
                                                controller: matric,
                                                hinText: 'Nombor Matrik',
                                                icon: Icons.engineering,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                                onChanged: (value) {
                                                  if (value == null || value.isEmpty)
                                                    return 'Please enter some text';
                                                },
                                              ),
                                              RoundedInputField(
                                                controller: firstName,
                                                hinText: 'Nama Hadapan',
                                                icon: Icons.perm_identity,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                              RoundedInputField(
                                                controller: lastName,
                                                hinText: 'Nama Belakang',
                                                icon: Icons.perm_identity,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                            ],
                                          )),
                                      Step(
                                          title: const Text('Maklumat Pengajian'),
                                          content: Column(
                                            children: <Widget>[
                                              
                                              RoundedInputField(
                                                controller: faculty,
                                                hinText: 'Fakulti',
                                                icon: Icons.flag,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                              RoundedInputField(
                                                controller: course,
                                                hinText: 'Kursus',
                                                icon: Icons.car_rental,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                            ],
                                          )),
                                      Step(
                                          title: const Text('Akaun'),
                                          content: Column(
                                            children: <Widget>[
                                              RoundedInputField(
                                                controller: sigUpEmailController,
                                                hinText: 'E-mail UTeM',
                                                icon: Icons.mail,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                              RoundedInputField(
                                                controller: signUppasswordController,
                                                hinText: 'Password',
                                                icon: Icons.lock,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                            ],
                                          )),
                                    ],
                                    currentStep: currentStep,
                                    onStepContinue: next,
                                    onStepCancel: cancel,
                                    onStepTapped: (step) => goTo(step),
                                  ),
                              ) : Form(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  key: signUpPemanduKey,
                                  child:  Stepper(
                                    controlsBuilder: (BuildContext context, {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 16.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            currentStep == 2 // this is the last step
                                            ? 
                                              ElevatedButton.icon(
                                              icon: Icon(Icons.create,color: Theme.of(context).accentColor,),
                                              onPressed: _submit,
                                              label: Text('DAFTAR', style: TextStyle(color: Theme.of(context).accentColor),),
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.greenAccent
                                              ),
                                            )
                                            : ElevatedButton.icon(
                                              icon: Icon(Icons.navigate_next),
                                              onPressed: onStepContinue,
                                              label: Text('SETERUSNYA'),
                                              style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context).accentColor
                                              )
                                            ),
                                            ElevatedButton.icon(
                                              icon: Icon(Icons.delete_forever,color: Colors.redAccent,),
                                              label: Text('KEMBALI', style: TextStyle(color: Colors.redAccent)),
                                              onPressed: onStepCancel,
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.transparent, shadowColor: Colors.transparent,
                                              )
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  steps: <Step>[
                                    Step(
                                        title: const Text('Biodata'),
                                        content: Column(
                                          children: <Widget>[
                                            RoundedInputField(
                                              controller: staffNumber,
                                              hinText: 'Nombor Staff',
                                              icon: Icons.engineering,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                              onChanged: (value) {
                                                if (value == null || value.isEmpty)
                                                  return 'Please enter some text';
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: firstName,
                                              hinText: 'Nama Hadapan',
                                              icon: Icons.perm_identity,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: lastName,
                                              hinText: 'Nama Belakang',
                                              icon: Icons.perm_identity,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                          ],
                                        )),
                                    Step(
                                        title: const Text('Verifikasi'),
                                        content: Column(
                                          children: <Widget>[
                                            RoundedInputField(
                                              controller: icNumber,
                                              hinText: 'Nombor IC',
                                              icon: Icons.flag,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: licenseNumber,
                                              hinText: 'Nombor Lesen',
                                              icon: Icons.car_rental,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                          ],
                                        )),
                                    Step(
                                        title: const Text('Hubungi'),
                                        content: Column(
                                          children: <Widget>[
                                            RoundedInputField(
                                              controller: phoneNumber,
                                              hinText: 'Nombor Telefon',
                                              icon: Icons.call,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                              onChanged: (value) {
                                                if (value == null || value.isEmpty)
                                                  return 'Please enter some text';
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: sigUpEmailController,
                                              hinText: 'E-mail UTeM',
                                              icon: Icons.mail,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: signUppasswordController,
                                              hinText: 'Password',
                                              icon: Icons.lock,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                          ],
                                        )),
                                  ],
                                  currentStep: currentStep,
                                  onStepContinue: next,
                                  onStepCancel: cancel,
                                  onStepTapped: (step) => goTo(step),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
