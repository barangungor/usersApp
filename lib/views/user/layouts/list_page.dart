import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usersapp/controllers/user/user_controller.dart';
import 'package:usersapp/views/user/layouts/create_update_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future? getUsers;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        getUsers = context.read<UserController>().getUsers(context);
      });
      scrollController.addListener(() {
        if (scrollController.position.maxScrollExtent ==
            scrollController.position.pixels) {
          context.read<UserController>().getUsers(
              page: context.read<UserController>().userPage + 1, context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => const UserCreateUpdatePage()))
              .whenComplete(() {
            setState(() {
              getUsers = context.read<UserController>().getUsers(context);
            });
          });
        },
      ),
      body: Column(children: [
        Expanded(
            child: FutureBuilder(
          future: getUsers,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return buildLoading();
              case ConnectionState.done:
                return Consumer<UserController>(
                  builder: (newcontext, viewModel, child) {
                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      controller: scrollController,
                      itemCount: viewModel.users?.length,
                      itemBuilder: (context, index) {
                        final data = viewModel.users?[index];
                        return ListTile(
                            title: Text('${data?.id} - '
                                '${data?.name ?? ''} ${data?.surname ?? ''}'),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                          '${AppLocalizations.of(context)!.phone} ${AppLocalizations.of(context)!.number}: '),
                                      Flexible(
                                          child: Text(data?.phoneNumber ?? '')),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                          '${AppLocalizations.of(context)!.identity} ${AppLocalizations.of(context)!.number} : '),
                                      Flexible(
                                          child: Text(data?.identity ?? '')),
                                    ],
                                  ),
                                ]),
                            trailing: PopupMenuButton(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 1:
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  UserCreateUpdatePage(
                                                      user: data)));
                                      break;
                                    case 2:
                                      BuildContext? dialogContext;
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          dialogContext = context;
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        },
                                      );
                                      await viewModel
                                          .deleteUser(data?.id, context)
                                          .then((value) {
                                        try {
                                          Navigator.pop(dialogContext!);
                                        } catch (e) {}
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(value == true
                                                  ? AppLocalizations.of(
                                                          context)!
                                                      .successProcess
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .failProcess),
                                            );
                                          },
                                        );
                                      });
                                      break;
                                    default:
                                  }
                                },
                                itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 1,
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .update),
                                      ),
                                      PopupMenuItem(
                                        value: 2,
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .delete),
                                      )
                                    ]));
                      },
                    );
                  },
                );
              default:
                return buildLoading();
            }
          },
        )),
      ]),
    );
  }

  Shimmer buildLoading() => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: ListView.builder(
          itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                title: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    right: 150,
                  ),
                  height: 8.0,
                  color: Colors.white,
                ),
                subtitle: Column(children: [
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(right: 100),
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(right: 100),
                    height: 8.0,
                    color: Colors.white,
                  ),
                ]),
              )),
          itemCount: 6,
        ),
      );
}
