import 'package:flutter/material.dart';
import 'package:tic_tac_toe/playing_screen1.dart';
import 'package:tic_tac_toe/playing_screen2.dart';


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
          actions: const <Widget>[
            // IconButton(
            //   icon: const Icon(Icons.help),
            //   tooltip: 'Help',
            //   onPressed: () {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //         const SnackBar(content: Text('Sorry')));
            //   },
            // ),
          ],
        ),
        body: Container(
          // color: Colors.yellow,
          // alignment: Alignment.center,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayingScreen1()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54,width: 2),
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Player1 VS Player2',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayingScreen2(isMobileFirst: false,)));
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54,width: 2),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Player VS Mobile\nPlayer First',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PlayingScreen2(isMobileFirst: true,)));
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black54,width: 2),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text('Player VS Mobile\nMobile First',textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
