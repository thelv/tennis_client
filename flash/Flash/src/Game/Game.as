package Game 
{
	
	import Game.Referee.Referee;
	import Game.Rally.Rally;
	import Game.Wait.Wait;
	import Game.Wait.NetworkWait;
	import Game.Rally.Player.RemotePlayer;

	public class Game 
	{

		public var 
			type: String,
			whoMain: Boolean,
			view: GameView, //view			
			rally: Rally,
			wait: Wait,
			referee:Referee;
		
		public function Game(type: String, whoMain: Boolean) 
		{
			//view
			this.type = type;
			this.whoMain = whoMain;
			view = new GameView();
			Main.stage.addChild(view);
			
			rally = new Rally(this);
			wait = (type=='local') ? new Wait(this) : new NetworkWait(this);
			referee = new Referee(this, whoMain);
			rally.time.synchronize(); 
			//referee.start() executes from string time.synchronize()
		}
		
		public function messageReceive(message: Object): void
		{
			switch(message.mt)
			{
				case 'pcp':
				case 'pcpa':
					(rally.player1 as RemotePlayer).messageReceive(message);
					break;
				case 'bh':
					rally.ball.messageReceive(message);
					break;
				case 'rw':
					rally.referee.messageReceive(message);
					break;
				case 'wr':
					(wait as NetworkWait).messageReceive(message);
					break;
				case 'ts':
					rally.time.messageReceive(message);
					break;
			}
		}
		
		public function messageSend(message: Object, sendType: Object=null): void
		{
			message.g = true;
			if (type == 'network')
			{
				Main.networkClient.messageSend(message, sendType);
			}
		}
	}

}