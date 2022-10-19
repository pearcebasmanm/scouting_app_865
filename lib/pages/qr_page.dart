import "package:csv/csv.dart";
import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../utils/get_match_data.dart";

class QRPage extends StatefulWidget {
  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  String matchDataCSV = "";

  getMatchDataCSV() async {
    final matchData = await getMatchData();
    setState(() {
      matchDataCSV = const ListToCsvConverter().convert([matchData]);
    });
  }

  @override
  void initState() {
    getMatchDataCSV();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        Flexible(child: QrImage(data: matchDataCSV)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SelectableText(
            matchDataCSV,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
