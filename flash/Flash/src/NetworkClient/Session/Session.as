package NetworkClient.Session 
{
	
	import NetworkClient.NetworkClient;
	
	public class Session 
	{
		
		private var	
			networkClient: NetworkClient,
			sessionEnjoyCount:int = 0;
		
		public function Session(networkClient: NetworkClient)
		{
			this.networkClient = networkClient;
			networkClient.messageSend(
				{mt: 'session_create' },
				{firstConnection: 0, connectionsRange: 1, connectionsCount:1, seriesName: 'g' }
			);
		}
		
		public function messageReceive(message: Object): void
		{
			switch(message.mt)
			{
				case 'session_create':
					var sessionId: String = message.session_id;
					for (var i:int = 1; i < networkClient.connectionsCount; i++)
					{
						networkClient.messageSend(
							{mt: 'session_enjoy', session_id: sessionId, connection_number: i},
							{firstConnection: i, connectionsRange: 1, connectionsCount:1, seriesName: 'g'}
						);
					}
					break;
				case 'session_enjoy':
					if (++sessionEnjoyCount == networkClient.connectionsCount - 1)
					{
						networkClient.sessionReady();
					}
					break;				
			}
		}
		
		
	}

}