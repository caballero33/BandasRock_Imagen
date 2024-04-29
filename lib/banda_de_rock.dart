import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BandasPage extends StatefulWidget {
  final String? imagenUrl;

  const BandasPage({Key? key, this.imagenUrl}) : super(key: key);

  @override
  State<BandasPage> createState() => _BandasPageState();
}

class _BandasPageState extends State<BandasPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final bandas = firestore.collection('Bandas').snapshots();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Bandas de Rock',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bandas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final listaBandas = snapshot.data!.docs;

            return ListView.builder(
              itemCount: listaBandas.length,
              itemBuilder: (context, index) {
                final banda = listaBandas[index];
                final votos = banda['voto'].toString();

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                      backgroundImage: NetworkImage(banda['url']),
                    ),
                    title: Text(
                      banda['nombre'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${banda['album']} - ${banda['lanzamiento']}',
                    ),
                    trailing: Text('VOTOS: $votos'),
                    onTap: () async {
                      DocumentReference docRef = FirebaseFirestore.instance
                          .collection('Bandas')
                          .doc(banda.id);

                      FirebaseFirestore.instance
                          .runTransaction((transaction) async {
                        DocumentSnapshot snapshot =
                            await transaction.get(docRef);

                        if (!snapshot.exists) {
                          throw Exception("El documento no existe!");
                        } else {
                          int nuevoVoto = snapshot.get('voto') + 1;
                          transaction.update(docRef, {'voto': nuevoVoto});
                        }
                      });
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/crear_banda');
        },
        tooltip: 'Nueva banda',
        child: const Icon(Icons.add),
      ),
    );
  }
}
