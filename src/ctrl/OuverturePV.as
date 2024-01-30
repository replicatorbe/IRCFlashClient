
package ctrl {
	
	import flash.events.Event;
	
	public class OuverturePV extends Event {
		
		public static const QUERY_EVENT_TYPE:String = "queryEvent";
		private var mNick:String;
		
		
		public function OuverturePV(nick:String = "") {
			super(QUERY_EVENT_TYPE,true);
			this.mNick = nick;
		}
		
		public function get Nick():String {
			return mNick;
		}
		
	} 
} 