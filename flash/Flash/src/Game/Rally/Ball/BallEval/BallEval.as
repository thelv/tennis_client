package Game.Rally.Ball.BallEval 
{
	
	import MathLib;
	import Game.Rally.Ball.Ball;
	
	public class BallEval 
	{
		private var ball: Ball;
		private var evalT: int, evalX: Number, evalY: Number, evalVx: Number, evalVy: Number, evalVa: Number, evalA: Number;
		private var rVaCoeff = 0.00133333333333, evalDt=3, stopAcceleration=0.00005;
		
		function BallEval(ball: Ball): void
		{
			this.ball = ball;
		}
		
		public function init(t: int):void		
		{
			evalT = t;
			evalX = ball.x;
			evalY = ball.y;
			evalVx = ball.vx;
			evalVy = ball.vy;
			evalA = ball.a;
			evalVa = ball.va;
		}
		
		public function eval(t: int): void
		{
			
			do
			{
				var actualT=Math.min(Math.max(t, this.evalT), this.evalT+this.evalDt);								
			
				if(actualT>this.evalT)
				{											
					var dt=actualT-this.evalT;																			
					
					var x = this.evalX + evalVx * dt;
					var y = this.evalY + evalVy * dt;
					
					var vL = MathLib.getLengthByCoords(evalVx, evalVy);
					var vA = MathLib.getAngleByCoords(evalVx, evalVy);
										
					if (vL != 0)
					{
						vA += evalVa * rVaCoeff * dt / vL;
						
						var vx = vL * Math.cos(vA);
						var vy = vL * Math.sin(vA);
					}
					else
					{
						var vx = evalVx;
						var vy = evalVy;
					}
										
					var a = evalA + evalVa * dt*0.2;
					
					var va = evalVa;
			
					if(actualT>=t)
					{
						ball.vx=vx;
						ball.vy=vy;
						ball.x=x;
						ball.y = y;
						ball.va = va;
						ball.a = a;						
						return;
					}
					else
					{
						evalVx=vx;
						evalVy=vy;
						evalX=x;
						evalY = y;
						evalA = a;
						evalVa = va;
						evalT += evalDt;						
					}
				}
				else
				{
					return;
				}
			}
			while(true);
		}
	}
	
}