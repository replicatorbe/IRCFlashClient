package ctrl
{
	import connexion.ConnexionIRC;
	
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import modele.ConfigEnvironnement;
	import modele.IRCColors;
	import modele.IrcNick;
	import modele.webcam;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.containers.TabNavigator;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.core.mx_internal;
	import mx.events.ListEvent;
	
	import spark.components.List;
	
	import vue.accueil;
	import vue.salon;

	public class SalonCtrl
	{
		
		public var view:salon;
		public var chanId:String;
		public var smiles:XML;
		public var ircp:ConnexionIRC;
		public var nickRolled:IrcNick;
		private var topic:String;
		private var bTopicByOp:Boolean;
		private var bSecret:Boolean;
		private var bPrivate:Boolean;
		private var bNoExternalMess:Boolean;
		private var bInvite:Boolean;
		private var bModerated:Boolean;
		private var bLimited:Boolean;
		private var iLimit:int;
		private var bKey:Boolean;
		private var sKey:String;
		private var ircW:accueil;
		private var encam:Boolean = false;
		private var messagecam:Boolean = false;
		
		public function SalonCtrl(sal:salon, conn:ConnexionIRC, axx:accueil, id:String)
		{
			this.view=sal;
			this.ircp=conn;
			this.ircW=axx;
			this.chanId=id;
			view.label=id;
			demarrage();
			
		}
		
		public function demarrage():void
		{
	//	view.listewebcam.addEventListener(ListEvent.CHANGE, listCamera_change);
		view.boutonsortir.addEventListener(MouseEvent.CLICK, sortirChan);
		view.boutoncampv.addEventListener(MouseEvent.CLICK, demandeCam);
		view.nickList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, openPrivate);
		view.boutoncomportement.addEventListener(MouseEvent.CLICK, mauvaisComportement);
				
	
		
		smiles = <smiles>
						<smile file="angry.gif" code=":{" width="20" height="20" />
			
						<smile file="smile.gif" code=":)" width="20" height="20" />
						<smile file="smile.gif" code=":-)" width="20" height="20" />
						<smile file="biggrin.gif" code=":D" width="20" height="20" />
<smile file="biggrin.gif" code=":-D" width="20" height="20" />
						<smile file="ohmy.gif" code=":O" width="20" height="20" />
<smile file="ohmy.gif" code=":O)" width="20" height="20" />
						<smile file="angry.gif" code=":(" width="20" height="20" />
						<smile file="sad.gif" code=":-(" width="20" height="20" />
						<smile file="tongue.gif" code=":p" width="20" height="20" />
<smile file="tongue.gif" code=":-p" width="20" height="20" />
						<smile file="wink.gif" code=";)" width="20" height="20" />
<smile file="wink.gif" code=";-)" width="20" height="20" />
<smile file="enerver.gif" code=":@" width="20" height="20" />	
<smile file="3d.png" code="(c" width="20" height="20" />
<smile file="amour.png" code="(a" width="20" height="20" />
<smile file="rose1.gif" code="(r" width="20" height="20" />
<smile file="frite.gif" code="(f" width="20" height="20" />	
<smile file="cochon.gif" code="(s" width="20" height="20" />				
<smile file="yeah.png" code="(z" width="20" height="20" />
<smile file="coeurr.gif" code="(k" width="20" height="20" />
<smile file="pizza.gif" code="(p" width="20" height="20" />
<smile file="wink.gif" code=":/" width="20" height="20" />
<smile file="wink.gif" code=":-/" width="20" height="20" />
<smile file="cousu.gif" code="(b" width="20" height="20" />	
<smile file="tongue.gif" code=":x" width="20" height="20" />	
<smile file="tongue.gif" code=":-x" width="20" height="20" />	
<smile file="help.gif" code="(y" width="20" height="20" />	
			
<smile file="rose.gif" code="(l" width="20" height="20" />
<smile file="rose1.gif" code="(1" width="20" height="20" />
						<smile file="3d.png.gif" code="(z" width="20" height="20" />
			<smile file="vin.gif" code="(v" width="20" height="20" />
<smile file="amour.gif" code="(1" width="20" height="20" />
<smile file="amour.png" code="(2" width="20" height="20" />
<smile file="cafe.gif" code="(3" width="20" height="20" />
<smile file="coeurbrise.gif" code="(4" width="20" height="20" />
					</smiles>;
		
		
		initCamera();
		
		}
		
		public function setIrcp(myircp:ConnexionIRC):void
		{
			this.ircp = myircp;
		}
		
		public function getEnCam():Boolean
		{
			return this.encam;
		}
		
		public function setEnCam(cam:Boolean):void
		{
			this.encam=cam;
		}
		
		public function getCamAttente():Boolean
		{
			return this.messagecam;
		}
		
		public function setCamAttente(cam:Boolean):void
		{
			this.messagecam=cam;
		}
		
		public function completeNick(nic:String, idx:int = 0) : String {
			
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			var indx:int = 0;
			var res:String = nic;
			var nicktext:String;
			
			for each (var nick:IrcNick in nickListData) {
				nicktext = nick.Nick;
				
				if (nic.toLowerCase() == nicktext.substring(0,nic.length).toLowerCase()) {
					indx++;
					
					if (indx>idx) {
						return nicktext;
					}
					res = nicktext;
				}
			}
			return res;
		}
		
		/** titre du salon **/
		
		public function getTitle():String 
		{
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			
			return getStrModes() + getStrTopic();
		}
		
		private function getStrModes():String 
		{
			
			var res:String = "[+";
			if (bInvite) res += "i";
			if (bKey) res += "k";
			if (bLimited) res += "l";
			if (bModerated) res += "m";
			if (bNoExternalMess) res += "n";
			if (bPrivate) res += "p";
			if (bSecret) res += "s";
			if (bTopicByOp) res += "t";
			if (bLimited) res += " " + iLimit;
			res += "]";
			
			if (res == "[+]") res = "";
			return res;
		}
		
		private function getStrTopic():String 
		{
			
			if (topic != null && topic.length > 0) {
				return topic;
			}
			else return "";
		}
		
		/** rafraichir le titre **/
		
		public function refreshTitle():void 
		{
			if (ircW!=null) 
				ircW.texttopic.htmlText = IRCColors.htmlencode(getTitle());
		}
		
		/**
		 * on défini le sujet du salon ici
		 * */
		
		public function set Topic(value:String):void 
		{
			this.topic = value;
		}
		
		public function voice(nick:String):void 
		{
			var aNick:IrcNick = getNick(nick);
			aNick.Voiced=true;
		}	 
		
		public function devoice(nick:String):void 
		{
			var aNick:IrcNick = getNick(nick);
			aNick.Voiced=false;
		}	
		
		public function op(nick:String):void 
		{
			var aNick:IrcNick = getNick(nick);
			aNick.Oped=true;
		}	
		
		public function deop(nick:String):void
		{
			var aNick:IrcNick = getNick(nick);
			aNick.Oped=false;
		}	
		
		public function setModes(modes:String):void 
		{
			var i:int;
			var bModif:Boolean = true;
			var c:String;
			
			for (i = 0; i < modes.length && c != " "; i++){
				c = modes.charAt(i);
				
				switch(c) {
					case "+" : bModif=true;
						break;
					case "-" : bModif = false;
						break;
					case "t" : bTopicByOp = bModif;
						break;
					case "n" : bNoExternalMess = bModif;
						break;
					case "m" : bModerated = bModif;
						break;
					case "s" : bSecret = bModif;
						break;
					case "p" : bPrivate = bModif;
						break;
					case "i" : bInvite = bModif;
						break;
					case "k" : bKey = bModif;
						
						if (bKey==true) {
							sKey = modes.substr(i+1);
						}
						else {
							sKey="";
						}
					case "l" : bLimited = bModif;
						
						if (bLimited==true) {
							iLimit = parseInt(modes.substr(i+1));
						}
						else {
							iLimit=0;
						}
						break;
				}
			}
			
			if (ircW!=null) {					
				ircW.texttopic.text = getTitle();
			}
		}
		
		public function setMode(cmd:String, list:Array):void {
			var aNick:String;
			
			if (list == null || list.length == 0) {
				this.setModes(cmd);
				return;
			}
			
			switch(cmd.substr(0,2)) {
				case "+v" :
					for each (aNick in list) {
					voice(aNick);
				}
					break;
				case "-v":
					for each (aNick in list) {
					devoice(aNick);
				}
					break;
				case "+o" :
					for each (aNick in list) {
					op(aNick);
				}
					break;
				case "-o":
					for each (aNick in list) {
					deop(aNick);
				}
					break;
				default :
					this.setModes(cmd + list.join(" "));
					break;
			}
			
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			if (nickListData!=null)
				nickListData.refresh();
		}
		
		
		/** ecriture eventement **/
		public function writeEvenement(mess:String): void
		{
			var now:Date = new Date();
			var hours:String = now.hours > 9 ? now.hours.toString() : "0" + now.hours.toString();
			var minutes:String = now.minutes > 9 ? now.minutes.toString() : "0" + now.minutes.toString();
			var timeString:String = hours + ":" + minutes;
			var htmlText:String = "[" + timeString + "] " + " * " + IRCColors.htmlencode(mess) + "\n";
			
			htmlText = "<font color=\"#009300\">"+htmlText+"</font><br />";
			view.ircView.htmlText += htmlText;
			view.ircView.verticalScrollPosition = int.MAX_VALUE-2;
			view.callLater(setScrollPosition);	
			view.ircView.validateNow();
			view.ircView.height = view.ircView.textHeight + 10;
			
		//	view.chatCanvas.verticalScrollPosition = view.chatCanvas.maxVerticalScrollPosition;
		//	view.chatCanvas.validateNow();
		}
		
		public function writePV(mess:String): void
		{
			var now:Date = new Date();
			var hours:String = now.hours > 9 ? now.hours.toString() : "0" + now.hours.toString();
			var minutes:String = now.minutes > 9 ? now.minutes.toString() : "0" + now.minutes.toString();
			var timeString:String = hours + ":" + minutes;
			var htmlText:String = "[" + timeString + "] " + IRCColors.htmlencode(mess) + "\n";
			
			htmlText = htmlText + "<br />";
			view.ircView.htmlText += htmlText;
			view.ircView.verticalScrollPosition = int.MAX_VALUE-2;	
			view.ircView.validateNow();	
		}
		
		private function setScrollPosition():void 
		{
			view.ircView.verticalScrollPosition = view.ircView.maxVerticalScrollPosition;
		}
		
		/** bouton mauvais comportement **/
		
		private function mauvaisComportement(event:Event):void
		{
			ircp.WriteMessage(chanId,"/SOS ");
			Alert.show("Nous avons informé l'équipe d'un comportement indésirable sur " + chanId);
		}	
		
	
		
		/** permet de regler le bug des smileys **/
		
		public function smileyHandler(mess:String):void
		{
			var smileyIndex:int = -1;
			var searchIndex:int = -1;
			var testSearchIndex:int = -1;
			var testString:String;
			var searchString:String = mess;
			
			
			for (var x:int = 0; x < smiles.child("*").length(); x++)
			{	
				testString = smiles.smile[x].attribute("code").toString().replace(/(\)|\()/, "\\$&");
				searchIndex = searchString.search(testString);
				if (searchIndex >= 0)
				{
					
					if (testSearchIndex < 0)
					{
						
						testSearchIndex = searchIndex;
						smileyIndex = x;
					}
					else
					{
						
						if (testSearchIndex > searchIndex)
						{
							testSearchIndex = searchIndex;
							smileyIndex = x;
						}
					}
				}
			}
			searchIndex = testSearchIndex;
			var newText:String = "";
			var oldText:String = view.ircView.htmlText;
			
			if (searchIndex < 0)
			{
				newText = mess;
			}
			
			
			while (searchIndex >= 0)
			{
				
				var smileyReplaceString:String = '<FONT COLOR="#'
				smileyReplaceString += view.chatCanvas.getStyle("backgroundColor").toString(16);
				smileyReplaceString += '"> ';
				smileyReplaceString += smiles.smile[smileyIndex].attribute("code");
				smileyReplaceString += '  </FONT>';
				
				
				view.ircView.htmlText = oldText + newText + searchString.slice(0, searchIndex + 1);	
				view.ircView.validateNow();
				
				
				var numLines:int = view.ircView.mx_internal::getTextField().numLines;
				var smiley:Image = new Image();
				smiley.source = "vue/assets/" + smiles.smile[smileyIndex].attribute("file");
				smiley.x = view.ircView.getLineMetrics(numLines - 1).width+2;
				smiley.y = view.ircView.textHeight - view.ircView.getLineMetrics(numLines - 1).height;
				view.chatCanvas.addChild(smiley);
				
				newText += searchString.slice(0, searchIndex) + smileyReplaceString;
				var codeLength:int = smiles.smile[smileyIndex].attribute("code").toString().length;
				searchString = searchString.slice(searchIndex + codeLength);
				
				
				searchIndex = -1;
				testSearchIndex = -1;
				smileyIndex = -1;
				
				
				for (x = 0; x < smiles.child("*").length(); x++)
				{
					
					testString = smiles.smile[x].attribute("code").toString().replace(/(\)|\()/, "\\$&");
					searchIndex = searchString.search(testString);
					
					if (searchIndex >= 0)
					{
						if (testSearchIndex < 0)
						{				
							testSearchIndex = searchIndex;
							smileyIndex = x;
						}
						else
						{
							
							if (testSearchIndex > searchIndex)
							{
								testSearchIndex = searchIndex;
								smileyIndex = x;
							}
						}
					}
				}
				
				searchIndex = testSearchIndex;
				
				if (searchIndex < 0)
				{
					newText += searchString;
				}
			}
			
			view.ircView.htmlText = oldText + newText;
			view.ircView.validateNow();
			view.ircView.height = view.ircView.textHeight + 10;
			
			view.chatCanvas.validateNow();
			view.chatCanvas.verticalScrollPosition = view.chatCanvas.maxVerticalScrollPosition;
		}
		
		public function write(mess:String):void
		{
			var now:Date = new Date();
			var hours:String = now.hours > 9 ? now.hours.toString() : "0" + now.hours.toString();
			var minutes:String = now.minutes > 9 ? now.minutes.toString() : "0" + now.minutes.toString();
			var timeString:String = hours + ":" + minutes;
			var pseudo:String;
			
			var htmlText:String = IRCColors.htmlencode(mess) + "\n";
			
			//var htmlText:String = htmlencode(mess);
			var pattern:RegExp = /<(.+)>/i;
			
			//event
			if (htmlText.charAt(8) == "*") htmlText = "<font color=\"#009300\">"+htmlText+"</font><br />";
				//motd
			else if (htmlText.charAt(8) == "-") htmlText = "<font color=\"#7F0000\">"+htmlText+"</font><br />";
				
				//on discute dans un salon
			else if (chanId.charAt(0) == "#") {
				
				pseudo = mess.replace(pattern,"$1");
				var arrMesId:Array = new Array();
				arrMesId = pseudo.split(" ") ;
				
				//si c'est pas moi qui parle
				if (arrMesId[0]!=ConfigEnvironnement.getInstance().getPseudo()) {
					
					
					var nickparleur:IrcNick = getNick(arrMesId[0]);
					//faire un hl ici
					
					if (nickparleur!=null) {
						
						var couleur:String;
						
						if ((nickparleur.getSexe()=="h") || (nickparleur.getSexe()=="H") || (nickparleur.getSexe()=="m") || (nickparleur.getSexe()=="M")) {
							
							couleur="#4043A4"; } else if ((nickparleur.getSexe()=="f") || (nickparleur.getSexe()=="F")) {
								couleur="#DA1CA7";
							} else {
								couleur="#000";
							}
						
						//sexe de la personne, afficher une petite icone à coté de son nick!
						htmlText=htmlText.replace(arrMesId[0],"");
						htmlText = "[" + timeString + "] <font color=\""+couleur+"\">"+nickparleur.Nick+"</font> <font color=\"#7F0000\">"+htmlText+"</font><br />";
						
					} else {
						htmlText=htmlText.replace(arrMesId[0],"");
						htmlText = "[" + timeString + "] <font color=\"#7F0000\">"+arrMesId[0]+"</font> <font color=\"#7F0000\">"+htmlText+"</font><br />";
					}
				} else {
					htmlText = "[" + timeString + "] <font color=\"#7F0000\">"+htmlText+"</font><br />";
					
				}
			} 	else {
				//messge en pv brut
				htmlText = "[" + timeString + "] " + IRCColors.htmlencode(mess) + "\n";
			}
			
		
			view.ircView.verticalScrollPosition = int.MAX_VALUE-2;
			view.callLater(setScrollPosition);		
			view.ircView.validateNow();
			view.ircView.height = view.ircView.textHeight + 10;	
			smileyHandler(htmlText);
		}
		
		
		
		/**
		 * ICI ON TRIE LA LISTE DANS LE NICKLIST
		 * */
		
		public function populateNickList(list:String):void 
		{
			
			if (view.nickList.dataProvider == null) view.nickList.dataProvider = new ArrayCollection();
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			
			for each (var nick:String in list.split(" "))
			{
				nickListData.addItem(new IrcNick(nick));		
			}
			
			//On trie la liste
			if (nickListData != null) 
			{
				nickListData.sort = new Sort();
				//on trie ici
				nickListData.sort.compareFunction = IrcNick.sortNick;
				nickListData.refresh();
			}
			
			view.nickList.labelFunction = IrcNick.formatNick;
		}
		
		
		/**
		 * ouverture du pv
		 * */
		
		public function openPrivate(evt:ListEvent):void
		{
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			var nick:IrcNick = nickListData[evt.rowIndex];
			var oe:OuverturePV = new OuverturePV(nick.Nick);
			view.dispatchEvent(oe);
			ircp.WriteMessage(nick.Nick,"/wb ");
		}
		
		/**
		 * modification sur le nick
		 * */
		
		public function setAsv(nick:String, asv:String):void
		{
			if (getNick(nick) !=null) getNick(nick).setAsv(asv);
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			nickListData.refresh();
		}
		
		
		/**
		 * info sur le nick **/
		
		public function getNick(nick:String):IrcNick 
		{
			var newNick:IrcNick = new IrcNick(nick);
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			
			
			if (nickListData != null) {
				
				for each(var aNick:IrcNick in nickListData) {
					if (aNick.Nick == newNick.Nick) return aNick;
				}
			}
			
			return null;
		}
		
		
		public function removeAll():IrcNick 
		{
			
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			
			if (nickListData != null) {
				
				for each(var aNick:IrcNick in nickListData) {
				//	removeNick(aNick.Nick);
				}
			}
			
			
			return null;
		}
		
		/** 
		 * renommer nick
		 */
		
		public function rename(nick:String, newNick:String):void 
		{
			var aNick:IrcNick = getNick(nick);
			aNick.Nick = newNick;
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			
			nickListData.refresh();
		}	
		
		
		/**
		 * clic bouton "demande cam"
		 * */
		
		public function demandeCam(e:Event):void
		{
			ircp.WriteMessage(chanId,"/wd ");	
		}
		
		
		/**
		 * retirer nick
		 * */
		
		public function removeNick(nick:String):void
		{
			var aNick:IrcNick = getNick(nick); 
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			nickListData.removeItemAt(nickListData.getItemIndex(aNick));
			nickListData.refresh();
			view.accord.label = "Chatteurs (" + nickListData.length + ")";
			
		}	
		
		/** permet de supprimer la nicklist pour le pv **/
		
		public function noNickList():void 
		{
			
			view.acc.removeChild(view.accord);
			view.acc.removeChild(view.accordsalon);
			view.acc.removeChild(view.accordwebcam);
			
		}
		
		public function noSalonList():void
		{
			view.acc.removeChild(view.webcampv);
		}
		
		public function removeEnfant():void 
		{
			view.divbar.removeChild(view.acc);
		}
		
		
		/** verificatioon d'être present
		 * */
		
		public function isPresent(nick:String):Boolean 
		{
			var aNick:IrcNick = getNick(nick);
			return (aNick!=null);
		}	
		
		
		/**
		 * on ajoute le nick a la liste quand l'user rejoind la salle! */
		
		public function addNick(nick:String, asv:String):void 
		{
			
			if (isPresent(nick)) return;
			
			var newNick:IrcNick = new IrcNick(nick);
			var nickListData:ArrayCollection = view.nickList.dataProvider as ArrayCollection;
			
			if (nickListData != null) {
				
				nickListData.addItem(newNick);
				nickListData.refresh();
				
				view.accord.label = "Chatteurs (" + nickListData.length + ")";  
				
			}
		}
		
		
		public function initCamera():void 
		{
			if (Camera.names.length > 0) { 
				view.my_video_display.attachCamera(webcam.getInstance().getCamera());
			}
			
			/*	if (Microphone.names.length > 0) {
			mic = Microphone.getMicrophone();
			}*/
		}
	
		
		private function sortirChan(event:Event):void
		{
			ircp.WriteMessage(chanId,"/PART ");
		}
			
	
	}
	
	
}