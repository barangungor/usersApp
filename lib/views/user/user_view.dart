import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usersapp/controllers/application/application_controller.dart';
import 'package:usersapp/views/user/layouts/list_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppLocalizations.of(context)!.users),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                context.read<ApplicationController>().changeAppLocale(context
                            .read<ApplicationController>()
                            .appLocale
                            .languageCode ==
                        'tr'
                    ? 'en'
                    : 'tr');
              },
              child: Row(
                children: [
                  const Text('EN'),
                  Consumer<ApplicationController>(
                      builder: (context, value, child) {
                    return AnimatedRotation(
                      turns: value.appLocale.languageCode == 'tr' ? 1 : 0.5,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.keyboard_arrow_right),
                    );
                    // Switch(
                    //     value:
                    //         value.appLocale.languageCode == 'tr' ? true : false,
                    //     onChanged: (val) {
                    //       value.changeAppLocale(
                    //           value.appLocale.languageCode == 'tr' ? 'en' : 'tr');
                    //     });
                  }),
                  const Text('TR')
                ],
              ),
            ),
          )
        ],
      ),
      body: const ListPage(),
    );
  }
}
