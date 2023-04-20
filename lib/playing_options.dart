import 'package:flutter/material.dart';
import 'package:tic_tac_toe/playing_screen.dart';


class PlayingOptionsPage extends StatefulWidget {
  const PlayingOptionsPage({Key? key}) : super(key: key);

  @override
  State<PlayingOptionsPage> createState() => _PlayingOptionsPageState();
}

class _PlayingOptionsPageState extends State<PlayingOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TicTacToe'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.help),
              tooltip: 'Help',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sorry')));
              },
            ),
          ],
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayingScreen()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24,width: 5),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Player1 VS Player2'),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24,width: 5),
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Text('Player VS Mobile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
