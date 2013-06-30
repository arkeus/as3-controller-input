package io.arkeus.ouya.controller {
	import flash.ui.GameInputDevice;

	public class GameController {
		public var device:GameInputDevice;
		public var removed:Boolean = false;

		public function GameController(device:GameInputDevice) {
			this.device = device;
			bindControls();
		}

		public function enable():void {
			device.enabled = true;
		}

		public function disable():void {
			device.enabled = true;
		}

		public function remove():void {
			removed = true;
		}

		public function reset():void {
			throw new Error("You must implement error in each GameController subclass");
		}

		protected function bindControls():void {
			throw new Error("You must implement bindControls in each GameController subclass");
		}
	}
}
