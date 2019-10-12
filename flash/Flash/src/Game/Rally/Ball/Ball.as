package Game.Rally.Ball 
{
	
	import Game.Game;
	import Game.Rally.Ball.BallEval.BallEval;
	import Game.Rally.Ball.BallCollisions.BallCollisions;
	
	public class Ball 
	{
		//vars
			
			private var game: Game;			
			private var eval: BallEval;	
			public var collisions: BallCollisions;
			public var x: Number, y: Number, vx: Number, vy: Number, va: Number, a: Number;
			public var r = 4;
			
			public var view: BallView; //view
				
		//constructor
		
			public function Ball(game: Game): void
			{
				this.game = game;
				
				this.eval = new BallEval(this);
				this.a = 0;
				this.setControlPoint(0, 0, 0, 0, 0, 0);				
				this.collisions = new BallCollisions(game, this);
				
				//view
				view = new BallView(this);
				viewShowPos();				
			}

		//view methods
		
			public function viewShowPos(): void
			{					
				view.showPosition(this.x, this.y, this.a);
			}	
			
		//logic methods
			
			public function setControlPoint(x: Number, y: Number, vx: Number, vy: Number, va: Number, t:int): void
			{
				this.x = x;
				this.y = y;
				this.vx = vx;
				this.vy = vy;
				this.va = va;
				eval.init(t);
			}
			
			public function shiftTime(t: int): void
			{								
				eval.eval(t);
				collisions.collise(t);
				viewShowPos(); //view
				
				//game.rally.middleLines.ballPos(x);
			}
			
			public function serve(start: Boolean, who: Boolean, t:int): void
			{								
				if (start)
				{
					setControlPoint(0, 0, 0.25 * (who ? 1: -1), 0, 0, t);
					collisions.init(t);
				}
				else
				{
					setControlPoint(0, 0, 0, 0, 0, game.rally.time.get());
					collisions.init(t);
				}
			}
			
			public function messageSendHit(t: int): void
			{					
				game.messageSend(
					{mt: 'bh', t: t, x: this.x, y: this.y, vx: this.vx, vy: this.vy, va: this.va}
					,{firstConnection: 9, connectionsRange: 3, connectionsCount: 2, seriesName: 'bh'}
				);
				//"bh" == "ball hit"
			}		
			
			public function messageReceive(message: Object):void
			{
				switch(message.mt)
				{
					case 'bh':
						setControlPoint( -message.x, -message.y, -message.vx, -message.vy, message.va, message.t);
						game.rally.middleLines.hit(1, -message.x, message.t);
						game.rally.referee.collision('player', 1);
						collisions.hitWas(1);
						shiftTime(game.rally.time.get());
						break;
				}
			}
	}

}