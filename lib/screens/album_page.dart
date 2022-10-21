import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

List<String> tracks = [
  "track 1",
  "track 2",
  "track 3",
  "track 4",
  "track 5",
];

class AlbumPage extends StatelessWidget {
  final String albumId;
  const AlbumPage({Key? key, required this.albumId}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Album Title"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200.0,
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/43/43566.png')),
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
                Icon(Icons.star_border_outlined),
              ]),
              Text("Community Rating"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue,
                  ),
                  child: Container(
                    height: 250,
                    child: ListView.builder(
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(tracks.elementAt(index).toString()),
                          trailing: Icon(Icons.star_border_outlined),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: Colors.blue,
                  ),
                  child: Row(
                    children: [
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 8.0, 15.0),
                          child: Icon(Icons.edit)),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(2.0, 8.0, 8.0, 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.0),
                              color: Colors.grey[50],
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                labelText: "Your rating",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                contentPadding: const EdgeInsets.all(8.0),
                              ),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[50],
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            labelText: "Your review",
                            isCollapsed: true,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                          style: TextStyle(fontSize: 20.0),
                          maxLines: 3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
