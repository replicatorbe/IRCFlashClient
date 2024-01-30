package modele
{
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.FlexGlobals;

	/**
	 * singleton
	 * */
	
	public class ConfigEnvironnement
	{
		
		private static var instance:ConfigEnvironnement = new ConfigEnvironnement();
		private var pseudo:String;
		private var pv:Boolean = false;
		private var asv:String;
		private var host:String = "espace-irc.org";
		private var port:int = 6667;
		private var webcam:Boolean=false;
		private var webcamString:String;
		private var notification:Boolean=true;
		private var repondeur:String;
		private var entresortie:Boolean=true;
		private var caminvisible:Boolean=false;
		private var rtmfpServer:String = 'rtmfp://stratus.adobe.com/cbd2224f9a56771b3d4d05c3-bd9b549abca2';
		private var serveurirc:String = "irc.espace-irc.org";
		
		//constructeur
		public function ConfigEnvironnement()
		{
			super();

		}
		
		public static function getInstance():ConfigEnvironnement
		{
			return instance;
		}

		public function setRepondeur(rep:String) :void
		{
			this.repondeur=rep;
		}
		
		public function getRepondeur():String
		{
			return this.repondeur;
		}
		
		public function getServeur():String
		{
			return this.serveurirc;
		}
		
		public function getServeurCam():String
		{
			return this.rtmfpServer;
		}
		
		public function setPseudo(pseudo:String) :void
		{
			this.pseudo=pseudo;
		}
		
		public function getPseudo():String
		{
			return this.pseudo;
		}
		
		public function setPv(pv:Boolean):void
		{
		this.pv=pv;	
		}
		
		public function getPv():Boolean {
			return pv;
		}
	
		public function setCamInvisible(cam:Boolean):void
		{
			this.caminvisible=cam;	
		}
		
		public function getCamInvisible():Boolean {
			return caminvisible;
		}
		
	
		public function setEntre(pv:Boolean):void
		{
			this.entresortie=pv;	
		}
		
		public function getEntre():Boolean {
			return entresortie;
		}
		
		
		public function setCam(pv:Boolean):void
		{
			this.webcam=pv;	
		}
		
		public function getCam():Boolean {
			return webcam;
		}
		
		public function setNotification(pv:Boolean):void
		{
			this.notification=pv;	
		}
		
		public function getNotification():Boolean {
			return notification;
		}
		
		
		public function setAsv(asv:String):void
		{
			this.asv=asv;
		}
		
		public function getAsv():String 
		{
			return this.asv;
		}
		
		public function setCamString(cam:String):void
		{
			this.webcamString=cam;
		}
		
		public function getCamString():String 
		{
			return this.webcamString;
		}
		
		public function setPort(port:int):void
		{
			this.port=port;
		}
		
		public function getPort():int 
		{
			return this.port;
		}
		
		public function setHost(host:String):void
		{
			this.host=host;
		}
		
		public function getHost():String 
		{
			return this.host;
		}
		
		
	}
}