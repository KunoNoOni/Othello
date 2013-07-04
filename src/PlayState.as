package
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		//Variables go here
		private var board:FlxSprite = new FlxSprite();
		private var back:FlxSprite = new FlxSprite();
		private var whiteScore:FlxText;
		private var blackScore:FlxText;
		private var wTurnText:FlxText;
		private var bTurnText:FlxText;
		private var winText:FlxText;
		private var loseText:FlxText;
		private var noMovesText:FlxText;
		private var shadowText1:FlxText;
		private var shadowText2:FlxText;
		private var shadowText3:FlxText;
		private var mxPos:int;
		private var myPos:int;
		private var currX:int;
		private var currY:int;
		private var vCurrX:int;
		private var vCurrY:int;
		private var wpieces:WhitePieces;
		private var wPieces:FlxGroup = new FlxGroup;
		private var bpieces:BlackPieces;
		private var bPieces:FlxGroup = new FlxGroup;
		private var boardArray:Array = new Array;
		private var cursor:MouseCursor;
		private var playerTurn:int;
		private var messageDisplayed:Boolean;
		private var gameOverMessageDisplayed:Boolean = false;
		private var checkingForValidMove:Boolean = false;
		private var validMoveFound:Boolean = false;
		private var noValidMoves:Boolean = false;
		private var gameOver:Boolean = false;
		private var validMove:Boolean = false;
		private var noValidBlackMove:Boolean = false;
		private var noValidWhiteMove:Boolean = false;
		private var numberOfValidMoves:int = 4;
		private var whitePieces:int = 2;
		private var blackPieces:int = 2;
		private var totalCapture:int = 0;
		private var totalNumberOfTiles:int = 64;
		private var capture:Array = new Array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
				
		override public function create():void
		{	
			//setup internal board
			boardArray = [[0,0,0,0,0,0,0,0],
						  [0,0,0,0,0,0,0,0],
						  [0,0,0,0,0,0,0,0],
						  [0,0,0,0,0,0,0,0],
						  [0,0,0,0,0,0,0,0],
						  [0,0,0,0,0,0,0,0],
						  [0,0,0,0,0,0,0,0],
						  [0,0,0,0,0,0,0,0]];
			
			//setup background
			back.loadGraphic(Registry.Back,false,false,512,1000);
			add(back);
			
			//set up board
			board.loadGraphic(Registry.Board,false,false,512,512);
			board.x = 0;
			board.y = 0;
			add(board);
			
			//set up initial score
			whiteScore = new FlxText(45,530, 100, "2");
			whiteScore.setFormat(null,50,0xFFFFFF, "center");
			add(whiteScore);
			blackScore = new FlxText(365,530, 100, "2");
			blackScore.setFormat(null,50,0x000000, "center");
			add(blackScore);
			
			//setup our mouse cursor
			cursor = new MouseCursor(1,1);
			add(cursor);
			
			//set first player
			playerTurn = 1;
			
			//setup board pieces
			wpieces = new WhitePieces(3,3);
			wPieces.add(wpieces);
			add(wpieces);
			boardArray[3][3] = 2;
			wpieces = new WhitePieces(4,4);
			wPieces.add(wpieces);
			add(wpieces);
			boardArray[4][4] = 2;
			bpieces = new BlackPieces(4,3);
			bPieces.add(bpieces);
			add(bpieces);
			boardArray[4][3] = 1;
			bpieces = new BlackPieces(3,4);
			bPieces.add(bpieces);
			add(bpieces);
			boardArray[3][4] = 1;

			//setup turn information
			shadowText1 = new FlxText(52,148,400,"White Player's Turn");
			shadowText1.setFormat(null,25,0x000000, "center");
			add(shadowText1);
			shadowText1.visible = false;
			wTurnText = new FlxText(55,145,400,"White Player's Turn");
			wTurnText.setFormat(null,25,0xFF7F00, "center");
			add(wTurnText);
			wTurnText.visible = false;
			shadowText2 = new FlxText(52,148,400,"Black Player's Turn");
			shadowText2.setFormat(null,25,0x000000, "center");
			add(shadowText2);
			shadowText2.visible = true;
			bTurnText = new FlxText(55,145,400,"Black Player's Turn");
			bTurnText.setFormat(null,25,0xFF7F00, "center");
			add(bTurnText);
			bTurnText.visible = true;
			messageDisplayed = true;
			
		}	
		
		override public function update():void
		{	
			if(FlxG.keys.justReleased("Q"))
			{
				printPlayfield();
			}
			
			mxPos = FlxU.floor((FlxG.mouse.screenX)/64);
			myPos = FlxU.floor((FlxG.mouse.screenY)/64);
			
			if(myPos > 7)
			{
				myPos = 7;
			}
			
			if(mxPos > 7)
			{
				mxPos = 7;
			}
			
			if(cursor.x > 448)
				cursor.x = 448;
			else
				cursor.x = mxPos*64;
			
			if(cursor.y > 448 || FlxG.mouse.screenY > 448)
			{
				cursor.y = 448;
			}
			else
				cursor.y = myPos*64;
			
			/*whiteScore.text = mxPos.toString();
			blackScore.text = myPos.toString();
			add(whiteScore);
			add(blackScore);*/

			if(messageDisplayed)
			{
				if(FlxG.mouse.justReleased())
				{
					messageDisplayed = false;
					wTurnText.kill();
					bTurnText.kill();
					shadowText1.kill();
					shadowText2.kill();
					FlxG.mouse.reset();
				}
			}

			if(FlxG.mouse.justReleased() && mxPos >= 0 && mxPos < 9 && myPos >= 0 && myPos < 9 && !noValidMoves && !gameOverMessageDisplayed)
			{
				FlxG.mouse.reset();
				if(boardArray[mxPos][myPos] != 0)
				{
					trace("Space "+mxPos+","+myPos+" is occupied by a "+boardArray[mxPos][myPos]);
				}
				else
				{
					
					currX = mxPos;
					currY = myPos;
					trace("<==========> Starting a new turn <==========>");
					trace("currX= "+currX+" currY= "+currY);
					if(playerTurn == 1)
					{
						//trace("setting start square to 1");
						boardArray[mxPos][myPos] = 1;
						//trace("boardArray["+mxPos+"]["+myPos+"]= "+boardArray[mxPos][myPos]);
					}
					else
					{
						//trace("setting start square to 2");
						boardArray[mxPos][myPos] = 2;
						//trace("boardArray["+mxPos+"]["+myPos+"]= "+boardArray[mxPos][myPos]);
					}
					trace("Current players is "+playerTurn);
					validateMove();
				}
				
			}
			
			if(validMove)
			{
				if(playerTurn == 1)
				{
					//trace("Black Piece placed at mxPos: "+(mxPos+1)+" myPos: "+(myPos+1));
					//boardArray[mxPos][myPos] = 1;
					bpieces = new BlackPieces(mxPos,myPos);
					bPieces.add(bpieces);
					add(bpieces);
					//groupList();
					//trace("Found current player's piece! Now to capture :)");
					blackPieces++;
					capturePieces(totalCapture);
					if((blackPieces+whitePieces)==totalNumberOfTiles || blackPieces == 0 || whitePieces == 0)
					{
						trace("<validMove black>gameOver set to TRUE!");
						gameOver = true;
					}
					else	
					{
						turns(playerTurn);
					}
				}
				else if(playerTurn == 2)
				{
					//trace("White Piece placed at mxPos: "+(mxPos+1)+" myPos: "+(myPos+1));
					//boardArray[mxPos][myPos] = 2;
					wpieces = new WhitePieces(mxPos,myPos);
					wPieces.add(wpieces);
					add(wpieces);
					//groupList();
					//trace("Found current player's piece! Now to capture :)");
					whitePieces++;
					capturePieces(totalCapture);
					if((blackPieces+whitePieces)==totalNumberOfTiles || blackPieces == 0 || whitePieces == 0)
					{
						trace("<validMove white>gameOver set to TRUE!");
						gameOver = true;
					}
					else	
					{
						turns(playerTurn);
					}
				}
			}

			if(noValidMoves && !gameOverMessageDisplayed)
			{
				if(FlxG.mouse.justReleased())
				{
					noMovesText.kill();
					shadowText3.kill();
					FlxG.mouse.reset();
					noValidMoves = false;
					trace("noValidWhiteMove: "+noValidWhiteMove+" noValidBlackMove: "+noValidBlackMove);
					trace("gameOver: "+gameOver);
					trace("playerTurn: "+playerTurn);
					if(noValidWhiteMove && noValidBlackMove)
					{
						trace("gameOver set to TRUE!");
						gameOver = true;
					}
					else 
					{
						if(playerTurn == 1 && !gameOver)
						{
							trace("Switching to White");
							turns(1);
						}
						else if(playerTurn == 2 && !gameOver)
						{
							trace("Switching to Black");
							turns(2);
						}
					}
				}
			}
			
			if(gameOver)
			{
				if(!gameOverMessageDisplayed)
				{
					if(whitePieces > blackPieces)
					{
						FlxG.mouse.reset();
						gameOverMessageDisplayed = true;
						shadowText3 = new FlxText(52,148,400,"White Player WINS!");
						shadowText3.setFormat(null,25,0x000000, "center");
						add(shadowText3);
						winText = new FlxText(55,145,400,"White Player WINS!");
						winText.setFormat(null,25,0xFF7F00, "center");
						add(winText);
						shadowText1 = new FlxText(52,188,400,"Click to Play Again!");
						shadowText1.setFormat(null,25,0x000000, "center");
						add(shadowText1);
						wTurnText = new FlxText(55,185,400,"Click to Play Again!");
						wTurnText.setFormat(null,25,0xFF7F00, "center");
						add(wTurnText);
					}
					if(blackPieces > whitePieces)
					{
						FlxG.mouse.reset();
						gameOverMessageDisplayed = true;
						shadowText3 = new FlxText(52,148,400,"Black Player WINS!");
						shadowText3.setFormat(null,25,0x000000, "center");
						add(shadowText3);
						winText = new FlxText(55,145,400,"Black Player WINS!");
						winText.setFormat(null,25,0xFF7F00, "center");
						add(winText);
						shadowText1 = new FlxText(52,188,400,"Click to Play Again!");
						shadowText1.setFormat(null,25,0x000000, "center");
						add(shadowText1);
						wTurnText = new FlxText(55,185,400,"Click to Play Again!");
						wTurnText.setFormat(null,25,0xFF7F00, "center");
						add(wTurnText);
						
					}
					if(whitePieces == blackPieces)
					{
						FlxG.mouse.reset();
						gameOverMessageDisplayed = true;
						shadowText3 = new FlxText(52,148,400,"The Game is a TIE!");
						shadowText3.setFormat(null,25,0x000000, "center");
						add(shadowText3);
						winText = new FlxText(55,145,400,"The Game is a TIE!");
						winText.setFormat(null,25,0xFF7F00, "center");
						add(winText);
						shadowText1 = new FlxText(52,188,400,"Click to Play Again!");
						shadowText1.setFormat(null,25,0x000000, "center");
						add(shadowText1);
						wTurnText = new FlxText(55,185,400,"Click to Play Again!");
						wTurnText.setFormat(null,25,0xFF7F00, "center");
						add(wTurnText);
					}
				}
				if(gameOverMessageDisplayed)
				{
					if(FlxG.mouse.justReleased())
					{
						FlxG.switchState(new TitleState());
					}
				}
			}
			
			super.update();
		}
		
		//Function to print the current playfield. mostly for debugging purposes.
		private function printPlayfield():void
		{
			trace("=========================");
			trace("  0   1   2   3   4   5   6   7");
			trace("0 " +boardArray[0][0]+" | "+boardArray[1][0]+" | "+boardArray[2][0]+" | "+boardArray[3][0]+" | "+boardArray[4][0]+" | "+boardArray[5][0]+" | "+boardArray[6][0]+" | "+boardArray[7][0]);
			trace("1 " +boardArray[0][1]+" | "+boardArray[1][1]+" | "+boardArray[2][1]+" | "+boardArray[3][1]+" | "+boardArray[4][1]+" | "+boardArray[5][1]+" | "+boardArray[6][1]+" | "+boardArray[7][1]);
			trace("2 " +boardArray[0][2]+" | "+boardArray[1][2]+" | "+boardArray[2][2]+" | "+boardArray[3][2]+" | "+boardArray[4][2]+" | "+boardArray[5][2]+" | "+boardArray[6][2]+" | "+boardArray[7][2]);
			trace("3 " +boardArray[0][3]+" | "+boardArray[1][3]+" | "+boardArray[2][3]+" | "+boardArray[3][3]+" | "+boardArray[4][3]+" | "+boardArray[5][3]+" | "+boardArray[6][3]+" | "+boardArray[7][3]);
			trace("4 " +boardArray[0][4]+" | "+boardArray[1][4]+" | "+boardArray[2][4]+" | "+boardArray[3][4]+" | "+boardArray[4][4]+" | "+boardArray[5][4]+" | "+boardArray[6][4]+" | "+boardArray[7][4]);
			trace("5 " +boardArray[0][5]+" | "+boardArray[1][5]+" | "+boardArray[2][5]+" | "+boardArray[3][5]+" | "+boardArray[4][5]+" | "+boardArray[5][5]+" | "+boardArray[6][5]+" | "+boardArray[7][5]);
			trace("6 " +boardArray[0][6]+" | "+boardArray[1][6]+" | "+boardArray[2][6]+" | "+boardArray[3][6]+" | "+boardArray[4][6]+" | "+boardArray[5][6]+" | "+boardArray[6][6]+" | "+boardArray[7][6]);
			trace("7 " +boardArray[0][7]+" | "+boardArray[1][7]+" | "+boardArray[2][7]+" | "+boardArray[3][7]+" | "+boardArray[4][7]+" | "+boardArray[5][7]+" | "+boardArray[6][7]+" | "+boardArray[7][7]);
		}
		
		private function turns(whosTurnWasIt:int):void
		{
			//validMove = false;
			
			if(whosTurnWasIt == 1)
			{
				playerTurn = 2;
				checkingForValidMove = true;
				checkForValidMove();
				trace("validMoveFound is set to "+validMoveFound);
				if(validMoveFound)
				{
					checkingForValidMove = false;
					validMoveFound = false;
					messageDisplayed = true;
					shadowText1 = new FlxText(52,148,400,"White Player's Turn");
					shadowText1.setFormat(null,25,0x000000, "center");
					add(shadowText1);
					wTurnText = new FlxText(55,145,400,"White Player's Turn");
					wTurnText.setFormat(null,25,0xFF7F00, "center");
					add(wTurnText);
				}
				else
				{
					checkingForValidMove = false;
				}
			}
			if(whosTurnWasIt == 2)
			{
				playerTurn = 1;
				checkingForValidMove = true;
				checkForValidMove();
				trace("validMoveFound is set to "+validMoveFound);
				if(validMoveFound)
				{
					checkingForValidMove = false;
					validMoveFound = false;
					messageDisplayed = true;
					shadowText2 = new FlxText(52,148,400,"Black Player's Turn");
					shadowText2.setFormat(null,25,0x000000, "center");
					add(shadowText2);
					bTurnText = new FlxText(55,145,400,"Black Player's Turn");
					bTurnText.setFormat(null,25,0xFF7F00, "center");
					add(bTurnText);
				}
				else
				{
					checkingForValidMove = false;
				}
			}
		}
		
		private function checkForValidMove():void
		{	
			var pt:int = 0;
			var x:int =0;
			var y:int =0;
			
			trace("<inside checkForValidMove>playerTurn = "+playerTurn);
			if(playerTurn == 1)
			{
				pt = 2;
			}
			else
			{
				pt = 1;
			}
			
			trace("Checking for a valid move");
			//first we run a horizontal check
			for(y=0;y<8;y++)
			{
				for(x=0;x<8;x++)
				{
					//trace("boardArray["+x+"]["+y+"] = "+boardArray[x][y])

					if(boardArray[x][y] == 0)
					{
						currX = x;
						currY = y;
						vCurrX=x;
						vCurrY=y;
						//trace("X: "+x+" Y: "+y);
						validateMove();
					}
				}
			}

			trace("numberOfValidMoves = "+numberOfValidMoves);
			if(numberOfValidMoves > 0)
			{
				numberOfValidMoves = 0;
				trace("A valid move was found!");
				validMoveFound = true;
				if(playerTurn == 1)
				{
					noValidBlackMove = false;
				}
				else
				{
					noValidWhiteMove = false;
				}
			}
			else
			{
				trace("No valid moves found!");
				numberOfValidMoves = 0;
			
				if(playerTurn == 1)
				{
					trace("no valid black move found");
					shadowText3 = new FlxText(52,148,400,"No Valid Move for Black");
					shadowText3.setFormat(null,25,0x000000, "center");
					add(shadowText3);
					noMovesText = new FlxText(55,145,400,"No Valid Move for Black");
					noMovesText.setFormat(null,25,0xFF7F00, "center");
					add(noMovesText);
					noValidMoves = true;
					noValidBlackMove = true;
				}
				else
				{
					trace("no valid white move found");
					shadowText3 = new FlxText(52,148,400,"No Valid Move for White");
					shadowText3.setFormat(null,25,0x000000, "center");
					add(shadowText3);
					noMovesText = new FlxText(55,145,400,"No Valid Move for White");
					noMovesText.setFormat(null,25,0xFF7F00, "center");
					add(noMovesText);
					noValidMoves = true;
					noValidWhiteMove = true;
				}
			}
		}
		
		private function validateMove():void
		{	
			//This is where we check to see if the square selected is valid. We already know its empty.
			//We will test each space starting with the space north of the selected square. We will then check in a clockwise
			//direction provided the selected square meets certain position criteria.
			
			var nDone:Boolean = false;
			var neDone:Boolean = false;
			var eDone:Boolean = false;
			var seDone:Boolean = false;
			var sDone:Boolean = false;
			var swDone:Boolean = false;
			var wDone:Boolean = false;
			var nwDone:Boolean = false;
			var endPointFound:Boolean = false;
			var pieceToCheckFor:int = 0;
			var currX_copy:int = currX;
			var currY_copy:int = currY;
			var y:int = 0;
			var x:int = 0;
			var captureIndex:int = 0;
			
			//we need to reset the holder variables
			totalCapture = 0;
			for(var i:int=0;i<capture.length;i++)
			{
				capture[i]=0;
			}
			
			//Check squares to the North
			//trace("ENTERING NORTH CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currY >= 2)
			{
				//trace("N square has a "+boardArray[currX][currY-1]+" in it");
				//this IF tests to make sure we need to test in this direction
				if(boardArray[currX][currY-1] != 0 && boardArray[currX][currY-1] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					for(y=currY-2;y>=0;y--)
					{
						//trace("Searching for endpoint...");
						if(y < 0)
						{
							break;
						}
						//trace("x = "+currX+" y= "+y+" has a "+boardArray[currX][y]);
						if(boardArray[currX][currY] == 0)
						{
							break;
						}
						else if(boardArray[currX][y] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<NORTH>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating North **********");
								break;
							}
						}
					}
					while (!nDone && endPointFound)
					{
						for(y=currY-1;y>=0;y--)
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+currX+","+y);
							//trace("boardArray["+currX+"]["+y+"]= "+boardArray[currX][y]);
							if(boardArray[currX][y] == pieceToCheckFor && !nDone && boardArray[currX][y-1] != 0)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+currX);
								capture[captureIndex]=currX;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+y);
								capture[captureIndex]=y;
								captureIndex++;
							}
							if(boardArray[currX][y] == playerTurn)
							{
								nDone = true;
								endPointFound = false;
								break;
							}
						}
					}
				}
			}
			//trace("EXITING NORTH CHECK");
			
			//Check squares to the NorthEast
			//trace("ENTERING NORTHEAST CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currX <= 5 && currY >= 2)
			{
				//this IF tests to make sure we need to test in this direction
				//trace("NE square has a "+boardArray[currX+1][currY-1]+" in it");
				if(boardArray[currX+1][currY-1] != 0 && boardArray[currX+1][currY-1] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					x = currX+2;
					for(y=currY-2;y>=0;y--)
					{
						//trace("Searching for endpoint...");
						if(x>=8 || y<0)
						{
							//trace("End of the line...");
							break;
						}
						//trace("x = "+x+" y= "+y+" has a "+boardArray[x][y]);
						if(boardArray[x][y] == 0)
						{
							//trace("Found a SPACE!");
							break;
						}
						if(boardArray[x][y] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<NORTHEAST>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating NorthEast **********");
								currX_copy = currX;
								currY_copy = currY;
								break;
							}
						}
						x++;
					}
					while (!neDone && endPointFound)
					{
						currX_copy++;
						currY_copy--;
						if((currX_copy<8 || currX_copy>=0) && (currY_copy<8 || currY_copy>=0)) 
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+currX_copy+","+currY_copy);
							//trace("boardArray["+currX_copy+"]["+currY_copy+"]= "+boardArray[currX_copy][currY_copy]);
							if(boardArray[currX_copy][currY_copy] == pieceToCheckFor && !neDone)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+currX_copy);
								capture[captureIndex]=currX_copy;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+currY_copy);
								capture[captureIndex]=currY_copy;
								captureIndex++;
							}
							if(boardArray[currX_copy][currY_copy] == playerTurn)
							{
								neDone = true;
								endPointFound = false;
							}
						}
					}
				}
			}
			//trace("EXITING NORTHEAST CHECK");
			
			//Check squares to the East
			//trace("ENTERING EAST CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currX <= 5)
			{
				//trace("E square has a "+boardArray[currX+1][currY]+" in it");
				//this IF tests to make sure we need to test in this direction
				if(boardArray[currX+1][currY] != 0 && boardArray[currX+1][currY] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					for(x=currX+2;x<8;x++)
					{
						//trace("Searching for endpoint...");
						if(x >= 8)
						{
							break;
						}
						//trace("x = "+x+" y= "+currY+" has a "+boardArray[x][currY]);
						if(boardArray[x][currY] == 0)
						{
							break;
						}
						if(boardArray[x][currY] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<EAST>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating East **********");
								break;
							}
						}
					}
					while (!eDone && endPointFound)
					{
						for(x=currX+1;x<8;x++)
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+x+","+currY);
							//trace("boardArray["+x+"]["+currY+"]= "+boardArray[x][currY]);
							if(boardArray[x][currY] == pieceToCheckFor && !eDone && boardArray[x+1][currY] != 0)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+x);
								capture[captureIndex]=x;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+currY);
								capture[captureIndex]=currY;
								captureIndex++;
							}
							if(boardArray[x][currY] == playerTurn)
							{
								eDone = true;
								endPointFound = false;
								break;
							}
						}
					}
				}
			}
			//trace("EXITING EAST CHECK");
			
			//Check squares to the SouthEast
			//trace("ENTERING SOUTHEAST CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currX <= 5 && currY <= 5)
			{
				//this IF tests to make sure we need to test in this direction
				//trace("SE square has a "+boardArray[currX+1][currY+1]+" in it");
				if(boardArray[currX+1][currY+1] != 0 && boardArray[currX+1][currY+1] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					x=currX+2;
					for(y=currY+2;y<8;y++)
					{
						//trace("Searching for endpoint...");
						if(x>=8 || y>=8)
						{
							//trace("End of the line...");
							break;
						}
						//trace("x = "+x+" y= "+y+" has a "+boardArray[x][y]);
						if(boardArray[x][y] == 0)
						{
							//trace("Found a SPACE!");
							break;
						}
						if(boardArray[x][y] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<SOUTHEAST>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating SouthEast **********");
								currX_copy = currX;
								currY_copy = currY;
								break;
							}
						}
						x++;
					}
					while (!seDone && endPointFound)
					{
						currX_copy++;
						currY_copy++;
						if((currX_copy<8 || currX_copy>=0) && (currY_copy<8 || currY_copy>=0)) 
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("currX= "+currX+" currY= "+currY);
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+currX_copy+","+currY_copy);
							//trace("boardArray["+currX_copy+"]["+currY_copy+"]= "+boardArray[currX_copy][currY_copy]);
							if(boardArray[currX_copy][currY_copy] == pieceToCheckFor && !seDone)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+currX_copy);
								capture[captureIndex]=currX_copy;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+currY_copy);
								capture[captureIndex]=currY_copy;
								captureIndex++;
							}
							if(boardArray[currX_copy][currY_copy] == playerTurn)
							{
								seDone = true;
								endPointFound = false;
							}
						}
					}
				}
			}
			//trace("EXITING SOUTHEAST CHECK");
			
			//Check squares to the South
			//trace("ENTERING SOUTH CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currY <= 5)
			{
				//this IF tests to make sure we need to test in this direction
				//trace("<SOUTH>Piece at this location belongs to player "+boardArray[currX][currY+1])
				if(boardArray[currX][currY+1] != 0 && boardArray[currX][currY+1] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					for(y=currY+2;y<8;y++)
					{
						//trace("Searching for endpoint...");
						if(y>=8)
						{
							break;
						}
						//trace("x = "+currX+" y= "+y+" has a "+boardArray[currX][y]);
						if(boardArray[currX][y] == 0)
						{
							break;
						}
						if(boardArray[currX][y] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<SOUTH>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating South **********");
								break;
							}
						}
					}
					while (!sDone && endPointFound)
					{
						for(y=currY+1;y<8;y++)
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+currX+","+y);
							//trace("boardArray["+currX+"]["+y+"]= "+boardArray[currX][y]);
							if(boardArray[currX][y] == pieceToCheckFor && !sDone && boardArray[currX][y+1] != 0)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+currX);
								capture[captureIndex]=currX;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+y);
								capture[captureIndex]=y;
								captureIndex++;
							}
							if(boardArray[currX][y] == playerTurn)
							{
								sDone = true;
								endPointFound = false;
								break;
							}
						}
					}
				}
			}
			//trace("EXITING SOUTH CHECK");
			
			//Check squares to the NorthEast
			//trace("ENTERING SOUTHWEST CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currX >=2  && currY <= 5)
			{
				//this IF tests to make sure we need to test in this direction
				//trace("SW square has a "+boardArray[currX-1][currY+1]+" in it");
				if(boardArray[currX-1][currY+1] != 0 && boardArray[currX-1][currY+1] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					x=currX-2;
					for(y=currY+2;y<8;y++)
					{
						//trace("Searching for endpoint...");
						if(x<0 || y>=8)
						{
							//trace("End of the line...");
							break;
						}
						//trace("x = "+x+" y= "+y+" has a "+boardArray[x][y]);
						if(boardArray[x][y] == 0)
						{
							//trace("Found a SPACE!");
							break;
						}
						if(boardArray[x][y] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<SOUTHWEST>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating SouthWest **********");
								currX_copy = currX;
								currY_copy = currY;
								break;
							}
						}
						x--;
					}
					while (!swDone && endPointFound)
					{
						currX_copy--;
						currY_copy++;
						if((currX_copy<8 || currX_copy>=0) && (currY_copy<8 || currY_copy>=0)) 
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+currX_copy+","+currY_copy);
							//trace("boardArray["+currX_copy+"]["+currY_copy+"]= "+boardArray[currX_copy][currY_copy]);
							if(boardArray[currX_copy][currY_copy] == pieceToCheckFor && !swDone)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+currX_copy);
								capture[captureIndex]=currX_copy;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+currY_copy);
								capture[captureIndex]=currY_copy;
								captureIndex++;
							}
							if(boardArray[currX_copy][currY_copy] == playerTurn)
							{
								swDone = true;
								endPointFound = false;
							}
						}
					}
				}
			}
			//trace("EXITING SOUTHWEST CHECK");
			
			//Check squares to the West
			//trace("ENTERING WEST CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currX >=2)
			{
				//this IF tests to make sure we need to test in this direction
				//trace("W square has a "+boardArray[currX-1][currY]+" in it");
				if(boardArray[currX-1][currY] != 0 && boardArray[currX-1][currY] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					for(x=currX-2;x>=0;x--)
					{
						//trace("Searching for endpoint...");
						if(x<0)
						{
							break;
						}
						//trace("x = "+x+" y= "+currY+" has a "+boardArray[x][currY]);
						if(boardArray[x][currY] == 0)
						{
							break;
						}
						if(boardArray[x][currY] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<WEST>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating West **********");
								break;
							}
						}
					}
					while (!wDone && endPointFound)
					{
						for(x=currX-1;x>=0;x--)
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+x+","+currY);
							//trace("boardArray["+x+"]["+currY+"]= "+boardArray[x][currY]);
							if(boardArray[x][currY] == pieceToCheckFor && !wDone && boardArray[x-1][currY] != 0)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+x);
								capture[captureIndex]=x;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+currY);
								capture[captureIndex]=currY;
								captureIndex++;
							}
							if(boardArray[x][currY] == playerTurn)
							{
								wDone = true;
								endPointFound = false;
							}
						}
					}
				}
			}
			//trace("EXITING WEST CHECK");
			
			//Check squares to the NorthWest
			//trace("ENTERING NORTHWEST CHECK");
			//this IF tests to make sure we're in a valid spot to test in this direction
			if(currX >= 2 && currY >= 2)
			{
				//this IF tests to make sure we need to test in this direction
				//trace("NW square has a "+boardArray[currX-1][currY-1]+" in it");
				if(boardArray[currX-1][currY-1] != 0 && boardArray[currX-1][currY-1] != playerTurn)
				{
					//trace("Start search for endpoint...");
					//direction looks good, need to test for endpoint.
					x=currX-2;
					for(y=currY-2;y>=0;y--)
					{
						//trace("Searching for endpoint...");
						if(x<0 || y<0)
						{
							//trace("End of the line...");
							break;
						}
						//trace("x = "+x+" y= "+y+" has a "+boardArray[x][y]);
						if(boardArray[x][y] == 0)
						{
							//trace("Found a SPACE!");
							break;
						}
						if(boardArray[x][y] == playerTurn)
						{
							if(checkingForValidMove)
							{
								trace("<NORTHWEST>A valid move is available at "+vCurrX+","+vCurrY);
								numberOfValidMoves++;
								break;
							}
							else
							{
								//trace("FOUND IT!");
								endPointFound = true;
								//trace("********** validating NorthWest **********");
								currX_copy = currX;
								currY_copy = currY;
								break;
							}
						}
						x--;
					}
					while (!nwDone && endPointFound)
					{
						currX_copy--;
						currY_copy--;
						if((currX_copy<8 || currX_copy>=0) && (currY_copy<8 || currY_copy>=0)) 
						{
							if(playerTurn == 1)
							{
								pieceToCheckFor = 2;
							}
							else
								pieceToCheckFor = 1;
							//trace("checking for pieces belonging to player "+pieceToCheckFor+" at "+currX_copy+","+currY_copy);
							//trace("boardArray["+currX_copy+"]["+currY_copy+"]= "+boardArray[currX_copy][currY_copy]);
							if(boardArray[currX_copy][currY_copy] == pieceToCheckFor && !nwDone)
							{
								//trace("Found a piece!");
								totalCapture++;
								//trace("set capture["+captureIndex+"]="+currX_copy);
								capture[captureIndex]=currX_copy;
								captureIndex++;
								//trace("set capture["+captureIndex+"]="+currY_copy);
								capture[captureIndex]=currY_copy;
								captureIndex++;
							}
							if(boardArray[currX_copy][currY_copy] == playerTurn)
							{
								nwDone = true;
								endPointFound = false;
							}
						}
					}
				}
			}
			//trace("EXITING NORTHWEST CHECK");
			
			if(totalCapture > 0)
			{
				trace("Move valid...");
				validMove = true;
			}
			else if(!checkingForValidMove)
			{
				boardArray[currX][currY]=0;
			}
		}
		
		private function capturePieces(toDo:int):void
		{trace("********** INSIDE capturePieces **********");
			var tmp:FlxSprite;
			var tmp2:FlxSprite;
			
			//trace("capture length is "+capture.length);
			for(var i:int=0;i<=(capture.length/2);i++)
			{
				//trace("i = " + i);
				if(playerTurn == 1 && toDo != 0)
				{trace("Running capture for BLACK PLAYER");
					trace("boardArray["+capture[i]+"]["+capture[i+1]+"]= "+boardArray[capture[i]][capture[i+1]]);
					boardArray[capture[i]][capture[i+1]] = 1;
					trace("Length of wPieces is "+wPieces.members.length);
					for(var j:int=0;j<wPieces.members.length;j++)
					{
						if(wPieces.members[j] != null)
						{
							tmp2 = wPieces.members[j];
							trace("tmp2.x = "+tmp2.x/64+","+" tmp2.y = "+tmp2.y/64);
							if(tmp2.x/64 == capture[i] && tmp2.y/64 == capture[i+1])
							{
								tmp = tmp2;
								wPieces.remove(tmp,true);
								trace("After removing the captured piece...");
								trace("Length of wPieces is "+wPieces.members.length);
								//groupList();
							}
						}
					}
					trace("Killing old white piece");
					tmp.kill();
					trace("creating new black piece");
					bpieces = new BlackPieces(capture[i],capture[i+1]);
					bPieces.add(bpieces);
					add(bpieces);
					whitePieces--;
					blackPieces++;
					toDo--;
				}
				if(playerTurn == 2 && toDo != 0)
				{trace("Running capture for WHITE PLAYER");
					trace("boardArray["+capture[i]+"]["+capture[i+1]+"]= "+boardArray[capture[i]][capture[i+1]]);
					boardArray[capture[i]][capture[i+1]] = 2;
					trace("Length of bPieces is "+bPieces.members.length);
					for(var k:int=0;k<bPieces.members.length;k++)
					{
						if(bPieces.members[k] != null)
						{
							tmp2 = bPieces.members[k];
							trace("tmp2.x = "+tmp2.x/64+","+" tmp2.y = "+tmp2.y/64);
							if(tmp2.x/64 == capture[i] && tmp2.y/64 == capture[i+1])
							{
								tmp = tmp2;
								bPieces.remove(tmp,true);
								trace("After removing the captured piece...");
								trace("Length of bPieces is "+bPieces.members.length);
								//groupList();
							}
						}
					}
					trace("Killing old black piece");
					tmp.kill();
					trace("creating new white piece");
					wpieces = new WhitePieces(capture[i],capture[i+1]);
					wPieces.add(wpieces);
					add(wpieces);
					whitePieces++;
					blackPieces--;
					toDo--;
				}
				i++;
			}
			whiteScore.text = whitePieces.toString();
			blackScore.text = blackPieces.toString();
			add(whiteScore);
			add(blackScore);
			validMove = false;
		}
	}
}
