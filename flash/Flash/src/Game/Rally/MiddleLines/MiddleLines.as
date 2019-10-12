package Game.Rally.MiddleLines
{
	
	import flash.display.Sprite;
	import Game.Rally.Scale.Scale;
	import Game.Rally.MiddleLines.MiddleLine.MiddleLine;
	
	public class MiddleLines
	{	
		public var lines: Array;
		public var view: Sprite;
		
		public function MiddleLines()
		{
			lines = 
			[
				new MiddleLine(true),
				new MiddleLine(false)
			];
			
			//view
			view = new Sprite();
			view.addChild(lines[0].view);
			view.addChild(lines[1].view);				
		}
		
		
		
		public function hit(player: int, x: Number, t: int): void
		{
			lines[0].hit(player, x, t);
			lines[1].hit(player, x, t);
		}
		
		public function init(): void
		{
			lines[0].init();
			lines[1].init();
		}
		
	}

}