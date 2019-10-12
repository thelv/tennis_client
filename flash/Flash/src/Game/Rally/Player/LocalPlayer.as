package Game.Rally.Player 
{
	
	import Game.Game;
	import Game.Rally.Player.KeyHandler.KeyHandler;
	
	public class LocalPlayer extends Player
	{
		//vars
			
			private var keyHandler: KeyHandler;
										
		//constructor
		
         	public function LocalPlayer(game: Game, side: Boolean): void
			{
				//logic				
				super(game, side);				
				keyHandler = 
				(
					side 
				)
				?
				(
					(
						game.type == 'local'
					)
					?					
						new KeyHandler(this, 75, 186, 76, 79, 39, 37)
					:
						//new KeyHandler(this, 65, 68, 83, 87, 39, 37)
						new KeyHandler(this, 68, 71, 70, 82, 39, 37)
				)	
				:
					new KeyHandler(this, 65, 68, 83, 87, 78, 86)
				;
			}				
			
		//logic						
			
			//вызывается из keyHandler
			public function afterKeyPressedChange(): void
			{				
				var movingX: Number=0;
				var movingY: Number=0;
				var movingA: Number=0;
				if(keyHandler.keyLeftPressed){movingX-=1;}
				if(keyHandler.keyRightPressed){movingX+=1;}
				if(keyHandler.keyDownPressed){movingY-=1;}
				if(keyHandler.keyUpPressed){movingY+=1;}
				if(keyHandler.keyTurnCounterClockWisePressed){movingA+=1;}
				if (keyHandler.keyTurnClockWisePressed) { movingA -= 1; }				
				if(Math.abs(this.movingX*this.movingY)==1)
				{									
					movingX = movingX / 1.414213;
					movingY = movingY / 1.414213;
				}	
				
				if (movingX != this.movingX || movingY != this.movingY || movingA != this.movingA)
				{
					var t: int = game.rally.time.get();					
					shiftTime(t);
												
					if(movingX!=this.movingX || movingY!=this.movingY)
					{														
						setControlPointXY(x, y, vx, vy, movingX, movingY, t);
						//this.sendMessage({message_type: 'control_point_xy', time: time, x: this.x, y: this.y, a: this.a, moving_x: this.movingX, moving_y: this.movingY, vx: this.controlPointVx, vy: this.controlPointVy, turning: this.turning}, this.sendTypeControlPoint);
					}					
					
					if (movingA != this.movingA)
					{
						setControlPointA(a, 0, movingA, t);
						//this.sendMessage({message_type: 'control_point_a', time: time, x: this.x, y: this.y, a: this.a, moving_x: this.movingX, moving_y: this.movingY, vx: this.controlPointVx, vy: this.controlPointVy, turning: this.turning}, this.sendTypeControlPoint);
					}
				}
			}
			
			private function messageSendControlPointXY(t: int): void
			{
				game.messageSend(
					{mt: 'pcp', t: t, x: this.x, y: this.y, mx: this.movingX, my: this.movingY, vx: this.vx, vy: this.vy}
					,{firstConnection: 1, connectionsRange: 4, connectionsCount: 2, seriesName: 'pcp'}
				);
				//"pcp"=="player_control_point"
			}
			
			private function messageSendControlPointA(t: int): void
			{
				game.messageSend(
					{mt: 'pcpa', t: t, a: this.a, ma: this.movingA}
					,{firstConnection: 1, connectionsRange: 4, connectionsCount: 2, seriesName: 'pcp'}
				);
				//"pcpa"=="player_control_point"				
			}		
			
			protected override function setControlPointXY(x:Number, y:Number, vx:Number, vy:Number, movingX:Number, movingY:Number, t: int): void
			{
				super.setControlPointXY(x, y, vx, vy, movingX, movingY, t);
				messageSendControlPointXY(t);
			}
			
			protected override function setControlPointA(a:Number, va:Number, movingA:Number, t: int): void
			{
				super.setControlPointA(a, va, movingA, t);
				messageSendControlPointA(t);
			}
			
	}

}