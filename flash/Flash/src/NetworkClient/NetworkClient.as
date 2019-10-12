package NetworkClient 
{
	
	import Game.Game;
	import NetworkClient.Connection.Connection;
	import NetworkClient.Session.Session;
	import flash.external.ExternalInterface;
	import com.adobe.serialization.json.JSON;
	
	public class NetworkClient 
	{
		public var 
			connectionsCount: int,
			connections: Array,
			host: String,
			port: int;		
			
		private var
			session: Session,
			seriesSendedIds:Object = { g:0, pcp: 0, pcpa: 0, bh: 0 }, //"g==general"
			seriesReceivedIds:Object = { g:0, pcp: 0, pcpa: 0, bh: 0 },
			seriesConnectionNumbers:Object = { g:0, pcp: 0, pcpa: 0, bh: 0 };
		
		public function NetworkClient(host: String, port: int, connectionsCount: int)
		{
			this.host = host;
			this.port = port;
			this.connectionsCount = connectionsCount;
			this.connections = new Array(connectionsCount);
			for (var i:int = 0; i != connectionsCount; i++)
			{
				connections[i] = new Connection(this, i);
			}			
		}
		
		public function connectionsReady(success: Boolean): void
		{
			if (success)
			{
				session = new Session(this);
			}
			else
			{
				trace('error');
				Main.jsLog('error');
				ExternalInterface.call('networkClientReady', false)
			}
			
		}
		
		public function sessionReady(): void
		{			
			trace('session_ready!');
			Main.jsLog('session_ready!');
			ExternalInterface.call('networkClientReady', true);
		}
		
		public function messageSend(message: Object, sendType: Object = null): void
		{
			if (sendType == null) sendType = { firstConnection: 0, connectionsRange: 1, connectionsCount:1, seriesName: 'g' };
			
			for (var i:int = 0; i < sendType.connectionsCount; i++)
			{
				var connectionNumber:int =
				(
					seriesConnectionNumbers[sendType.seriesName] == sendType.connectionsRange-1
				)
				? 
					sendType.firstConnection + (seriesConnectionNumbers[sendType.seriesName] = 0)
				:
					sendType.firstConnection + (++seriesConnectionNumbers[sendType.seriesName])
				;
				
				message.s = { t: 's', s: sendType.seriesName, i: ++seriesSendedIds[sendType.seriesName] }; //xxx.service={send_type: 'series', series_name: xxx, message_id: xxx}
				trace('OUT (' + connectionNumber + ')' + JSON.encode(message));
				Main.jsLog('OUT (' + connectionNumber + ')' + JSON.encode(message));
				connections[connectionNumber].sendMessage(message);				
			}
		}
		
		public function messageReceive(message: Object, connectionNumber: int): void
		{
			trace('IN (' + connectionNumber + ')' + JSON.encode(message));
			Main.jsLog('IN (' + connectionNumber + ')' + JSON.encode(message));
			
			if (message.s)
			{
				if(seriesReceivedIds[message.s.s]>=message.s.i)
				{
					//ignore message
					trace('IGNORE SERIES MESSAGE');
				}
				else
				{					
					seriesReceivedIds[message.s.s] = message.s.i;
					if (message.g)
					{
						Main.game.messageReceive(message);
					}
					else
					{
						ExternalInterface.call('networkClientMessageReceive', message);
					}
				}
			}
			else
			{
				switch(message.mt)
				{
					case 'session_create':
					case 'session_enjoy':
						session.messageReceive(message);
						break;
					default:
						ExternalInterface.call('networkClientMessageReceive', message);
				}
			}
		}
		
	}

}