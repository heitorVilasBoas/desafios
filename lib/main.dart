import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:developer' as developer;

final userRef = FirebaseFirestore.instance.collection('test');

String? valores = ' ';

adicionarValor(String? valor){
  Map<String,dynamic> demoData = { "valor": valor};

  CollectionReference colecao = userRef;
  DocumentReference documento = colecao.doc('teste');
  documento.set(demoData);

}

Future pegarValores() async{
  await userRef.doc('teste').get().then((snapshot) async{
    valores = snapshot.data()!['valor'];
    developer.log(snapshot.data()!['valor']);
    developer.log('debug');
  });
}


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    /*options: FirebaseOptions(
      apiKey: "XXX",
      appId: "1:37484653429:android:5bc94bc7a8de8c52ca013c",
      messagingSenderId: "XXX",
      projectId: "XXX",
    ),*/
  );
  runApp( MyApp());
}



class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);


  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        body: Padding(
            padding:  EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [



                //Caixa de inserção do valor
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Favor insira um valor:',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                        onPressed: () {
                          _textController.clear();
                        },
                        icon: Icon(Icons.clear)),
                  ),

                ),
                SizedBox(height: 10),
                //botão para enviar informação para o firebase
                MaterialButton(
                  onPressed: () {// enviar informação para o firebase
                    final valor = Text(_textController.text).data;

                    adicionarValor(valor);
                  },
                  color: Colors.black,
                  child: const Text('Enviar Dados', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 10),
                //botão para a mudança de tela
                MaterialButton(
                  onPressed: (){
                    pegarValores();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SegundaPag()),
                    );
                  },
                  color: Colors.blue,
                  child: const Text('Prosseguir', style: TextStyle(color: Colors.white)),
                )
              ],
            )
        )

    );

  }
}


class SegundaPag extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: (Text('O dado inserido Foi : ' + valores!)),
                  ),
                ),
              ),
              MaterialButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                color: Colors.blue,
                child: const Text('Retornar a Tela inicial', style: TextStyle(color: Colors.white)),
              )
            ],
          ),

        )

    );

  }
}

