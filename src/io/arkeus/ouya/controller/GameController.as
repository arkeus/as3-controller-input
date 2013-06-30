package io.arkeus.ouya.controller {
	import flash.ui.GameInputDevice;

	public class GameController {
		protected var device:GameInputDevice;
		
		public function GameController(device:GameInputDevice) {
			this.device = device;
			//GameInputControlName.initialize(device);
			bindControls();
		}
		
		public function enable():void {
			device.enabled = true;
		}
		
		public function disable():void {
			device.enabled = true;
		}
		
		public function reset():void {
			throw new Error("You must implement error in each GameController subclass");
		}
		
		protected function bindControls():void {
			throw new Error("You must implement bindControls in each GameController subclass");
		}
	}
}
