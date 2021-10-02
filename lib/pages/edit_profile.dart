import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utem_bus_app/components/rounded_input_field.dart';
import 'package:utem_bus_app/services/authentication_service.dart';

class EditProfileWidget extends StatefulWidget {

  final bool userType;

  const EditProfileWidget(
      {Key key, this.userType})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileWidget> {
 final TextEditingController editEmailController = TextEditingController();
  final TextEditingController editpasswordController =
      TextEditingController();
  final TextEditingController editfirstName = TextEditingController();
  final TextEditingController editlastName = TextEditingController();
  final TextEditingController editstaffNumber = TextEditingController();
  final TextEditingController editicNumber = TextEditingController();
  final TextEditingController editphoneNumber = TextEditingController();
  final TextEditingController editlicenseNumber = TextEditingController();
  final TextEditingController editfaculty = TextEditingController();
  final TextEditingController editcourse = TextEditingController();
  final TextEditingController editmatric = TextEditingController();

  GlobalKey<FormState> editPemanduKey = new GlobalKey<FormState>();
  GlobalKey<FormState> editPelajarKey = new GlobalKey<FormState>();
  int currentStep = 0;
  bool complete = false;
  String finalText;

  @override
  void initState() {
    getUserData();

    super.initState();
  }

  void getUserData() async {
    DocumentSnapshot doc;
    if(widget.userType) {
      doc = await FirebaseFirestore.instance.collection('pelajar').doc(FirebaseAuth.instance.currentUser.uid).get();
      editfirstName.text = doc.data()['FirstName'];
      editlastName.text = doc.data()['LastName'];
      editEmailController.text = doc.data()['Email'];
      editpasswordController.text = doc.data()['Password'];
      editfaculty.text = doc.data()['Faculty'];
      editcourse.text = doc.data()['Course'];
      editmatric.text = doc.data()['StudentID'];
    }
    else {
      doc = await FirebaseFirestore.instance.collection('pemandu').doc(FirebaseAuth.instance.currentUser.uid).get();
      editfirstName.text = doc.data()['FirstName'];
      editlastName.text = doc.data()['LastName'];
      editEmailController.text = doc.data()['Email'];
      editpasswordController.text = doc.data()['Password'];
      editicNumber.text = doc.data()['IdentityCard'];
      editphoneNumber.text = doc.data()['PhoneNumber'];
      editlicenseNumber.text = doc.data()['License'];
      editstaffNumber.text = doc.data()['DriverID'];
    }
  }

  next() {
    goTo(currentStep + 1);
  }

  _submit(){
    setState(() {
          if(widget.userType == false){
            if (editPemanduKey.currentState.validate()) {
              context
                  .read<AuthenticationService>()
                  .editProfile(
                      email: editEmailController.text.trim(),
                      password: editpasswordController.text.trim(),
                      firstName: editfirstName.text,
                      lastName: editlastName.text,
                      icNumber: editicNumber.text,
                      fonNumber: editphoneNumber.text,
                      licenseNumber: editlicenseNumber.text,
                      staffNumber: editstaffNumber.text,
                      type: widget.userType)
                  .then((value) {
                finalText = value;
                complete = true;
                Navigator.pop(context);
              });
            } else {
              currentStep = 0;
            }
          }
          else {
            if (editPelajarKey.currentState.validate()) {
              context
                  .read<AuthenticationService>()
                  .editProfile(
                      email: editEmailController.text.trim(),
                      password: editpasswordController.text.trim(),
                      firstName: editfirstName.text,
                      lastName: editlastName.text,
                      icNumber: editfaculty.text,
                      fonNumber: editcourse.text,
                      staffNumber: editmatric.text,
                      type: widget.userType)
                  .then((value) {
                finalText = value;
                complete = true;
                Navigator.pop(context);
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
                        'Kemaskini Biodata',
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
                            Expanded(
                              child: widget.userType ? Form(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              key: editPelajarKey,
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
                                              label: Text('KEMASKINI', style: TextStyle(color: Theme.of(context).accentColor),),
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
                                                controller: editmatric,
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
                                                controller: editfirstName,
                                                hinText: 'Nama Hadapan',
                                                icon: Icons.perm_identity,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                              RoundedInputField(
                                                controller: editlastName,
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
                                                controller: editfaculty,
                                                hinText: 'Fakulti',
                                                icon: Icons.flag,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                              RoundedInputField(
                                                controller: editcourse,
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
                                                controller: editEmailController,
                                                hinText: 'E-mail UTeM',
                                                icon: Icons.mail,
                                                validator: (value) {
                                                  if (value.isEmpty)
                                                    return "Required";
                                                },
                                              ),
                                              RoundedInputField(
                                                controller: editpasswordController,
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
                                  key: editPemanduKey,
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
                                              label: Text('KEMASKINI', style: TextStyle(color: Theme.of(context).accentColor),),
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
                                              controller: editstaffNumber,
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
                                              controller: editfirstName,
                                              hinText: 'Nama Hadapan',
                                              icon: Icons.perm_identity,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: editlastName,
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
                                              controller: editicNumber,
                                              hinText: 'Nombor IC',
                                              icon: Icons.flag,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: editlicenseNumber,
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
                                              controller: editphoneNumber,
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
                                              controller: editEmailController,
                                              hinText: 'E-mail UTeM',
                                              icon: Icons.mail,
                                              validator: (value) {
                                                if (value.isEmpty)
                                                  return "Required";
                                              },
                                            ),
                                            RoundedInputField(
                                              controller: editpasswordController,
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