import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_app/components/app_dialog.dart';
import 'package:car_app/constants/app_color.dart';

import 'package:car_app/gen/assets.gen.dart';
import 'package:car_app/pages/auth/change_password_page.dart';
import 'package:car_app/pages/auth/login_page.dart';

import 'package:car_app/pages/profile/profile_page.dart';
import 'package:car_app/services/local/shared_prefs.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({
    super.key,
    required this.pageIndex,
  });

  final int pageIndex;

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
    const iconSize = 20.0;
    const iconColor = AppColor.orange;
    const spacer = 6.0;
    const textStyle = TextStyle(color: AppColor.brown, fontSize: 16.5);

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // const LanguagePopupMenu(),
          const Text('Welcome',
              style: TextStyle(color: AppColor.red, fontSize: 20.0)),
          Text(
            SharedPrefs.user?.name ?? '',
            style: const TextStyle(
                color: AppColor.brown,
                fontSize: 16.8,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 18.0),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: const Row(
              children: [
                Icon(Icons.home, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('Home', style: textStyle),
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ));
            },
            behavior: HitTestBehavior.translucent,
            child: const Row(
              children: [
                Icon(Icons.person, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('My Profile', style: textStyle),
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: const Row(
              children: [
                Icon(Icons.settings, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('Setings', style: textStyle),
              ],
            ),
          ),
          const SizedBox(height: 18.0),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordPage(),
                  ));
            },
            behavior: HitTestBehavior.translucent,
            child: const Row(
              children: [
                Icon(Icons.lock_outline, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('Change Password', style: textStyle),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 16.0, right: 20.0),
            height: 1.2,
            color: AppColor.grey,
          ),
          const Spacer(flex: 1),
          Row(
            children: [
              const SizedBox(width: 12.0),
              Expanded(child: Image.asset(Assets.images.autocarlogo.path)),
            ],
          ),
          const Spacer(flex: 2),
          InkWell(
            onTap: () => AppDialog.dialog(
              context,
              title: '😍',
              content: 'Do you want to logout?',
              action: () async {
                await FirebaseAuth.instance.signOut();
                await SharedPrefs.removeSeason();
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const LoginPage(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: const Row(
              children: [
                Icon(Icons.logout, size: iconSize, color: iconColor),
                SizedBox(width: spacer),
                Text('Logout', style: textStyle),
              ],
            ),
          ),
          //  const SizedBox(height: 10.0),
          //const LanguagePopupMenu(),
        ],
      ),
    );
  }
}
