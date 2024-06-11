import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:todo/screens/task_list/controller/drawer_items.dart';
import 'package:todo/services/route_service/route_service.gr.dart';

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: Colors.white,
      child: ListView.separated(
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () async {
              switch (i) {
                case 0:
                  Navigator.pop(context);
                  await AutoRouter.of(context).push(
                    const CategoryRoute(),
                  );

                  break;
                case 1:
                  Navigator.pop(context);
                  await AutoRouter.of(context).push(
                    const ArchieveRoute(),
                  );
                  break;
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
                bottom: 20,
              ),
              child: Row(
                children: [
                  Icon(drawerIcons[i]),
                  const SizedBox(width: 20),
                  Text(
                    DrawerItems.values[i].type,
                    style: const TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.black),
        itemCount: DrawerItems.values.length,
      ),
    );
  }
}
