package modele
{
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	
	public class webcam {
	
		private var nc:NetConnection;
		private var sendNS:NetStream;
		private var cam:Camera;
		private var mic:Microphone;
		private static var instance:webcam = new webcam();
		
		public function webcam()
		{
			super();
		}
	
		public static function getInstance():webcam
		{
			return instance;
		}
		
		public function getCamera():Camera
		{
			return cam;
		}
		
		public function setCamera(camera:Camera):void
		{
			cam=camera;
			//apres avoir configuré la cam, on lance la demande de connexion
			initNetConnection();
		}
		
		
		private function initCamera():void {
			if (Camera.names.length > 0) { 
				cam = Camera.getCamera();
			}
			
			if (Microphone.names.length > 0) {
				mic = Microphone.getMicrophone();
			}
		}
		
		private function initNetConnection():void {
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusEvent);
			nc.connect(ConfigEnvironnement.getInstance().getServeurCam());
		}
		
		private function netStatusEvent(event:NetStatusEvent):void {

			if (event.info.code == 'NetConnection.Connect.Success') {
				ConfigEnvironnement.getInstance().setCamString(nc.nearID);
				ConfigEnvironnement.getInstance().setCam(true);
				initSendNetStream();
				//permet d'indiquer au client 
				//que la cam est actif
				ConfigEnvironnement.getInstance().setCam(true);
			}
		}
		
		private function initSendNetStream():void {
			sendNS = new NetStream(nc, NetStream.DIRECT_CONNECTIONS);
			sendNS.addEventListener(NetStatusEvent.NET_STATUS, netStatusEvent);
			
			var clientObject:Object = new Object();
			clientObject.onPeerConnect = function(ns:NetStream):Boolean {return true;}
			
			sendNS.client = clientObject;
			sendNS.attachCamera(cam);
			sendNS.attachAudio(mic);
			sendNS.publish('video');
		}
		
	
	}
}