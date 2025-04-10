import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/feature/form/presentation/widgets/form_gradient_button.dart';
import 'package:flutter_clean_architecture/feature/form/presentation/widgets/form_text_field.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final genderController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _addListeners();
  }

  void _addListeners() {
    final controllers = [
      nameController,
      emailController,
      phoneController,
      genderController,
      countryController,
      stateController,
      cityController,
    ];

    for (var controller in controllers) {
      controller.addListener(_validateForm);
    }
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    genderController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Registration Form",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  FormTextField(
                    hintText: "Name",
                    controller: nameController,
                    inputType: TextInputType.name,
                  ),
                  SizedBox(height: 15),
                  FormTextField(
                    hintText: "Email",
                    controller: emailController,
                    inputType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 15),
                  FormTextField(
                    hintText: "Phone",
                    controller: phoneController,
                    inputType: TextInputType.phone,
                  ),
                  SizedBox(height: 15),
                  FormTextField(
                    hintText: "Gender",
                    controller: genderController,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormTextField(
                    hintText: "Country",
                    controller: countryController,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormTextField(
                    hintText: "State",
                    controller: stateController,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 15),
                  FormTextField(
                    hintText: "City",
                    controller: cityController,
                    inputType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  Opacity(
                    opacity: _isFormValid ? 1 : 0.2,
                    child: IgnorePointer(
                      ignoring: !_isFormValid,
                      child: FormGradientButton(
                        onClick: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Form Submitted Successfully"),
                              ),
                            );
                            nameController.clear();
                            emailController.clear();
                            stateController.clear();
                            cityController.clear();
                            phoneController.clear();
                            genderController.clear();
                            countryController.clear();

                            setState(() {
                              _isFormValid = false;
                            });
                          }
                        },
                        btnText: "Submit",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
