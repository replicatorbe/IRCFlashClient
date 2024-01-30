
package ctrl 
{
	
	import flash.events.Event;
	
	public class ConnectEvent extends Event
	{
		
		public static const CONNECT_EVENT_TYPE:String = "connectEvent";
		
		private var mHost:String;
		private var mPort:Number;
		private var mNick:String;
		private var mChan:String;
		private var asv:String;
		
		public function ConnectEvent(host:String = "", port:int = 6667, nick:String = "chatteur", chan:String = "#Accueil", asv:String = "24 F Paris")
		{
			super(CONNECT_EVENT_TYPE);
			
			this.mHost = host;
			this.mPort = port;
			this.mNick = nick;
			this.mChan = chan;
			this.asv = asv;
		}
		
		public function get Host():String
		{
			return mHost;
		}
		
		public function get Nickname():String
		{
			return mNick;
		}
		
		public function get Port():int
		{
			return mPort;
		}
		
		public function get Channel():String
		{
			return mChan;
		}
		
		public function get Asv():String 
		{
			return asv;
		}
		
	} 
}