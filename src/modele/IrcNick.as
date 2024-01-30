
package modele
{
	import mx.controls.Alert;

	public class IrcNick
	{
		
		private var mNick:String;
		private var mVoiced:Boolean;
		private var mOped:Boolean;
		private var mSa:Boolean;
		private var age:int;
		private var sexe:String = "";
		private var ville:String = "";
		
		
		public function IrcNick(nick:String) {
		
			this.mVoiced = false;
			this.mOped = false;
			this.mNick=nick;
			

			/*this.age=age;
			this.sexe=sexe;
			this.ville=ville;*/
			
			//voice
			if (nick.charAt(0) == "+") {
				mVoiced = true;
				mNick=nick.substr(1);				
			}
			
			//op
			if (nick.charAt(0) == "@") {
				mOped = true;
				mNick=nick.substr(1);
			}
			
			//sadmin
			if (nick.charAt(0) == "&") {
				mSa = true;
				mNick=nick.substr(1);
			}
			
			
		}
		
		public function get Nick():String {
			return mNick;
		}

		public function set Nick(value:String):void {
			mNick = value;
		}
		
		public function get Oped():Boolean {
			return mOped;
		}
		
		public function get Voiced():Boolean {
			return mVoiced;
		}
		
		public function get Sop():Boolean {
			return mSa;
		}
		
		public function set Oped(value:Boolean):void {
			this.mOped = value;
		}
		
		public function get Age():int {
			return age;
		}
		
		public function set Age(value:int):void {
			this.age = value;
		}
		
		public function get Ville():String {
			return ville;
		}
		
		public function getSexe():String {
	/*		if ((this.sexe=="h") || (this.sexe=="H") || (this.sexe=="m") || (this.sexe=="M")) {
				return true;
			}
			return false; */
			
			return this.sexe;
		}
		
		public function setAsv(asv:String):void 
		{
			
			var a:Array = asv.split(" ") 
				//asv doit etre de 3 pour être stocké
			if (a.length>3) {
				this.age=a[1];
				this.sexe=a[2];
				this.ville=a[3]
			}

		}
		
		public function setVille(value:String):void {
			this.ville = value;
		}
		
		
		public function set Voiced(value:Boolean):void {
			this.mVoiced = value;
		}
		
		public function set Sop(value:Boolean):void {
			this.mSa = value;
		}
		
		static public function sortNick(a:IrcNick, b:IrcNick, fields:Array=null):int {
		
			if (a.Oped && !b.Oped) return -1;
			if (b.Oped && !a.Oped) return 1;
			
			if (a.Voiced && !b.Voiced) return -1;
			if (b.Voiced && !a.Voiced) return 1;
			
			if (a.Nick.toLocaleLowerCase() < b.Nick.toLocaleLowerCase()) return -1;
			if (a.Nick.toLocaleLowerCase() > b.Nick.toLocaleLowerCase()) return 1;
			return 0
		}
		
		static public function formatNick(item:IrcNick):String {
			var res:String;
			//if (item.Oped) return "@" + item.Nick;
			if (item.Voiced) return "+" + item.Nick;
			if (item.Sop) return item.Nick;
			if (item.age<0) return item.Nick;
			if (item.sexe=="") return item.Nick;
			if (item.ville=="") return item.Nick;
			return item.Nick + " " + item.age + " " + item.sexe + " " + item.ville;
		}
		
	}
} 