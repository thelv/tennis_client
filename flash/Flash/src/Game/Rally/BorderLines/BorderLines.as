package Game.Rally.BorderLines 
{
	
	import flash.display.Sprite;
	import Game.Rally.Scale.Scale;
	
	public class BorderLines 
	{
		
		private var w:Number = 1.3, h:Number = 1.4;
		public var lines: Array;
		public var view: Sprite;
		
		public function BorderLines() 
		{
			lines = new Array(
				new Array(Scale.convertX(-w), Scale.convertY(-h), Scale.convertX(w), Scale.convertY(-h))
				,new Array(Scale.convertX(-w), Scale.convertY(-h), Scale.convertX(-w), Scale.convertY(h))
				,new Array(Scale.convertX(w), Scale.convertY(h), Scale.convertX(-w), Scale.convertY(h))
				,new Array(Scale.convertX(w), Scale.convertY(h), Scale.convertX(w), Scale.convertY(-h))
			);
						
			//view
			view = new Sprite();			
			viewPaint();
		}
		
		//view
		private function viewPaint(): void
		{			
			view.graphics.lineStyle(1, 0xaa4444);
			for (var i:int = 0; i < lines.length; i++)
			{
				var line:Array = lines[i];
				view.graphics.moveTo(line[0], line[1]); 
				view.graphics.lineTo(line[2], line[3]);
			}
		}
		
	}

}