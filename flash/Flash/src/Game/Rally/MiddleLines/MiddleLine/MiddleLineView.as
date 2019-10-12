package Game.Rally.MiddleLines.MiddleLine 
{
	import flash.display.Sprite;

	public class MiddleLineView extends Sprite
	{
		private var 
			curve:Array,
			prevPosW: Number,
			curveXMax: Number
		;		
		
		public function MiddleLineView(curve: Array, curveXMax:Number, side: Boolean)
		{
			this.curve = curve;
			this.curveXMax = curveXMax;				
		}
		
		public function setPos(posX: Number, posW: Number): void
		{			
			/*graphics.lineStyle(1, 0x8000ee, 0);
			for(var i:Number = 1; i < curve.length; i++)
			{
				graphics.moveTo(curve[i-1][0]*prevPosW, curve[i-1][1]); 
				graphics.lineTo(curve[i][0]*prevPosW, curve[i][1]); 
				
				graphics.moveTo(curve[i-1][0]*prevPosW, -curve[i-1][1]); 
				graphics.lineTo(curve[i][0]*prevPosW, -curve[i][1]); 
			}
			graphics.lineStyle(1, 0x80bb80, 1);*/
			if (Math.round(curveXMax * prevPosW) != Math.round(curveXMax * posW))
			{
				graphics.clear();
				graphics.lineStyle(1, 0x80bb80, 1);
				for(var i:Number = 1; i < curve.length; i++)
				{
					graphics.moveTo(curve[i-1][0]*posW, curve[i-1][1]); 
					graphics.lineTo(curve[i][0]*posW, curve[i][1]); 
					
					graphics.moveTo(curve[i-1][0]*posW, -curve[i-1][1]); 
					graphics.lineTo(curve[i][0]*posW, -curve[i][1]); 
				}	
				prevPosW = posW;
			}
			x = posX;
		}
		
	}

}