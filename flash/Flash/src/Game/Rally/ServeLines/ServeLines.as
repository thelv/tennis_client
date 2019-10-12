package Game.Rally.ServeLines
{
	
	import flash.display.Sprite;
	import Game.Rally.Scale.Scale;
	
	public class ServeLines
	{		
		private var h:Number = 1;
		public var lines: Array;
		public var view: Sprite;
		public var centralLine: Array;
		public var w:Number=359;
		
		public function ServeLines()
		{
			this.w = w;
			
			lines = 
			[
				[
					-w, Scale.convertY(-h)+1,
					-w, Scale.convertY(h)-1
				],
				[
					w, Scale.convertY(-h)+1, 
					w, Scale.convertY(h)-1
				]
			]					
			
			//view
			view = new Sprite();			
			viewPaint();
		}
		
		//view
		private function viewPaint(): void
		{			
			view.graphics.lineStyle(1, 0x80bb80);
			for (var i:int = 0; i < lines.length; i++)
			{				
				var line:Array = lines[i];				
				view.graphics.moveTo(line[0], line[1]); 
				view.graphics.lineTo(line[2], line[3]);							
			}			
		}
	}

}