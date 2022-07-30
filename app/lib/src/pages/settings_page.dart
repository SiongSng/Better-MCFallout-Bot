import 'package:better_mcfallout_bot/src/better_mcfallout_bot.dart';
import 'package:better_mcfallout_bot/src/config/server_region.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late ServerRegion region;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  bool hidePassword = true;

  @override
  void initState() {
    region = appConfig.region;
    emailController = TextEditingController(text: appConfig.email);
    passwordController = TextEditingController(text: appConfig.password);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('機器人設定'),
      scrollable: true,
      content: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Minecraft 帳號',
              hintText: '請輸入 Microsoft 帳號 (Email)',
            ),
            controller: emailController,
            onChanged: (_) {
              appConfig.email = emailController.text;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
                labelText: 'Minecraft 密碼',
                hintText: '請輸入 Microsoft 帳號的密碼',
                suffixIcon: IconButton(
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    })),
            obscureText: hidePassword,
            controller: passwordController,
            onChanged: (_) {
              appConfig.password = passwordController.text;
            },
          ),
          Row(
            children: [
              const Text("伺服器區域", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButton<ServerRegion>(
                  value: region,
                  style: const TextStyle(color: Colors.lightBlue),
                  onChanged: (ServerRegion? value) {
                    setState(() {
                      region = value!;
                    });
                    appConfig.region = region;
                  },
                  isExpanded: true,
                  items: ServerRegion.values
                      .map<DropdownMenuItem<ServerRegion>>(
                          (ServerRegion value) {
                    return DropdownMenuItem<ServerRegion>(
                      value: value,
                      alignment: Alignment.center,
                      child: Text(value.getName(),
                          style:
                              const TextStyle(fontSize: 16, fontFamily: 'font'),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: const [ConfirmButton()],
    );
  }
}
