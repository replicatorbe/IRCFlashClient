
package ctrl 
{
	
	import flash.events.Event;
	
	
	public class SendMessageEvent extends Event
	{
		public static const SEND_MESS_EVENT_TYPE:String = "SendMessageEvent";
		
		public var text:String;
		
		public function SendMessageEvent(text:String = "" )
		{
			super(SEND_MESS_EVENT_TYPE);
			this.text = text;
		}
		
	} 
}
