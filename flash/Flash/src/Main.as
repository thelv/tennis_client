package 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.*;
	import flash.system.*;
	import flash.errors.*;
	import flash.external.ExternalInterface;
	import NetworkClient.NetworkClient;
	import Game.Game;
	
	[SWF(width="1200",height="700",backgroundColor="0x88dd88")]
	
	public class Main extends Sprite 
	{		
		static private var socketsCount: int = 12;
		private var sockets:Array;
		static private var successConnectionCount:int = 0;
		public static var networkClient: NetworkClient;
		public static var game: Game;
		public static var stage:Stage;
		
		public function Main():void
		{			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
					
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			/* entry point */		

			Main.stage = stage;
			ExternalInterface.addCallback('gameCreate', gameCreate);
			ExternalInterface.addCallback('messageSend', messageSend);
			Main.networkClient = new NetworkClient('tennis2.thelv.ru', 8080, 12);
			//Main.networkClient = new NetworkClient('localhost', 8080, 12);//*/
			//Main.networkClient = new NetworkClient('169.254.62.60', 8080, 12);
			
			//Main.game = new Game('local' , false);
		}
		
		public function messageSend(message: Object, sendType: Object=null): void
		{			
			networkClient.messageSend(message, sendType);
		}				
		
		public function gameCreate(type:String, whoMain:Boolean): void
		{
			Main.game = new Game(type, whoMain);
		}
		
		public static function jsLog(message: *): void
		{
			//ExternalInterface.call('consoleLog', message);
		}
	}
	
}