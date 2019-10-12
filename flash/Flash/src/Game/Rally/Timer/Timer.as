package Game.Rally.Timer
{
	
	import flash.utils.Timer;
    import flash.events.TimerEvent;
	import Game.Game;
	
	public class Timer
	{		
		var game: Game;
		var timer: flash.utils.Timer;
		
		public function Timer(game: Game): void
		{
			this.game = game;
			timer = new flash.utils.Timer(10, 0);
			timer.addEventListener("timer", action);
			timer.start();
		}
		
		public function action(event:TimerEvent): void
		{
			game.rally.shiftTime(game.rally.time.get());
		}
	}

}