
package connexion
{
	import ctrl.*;
	
	import flash.display.JointStyle;
	import flash.errors.EOFError;
	import flash.events.*;
	import flash.net.Socket;
	import flash.utils.*;
	
	import modele.ConfigEnvironnement;
	
	import mx.controls.Alert;
	import mx.controls.Text;
	import mx.messaging.events.MessageEvent;
	import mx.utils.StringUtil;
	
	/**
	 * obliger d'utiliser Sockets et non XMLSocket pour IRC
	 * cf rapport "contrainte"
	 * */
	
	public class ConnexionIRC extends Socket
	{
		
		private var buffer:String;
		
		public function ConnexionIRC()
		{
			super(ConfigEnvironnement.getInstance().getHost(),ConfigEnvironnement.getInstance().getPort());
			buffer="";			
		}
		
		public function RegisterNick():void 
		{
			//writeUTFBytes("PASS toto \r\n");
			WriteRawMessage("NICK " + ConfigEnvironnement.getInstance().getPseudo());
			WriteRawMessage("USER " + ConfigEnvironnement.getInstance().getPseudo() + " host server :" + ConfigEnvironnement.getInstance().getAsv());
			flush();
		}
		
		
		public function ReadMessage():void 
		{
			try {
				buffer += readUTFBytes(bytesAvailable);
				var buferTmp:String = new String(buffer);
				var indx:int = buffer.lastIndexOf("\r\n");
				if(indx > -1) {
					buffer = buffer.substring(indx+2);
					for each(var mess:String in buferTmp.substring(0,indx).split("\r\n")) {
						decodeMessage(mess);
					}
				}
			}
			catch (e:EOFError)
			{			
			}	
		}
		
		private function decodeMessage(mess:String):void
		{
			mess = StringUtil.trim(mess);
			
			if(mess == "") return;
			
			/**
			 * permet de rester connecté sur le serveur
			 * voir documentation théorique
			 * */
			
			if(mess.substr(0,6) == "PING :") {
				WriteRawMessage("PONG " + mess.substr(6,mess.length-6));
			}
			
			
			if(mess.charAt(0) == ':') {
				var re1:RegExp = new RegExp("[ @!]");
				var prefix:String = mess.split(re1)[0].substring(1);
				mess = mess.substring(mess.indexOf(" ")+1);
			}
			
			
			var cmd:String;
			cmd = mess.split(" ",1)[0];
			mess = mess.substring(mess.indexOf(" ")+1);
			
			if (cmd == "004") dispatchEvent(new ConnectedEvent());
			
			var params:Array;
			if(mess.indexOf(":") > -1) {
				params = mess.split(":")[0].split(" ")
				if(params[params.length-1] == "")
					params[params.length-1] = mess.substring(mess.indexOf(":")+1);
				else params = params.concat(mess.substring(mess.indexOf(":")+1));
			}
			else {
				params = mess.split(" ");
			}
			var me:RecvMessageEvent = new RecvMessageEvent(prefix,cmd,params);
			dispatchEvent(me);	
		}
		
		/**
		 * envoie des événements IRC
		 * */
		
		
		public function WriteRawMessage(mess:String):void
		{
			writeUTFBytes(mess + "\r\n");
			flush();
		}
		
		
		public function WriteMessage(chanID:String, mess:String):void
		{
			var mess2Serv:String = "";
			mess = StringUtil.trim(mess);
			
			if(mess.charAt(0) == '/')
			{
				var tok:Array = mess.split(' ');
				var cmd:String = tok[0].toLowerCase();
				switch(cmd) {
					case "/j" :
					case "/join" :
						join(tok.slice(1).join(" "));
						return;	
					case "/part" :	
						mess2Serv = "PART " + chanID;
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/sos" :	
						mess2Serv = "PRIVMSG #staff Mauvais comportement sur" + chanID;
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/quit" :	
						mess2Serv = "QUIT ";
						mess2Serv += tok.slice(1).join(" ");
						break; 
					//protocole "maison" utilsant CTCP 
					//pour communication entre users to users
					//pour webcam et diverses options
					case "/wb" :	
						mess2Serv = "PRIVMSG " + chanID +" :\x01WC :DOYOUHAVEWEBCAM";
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/wyes" :	
						mess2Serv = "PRIVMSG " + chanID +" :\x01WC :WEBCAMYES " + ConfigEnvironnement.getInstance().getCamString();
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/wno" :	
						mess2Serv = "PRIVMSG " + chanID +" :\x01WC :WEBCAMNO";
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/wd" :	
						mess2Serv = "PRIVMSG " + chanID +" :\x01WC :IWANTYOURCAM";
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/wok" :	
						mess2Serv = "PRIVMSG " + chanID +" :\x01WC :GOCAM " + ConfigEnvironnement.getInstance().getCamString();
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/wno" :	
						mess2Serv = "PRIVMSG " + chanID +" :\x01WC :REFUSECAM ";
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/notice" :	
						mess2Serv = "NOTICE ";
						mess2Serv += tok.slice(1).join(" ");
						break;
					case "/me" :	
						mess2Serv = "PRIVMSG " + chanID + " :\x01ACTION";
						mess2Serv += mess.substring(cmd.length);
						mess2Serv += "\x01";
						break;
					case "/op" :	
						mess2Serv = "MODE " + chanID + " +o ";
						if(tok[1]) mess2Serv += tok[1];
						else return;
						break;
					case "/voice" :	
						mess2Serv = "MODE " + chanID + " +v ";
						if(tok[1]) mess2Serv += tok[1];
						else return;
						break;
					case "/deop" :	
						mess2Serv = "MODE " + chanID + " -o ";
						if(tok[1]) mess2Serv += tok[1];
						else return;
						break;
					case "/devoice" :	
						mess2Serv = "MODE " + chanID + " -v ";
						if(tok[1]) mess2Serv += tok[1];
						else return;
						break;
					default :
						WriteRawMessage(mess.substr(1));
						return;
						break;
				}
			}
			else mess2Serv += "PRIVMSG " + chanID + " :" + mess;
			writeUTFBytes(mess2Serv + "\r\n");			
			flush();
		}
		
		public function join(chanID:String):void {
			var temp:String = StringUtil.trim(chanID);
			
			if (temp.charAt(0) != "#") {
				temp = "#" + temp;
			}
			WriteRawMessage("JOIN " +	temp);
			WriteRawMessage("MODE " +	temp);
		}
	}
}
