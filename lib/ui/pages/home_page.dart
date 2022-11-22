import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tweet {
  final String text;
  final String author;

  const Tweet(this.text, this.author);
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Tweet>> _future;

  @override
  void initState() {
    _future = _loadTweets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter'),
      ),
      body: FutureBuilder<List<Tweet>>(
        // key: ValueKey(_future.hashCode),
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline),
                  const Text('Une erreur s\'est produite'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _future = _loadTweets();
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            final tweets = snapshot.requireData;

            return ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                final tweet = tweets[index];
                return ListTile(
                  title: Text(tweet.author),
                  subtitle: Text(tweet.text),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<List<Tweet>> _loadTweets() async {
    await Future.delayed(const Duration(seconds: 3));

    final json = jsonDecode(await rootBundle.loadString('assets/feed.json'));

    print('loading tweets');

    throw 'qskdjfhqklsdjhf';

    return (json['tweets'] as List<dynamic>)
        .map((json) => Tweet(json['text'] as String, json['author'] as String))
        .toList();
  }
}
