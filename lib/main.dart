import 'package:english_words/english_words.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp()); //返回的主体入口，相当于RN中的render（）；

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      /*title: 'Welcome', //任务管理中的Name
      home: new Scaffold( //Scaffold就是一个提供 Material Design 设计中基本布局的 widget
        appBar: new AppBar(
          title: new Text('Welcome to Flutter'),
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved())
          ],
        ),
        body: new Center(
          //body为整个页面的主体View，new Center代表居中
//          child: new Text('Hello World'),
          child: new RandomWords(), //child为主体View中的各个子View中的一个
        ),
      ),*/
      //TODO 简化，导航放到自页面，也可以不简化，共用导航（以后完善）
      title: "My Flutter on Task Name!",
      home: new RandomWords(),
    );
  }

}

class RandomWords extends StatefulWidget {
  //StatefulWidget有状态的Widget，StatelessWidget无状态的Widget
  @override
  State<StatefulWidget> createState() {
    return new RandomWordsState();
  }
}


class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[]; //Dart中，下划线前缀标识符，会强制其变成私有的
  final _saved = new Set<WordPair>();

  final _biggerfont = const TextStyle(fontSize: 18.0);
  final wordPair = new WordPair.random();

  Widget _builsSuggestions() {
    //返回一个列表View
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          //列表Item
          if (i.isOdd) return new Divider(); //设置分割线
          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(prefix0.generateWordPairs().take(10));
          }
          return _builRow(_suggestions[index]);
        });
  }

  //TODO 另一种尝试：共用导航栏实现--》框架？
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("First Page"),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
        body: _builsSuggestions(),
    );
  }

  Widget _builRow(WordPair suggestion) {
    final alreadySaved = _saved.contains(suggestion);
    return new ListTile(
      title: new Text(
        suggestion.asPascalCase,
        style: _biggerfont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        print("--Clicked--"+suggestion.asString);
        setState(() {//在Flutter的响应式风格的框架中，调用setState() 会为State对象触发build()方法，从而导致对UI的更新
          if (alreadySaved) {
            _saved.remove(suggestion);
          } else {
            _saved.add(suggestion);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _saved.map(
                (pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerfont,
                ),
              );
            },
          );
          final divided = ListTile
              .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Second Page'),
              actions: <Widget>[
                new IconButton(icon: new Icon(Icons.map), onPressed: null)
              ],
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
