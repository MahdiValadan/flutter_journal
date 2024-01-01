import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hero ListView")),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          child: ListView.builder(
            itemCount: _images.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => SecondPage(heroTag: index)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Hero(
                        tag: index,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            _images[index],
                            width: 200,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Text(
                        'Title: $index',
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  final int heroTag;

  const SecondPage({Key? key, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hero ListView Page 2")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(_images[heroTag]),
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              "Content goes here",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          )
        ],
      ),
    );
  }
}

final List<String> _images = [
  "https://firebasestorage.googleapis.com/v0/b/flutter-journal-ea1b4.appspot.com/o/Kitten%20(1).jpg?alt=media&token=c6cf4718-e312-49f0-8305-7c11ce66dc0c",
  'https://picsum.photos/id/1000/960/540',
  'https://picsum.photos/id/1000/960/540',
  'https://picsum.photos/id/1000/960/540',
  'https://picsum.photos/id/1000/960/540',
  'https://picsum.photos/id/1000/960/540'
];
