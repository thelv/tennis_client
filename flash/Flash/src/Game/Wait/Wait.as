package Game.Wait 
{
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import Game.Game;
	
	public class Wait 
	{
		public var
			game: Game,
			view: TextField;
		
		public function Wait(game: Game) 
		{
			this.game = game;
			
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
				height = 27; 
				multiline = true; 
				wordWrap = true; 
				htmlText = "<span class='wait'>Press <u>space</u> to continue.</span>";
				x = -150;
				y = -100;
			}
			game.view.addChild(view);
		}
		
		public function wait(): void
		{			
			Main.stage.addEventListener(KeyboardEvent.KEY_UP, ready);
			
			//view
			view.visible = true;
		}
		
		public function ready(event: KeyboardEvent): void
		{
			if (event.keyCode == 32)
			{					
				Main.stage.removeEventListener(KeyboardEvent.KEY_UP, ready);
				game.referee.rallyStart(game.rally.time.get());
				
				//view
				view.visible = false;
			}		
		}
		
	}

}