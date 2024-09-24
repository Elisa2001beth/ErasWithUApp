import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';

final defaultInitialReaction = Reaction<String>(
  value: null,
  icon: const Icon(
    CupertinoIcons.smiley,
    color: Colors.grey,
    size:20.0,
  ),
);

final reactions = [
  Reaction<String>(
    value: 'Happy',
    title: _buildTitle('Happy'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/happy.png'),
    icon: const Icon(
      CupertinoIcons.smiley,
      color: Colors.grey,
      size:20.0,
    ),
  ),
  Reaction<String>(
    value: 'Angry',
    title: _buildTitle('Angry'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/angry.png'),
    icon: _buildReactionsIcon(
      'assets/images/angry.png',
      const Text(
        'Angry',
        style: TextStyle(
          color: Color(0XFFed5168),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'In love',
    title: _buildTitle('In love'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/in-love.png'),
    icon: _buildReactionsIcon(
      'assets/images/in-love.png',
      const Text(
        'In love',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Sad',
    title: _buildTitle('Sad'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/sad.png'),
    icon: _buildReactionsIcon(
      'assets/images/sad.png',
      const Text(
        'Sad',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Surprised',
    title: _buildTitle('Surprised'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/surprised.png'),
    icon: _buildReactionsIcon(
      'assets/images/surprised.png',
      const Text(
        'Surprised',
        style: TextStyle(
          color: Color(0XFFffda6b),
        ),
      ),
    ),
  ),
  Reaction<String>(
    value: 'Mad',
    title: _buildTitle('Mad'),
    previewIcon: _buildReactionsPreviewIcon('assets/images/mad.png'),
    icon: _buildReactionsIcon(
      'assets/images/mad.png',
      const Text(
        'Mad',
        style: TextStyle(
          color: Color(0XFFf05766),
        ),
      ),
    ),
  ),
];

Container _buildTitle(String title) {
  return Container(
        decoration: BoxDecoration(
      color: Colors.red,
      borderRadius: BorderRadius.circular(5),
    ),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Padding _buildReactionsPreviewIcon(String path) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 8.0),
    child: Image.asset(path, height: 30),
  );
}

Image _buildIcon(String path) {
  return Image.asset(
    path,
    height: 20,
    width: 20,
  );
}

Container _buildReactionsIcon(String path, Text text) {
  return Container(
    color: Colors.transparent,
    child: Row(
      children: <Widget>[
        Image.asset(path, height: 20),
        const SizedBox(width: 5),
        text,
      ],
    ),
  );
}