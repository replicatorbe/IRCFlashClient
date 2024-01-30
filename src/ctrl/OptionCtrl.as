package ctrl
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import modele.ConfigEnvironnement;
	
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import vue.option;

	public class OptionCtrl
	{
		private var view:option;
		
		/**
		 * constructeur
		 * */
		
		public function OptionCtrl(view:option)
		{
			this.view=view;
			view.addEventListener(CloseEvent.CLOSE,close);
			chargement();
		}
		
		/** au démarrage **/
		
		public function chargement():void {
			view.valider.addEventListener(MouseEvent.CLICK,appuyer);
			view.mp.selected=ConfigEnvironnement.getInstance().getPv();
			view.notification.selected=ConfigEnvironnement.getInstance().getNotification();
			view.salon.selected=ConfigEnvironnement.getInstance().getEntre();
			view.webcam.selected=ConfigEnvironnement.getInstance().getCamInvisible();
			view.repondeur.text=ConfigEnvironnement.getInstance().getRepondeur();
		}
		
		/**
		 * fermeture de la fenetre
		 * */
		
		public function close(e:Event):void
		{
			PopUpManager.removePopUp(view);
		}
		
		/**
		 * bouton 
		 * */
		
		public function appuyer(e:Event):void
		{
			ConfigEnvironnement.getInstance().setPv(view.mp.selected);
			ConfigEnvironnement.getInstance().setNotification(view.notification.selected);
			ConfigEnvironnement.getInstance().setRepondeur(view.repondeur.text);
			ConfigEnvironnement.getInstance().setEntre(view.salon.selected);
			ConfigEnvironnement.getInstance().setCamInvisible(view.webcam.selected);
			PopUpManager.removePopUp(view);
		}
		
		
	}
}