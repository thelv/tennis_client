package Game.Rally.Player.PlayerEvalA 
{
	
	import Game.Rally.Player.Player;
	
	public class PlayerEvalA
	{
		private var player: Player;		
		private var controlPointTime: int, controlPointA: Number;
		private const velocity = 0.001;
		
		public function PlayerEvalA(player: Player): void
		{			
			this.player = player;
		}
		
		public function init(t: int):void		
		{
			controlPointA = player.a;
			controlPointTime = t;
		}
		
		public function eval(t: int): void
		{
			player.a = controlPointA - player.movingA * velocity * (t - controlPointTime);
		}
	}

}