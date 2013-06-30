package io.arkeus.ouya.control {
	import flash.ui.GameInputControl;

	import io.arkeus.ouya.controller.GameController;

	public class TriggerControl extends ButtonControl {
		public function TriggerControl(device:GameController, control:GameInputControl) {
			super(device, control);
		}

		public function get distance():Number {
			return value;
		}
	}
}
