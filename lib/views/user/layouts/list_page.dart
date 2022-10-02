import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:usersapp/controllers/user/user_controller.dart';
import 'package:usersapp/views/user/layouts/create_update_page.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  Future? getUsers;
  ScrollController scrollController = ScrollController();
  var scrollHeight;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        getUsers = context.read<UserModel>().getUsers();
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
              getUsers = context.read<UserModel>().getUsers();
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
                return Consumer<UserModel>(
                  builder: (newcontext, viewModel, child) {
                    print(scrollHeight);
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: viewModel.users?.length,
                      itemBuilder: (context, index) {
                        final data = viewModel.users?[index];
                        if (scrollHeight != null &&
                            index == viewModel.users!.length - 1) {
                          scrollController.animateTo(scrollHeight,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.linear);
                        }
                        return ListTile(
                            title: Text(
                                '${data?.name ?? ''} ${data?.surname ?? ''}'),
                            subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text('Telefon Numarası: '),
                                      Flexible(
                                          child: Text(data?.phoneNumber ?? '')),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text('Kimlik Numarası: '),
                                      Flexible(
                                          child: Text(data?.identity ?? '')),
                                    ],
                                  ),
                                ]),
                            trailing: PopupMenuButton(
                                onSelected: (value) async {
                                  switch (value) {
                                    case 1:
                                      scrollHeight =
                                          scrollController.position.pixels;
                                      Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      UserCreateUpdatePage(
                                                          user: data)))
                                          .whenComplete(() {
                                        setState(() {
                                          getUsers = context
                                              .read<UserModel>()
                                              .getUsers();
                                        });
                                      });
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
                                          .deleteUser(data?.id)
                                          .then((value) {
                                        try {
                                          Navigator.pop(dialogContext!);
                                        } catch (e) {}
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Text(value == true
                                                  ? 'İşlem başarılı'
                                                  : 'İşlem başarısız'),
                                            );
                                          },
                                        );
                                      });
                                      break;
                                    default:
                                  }
                                },
                                itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Text("Düzenle"),
                                      ),
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Text("Sil"),
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
