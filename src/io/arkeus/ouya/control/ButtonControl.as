package io.arkeus.ouya.control {
	import flash.events.Event;
	import flash.ui.GameInputControl;
	
	import io.arkeus.ouya.ControllerInput;
	import io.arkeus.ouya.controller.GameController;

	public class ButtonControl extends GameControl {
		private var changed:Boolean = false;
		private var minimum:Number;
		private var maximum:Number;
		
		public function ButtonControl(device:GameController, control:GameInputControl, minimum:Number = 0.5, maximum:Number = 1) {
			super(device, control);
			this.minimum = minimum;
			this.maximum = maximum;
		}
		
		public function get pressed():Boolean {
			return updatedAt >= ControllerInput.previous && value >= minimum && value <= maximum && changed;
		}
		
		public function get released():Boolean {
			return updatedAt >= ControllerInput.previous && (value < minimum || value > maximum) && changed;
		}
		
		public function get held():Boolean {
			return value >= minimum && value <= maximum;
		}
		
		override protected function onChange(event:Event):void {
			var beforeHeld:Boolean = held;
			super.onChange(event);
			changed = held != beforeHeld;
		}
	}
}
