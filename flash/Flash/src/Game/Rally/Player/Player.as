package Game.Rally.Player 
{
	
	import Game.Game;
	import Game.Rally.Player.PlayerEvalXY.PlayerEvalXY;
	import Game.Rally.Player.PlayerEvalA.PlayerEvalA;
	import Game.Rally.Player.PlayerCollisions.PlayerCollisions;
	
	public class Player	
	{
		//vars
		
			//view			
				public var view:PlayerView;
			
			//logic
				public var game:Game; //parent
				public var startX: int, startA: Number;
				public var holded: Boolean;
				public var collisions: PlayerCollisions;
				public var x: Number, y:Number, a: Number, vx: Number, vy: Number, va: Number; //position
				public var movingX: Number, movingY: Number, movingA: Number; //moving
				private var evalXY: PlayerEvalXY, evalA: PlayerEvalA;
				public var length: Number = 40;
				public var side: Boolean;
			
		//constructor		
		
			public function Player(game: Game, side: Boolean): void
			{																
				//logic
				this.game = game;	
				this.side = side;
				evalXY = new PlayerEvalXY(this);
				evalA = new PlayerEvalA(this);
				holded = true;
				startX = side ? 360: -360;
				startA = side? -Math.PI / 2 : Math.PI / 2;
				setControlPointXY(startX, 0, 0, 0, 0, 0, 0);
				setControlPointA(side ? -Math.PI/2 : Math.PI/2, 0, 0, 0);								
				collisions = new PlayerCollisions(this);

				//view					
				view = new PlayerView(this);
				viewShowPos();
			}
		
		//methods
		
			//view

				private function viewShowPos(): void
				{					
					view.showPosition(this.x, this.y, this.a);
				}																					
				
			//logic	
			
				public function hold(hold:Boolean, t:int): void
				{
					if (hold)
					{
						holded = true;
						setControlPointXY(startX, 0, 0, 0, movingX, movingY, t);
						setControlPointA(startA, 0, movingA, t);
						collisions.init(t);
					}
					else
					{
						holded = false;
					}
				}			
				
				protected function setControlPointXY(x:Number, y:Number, vx:Number, vy:Number, movingX:Number, movingY:Number, t: int): void
				{
					this.movingX=movingX;
					this.movingY=movingY;															
					this.x=x;
					this.y=y;
					this.vx=vx;
					this.vy=vy;
					evalXY.init(t);
				}
				
				protected function setControlPointA(a:Number, va:Number, movingA:Number, t: int): void
				{					
					this.movingA=movingA;
					this.a = a;					
					this.va = va;			
					evalA.init(t);
				}
				
				public function shiftTime(t: int): void
				{					
					evalXY.eval(t);
					evalA.eval(t);
					viewShowPos();
				}								
	}

}