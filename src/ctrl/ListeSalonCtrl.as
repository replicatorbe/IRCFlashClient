package ctrl
{
	import connexion.ConnexionIRC;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import vue.listesalon;
	import vue.salon;

	public class ListeSalonCtrl
	{
		private var view:listesalon;
		private var protocole:ConnexionIRC;
		
		public function ListeSalonCtrl(view:listesalon)
		{
			this.view=view;
			view.addEventListener(CloseEvent.CLOSE,close);
			view.datasalon.addEventListener(MouseEvent.DOUBLE_CLICK, onGridDoubleClick);
		}
		
		private function close(e:Event):void
		{
			PopUpManager.removePopUp(view);
		}
		
		public function init(salon:ArrayCollection, protocole:ConnexionIRC):void {
			this.view.datasalon.dataProvider=salon;
			this.protocole=protocole;
		}
		
		private function onGridDoubleClick(event:MouseEvent):void
		{
			this.protocole.WriteRawMessage("JOIN " + view.datasalon.selectedItem.Salon);
		} 
		
	}
}