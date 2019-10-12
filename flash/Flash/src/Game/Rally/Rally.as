package Game.Rally 
{	
	import Game.Game;
	import Game.Rally.Referee.Referee;
	import Game.Rally.FieldLines.FieldLines;
	import Game.Rally.BorderLines.BorderLines;
	import Game.Rally.MiddleLines.MiddleLines;
	import Game.Rally.ServeLines.ServeLines;
	import Game.Rally.Time.Time;
	import Game.Rally.Timer.Timer;
	import Game.Rally.Player.Player;
	import Game.Rally.Player.LocalPlayer;
	import Game.Rally.Player.RemotePlayer;
	import Game.Rally.Ball.Ball;

	public class Rally 
	{
		
		private var
			game: Game;
		
		public var
			referee: Referee,
			fieldLines: FieldLines,
			borderLines: BorderLines,
			middleLines: MiddleLines,
			serveLines: ServeLines,
			time: Time,
			timer: Timer,
			ball: Ball,
			player0: LocalPlayer,
			player1: Player;
			
		
		public function Rally(game: Game)
		{
			this.game = game;
			
			time = new Time(game);
			fieldLines = new FieldLines();
			borderLines = new BorderLines();
			middleLines = new MiddleLines();
			serveLines = new ServeLines();
			referee = new Referee(game);
			ball = new Ball(game);
			player0 = new LocalPlayer(game, true);
			player1 = (game.type == 'local') ? new LocalPlayer(game, false) : new RemotePlayer(game, false);
			
			//view
			game.view.addChild(middleLines.view);
			game.view.addChild(serveLines.view);
			game.view.addChild(fieldLines.view);
			game.view.addChild(borderLines.view);
			game.view.addChild(player0.view);
			game.view.addChild(player1.view);
			game.view.addChild(ball.view);
			
			//start
			timer = new Timer(game);
		}
		
		public function shiftTime(t: int): void
		{						
			middleLines.lines[0].shiftTime(t);
			middleLines.lines[1].shiftTime(t);
			player0.shiftTime(t);
			player1.shiftTime(t);
			ball.shiftTime(t);			
		}
		
		public function viewShowServeLines(show: Boolean): void
		{
			if (show)
			{
				serveLines.view.visible = true;
			}
			else
			{
				serveLines.view.visible = false;
			}
		}
	}

}