import "package:csv/csv.dart";
import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import 'package:scouting_app_865/utils/get_match_data.dart';
import 'package:scouting_app_865/utils/gsheets_api.dart';
import "package:shared_preferences/shared_preferences.dart";

class QRPage extends StatefulWidget {
  // final Function resetParentData;

  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String data = "";

  // Update QR Code
  updateQrCode() async {
    final matchData = await getMatchData();
    setState(() => data = const ListToCsvConverter().convert([matchData]));
  }

  @override
  void initState() {
    updateQrCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        QrImage(data: data),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 5,
          ),
          child: SelectableText(
            data,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        TextButton(
          child: const Text("Reset Data"),
          onPressed: () {
            // ignore: invalid_use_of_visible_for_testing_member
            SharedPreferences.setMockInitialValues({});
            // widget.resetParentData;
          },
        )
      ],
    );
  }
}
