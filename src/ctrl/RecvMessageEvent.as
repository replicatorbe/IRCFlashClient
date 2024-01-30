
package ctrl 
{
	
	import flash.events.Event;
	
	public class RecvMessageEvent extends Event
	{
		
		public static const RECV_MESS_EVENT_TYPE:String = "RecvMessageEvent";
		public var prefix:String;
		public var cmd:String;		
		public var params:Array;	
		
		
		public function RecvMessageEvent(prefix:String = "",cmd:String = "",params:Array = null)
		{
			super(RECV_MESS_EVENT_TYPE);
			this.prefix = prefix;
			this.cmd = cmd;
			this.params = params;
		}
		
	} 
} 
