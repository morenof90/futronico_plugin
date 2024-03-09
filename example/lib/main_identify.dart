import 'package:flutter/material.dart';
import 'package:futronic/enum/ftr_signal_status.dart';
import 'package:futronic/futronico.dart';

const int digitalMaxSize = 2;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FutronicoExample());
}

class FutronicoExample extends StatelessWidget {
  const FutronicoExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FutronicExamplePage(title: 'Futronico exemplo'),
    );
  }
}

class FutronicExamplePage extends StatefulWidget {
  const FutronicExamplePage({super.key, required this.title});

  final String title;

  @override
  State<FutronicExamplePage> createState() => _FutronicExamplePageState();
}

class _FutronicExamplePageState extends State<FutronicExamplePage> {
  @override
  void dispose() {
    futronico.terminate();
    super.dispose();
  }

  Futronico futronico = Futronico();

  @override
  void initState() {
    setListener();
    super.initState();
  }

  bool _enrollHasBeenCanceled(FutronicEnrollResult result) {
    if (result.quality >= 0) return false;

    setState(() {
      textoResultado = "Leitura Cancelada";
    });

    return true;
  }

  void setListener() {
    Futronico.futronicStatusController.stream.listen((event) {
      if (event.currentStatus == FTR_SIGNAL_STATUS.touch_sensor) {
        setState(() {
          textoResultado = "Coloque o dedo";
        });
      }
      if (event.currentStatus == FTR_SIGNAL_STATUS.take_off) {
        setState(() {
          textoResultado = "Tire o dedo";
        });
      }
    });
  }

  String textoResultado = "Aguardando digital";
  List<List<int>> digitals = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              textoResultado,
            ),
            TextButton(
                onPressed: () {
                  futronico.cancelOperation();
                },
                child: const Text("Cancelar leitura"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            if (digitals.length < digitalMaxSize) {
              FutronicEnrollResult enrollResult =
                  await futronico.enrollTemplate();

              // Operation has been canceled
              if (_enrollHasBeenCanceled(enrollResult)) return;

              digitals.add(enrollResult.enrollTemplate);
              setState(() {
                textoResultado =
                    "Digital(${digitals.length + 1}) recebida com a qualidade ${enrollResult.quality} de 10";
              });
            } else {
              FutronicEnrollResult currentDigital =
                  await futronico.enrollTemplate(purposeIdentify: true);

              // Operation has been canceled
              if (_enrollHasBeenCanceled(currentDigital)) return;

              int identifiedFingerPrintIndex = await futronico.identify(
                  digitals, currentDigital.enrollTemplate);

              setState(() {
                textoResultado = identifiedFingerPrintIndex >= 0
                    ? "Digital (${identifiedFingerPrintIndex + 1})"
                    : "Digital é feike";
              });
            }
          } on FutronicError catch (e) {
            setState(() {
              textoResultado = e.message;
            });
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
