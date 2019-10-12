package Game.Wait 
{
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Game.Game;
	
	public class NetworkWait extends Wait
	{
		private var
			isReadyWe: Boolean,
			isReadyHe: Boolean,
			timer: Timer,
			startTime: int;

		
		public function NetworkWait(game: Game) 
		{
			super(game);			
			isReadyWe = false;
			isReadyHe = false;			
			timer = new Timer(100, 1);
			timer.addEventListener(TimerEvent.TIMER, startImmediately);
			
			//view
			var style:StyleSheet = new StyleSheet(); 
			
			var styleObj:Object = new Object(); 			
			styleObj.textAlign = "center";
			styleObj.fontFamily = "_typewriter";			
			styleObj.fontSize = 16;
			style.setStyle(".wait", styleObj); 
			
			view = new TextField();			
			view.visible = false;
			view.background = true;			
			view.backgroundColor = 0xAAAAAA;
			view.border = true;
			view.borderColor = 0x888888;
			view.styleSheet = style;
			with (view)
			{
				width = 300; 
				height = 62; 
				multiline = true; 
				wordWrap = true; 
				x = -150;
				y = -100;
			}
			game.view.addChild(view);
		}
		
		override public function wait(): void
		{
			Main.stage.addEventListener(KeyboardEvent.KEY_UP, readyWe);
			
			//view
			viewShowReady();
			view.visible = true;
		}
		
		public function readyWe(event: KeyboardEvent): void
		{			
			if (event.keyCode == 32)
			{								
				isReadyWe = ! isReadyWe;
				start(-1);
			}
		}
		
		public function start(time:int): void
		{
			viewShowReady();
			
			if (time < 0)
			{
				if (! isReadyWe || ! isReadyHe)
				{
					if (time == -1) 
					{
						messageSendReady(isReadyWe, -2);
					}
					return;
				}
				else
				{					
					time = game.rally.time.get();
					messageSendReady(true, time);
				}
			}			
			
			Main.stage.removeEventListener(KeyboardEvent.KEY_UP, ready);
			isReadyWe = false;
			isReadyHe = false;
			
			timer.reset();
			startTime = time + 1000;
			var delay:int = startTime-game.rally.time.get();
			if(delay<=0)
			{
				startImmediately(null);
			}
			else
			{
				timer.reset();
				timer.delay = delay;
				timer.start();
			}
			
			//view
			view.visible = false;
			game.referee.view.visible = false;
		}
		
		public function startImmediately(event:TimerEvent): void
		{
			game.referee.rallyStart(startTime);
		}
		
		public function messageReceive(message: Object): void
		{
			switch(message.mt)
			{
				case 'wr':										
					isReadyHe = message.r;
					start(message.t);					
					break;
			}
		}
		
		public function messageSendReady(ready: Boolean, time: int): void
		{
			game.messageSend(
				{mt: 'wr', r: ready, t: time}
			);
			//"wr" == "wait ready (or not)"
		}
		
		private function viewShowReady()
		{
			view.htmlText="<span class='wait'>Press <u>space</u> if you're "+(isReadyWe ? "not " : "")+"ready (you're "+(isReadyWe ? "" : "not ")+"ready).<br>Your opponent is "+(isReadyHe ? "" : "not ")+"ready.</span>";
		}
		
	}

}