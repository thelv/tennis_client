package Game.Rally.Player 
{
	
	import Game.Game;
	
	public class RemotePlayer extends Player 
	{
		
		public function RemotePlayer(game: Game, side: Boolean)
		{			
			super(game, side);
		}	

		public function messageReceive(message:Object): void
		{
			switch(message.mt)
			{
				case 'pcp':
					setControlPointXY(-message.x, -message.y, -message.vx, -message.vy, -message.mx, -message.my, message.t);
					break;
				case 'pcpa':
					setControlPointA(message.a+Math.PI, message.va, message.ma, message.t);
					break;
			}
		}
		
	}

}