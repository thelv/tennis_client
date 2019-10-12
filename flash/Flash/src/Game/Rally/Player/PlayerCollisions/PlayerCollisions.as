package Game.Rally.Player.PlayerCollisions 
{
	
	import Game.Rally.Player.Player;
	
	public class PlayerCollisions 
	{
		
		private var player:Player;
		private var prevX:Number, prevY:Number, prevA:Number;
		
		public function PlayerCollisions(player: Player):void
		{
			this.player = player;
			init(0);
		}
		
		public function init(t:int):void
		{
			prevX = player.x;
			prevY = player.y;			
			prevA = player.a;
		}
		
		public function getParams(): Object
		{			
			var r:Object = {	
				xy: [player.x, player.y],
				prevXy: [prevX, prevY],
				//line: new Array(getLine(prevX, prevY, prevA), getLine(player.x, player.y, player.a)),
				dir: [Math.cos(player.a), Math.sin(player.a)],
				prevDir: [Math.cos(prevA), Math.sin(prevA)],
				v: new Array(player.vx, player.vy),
				length: player.length
			};
			return r;
		}
		
		private function getLine(x: Number, y: Number, a:Number): Array
		{
			return new Array
			(
				x - player.length * Math.cos(a)
				,y - player.length * Math.sin(a)
				,x + player.length * Math.cos(a)
				,y + player.length * Math.sin(a)
			);
		}
		
	}

}