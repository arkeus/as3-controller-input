package io.arkeus.ouya.control {
	import flash.events.Event;
	import flash.ui.GameInputControl;
	
	import io.arkeus.ouya.ControllerInput;
	import io.arkeus.ouya.controller.GameController;

	public class GameControl {
		private var device:GameController;
		private var control:GameInputControl;

		public var value:Number = 0;
		public var updatedAt:uint = 0;

		public function GameControl(device:GameController, control:GameInputControl) {
			this.device = device;
			this.control = control;

			if (control != null) {
				this.control.addEventListener(Event.CHANGE, onChange);
			}
		}

		public function reset():void {
			value = 0;
			updatedAt = 0;
		}

		protected function onChange(event:Event):void {
			value = (event.target as GameInputControl).value;
			updatedAt = ControllerInput.now;
		}
	}
}
