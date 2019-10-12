package Game.Rally.Time 
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Game.Game;
	
	public class Time 
	{
		
		private var 
			game: Game,
			startTime: int,
			shiftTime: int = 0,
			shiftTimes:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			i:int = 0,
			timer: Timer;
		
		public function Time(game: Game)
		{
			this.game = game;
			startTime = new Date().time;			
			timer = new Timer(200, 10);
			timer.addEventListener(TimerEvent.TIMER, messageSendSynchronizeRequest); 
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, synchronizeComplete);
		}
		
		public function get(): int
		{			
			return new Date().time - startTime - shiftTime;
		}
		
		private function getAbs(): int
		{
			return new Date().getTime();
		}
		
		
		public function synchronize(): void
		{
			if (game.whoMain)
			{
				timer.start();
			}
			else
			{
				game.referee.start();
			}
		}
		
		public function messageSendSynchronizeRequest(event:TimerEvent): void
		{
			game.messageSend(
					{mt: 'ts', t0: getAbs()-startTime}
			);
			//"ts"=="time_synchronization"	
		}
		
		public function messageSendSynchronizeResponse(t0: int): void
		{
			game.messageSend(
					{mt: 'ts', t0: t0, t1: get()}
			);
			//"rw"=="rally_win (or loose)"
		}
		
		public function messageReceive(message: Object): void
		{
			switch(message.mt)
			{
				case 'ts':
					if (game.whoMain)
					{
						shiftTimes[i] = (getAbs() - startTime + message.t0) / 2 - message.t1;
						
						var newShiftTime = 0;
						for (var j:int = 0; j <= 9; j++)
						{
							newShiftTime += shiftTimes[i];
						}
						shiftTime = newShiftTime / 10;
					}
					else
					{
						messageSendSynchronizeResponse(message.t0);
					}
			}
		}
		
		public function synchronizeComplete(event:TimerEvent): void
		{
			game.referee.start();
			timer.delay = 10000;
			timer.repeatCount = 0;
			timer.reset();
			timer.start();
		}
	}

}