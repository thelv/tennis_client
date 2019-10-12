package 
{	
	import flash.display.Sprite;	

	public class View extends Sprite
	{		
		private var diagonalLength: Number, diagonalAngle: Number;
			
		public function View(width: int, height: int): void
		{								
			diagonalLength = Math.sqrt(width*width + height*height) / 2;			
			diagonalAngle = Math.atan(height / width);
		}
		
		public function showPosition(x: Number, y: Number, a: Number): void
		{			
			this.x =  x - diagonalLength * Math.cos(diagonalAngle - a);
			this.y =  - y - diagonalLength * Math.sin(diagonalAngle - a);
			this.rotation = - a * 180 / Math.PI;						
		}	
	}	
}