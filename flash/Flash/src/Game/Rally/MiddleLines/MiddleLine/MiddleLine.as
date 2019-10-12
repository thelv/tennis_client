package Game.Rally.MiddleLines.MiddleLine 
{
	import flash.display.Sprite;
	import Game.Rally.Scale.Scale;
	
	public class MiddleLine 
	{
		private var
			side: Boolean, sideSign: int, t0: int,
			pos:Number, posV:Number, posStart:Number, posVInc: Number = 0.025 / 80, posVDec:Number = 0.05 / 80,
			posX: Number, posXV:Number, posXV0:Number=80,
			posW:Number, posWV:Number, posWV0:Number = 2
		;
		
		public var 
			curve:Array = [[30, 0], [30, 60], [0, 250]], curveYMax:Number = 100, curveXMax:Number=30,
			state: String = 'dec',
			view: MiddleLineView //view
		;
		
		public function MiddleLine(side: Boolean)
		{
			this.side = side;
			sideSign = side? 1: -1;
			state = 'dec';
			pos = 0;
			posV = 0;
			posStart = 0;
			//view
			view = new MiddleLineView(curve, curveXMax, side);
		}
		
		public function hit(player: int, x: Number, t: int): void
		{
			state = ((player == 1) == side) ? 'inc' : 'dec';
			t0 = t;
			posStart = this.pos;
		}
		
		public function shiftTime(t: int): void
		{
			switch(state)
			{
				case 'inc':
					var posPossible:Number = (t - t0) * posVInc;
					if(posPossible < pos)
					{
						posV = 0;
					}
					else if(posPossible < 1)
					{
						pos = posPossible;
						posV = posVInc;
					}
					else
					{
						pos = 1;
						posV = 0;
					}
					break;
				case 'dec':
					pos = Math.max(0, posStart - (t - t0) * posVDec);
					posV = 0;
					break;
			}
			
			posX = Math.min(pos,0.7)*posXV0;
			posXV = (pos < 1) ? posXV0 : 0;
			//posW = Math.max(0, pos-0.3)/0.7;
			posW = Math.max(0, pos-0.3)/(1 - 0.3);
			if (pos > 0.7) posW+=(pos-0.7)*posXV0/curveXMax;
			posWV = 1;
			if (pos > 0.7) posWV+=posXV0/curveXMax;
			
			//view
			view.setPos(-sideSign*posX, -sideSign*posW);
		}
		
		public function xAndVByY(y: Number): Object
		{
			y = Math.min(Math.abs(y), curveYMax);
			for (var i = 1; i < curve.length; i++)
			{
				if (y <= curve[i][1])
				{
					var curveX:Number=
						curve[i-1][0]
						+
						(curve[i][0]-curve[i-1][0])
						*
						(
							(y-curve[i-1][1]) 
							/
							(curve[i][1]-curve[i-1][1])
						)
					;
					
					return  {
						x: posX + curveX * posW,
						v: posV * (posXV + curveX*posWV)
					};
				}
			}
			
			return { x:0, v:0 };
		}
		
		public function init()
		{
			state = 'dec';
			t0 = 0;
			pos = 0;
			posX = 0;
			posV = 0;
		}
	}

}