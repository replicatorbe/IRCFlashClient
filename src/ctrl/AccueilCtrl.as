package ctrl
{
	import com.fnicollet.toaster.Toaster;
	import com.fnicollet.toaster.ToasterPosition;
	import com.fnicollet.toaster.message.avast.ToastMessageAvast;
	import com.fnicollet.toaster.message.gtalk.ToastMessageGTalk;
	import com.fnicollet.toaster.message.ubuntu.ToastMessageUbuntu;
	
	import connexion.ConnexionIRC;
	
	import ctrl.*;
	import ctrl.OuverturePV;
	import ctrl.SendMessageEvent;
	
	import flash.events.*;
	import flash.events.KeyboardEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.profiler.showRedrawRegions;
	import flash.text.TextFormat;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import flexlib.controls.SuperTabBar;
	import flexlib.controls.tabBarClasses.SuperTab;
	
	import modele.*;
	import modele.ConfigEnvironnement;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.controls.List;
	import mx.controls.TabBar;
	import mx.controls.TextInput;
	import mx.core.FlexGlobals;
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.events.ChildExistenceChangedEvent;
	import mx.events.CloseEvent;
	import mx.events.ColorPickerEvent;
	import mx.events.ListEvent;
	import mx.events.StyleEvent;
	import mx.managers.PopUpManager;
	import mx.managers.ToolTipManager;
	import mx.messaging.Channel;
	import mx.messaging.channels.SecureHTTPChannel;
	import mx.styles.StyleManager;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import spark.components.TitleWindow;
	
	import vue.*;
	import vue.lecteurvideo;
	import vue.listeuser;
	import vue.video;
	
	public class AccueilCtrl
	{
		
		private var protocole:ConnexionIRC;
		private var currentWindow:salon;
		private var messagesSend:Array;		
		private var historyIndex:int;
		private var idComplete:int;
		private var searchPattern:String;
		private var myCe:ConnectEvent;
		private var salons:ArrayCollection;
		private var users:ArrayCollection;
		private var asv:String;
		private var couleur:String = "\x0301";
		private var pseudoenattente:salon;
		private var toastMessagea:notificationcam
		public var popup:FenetreConnexion;
		private var connexionautomatique:String = FlexGlobals.topLevelApplication.parameters.connexionautomatique;
		
		[Bindable]
		public var view:accueil;
		
		
		[Embed(source="vue/assets/home.png")]
		private var infos_icon:Class;
		
		[Embed(source="vue/assets/information.gif")]
		private var home_icon:Class;
		
		[Embed(source="vue/assets/messages-icon.gif")]
		private var message_icon:Class;  
		
		/**
		 * controleur de la classe
		 * */
		
		public function AccueilCtrl(vue:accueil)
		{
			this.view=vue;	
		}
		
		/**
		 * permet de valider le changement de pseudo dans la case prévue à cet effet
		 * 
		 * */
		
		public function keyDownPseudo(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				changementNick(view.textpseudo.text);
			}	
		}
		
		/**
		 * evenement quand on change de couleur
		 * */
		
		public function onColorPick(event:ColorPickerEvent):void 
		{
			couleur = "\x03" + IRCColors.colors[event.currentTarget.selectedIndex].value;
			view.messageLine.setStyle('color',IRCColors.colors[event.currentTarget.selectedIndex].color);
			this.view.callLater(currentWindow.giveFocus);
		}
		
		
		/**
		 * fonction du clavier principale 
		 * */
		
		public function keyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.ENTER)
			{
				sendMessage(event)
			}
			
			if (event.keyCode == Keyboard.UP)
			{
				this.historyIndex++;
				if (this.historyIndex>10) this.historyIndex=10;
				view.messageLine.text = this.messagesSend[this.messagesSend.length-this.historyIndex];
			}
			
			if (event.keyCode == Keyboard.DOWN)
			{
				this.historyIndex--;
				if(this.historyIndex<1) this.historyIndex=1;
				view.messageLine.text = this.messagesSend[this.messagesSend.length-1-this.historyIndex];
			}
			
			
			if (event.keyCode == Keyboard.TAB)
			{
				if (searchPattern==null) 
					searchPattern = view.messageLine.text.substring(view.messageLine.text.lastIndexOf(" ")+1);
				currentWindow = view.tabs.selectedChild as salon;
				var nick:String = currentWindow.ctrle.completeNick(searchPattern,idComplete);
				view.messageLine.text = view.messageLine.text.substring(0,view.messageLine.text.lastIndexOf(" ")+1) + nick;
				idComplete++;
				view.callLater(currentWindow.giveFocus1);
			}
			
		}
		
		
		public function demarrage():void
		{
			
			//on créer une collection d'user
			users = new ArrayCollection();
			messagesSend = new Array();
			historyIndex=0;
			currentWindow = view.statusTab; 
			currentWindow.label="Status";
			currentWindow.chanId="Status";
			currentWindow.ctrle.noNickList();
			currentWindow.ctrle.noSalonList();
			currentWindow.ctrle.removeEnfant();
			//interdit de fermer la fenetre "Status"
			view.tabs.setClosePolicyForTab(0,SuperTab.CLOSE_NEVER);
			//on met l'icone dedans
			view.statusTab.icon = home_icon;
			
			//ecouteur défaut
			view.s1.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s2.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s3.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s4.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s5.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s6.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s7.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s8.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s9.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s10.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s11.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s12.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s13.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s14.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s15.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s16.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s17.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s18.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s19.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s20.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s21.addEventListener(MouseEvent.CLICK, clickSmile);
			view.s22.addEventListener(MouseEvent.CLICK, clickSmile);
			
			//bouton
			view.boutonoption.addEventListener(MouseEvent.CLICK,openOptions);
			
			//on ouvre popup
			if (connexionautomatique == "ok") {
				
				
				var asv:String = "" + FlexGlobals.topLevelApplication.parameters.age + " " + FlexGlobals.topLevelApplication.parameters.sexe + " " + FlexGlobals.topLevelApplication.parameters.ville + "";
				this.addEventListener(ConnectEvent.CONNECT_EVENT_TYPE, onConnectionAttempt); 
				var ce:ConnectEvent = new ConnectEvent(ConfigEnvironnement.getInstance().getServeur(),ConfigEnvironnement.getInstance().getPort(),StringUtil.trim(FlexGlobals.topLevelApplication.parameters.pseudo),"#accueil",asv);
				dispatchEvent(ce);
				
			} else {
				popup = FenetreConnexion(PopUpManager.createPopUp(view,FenetreConnexion,true));
				PopUpManager.centerPopUp(popup); 
				popup.addEventListener(ConnectEvent.CONNECT_EVENT_TYPE, onConnectionAttempt); 
				
			}
		}
		
		public function openOptions(e:Event):void
		{
			view.openOptions();
		}
		
		public function clickSmile(event:Event):String
		{	
			switch(event.currentTarget.name) {
				
				case "s1" :
					view.messageLine.text+=":(";
					break;
				case "s2" :
					view.messageLine.text+=":D";
					break;
				case "s3" :
					view.messageLine.text+=":O";
					break;
				case "s4" :
					view.messageLine.text+=":-(";
					break;
				case "s5" :
					view.messageLine.text+=":)";
					break;
				case "s6" :
					view.messageLine.text+=":x";
					break;
				case "s7" :
					view.messageLine.text+=":/";
					break;
				case "s8" :
					view.messageLine.text+="(v";
					break;
				case "s9" :
					view.messageLine.text+="(l";
					break;
				case "s10" :
					view.messageLine.text+="(c";
					break;
				case "s11" :
					view.messageLine.text+="(z";
					break;
				case "s12" :
					view.messageLine.text+="(2";
					break;
				case "s13" :
					view.messageLine.text+="(1";
					break;
				case "s14" :
					view.messageLine.text+="(3";
					break;
				case "s15" :
					view.messageLine.text+="(p";
					break;
				case "s16" :
					view.messageLine.text+="(f";
					break;
				case "s17" :
					view.messageLine.text+="(s";
					break;
				case "s18" :
					view.messageLine.text+="(4";
					break;
				case "s19" :
					view.messageLine.text+="(k";
					break;
				case "s20" :
					view.messageLine.text+="(b";
					break;
				case "s21" :
					view.messageLine.text+=":@";
					break;
				case "s22" :
					view.messageLine.text+="(y";
					break;
				default :
					return null;		
			}
			
			
			return null;
		}
		public function onConnectionAttempt(ce:ConnectEvent):void
		{
			myCe=ce;
			PopUpManager.removePopUp(popup);
			ConfigEnvironnement.getInstance().setPseudo(ce.Nickname);
			ConfigEnvironnement.getInstance().setAsv(ce.Asv);
			ConfigEnvironnement.getInstance().setPort(ce.Port);
			view.textpseudo.text = ce.Nickname;
			
			protocole = new ConnexionIRC();
			protocole.addEventListener(Event.CONNECT,onConnect);
			protocole.addEventListener(ProgressEvent.SOCKET_DATA,onSocketData);
			protocole.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
			protocole.addEventListener(RecvMessageEvent.RECV_MESS_EVENT_TYPE,onMessageRecv);
			//protocole.addEventListener(JoinEvent.JOIN_EVENT_TYPE, onJoin);
			//protocole.addEventListener(PartEvent.PART_EVENT_TYPE, onPart);
			protocole.addEventListener(ConnectedEvent.CONNECTED_EVENT_TYPE,onReady);
			this.addEventListener(SendMessageEvent.SEND_MESS_EVENT_TYPE, onMessageSend);
			view.addEventListener(OuverturePV.QUERY_EVENT_TYPE, onQuery);
			view.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,clickMenu);
			view.tabs.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,onCloseTab);
			protocole.addEventListener(Event.CLOSE, closeConnection);	
			view.textpseudo.addEventListener(KeyboardEvent.KEY_DOWN, keyDownPseudo);
			view.boutonconnecte.addEventListener(MouseEvent.CLICK, ouvertureUsers);
			view.boutonsalon.addEventListener(MouseEvent.CLICK, liste);
			view.boutonquitter.addEventListener(MouseEvent.CLICK, quit);
			view.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			view.envoyer.addEventListener(MouseEvent.CLICK, sendMessage);
			view.boutonaide.addEventListener(MouseEvent.CLICK, urlAide); 
			view.boutonquitter.label = "Quitter";
			view.color.addEventListener(ColorPickerEvent.CHANGE, onColorPick);
			//on entre les infos du colorpick
			view.color.dataProvider=IRCColors.colors;
		}
		
		private function clickMenu(me:ContextMenuEvent):void
		{
			
			var cmi:ContextMenuItem = me.target as ContextMenuItem;
			currentWindow = view.tabs.selectedChild as salon;
			
			/*		switch(cmi.caption) {
			case "OP" : protocole.WriteMessage(currentWindow.chanId, "/op " + currentWindow.nickList.selectedItem);
			break;
			case "DEOP" : protocole.WriteMessage(currentWindow.chanId,"/deop " + currentWindow.nickList.selectedItem);
			break;
			case "VOICE" : protocole.WriteMessage(currentWindow.chanId,"/voice " + currentWindow.nickList.selectedItem);
			break;
			case "DEVOICE" : protocole.WriteMessage(currentWindow.chanId,"/devoice " + currentWindow.nickList.selectedItem);
			break;
			}*/
		}
		
		private function urlAide(event:Event):void
		{
			var aide:URLRequest = new URLRequest("http://www.espace-irc.org");
			navigateToURL(aide);
		}
		
		private function closeConnection(event:Event):void
		{
			users.removeAll();
			//salons.removeAll();
			//	view.statusTab.nickList.
		}
		
		private function onConnect(event:Event):void
		{
			protocole.RegisterNick();
		}
		
		/**permet d'attendre avant de rejoindre
		 * tout les salons d'un coup
		 * cela permet d'eviter de partir en exces flood
		 * */
		
		private function onReady(event:Event):void
		{
			var myTimer:Timer = new Timer(100, 5);
			myTimer.start()
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		
		private function onTimerComplete(event:Event):void {
			protocole.join(myCe.Channel);
		}
		
		/**
		 * commande pour envoyer une déconnexion
		 * */
		
		private function quit(event:Event):void
		{
			if (protocole.connected) {
				
				protocole.WriteRawMessage("QUIT");
				view.boutonquitter.label = "Se connecter";
				view.openConnexion();
				
			} else {
				view.boutonquitter.label="Quitter";
			}
		}
		
		/**
		 * commande envoyé pour avoir les salons
		 * */
		
		public function liste(event:Event):void
		{
			protocole.WriteRawMessage("LIST");
		}
		
		/**
		 * commande pour un changement de nick
		 * */
		
		private function changementNick(nick:String):void
		{
			protocole.WriteRawMessage("NICK " + nick);
		}
		
		
		private function onIOError(event:IOErrorEvent):void
		{
			//		popup.connectButton.enabled=true;
		}
		
		
		private function onSocketData(pe:ProgressEvent):void
		{
			protocole.ReadMessage();
		}
		
		private function highlightTab(tab:salon):void {
			
			var myTabBt:Button;
			myTabBt = view.tabs.getTabAt(view.tabs.getChildIndex(tab)) as Button;
			myTabBt.setStyle("color","Red");
		}
		
		private function getTab(id:String):salon {
			
			for each (var myTab:salon in view.tabs.getChildren()) 
			{
				if (myTab.chanId == id) return myTab;
			}
			return null;
		}
		
		private function onCloseTab(te:ChildExistenceChangedEvent):void
		{
			var myTab:salon = te.relatedObject as salon;
			
			if (myTab != null && myTab.chanId.charAt(0) == "#") {
				this.protocole.WriteRawMessage("PART " + myTab.chanId);
			}
		}	
		
		/**
		 * créer un message privé
		 * */
		public function onQuery(qe:OuverturePV):Boolean
		{
			
			if (getTab(qe.Nick) == null) {
				
				var nouveauSalon:salon = new salon;
				nouveauSalon.setID(qe.Nick);
				view.tabs.addChild(nouveauSalon);
				//permet de selectionner le pv directement quand il souvre
				view.tabs.selectedChild = nouveauSalon;
				
				nouveauSalon.ctrle.noNickList();
				nouveauSalon.ctrle.setIrcp(this.protocole);
				nouveauSalon.icon = this.message_icon;
				nouveauSalon.ctrle.Topic="Nous vous conseillons de ne jamais communiquer à quiconque votre mot de passe, ni votre numéro de téléphone, ni votre adresse ni même vos noms et prénoms.";
				
				return true;
			}
			return false;
		}	
		
		public function onRecQuery(qe:OuverturePV):Boolean
		{
			
			if (getTab(qe.Nick) == null) {
				
				var nouveauSalon:salon = new salon;
				nouveauSalon.setID(qe.Nick);
				view.tabs.addChild(nouveauSalon);
				nouveauSalon.ctrle.noNickList();
				nouveauSalon.setIrcp(this.protocole);
				nouveauSalon.ctrle.setIrcp(this.protocole);
				nouveauSalon.icon = this.message_icon;
				nouveauSalon.ctrle.Topic="Nous vous conseillons de ne jamais communiquer à quiconque votre mot de passe, ni votre numéro de téléphone, ni votre adresse ni même vos noms et prénoms.";
				
				if (currentWindow != nouveauSalon) {
					highlightTab(nouveauSalon);
				}	
				
				return true;
			}
			return false;
		}	
		
		
		/**
		 * lors d'un clic sur "users" dans le menu
		 * */
		
		public function ouvertureUsers(pEvt:Event):void
		{			
			view.openPopupUsers();
			view.fBox2.addEventListener(CloseEvent.CLOSE,onClose);
			view.fBox2.addEventListener(OuverturePV.QUERY_EVENT_TYPE, onQuery);
			(view.fBox2 as listeuser).datasalon.dataProvider=users;	
		}
		
		public function onClose(e:CloseEvent):void {
			// L'evenement contient la reference du diffuseur (celui a l'origine de l'evenement)
			// dans ce cas notre fenetre.
			var dBox1:IFlexDisplayObject = e.target as IFlexDisplayObject;
			PopUpManager.removePopUp(dBox1);	
		}
		
		public function sendMessage(e:Event):void
		{
			historyIndex=0;
			messagesSend.push(view.messageLine.text);
			
			if (messagesSend.length>10) 
				messagesSend.pop();
			
			var me:SendMessageEvent = new SendMessageEvent(couleur + view.messageLine.text);
			view.messageLine.text = "";
			dispatchEvent(me)
		}
		
		public function send_Message(message:String):void
		{	
			this.protocole.WriteRawMessage(message);
		}
		
		
		private function onMessageSend(me:SendMessageEvent):void
		{
			currentWindow = view.tabs.selectedChild as salon;
			protocole.WriteMessage(currentWindow.chanId, me.text);
			
			if (me.text.charAt(0) != "/") {
				currentWindow.ctrle.write("<"+ ConfigEnvironnement.getInstance().getPseudo() +"> " + me.text);					
			}
				
			else if (me.text.substring(0,4) == "/me") {
				currentWindow.ctrle.write(ConfigEnvironnement.getInstance().getPseudo() + me.text.substring(3));					
			}
		}
		
		/**
		 * fonction de webcam
		 * 
		 * */
		
		private function alertClickHandler(event:MouseEvent):void{
			
			
			if (event.target.label == "Accepter") {
				protocole.WriteMessage(pseudoenattente.chanId,"/wok ");
				pseudoenattente.ctrle.setCamAttente(false);
				pseudoenattente.ctrle.setEnCam(true);
				toastMessagea.close();
			
				
			} else if (event.target.label == "Refuser") {
				
				protocole.WriteMessage(pseudoenattente.chanId,"/wno ");
				pseudoenattente.ctrle.setCamAttente(false);
				pseudoenattente.ctrle.setEnCam(false);
				toastMessagea.close();

				
				
			} else if  (event.target.label == "Ignorer"){
				protocole.WriteMessage(pseudoenattente.chanId,"/wno ");
				pseudoenattente.ctrle.setCamAttente(true);
				pseudoenattente.ctrle.setEnCam(false);
				toastMessagea.close();
			}
		}
		
		
		private function onMessageRecv2(me:RecvMessageEvent):void
		{
			var myTab:salon;
			var newChan:salon;
			var cmdi:int = parseInt(me.cmd);
			var firstmessage:Boolean;
			
			switch (me.cmd) {
				
				case "PRIVMSG" :
					
					//protocole maison
					if ((me.params[0] == ConfigEnvironnement.getInstance().getPseudo())) {
						
						if (me.params[1].toString().substr(0,3) == "\x01WC") {
							currentWindow.ctrle.write("\x03" + "06* "+ me.prefix + " " + me.params[1].substring(8,me.params[1].length-1)+"\x03");
							
							if (me.params[1].toString().substr(5,20) == "DOYOUHAVEWEBCAM") {
								
								//si j'ai une cam, je dis yes :D
								//sauf si je veux la rendre invisibile :D
								if (ConfigEnvironnement.getInstance().getCam()) {
									if (!ConfigEnvironnement.getInstance().getCamInvisible())
										protocole.WriteMessage(me.prefix,"/wyes ");
								}
								break;
							} 
							
						
							if (me.params[1].toString().substr(5,9) == "WEBCAMYES")  {
								//il ns faut stocker quelque part son peering
								
								myTab=getTab(me.prefix);
								myTab.boutoncampv.visible=true;
								break;
								//recoit la demande de cam
							} else if (me.params[1].toString().substr(5,12) == "IWANTYOURCAM") {
								
								//il ns faut stocker quelque part son peering
								if (getTab(me.prefix)!=null) {
									pseudoenattente = getTab(me.prefix);
									if ((ConfigEnvironnement.getInstance().getCam()) && (!pseudoenattente.ctrle.getEnCam()) && (!pseudoenattente.ctrle.getCamAttente())) {
									pseudoenattente.ctrle.setCamAttente(true);
									
									toastMessagea = new notificationcam; 
									toastMessagea.sampleCaption=  me.prefix + " demande accès à votre webcam";
									Toaster.toast(toastMessagea,ToasterPosition.BOTTOM_RIGHT);
									toastMessagea.accepter.addEventListener(MouseEvent.CLICK, alertClickHandler);
									toastMessagea.refuser.addEventListener(MouseEvent.CLICK, alertClickHandler);
									toastMessagea.ignorer.addEventListener(MouseEvent.CLICK, alertClickHandler);
									
									}}
								break;
								
								//on reçoit l'acceptation de la cam!
							}  else if (me.params[1].toString().substr(5,5) == "GOCAM") {
								myTab=getTab(me.prefix);
								
								if ((myTab!=null) && (!myTab.ctrle.getEnCam())) {
								//on vérifie si la personne est en stream
								
								///passer parametre a 11
								var peer:String=me.params[1].toString().substr(10);
								//retirer les espaces
								peer = StringUtil.trim(peer);
								view.openCameraUser();
								view.dBox2.addEventListener(CloseEvent.CLOSE,onClose);
								(view.dBox2 as lecteurvideo).demarrage(peer);
								myTab.ctrle.setEnCam(true);
								}
								break;
								
							}
							break;
						}
						
						//systeme anti pv
						if (!ConfigEnvironnement.getInstance().getPv()) {
							//permet d'envoyer le premier message 
							
							//permet l'ouverture d'un mp
							var oe:OuverturePV = new OuverturePV(me.prefix);						
							dispatchEvent(oe);
							firstmessage = onRecQuery(oe);
							
							myTab=getTab(me.prefix);
							
						}
						
					} else 
					{
						myTab=getTab(me.params[0]);
					}
					
					if (myTab != null) {
						//CTCP  action
						
						if (me.params[1].toString().substr(0,7) == "\x01ACTION") {
							myTab.ctrle.write("\x03" + "06* "+ me.prefix + " " + me.params[1].substring(8,me.params[1].length-1)+"\x03");		
						}
						else 
						{	
							
							if (firstmessage) { 	
								
								//on envoi le message du répondeur
								if (ConfigEnvironnement.getInstance().getRepondeur()!=null) {
									protocole.WriteMessage(me.prefix, ConfigEnvironnement.getInstance().getRepondeur());
									myTab.ctrle.writePV("<"+ me.prefix +"> " + ConfigEnvironnement.getInstance().getRepondeur());
								}
								
								if (ConfigEnvironnement.getInstance().getNotification()) {
									var toastMessage:ToastMessageGTalk = new ToastMessageGTalk;
									toastMessage.imageSource = "vue/assets/avatar1.png";
									toastMessage.sampleCaption = me.prefix + " envoie un nouveau message privé";
									Toaster.toast(toastMessage,ToasterPosition.BOTTOM_RIGHT);
									toastMessage.userName.text="Message privé de "+ me.prefix;
								}
							
									if (myTab.chanId.charAt(0) == "#") {
								
								myTab.ctrle.write("<"+ me.prefix +"> " + me.params[1]); 
									} else {
								myTab.ctrle.writePV("<"+ me.prefix +"> " + me.params[1]); 
									}
								
							}
							else
							{
								myTab.ctrle.write("<"+ me.prefix +"> " + me.params[1]); 
							}
							
							currentWindow = view.tabs.selectedChild as salon;
							
							if (currentWindow != myTab) {
								highlightTab(myTab);
							}	
						}			
					}
					
					break;
				case "NOTICE" :
					var srcTmp:String = (me.prefix != null) ? me.prefix : myCe.Host;
					if (ConfigEnvironnement.getInstance().getNotification()) {
						var toastMessage:ToastMessageGTalk = new ToastMessageGTalk;
						toastMessage.imageSource = "vue/assets/avatar1.png";
						toastMessage.sampleCaption = me.params[1];
						Toaster.toast(toastMessage,ToasterPosition.BOTTOM_RIGHT);
						toastMessage.userName.text="Message bref de "+srcTmp;
					}
					break;
				case "PING" :
					//statusTab.write("PING ?");
					break;
				case "PONG" :
					//statusTab.write("PONG !");
					break;
				case "JOIN" :
					
					//user qui rejoind la salle
					if (me.prefix != ConfigEnvironnement.getInstance().getPseudo()) {
						
						myTab=getTab(me.params[0]);
						
						if (myTab != null) {
							
							myTab.ctrle.addNick(me.prefix,asv);
							
							if (ConfigEnvironnement.getInstance().getEntre())
								myTab.ctrle.writeEvenement(me.prefix+ " a rejoint " + myTab.chanId);
						}
						
						send_Message("WHO " + me.prefix);
						
					} else {
						
						
						if (getTab(me.params[0]) == null) {
							
							newChan = new salon();
							newChan.setIrcp(protocole);
							newChan.setID(me.params[0]);
							
							view.tabs.icon = this.infos_icon;
							newChan.icon = this.infos_icon;
							
							view.tabs.addChild(newChan);
							view.tabs.selectedChild = newChan;
							
							
							/**
							 * Message d'accueil personnalisé lorsque le client
							 * rejoind un nouveau salon **/
							newChan.setFocus();
							newChan.ctrle.writeEvenement("Bienvenue sur " +  newChan.chanId);
							newChan.ctrle.noSalonList();
						}	
					}
					break;
				
				case "PART" :
					
					if (me.prefix != ConfigEnvironnement.getInstance().getPseudo()) {
						myTab= getTab(me.params[0]);
						
						if (myTab !=null) { 
							
							myTab.ctrle.removeNick(me.prefix);
							
							if (ConfigEnvironnement.getInstance().getEntre()) {
								if (me.params.length>1) {
									myTab.ctrle.writeEvenement(me.prefix+ " à quitté " + myTab.chanId + " (" + me.params[1] + ")");	
								}
								else myTab.ctrle.writeEvenement(me.prefix+ " à quitté " + myTab.chanId);	
							}
						}
					}
					else {
						myTab = getTab(me.params[0]);
						if(myTab != null) view.tabs.removeChild(myTab);
					}
					break;
				
				case "KICK" :
					if (me.params[1] != ConfigEnvironnement.getInstance().getPseudo()) {
						myTab= getTab(me.params[0]);
						//ce n'est pas le client qui se fait ejecté
						
						if (myTab!=null) { 
							myTab.ctrle.removeNick(me.params[1]);
							
							if (me.params.length>1) {
								myTab.ctrle.writeEvenement(me.params[1] + " a été éjecté par " + me.prefix + " (" + me.params[2] + ")");	
								
							}
							else myTab.ctrle.writeEvenement(me.params[1] + " a été éjecté par " + me.prefix);	
						}
						
					} else {
						//quand c le client lui même qui se fait ejecter
						myTab = getTab(me.params[0]);
						if (myTab != null) view.tabs.removeChild(myTab);
						if (me.params.length>1) {
							view.statusTab.ctrle.writeEvenement("Vous avez (" + me.params[1]+ ") été éjecté par " + me.prefix + " (" + me.params[2] + ")");	
						}
						else view.statusTab.ctrle.writeEvenement("Vous avez (" + me.params[1]+ ") été éjecté par " + me.prefix);	
					}
					break;
				
				case "MODE" :
					
					if (me.params.length>1) {
						myTab= getTab(me.params[0]);
						
						if (myTab !=null) {
							//myTab.write("* "+me.prefix+ " sets mode: " + me.params.slice(1).join(" "));
							myTab.ctrle.setMode(me.params[1], me.params.slice(2));
						}
					}
					break;
				
				case "QUIT" :
					
					if (me.prefix != ConfigEnvironnement.getInstance().getPseudo()) {
						for each (myTab in view.tabs.getChildren()) {
							if (myTab.ctrle.isPresent(me.prefix)) {
								myTab.ctrle.removeNick(me.prefix);
								
								if (me.params != null && me.params.length>0) {
									myTab.ctrle.writeEvenement(me.prefix+ " a quitté le chat (" + me.params[0] + ")");
								}
								else myTab.ctrle.writeEvenement(me.prefix+ " a quitté le chat");
							}
						}
					}
					break;
				
				case "NICK" :
					
					if (me.prefix == ConfigEnvironnement.getInstance().getPseudo()) {
						ConfigEnvironnement.getInstance().setPseudo(me.params[0]);
						view.textpseudo.text = me.params[0];
					}
					
					for each (myTab in view.tabs.getChildren()) {
					
					//Change le nom dans la nicklist
					if (myTab.ctrle.isPresent(me.prefix)) {
						myTab.ctrle.rename(me.prefix,me.params[0]);
						myTab.ctrle.writeEvenement(me.prefix+ " a changé de pseudo en " + me.params[0]);
					}
					
					//Change le nom des messages privés
					if (myTab.chanId == me.prefix) {
						myTab.chanId = me.params[0];
						myTab.label = me.params[0];
					}
				}
					break;
				case "TOPIC" :
					myTab= getTab(me.params[0]);
					if(myTab != null) {
						myTab.ctrle.writeEvenement("*" + me.prefix + " à change le sujet de la salle en '" +  me.params[1]+"'");
						myTab.ctrle.Topic = me.params[1];
						
						if (currentWindow==myTab)  myTab.ctrle.refreshTitle();
					}
					break;
				case "ERROR" :
					for each (myTab in view.tabs.getChildren()) {
					myTab.ctrle.writeEvenement(myCe.Host + " " + me.params[0]);
				}
					break;
				default :
					view.statusTab.ctrle.writeEvenement(me.prefix + " " + me.cmd + " " + me.params.join(" "));
			}
		}
		
		private function onMessageRecv(me:RecvMessageEvent):void
		{
			var myTab:salon;
			var newChan:salon;
			var cmdi:int = parseInt(me.cmd);
			
			if (cmdi > 0) {
				
				switch(cmdi) {
					
					case 001 :
						if (me.params[0] != ConfigEnvironnement.getInstance().getPseudo()) {
							ConfigEnvironnement.getInstance().setPseudo(me.params[0]);
						}
						break;
					case 002:
					break;
					case 003:
					break;
					case 004:
					break;
					case 005:
					break;
					case 251:
					send_Message("WHO *");
					break;
					case 252:
					break;
					case 253:
					break;
					case 254:
					break;
					case 255:
					break;
					case 265:
					break;
					case 266:
					break;
					case 376:
					break;
					//Liste des connectés
					//quand on rentre dans un salon
					case 353 :
					//statusTab.write(me.params[1] + " ASV " + me.params.toString());
					
					//salon existe-t-il aupres du client :)
					myTab=getTab(me.params[me.params.length-2]);
					
					//on recupére la liste des users
					users.removeAll();
					
					send_Message("WHO *");
					myTab=getTab(me.params[me.params.length-2]);
					
					if (myTab != null) {
						myTab.ctrle.populateNickList(me.params.pop());
					}
					
					break;
					case 352 :
					//statusTab.write(me.params[1] + " ASV " + me.params.toString());
					
					//		Alert.show(me.params[1]);
					//sa marche ici
					//asv:>Alert.show(me.params[7]);
					//nick de tout le monde	Alert.show(me.params[5]);
					myTab=getTab(me.params[1]);
					var temporaire:String =me.params[7];
					
					users.addItem({Pseudo:me.params[5], ASV:me.params[7]});
					
					//on met l'asv a jour
					if (myTab != null) {
						myTab.ctrle.setAsv(me.params[5],me.params[7]);
					}
					
					//salon existe-t-il aupres du client :)
					//myTab=getTab(me.params[me.params.length-2]);
					/*	var nicka:String;
					nicka=me.params.pop();
					var lasv:String;
					*/
					
					break;
					case 315 : // on reçoit la fin de la recherche des users		
					break;	
					//topic
					case 332 :
					myTab= getTab(me.params[1]);
					
					if (myTab != null) {
						myTab.ctrle.writeEvenement("Sujet est '" +  me.params[2]+"'");
						myTab.ctrle.Topic = me.params[2];
					}
					
					break;
					// time of topic 
					case 333: 
					myTab= getTab(me.params[1]);
					
					if (myTab != null) {
						nbSec = parseInt(me.params[3]);
						nbDate = new Date(nbSec*1000);
						myTab.ctrle.writeEvenement("Mis par " +  me.params[2] + " le " + nbDate.toLocaleString());
					}
					break;
					//Modes
					case 324 :
					myTab= getTab(me.params[1].split(" ")[0]);
					if (myTab != null) {
						myTab.ctrle.setModes(me.params[1].split(" ").slice(1).join(" "));
					}
					break;
					//Whois reply
					case 311 :
					//statusTab.write(me.params[1] + " est " + me.params.slice(2).join(" "));
					//		Alert.show(me.params[1]);
					//	Alert.show(me.params.slice(5).join(" "));	
					asv = me.params.slice(5).join(" ");
					//myTab=getTab(currentWindow);
					//Alert.show(myTab.toString());
					//myTab= currentWindow;
					//Alert.show(myTab.toString());
					//	if (myTab != null) myTab.setAsv(me.params[1],asv);
					//Alert.show("asv " + asv.toString());
					break;
					case 312 :
					//		statusTab.write(me.params[1] + " using " + me.params.slice(2).join(" "));		
					break;
					//idle
					case 317 :
					
					var nbSec:int = parseInt(me.params[2]);
					var nbDate:Date = new Date(nbSec*1000);
					var strDate:String = "";
					
					if (nbDate.date>1) strDate = (nbDate.date-1) + " day(s) ";
					if (nbDate.hours>1) strDate += nbDate.hours-1 + " hour(s) ";
					if (nbDate.minutes>1) strDate += nbDate.minutes-1 + " min(s) ";
					if (nbDate.seconds>1) strDate += nbDate.seconds-1 + " sec(s) ";
					
					nbSec = parseInt(me.params[3]);
					nbDate = new Date(nbSec*1000);
					view.statusTab.ctrle.writeEvenement(me.params[1] + " est inactif depuis " + strDate + " , signed on " + nbDate.toLocaleString());
					break;
					case 319 :
					view.statusTab.ctrle.writeEvenement(me.params[1] + " on " + me.params.slice(2).join(" "));		
					break;
					case 366: //end of names
					case 329: // creation time of channel
					break;
					case 321: // on reçoit le raw pour avertir qu'on va recevoir le salon
					salons = new ArrayCollection();
					break;
					case 322: // on reçoit la liste des salon
					var texte = IRCColors.htmlencode(me.params[3]);
					salons.addItem({Salon  :me.params[1], Sujet:texte.removeBalise(), Users   :me.params[2]});
					break;
					case 323 : // on reçoit la fin des listes sdes salons		
					view.openPopupSalons();
					view.dBox1.addEventListener(CloseEvent.CLOSE,onClose);
					(view.dBox1 as listesalon).ctrle.init(salons,protocole);	
					break;
					default :
					view.statusTab.ctrle.writeEvenement(me.params.slice(1).join(" "));		
				}
				
			} else {
				onMessageRecv2(me);	
			}
			
		}
		
		String.prototype.removeBalise = function() {
			
			var tab = this.split("");
			
			var taille = tab.length;
			
			var texte = tab.join("");
			
			texte = "";
			
			for (var i = 0; i<taille; i++) {
				
				if (tab[i] == "<") {
					
					var balise = this.substring(i, this.lastIndexOf(">", i)+1);
					
					if (balise.length>1) {
						
						texte += balise;
						
					}
					
				}
				
			}
			
			return texte;
			
		};

		
		
	}
}