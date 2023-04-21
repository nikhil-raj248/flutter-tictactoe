import 'dart:math';

import 'package:flutter/material.dart';

class PlayingScreen2 extends StatefulWidget {
  const PlayingScreen2({Key? key,
    required this.isMobileFirst}) : super(key: key);

  final bool? isMobileFirst;

  @override
  State<PlayingScreen2> createState() => _PlayingScreen2State();
}

class _PlayingScreen2State extends State<PlayingScreen2> {

  int currPlayer = 1;
  bool gameWon = false;
  bool gameDraw = false;
  List<List<int>> grid=[
    [0,0,0],
    [0,0,0],
    [0,0,0],
  ];

  @override
  void initState() {
    super.initState();
    if(widget.isMobileFirst!){
      Future<List<int>> bestMove= findBestMove();
      bestMove.then((value){
        currPlayer=2;
        onCellClicked(value[0],value[1]);
      });
    }
  }

  void onCellClicked(int row,int col){
    setState(()  {
      if(grid[row][col]==0 && !gameWon){
        grid[row][col]=currPlayer;
        if(checkColWin()||checkRowWin()||checkDiagnolWin()){
          gameWon = true;
        }
        else if(isMovesLeft()){
          if(currPlayer==1){
            //call best possible step
            currPlayer=2;
            Future<List<int>> bestMove= findBestMove();
            bestMove.then((value){
              onCellClicked(value[0],value[1]);
            });
          }
          else {
            currPlayer=1;
          }
        }
        else{
          gameDraw=true;
        }
      }
    });
  }

  bool checkRowWin(){
    for(int i=0;i<3;i++){
      int cnt=0;
      for(int j=0;j<3;j++){
        if(grid[i][j]==0)break;
        if(grid[i][j]==grid[i][0])cnt++;
      }
      if(cnt==3)return true;
    }
    return false;
  }

  bool checkColWin(){
    for(int j=0;j<3;j++){
      int cnt=0;
      for(int i=0;i<3;i++){
        if(grid[i][j]==0)break;
        if(grid[i][j]==grid[0][j])cnt++;
      }
      if(cnt==3)return true;
    }
    return false;
  }

  bool checkDiagnolWin(){
    int cnt1=0,cnt2=0;
    for(int i=0;i<3;i++){
      if(grid[i][i]==grid[0][0])cnt1++;
      if(grid[i][2-i]==grid[0][2])cnt2++;
    }
    if(grid[1][1]==0)return false;
    return (cnt1==3 || cnt2==3);
  }

  Widget setCellValue(int row,int col){
    if(grid[row][col]==0){
      return Container();
    }
    else if(grid[row][col]==1){
      return const Icon(
        Icons.close,
        size: 80,
      );
    }
    else{
      return const Icon(
        Icons.circle_outlined,
        size: 70,
      );
    }
  }

  void resetGame(){
    setState(() {
      gameWon=false;
      currPlayer=1;
      gameDraw=false;
      for(int i=0;i<3;i++){
        for(int j=0;j<3;j++){
          grid[i][j]=0;
        }
      }
    });
  }

  bool isMovesLeft(){
    for(int i=0;i<3;i++){
      for(int j=0;j<3;j++){
        if(grid[i][j]==0)return true;
      }
    }
    return false;
  }

  int evaluate(){
    for(int i=0;i<3;i++){
      if(grid[i][0]==grid[i][1] && grid[i][0]==grid[i][2]){
        if(grid[i][0]==2)return 10;
        else if(grid[i][0]==1)return -10;
      }
    }
    for(int j=0;j<3;j++){
      if(grid[0][j]==grid[1][j] && grid[1][j]==grid[2][j]){
        if(grid[0][j]==2)return 10;
        else if(grid[0][j]==1)return -10;
      }
    }
    if(grid[0][0]==grid[1][1] && grid[0][0]==grid[2][2]){
      if(grid[0][0]==2)return 10;
      else if(grid[0][0]==1)return -10;
    }
    if(grid[0][2]==grid[1][1] && grid[1][1]==grid[2][0]){
      if(grid[1][1]==2)return 10;
      else if(grid[1][1]==1)return -10;
    }
    return 0;
  }

  int minmax(bool isMax){
    int score = evaluate();
    if(score==10 || score==-10)return score;
    if(isMovesLeft()==false)return 0;
    if(isMax){
      int mx=-1000;
      for(int i=0;i<3;i++){
        for(int j=0;j<3;j++){
          if(grid[i][j]==0){
            grid[i][j]=2;
            mx=max(mx,minmax(!isMax));
            grid[i][j]=0;
          }
        }
      }
      return mx;
    }
    else{
      int mn=1000;
      for(int i=0;i<3;i++){
        for(int j=0;j<3;j++){
          if(grid[i][j]==0){
            grid[i][j]=1;
            mn=min(mn,minmax(!isMax));
            grid[i][j]=0;
          }
        }
      }
      return mn;
    }
  }

  Future<List<int>> findBestMove() async{
    int bestVal = -1000;
    int r=-1,c=-1;
    for(int i=0;i<3;i++){
      for(int j=0;j<3;j++){
        if(grid[i][j]==0){
          grid[i][j]=2;
          int val=minmax(false);
          grid[i][j]=0;
          if(val>bestVal){
            bestVal=val;
            r=i;
            c=j;
          }
        }
      }
    }
    return [r,c];
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  // color: Colors.white24,
                  child: Center(
                    child: gameDraw?Text('Game Draw!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.teal),)
                        :gameWon?Text((currPlayer==1)?'You WON':'Mobile WON',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.red),)
                        :Text((currPlayer==1)?'Your Turn':'Mobile Turn',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Colors.orange),),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(0,0);
                                    },
                                    child: setCellValue(0,0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 4,
                                color: Colors.blueAccent,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(0,1);
                                    },
                                    child: setCellValue(0,1),
                                  ),
                                ),
                              ),
                              Container(
                                width: 4,
                                color: Colors.blueAccent,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(0,2);
                                    },
                                    child: setCellValue(0,2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 4,
                        color: Colors.blueAccent,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(1,0);
                                    },
                                    child: setCellValue(1,0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 4,
                                color: Colors.blueAccent,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(1,1);
                                    },
                                    child: setCellValue(1,1),
                                  ),
                                ),
                              ),
                              Container(
                                width: 4,
                                color: Colors.blueAccent,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(1,2);
                                    },
                                    child: setCellValue(1,2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 4,
                        color: Colors.blueAccent,
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(2,0);
                                    },
                                    child: setCellValue(2,0),
                                  ),
                                ),
                              ),
                              Container(
                                width: 4,
                                color: Colors.blueAccent,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(2,1);
                                    },
                                    child: setCellValue(2,1),
                                  ),
                                ),
                              ),
                              Container(
                                width: 4,
                                color: Colors.blueAccent,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.zero),
                                      ),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                    ),
                                    onPressed: () {
                                      onCellClicked(2,2);
                                    },
                                    child: setCellValue(2,2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Center(
                      child: GestureDetector(
                        onTap: (){
                          resetGame();
                        },
                        child: Container(
                            height: 50,
                            width: 100,
                            color: Colors.grey.shade900,
                            child: Center(
                                child: Text("Reset",style: TextStyle(fontSize: 16,color: Colors.purple),
                                )
                            )
                        ),
                      )
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
