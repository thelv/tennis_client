package NetworkClient.Connection
{

	import flash.net.Socket;
	import flash.events.*;
	import flash.net.*;	
	import flash.utils.ByteArray;
	import NetworkClient.NetworkClient;
	import com.adobe.serialization.json.JSON;
	
	public class Connection 
	{
		
		private var networkClient: NetworkClient;
		public var socket:Socket;
		private var message:String='';
		private var number:int;
		static private var successConnectionCount:int = 0;
		
		public function Connection(networkClient: NetworkClient, number: int)
		{
			this.networkClient = networkClient;
			this.number = number;
			socket = new flash.net.Socket(networkClient.host, networkClient.port);
			socket.addEventListener(Event.CONNECT, connectHandler);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			socket.addEventListener(Event.CLOSE, closeHandler);
			socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			socket.connect(networkClient.host, networkClient.port);
		}
		
		private function connectHandler(event:Event):void 
		{    			
			if (++Connection.successConnectionCount == networkClient.connectionsCount)
			{
				networkClient.connectionsReady(true);				
			}
		}

		private function ioErrorHandler(event:IOErrorEvent):void 
		{
			networkClient.connectionsReady(false);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void 
		{
			networkClient.connectionsReady(false);
		}

		private function closeHandler(event:Event):void 
		{
			networkClient.connectionsReady(false);
		}
		
		private function socketDataHandler(event:ProgressEvent):void 
		{			
			message += socket.readUTFBytes(socket.bytesAvailable);
			var i = -1;
			if ((i = message.indexOf("\n")) != -1)
			{				
				networkClient.messageReceive(JSON.decode(message.substr(0, i)), this.number);
				message = message.substr(i + 1);
				if (message.length != 0)
				{
					socketDataHandler(null);
				}
			}
		}
		
		public function sendMessage(message:Object):void
		{							
			socket.writeUTFBytes(JSON.encode(message)+"\n");
			socket.flush();
		}
	}

}