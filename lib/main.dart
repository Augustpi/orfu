import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Name Generator',
      theme: new ThemeData(primaryColor: Colors.white),
      home: new RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup Name Generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return new Divider();
          final index = i ~/ 2;

          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
            // bu satır sonradan eklendi -- her listenin sona geldiğinde yeni kelimeler oluşturuluyor bunu bildirmek için snackbar kullanıyorum..
            /*
             if (index != 0) {
              Scaffold.of(context).showSnackBar(
                new SnackBar(
                  content: new Text('Place wait new worlds generate')));              
            } 
            */
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair suggestion) {
    final alreadySaved = _saved.contains(suggestion);
    return new ListTile(
      title: new Text(
        suggestion.asPascalCase,
        style: _biggerFont,
      ),
      leading: new CircleAvatar(
        child: new Text(suggestion.asPascalCase.substring(0, 1)),
        backgroundColor: Colors.orange,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(suggestion);
          } else {
            _saved.add(suggestion);
          }
        });
      },
    );
  }

  Widget _buildRowSuggestion(WordPair suggestion) {
    final alreadyRemoved = _saved.contains(suggestion);
    return new ListTile(
      title: new Text(
        suggestion.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadyRemoved ? Icons.favorite_border : Icons.favorite,
        color: alreadyRemoved ? null : Colors.red,
      ),
      onTap: () {
        setState(() {
          if (alreadyRemoved) {
            _saved.add(suggestion);
          } else {
            _saved.remove(suggestion);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final titles = _saved.map((pair) {
        return new ListTile(
            title: new Text(
              pair.asPascalCase,
              style: _biggerFont,
            ),
            trailing: new Icon(Icons.favorite, color: Colors.red),
            leading: new CircleAvatar(
              child: new Text(
                pair.asPascalCase.substring(0, 1),
              ),
              backgroundColor: Colors.yellow,
            ),
            onTap: () {
              setState(() {
                _saved.remove(pair);
              });
            });
      });

      ListView listView = new ListView(
          children:
              ListTile.divideTiles(context: context, tiles: titles).toList());

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: listView,
      );
    }));
  }
}
