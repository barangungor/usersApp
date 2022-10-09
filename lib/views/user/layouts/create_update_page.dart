import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:usersapp/controllers/user/user_controller.dart';
import 'package:usersapp/models/user/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserCreateUpdatePage extends StatefulWidget {
  const UserCreateUpdatePage({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  State<UserCreateUpdatePage> createState() => _UserCreateUpdatePageState();
}

class _UserCreateUpdatePageState extends State<UserCreateUpdatePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController(),
      surnameController = TextEditingController(),
      birthdateController = TextEditingController(),
      phoneNumberController = TextEditingController(),
      identityController = TextEditingController(),
      sallaryController = TextEditingController();

  InputDecoration inputStyle(label) => InputDecoration(
      labelText: label, border: const OutlineInputBorder(), counterText: '');

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        nameController.text = widget.user?.name ?? '';
        surnameController.text = widget.user?.surname ?? '';
        birthdateController.text = widget.user?.birthDate.toString() ?? '';
        phoneNumberController.text = widget.user?.phoneNumber ?? '';
        identityController.text = widget.user?.identity ?? '';
        sallaryController.text = widget.user?.sallary.toString() ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            title: Text(
                '${AppLocalizations.of(context)!.user} ${widget.user == null ? AppLocalizations.of(context)!.create : AppLocalizations.of(context)!.update} ')),
        body: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  TextFormField(
                    controller: nameController,
                    textInputAction: TextInputAction.next,
                    decoration: inputStyle(AppLocalizations.of(context)!.name),
                    validator: (value) {
                      return value == null || value.trim().isEmpty == true
                          ? AppLocalizations.of(context)!.cannotNull
                          : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: surnameController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        inputStyle(AppLocalizations.of(context)!.surname),
                    validator: (value) {
                      return value == null || value.trim().isEmpty == true
                          ? AppLocalizations.of(context)!.cannotNull
                          : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    readOnly: true,
                    controller: birthdateController,
                    decoration:
                        inputStyle(AppLocalizations.of(context)!.birthday),
                    onTap: () async {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          birthdateController.text = value.toString();
                        }
                      });
                    },
                    validator: (value) {
                      return value == null || value.trim().isEmpty == true
                          ? AppLocalizations.of(context)!.cannotNull
                          : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: phoneNumberController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    textInputAction: TextInputAction.next,
                    decoration: inputStyle(
                        '${AppLocalizations.of(context)!.phone} ${AppLocalizations.of(context)!.number}'),
                    validator: (value) {
                      return value == null || value.trim().isEmpty == true
                          ? AppLocalizations.of(context)!.cannotNull
                          : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: identityController,
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    textInputAction: TextInputAction.next,
                    decoration: inputStyle(
                        '${AppLocalizations.of(context)!.identity} ${AppLocalizations.of(context)!.number}'),
                    validator: (value) {
                      return value == null || value.trim().isEmpty == true
                          ? AppLocalizations.of(context)!.cannotNull
                          : userController.checkIdentity(value) == false
                              ? AppLocalizations.of(context)!.unverifiedIdentity
                              : null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: sallaryController,
                    keyboardType: TextInputType.number,
                    decoration:
                        inputStyle(AppLocalizations.of(context)!.sallary),
                    validator: (value) {
                      return value == null || value.trim().isEmpty == true
                          ? AppLocalizations.of(context)!.cannotNull
                          : null;
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)!.save),
                    onPressed: () async {
                      if (formKey.currentState?.validate() == true) {
                        BuildContext? dialogContext;
                        showDialog(
                          context: context,
                          builder: (context) {
                            dialogContext = context;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                        var bodyData = {
                          'name': nameController.text,
                          'surname': surnameController.text,
                          'birthdate': birthdateController.text,
                          'phone_number': phoneNumberController.text,
                          'identity': identityController.text,
                          'sallary': sallaryController.text
                        };
                        if (widget.user == null) {
                          userController
                              .createUser(bodyData, context)
                              .then((value) {
                            try {
                              Navigator.pop(dialogContext!);
                            } catch (e) {}
                            showProcessResult(
                                context,
                                value == true
                                    ? AppLocalizations.of(context)!
                                        .successProcess
                                    : AppLocalizations.of(context)!
                                        .failProcess);
                          });
                        } else {
                          bodyData['id'] = widget.user!.id.toString();
                          userController
                              .updateUser(bodyData, context)
                              .then((value) {
                            try {
                              Navigator.pop(dialogContext!);
                            } catch (e) {}
                            showProcessResult(
                                context,
                                value == true
                                    ? AppLocalizations.of(context)!
                                        .successProcess
                                    : AppLocalizations.of(context)!
                                        .failProcess);
                          });
                        }
                      }
                    },
                  ),
                  if (widget.user != null)
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.delete),
                      onPressed: () async {
                        BuildContext? dialogContext;
                        showDialog(
                          context: context,
                          builder: (context) {
                            dialogContext = context;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        );
                        await userController
                            .deleteUser(widget.user?.id, context)
                            .then((value) {
                          try {
                            Navigator.pop(dialogContext!);
                          } catch (e) {}
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(value == true
                                    ? AppLocalizations.of(context)!
                                        .successProcess
                                    : AppLocalizations.of(context)!
                                        .failProcess),
                              );
                            },
                          ).whenComplete(() {
                            if (value == true) {
                              Navigator.pop(context);
                            }
                          });
                        });
                      },
                    ),
                ]),
              )),
        ),
      ),
    );
  }

  showProcessResult(BuildContext context, content) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(content ?? ''),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.ok))
          ],
        );
      },
    );
  }
}
