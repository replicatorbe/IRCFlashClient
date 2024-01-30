
package modele
{
	/**
	 * permet de transformer les couleurs IRC 
	 * */
	
	public class IRCColors {
		
		static public function htmlencode(mess:String):String
		{
			//caractere speciaux
			mess=mess.replace(/&/g,"&amp;");
			mess=mess.replace(/"/g,"&quot;");
			mess=mess.replace(/</g,"&lt;");
			mess=mess.replace(/>/g,"&gt;");
			
			//couleur
			var re:RegExp;
			if (mess.indexOf("\x03") > -1) {
				re = new RegExp("\x03([0-9]{1,2})([,]([0-9]{1,2}))?([^\x03]*)([\x03]|$)","g");
				var temp:Array = re.exec(mess);
				
				do {
					mess = mess.replace(temp[0],IRCColors.colors1(temp));
					temp = re.exec(mess);
				} while(temp != null);
			}
			
			//gras
			if (mess.indexOf("\x02") > -1) {
				re = new RegExp("\x02([^\x02]*)\x02","g");
				mess = mess.replace(re,"<b>$1</b>");
			}			
			
			//souligne
			if (mess.indexOf("\x1F") > -1) {
				re = new RegExp("\x1F([^\x1F]*)\x1F","g");
				mess = mess.replace(re,"<u>$1</u>");
			}			
			
			return mess;
		}
		
		static public function colors1(masque:Array):String {
			
			var colors:Array = new Array('#FFFFFF', '#000000', '#000080', '#00AA00', '#FF0000', '#AA0000', '#AA00AA', '#FF8040', '#FFFF00', '#00FF00', '#008080', '#00FFFF', '#0000FF', '#FF00FF', '#808080','#C0C0C0'); 
			var i:int = parseInt(masque[1]);
			var	res:String= '<font color=\"' + IRCColors.colors2[i] + '\"';
			//	if (masque[2]) { res += ' background-color=\"' + colors[masque[3]] + '\"'; }
			res += '>' + masque[4] + '</font>';
			
			if (masque[5]) res += masque[5];
			return res;
		} 
		

		static public var colors:Array = [
			{label:"White (00)", color:'0xFFFFFF', value:"00"},
			{label:"Black (01)", color:'0x000000', value:"01"},
			{label:"Blue (02)", color:'0x000080', value:"02"},
			{label:"Green (03)", color:'0x00AA00', value:"03"},
			{label:"Red (04)", color:'0xFF0000', value:"04"},
			{label:"Brown (05)", color:'0xAA0000', value:"05"},
			{label:"Pruple (06)", color:'0xAA00AA', value:"06"},
			{label:"Orange (07)", color:'0xFF8040', value:"07"},
			{label:"Yellow (08)", color:'0xFFFF00', value:"08"},
			{label:"Lg Green (09)", color:'0x00FF00', value:"09"},
			{label:"Teal (10)", color:'0x008080', value:"10"},
			{label:"Lg Cyan (11)", color:'0x00FFFF', value:"11"},
			{label:"Lg Blue (12)", color:'0x0000FF', value:"12"},
			{label:"Pink (13)", color:'0xFF00FF', value:"13"},
			{label:"Grey (14)", color:'0x808080', value:"14"},
			{label:"Lg Grey (15)", color:'0xC0C0C0', value:"15"}]; 		
			
		static public var colors2:Array = [
			'#FFFFFF',
			'#000000',
			'#000080',
			'#00AA00',
			'#FF0000',
			'#AA0000',
			'#AA00AA',
			'#FF8040',
			'#FFFF00',
			'#00FF00',
			'#008080',
			'#00FFFF',
			'#0000FF',
			'#FF00FF',
			'#808080',
			'#C0C0C0']; 
	}
}