package Game.Rally.Referee 
{
		
	import Game.Game;
	
	public class Referee 
	{
		
		private var game: Game;
		private var wasOurHit: Boolean;
		private var stage: String; // ['after hit', 'on win']
		private var whoServe: Boolean;
		
		public function Referee(game: Game) 
		{
			this.game = game;
		}
		
		public function start(whoServe: Boolean, t:int): void
		{						
			wasOurHit = ! whoServe;
			stage = 'on win';
			this.whoServe = whoServe;	
			
			game.rally.player0.hold(false, t);
			game.rally.player1.hold(false, t);
			game.rally.ball.serve(true, whoServe, t);
			game.rally.ball.collisions.reset();
			
			game.rally.viewShowServeLines(false);			
		}				
		
		public function collision(type: String /* [border, field, player] */, number: int):void
		{			
			if ((game.type == 'local') || (! wasOurHit) || (type=='player'))
			{									
				if (type == 'player')
				{
					wasOurHit = (number == 0);
					stage = 'after hit';
				}
				else 
				{				
					if (stage == 'on win')
					{
						rallyEnd(wasOurHit);
					}
					else if (type == 'border')
					{										
						rallyEnd(! wasOurHit);
					}
					else
					{
						if ((number == 0 || number == 1) == wasOurHit)
						{
							rallyEnd(! wasOurHit);
						}
						else
						{
							stage = 'on win';
						}
					}
				}
			}
		}
		
		private function rallyEnd(whoWin: Boolean, isMessageFromHe: Boolean=false): void
		{									
			if (! isMessageFromHe)
			{
				messageSendRallyEnd(whoWin);
			}
			game.referee.rallyEnd(whoWin);
			
			var t:int = game.rally.time.get();
			game.rally.player0.hold(true, t);
			game.rally.player1.hold(true, t);
			game.rally.ball.serve(false, false, t);
			
			game.rally.viewShowServeLines(true);
			game.rally.middleLines.init();
		}
		
		private function messageSendRallyEnd(whoWin: Boolean): void
		{
			game.messageSend({mt: 'rw', w: whoWin});
			//"rw"=="rally_win (or loose)"
		}
		
		public function messageReceive(message: Object): void
		{
			switch(message.mt)
			{
				case 'rw':
					rallyEnd(! message.w, true);
					break;
			}
		}
	}

}