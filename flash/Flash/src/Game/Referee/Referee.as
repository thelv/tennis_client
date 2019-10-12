package Game.Referee 
{

	import flash.text.StyleSheet;
	import flash.text.TextField;
	import Game.Game;
	import Game.Rally.Scale.Scale;

	public class Referee 
	{
		
		private var 
			game: Game,
			whoServe: Boolean,
			score: Array,
			scoreLimits: Array,
			scoreAdv: int,
			scoreInc: Array,
			winner: int = -1,
			setsNumber:int = -1;
			
			public var
				view: TextField;
		
		public function Referee(game: Game, whoMain: Boolean) 
		{
			this.game = game;
			whoServe = ! whoMain;
			scoreInit();			
			
			//view
			var style:StyleSheet = new StyleSheet(); 
			 
			var styleObj:Object = new Object(); 			
			styleObj.textAlign = "center";
			styleObj.fontWeight = "normal";
			styleObj.fontFamily = "_typewriter";
			styleObj.fontSize = 16;			
			style.setStyle(".score", styleObj); 
			
			view = new TextField();
			view.styleSheet = style;
			with (view)
			{
				width = 800; 
				height = 30; 
				multiline = true; 
				wordWrap = true; 				
				x = -400;//-Scale.convertX(1);
				y = -Scale.convertY(1) - 33;
			}
			game.view.addChild(view);
			//Main.stage.addChild(view);
			
			viewShowScore();
		}
	
		public function start(): void
		{
			game.wait.wait();
		}
		
		
		public function rallyEnd(whoWin: Boolean): void
		{
			whoServe = ! whoServe;
			scoreChange(whoWin);
			viewShowScore();
			if (score[2][0] == setsNumber)
			{
				winner = 0;
			}
			else if (score[2][0] == setsNumber) {
				winner = 1;
			}			
			game.wait.wait();
			
			//view
			view.visible = true;

		}
		
		public function rallyStart(t: int): void
		{		
			if (winner>=0)
			{
				winner = -1;
				scoreInit();
			}
			game.rally.referee.start(whoServe, t);
			
			//view
			view.visible = false;

		}
		
		
		private function scoreChange(whoWin: Boolean, type: int=0): void
		{						
			var whoWinInt:int = whoWin ? 0 : 1;
			scoreInc = [type, whoWinInt];
			var notWhoWinInt:int = whoWin ? 1 : 0;
			var newScore:int = (score[type][whoWinInt] += 1)
			if (newScore > scoreLimits[type])			
			{
				if (type == 0 && score[type][notWhoWinInt] == scoreLimits[0])
				{
					score[type][whoWinInt] = scoreLimits[0];
					if (scoreAdv == whoWinInt)
					{						
						score[type] = [0, 0];
						scoreChange(whoWin, type + 1);
						scoreAdv = -1;
					}
					else if(scoreAdv==notWhoWinInt)
					{						
						scoreAdv = -1;
					}
					else
					{
						scoreAdv = whoWinInt;
					}				
				}
				else
				{
					score[type] = [0, 0];
					scoreChange(whoWin, type + 1);
				}
			}			
		}
		
		private function scoreInit(): void
		{
			score = [[0, 0], [0, 0], [0, 0]];
			scoreLimits = [7, 2];
			scoreAdv = -1;
			scoreInc = [0,-1];			
		}
		
		private function viewShowScore(): void
		{
			var str:String = '<span class=\'score\'>Score (sets/games/balls): ';
			for (var i:int = 2; i >= 0; i--)
			{
				if (i == 0 && scoreAdv == 1)
				{
					str += 'adv ';
				}
				
				if (i == 0 && ! whoServe)
				{
					str += '*';
				}
								
				if (scoreInc[0] == i && scoreInc[1] == 1)
				{
					str += '<u>'+score[i][1]+'</u>';
				}
				else
				{
					str += score[i][1];
				}
				
				str+=':'								
				
				if (scoreInc[0] == i && scoreInc[1] == 0)
				{
					str += '<u>'+score[i][0]+'</u>';
				}
				else
				{
					str += score[i][0];
				}
				
				if (i == 0 && scoreAdv == 0)
				{
					str += ' adv';
				}
				
				if (i == 0 && whoServe)
				{
					str += '*';
				}
				
				if (i !== 0)
				{
					str += ' / ';
				}
			}
			str += '</span>';
			view.htmlText = str;			
		}
		
	}

}