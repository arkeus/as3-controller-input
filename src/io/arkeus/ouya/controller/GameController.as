package io.arkeus.ouya.controller {
	import flash.ui.GameInputDevice;

	/**
	 * A class abstracting away the input controls for a single controller.
	 */
	public class GameController {
		/** The underlying source game device. */
		public var device:GameInputDevice;
		/** A flag indicating if this controller was removed (no longer usable). */
		public var removed:Boolean = false;

		/** Creates a game controller and binds the controlers to the source device. */
		public function GameController(device:GameInputDevice) {
			this.device = device;
			bindControls();
		}

		/**
		 * Sets the enabled flag to true.
		 */
		public function enable():void {
			device.enabled = true;
		}

		/**
		 * Sets the enabled flag to false.
		 */
		public function disable():void {
			device.enabled = true;
		}

		/**
		 * Sets the controller as removed.
		 */
		public function remove():void {
			removed = true;
		}

		/**
		 * Resets all the inputs on the controller. Useful after a state change when you don't
		 * want the inputs to trigger in the new state.
		 */
		public function reset():void {
			throw new Error("You must implement reset in each GameController subclass");
		}

		/**
		 * Private method that is called on initialization. All control bindings should
		 * go in this method.
		 */
		protected function bindControls():void {
			throw new Error("You must implement bindControls in each GameController subclass");
		}
	}
}
