package io.arkeus.ouya.controller {
	import flash.events.Event;
	import flash.ui.GameInputControl;
	import flash.ui.GameInputDevice;
	
	import io.arkeus.ouya.control.ButtonControl;
	import io.arkeus.ouya.control.DirectionalPadControl;
	import io.arkeus.ouya.control.JoystickControl;
	import io.arkeus.ouya.control.TriggerControl;

	public class OuyaController extends GameController {
		public var o:ButtonControl;
		public var u:ButtonControl;
		public var y:ButtonControl;
		public var a:ButtonControl;

		public var lb:ButtonControl;
		public var lt:TriggerControl;
		public var leftStick:JoystickControl;

		public var rb:ButtonControl;
		public var rt:TriggerControl;
		public var rightStick:JoystickControl;

		public var dpad:DirectionalPadControl;
		public var down:ButtonControl;
		public var left:ButtonControl;
		public var right:ButtonControl;

		public function OuyaController(device:GameInputDevice) {
			super(device);
		}

		override protected function bindControls():void {
			var controlMap:Object = {};
			for (var i:uint = 0; i < device.numControls; i++) {
				var control:GameInputControl = device.getControlAt(i);
				controlMap[control.id] = control;
			}

			if (controlMap['BUTTON_100'] != null) {
				// Bindings on Ouya
				o = new ButtonControl(this, controlMap['BUTTON_96']);
				u = new ButtonControl(this, controlMap['BUTTON_99']);
				y = new ButtonControl(this, controlMap['BUTTON_100']);
				a = new ButtonControl(this, controlMap['BUTTON_97']);

				lb = new ButtonControl(this, controlMap['BUTTON_102']);
				rb = new ButtonControl(this, controlMap['BUTTON_103']);
				lt = new TriggerControl(this, controlMap['BUTTON_104']);
				rt = new TriggerControl(this, controlMap['BUTTON_105']);

				leftStick = new JoystickControl(this, controlMap['AXIS_0'], controlMap['AXIS_1'], controlMap['BUTTON_106'], true);
				rightStick = new JoystickControl(this, controlMap['AXIS_11'], controlMap['AXIS_14'], controlMap['BUTTON_107'], true);

				dpad = new DirectionalPadControl(this, controlMap['BUTTON_19'], controlMap['BUTTON_20'], controlMap['BUTTON_21'], controlMap['BUTTON_22']);
			} else {
				// Bindings on PC
				o = new ButtonControl(this, controlMap['BUTTON_6']);
				u = new ButtonControl(this, controlMap['BUTTON_7']);
				y = new ButtonControl(this, controlMap['BUTTON_8']);
				a = new ButtonControl(this, controlMap['BUTTON_9']);

				lb = new ButtonControl(this, controlMap['BUTTON_10']);
				rb = new ButtonControl(this, controlMap['BUTTON_11']);
				lt = new TriggerControl(this, controlMap['BUTTON_18']);
				rt = new TriggerControl(this, controlMap['BUTTON_19']);

				leftStick = new JoystickControl(this, controlMap['AXIS_0'], controlMap['AXIS_1'], controlMap['BUTTON_12'], true);
				rightStick = new JoystickControl(this, controlMap['AXIS_3'], controlMap['AXIS_4'], controlMap['BUTTON_13'], true);

				dpad = new DirectionalPadControl(this, controlMap['BUTTON_14'], controlMap['BUTTON_15'], controlMap['BUTTON_16'], controlMap['BUTTON_17']);
			}
		}

		override public function reset():void {
			a.reset();
			o.reset();
			y.reset();
			a.reset();
			lb.reset();
			rb.reset();
			lt.reset();
			rt.reset();
			leftStick.reset();
			rightStick.reset();
			dpad.reset();
		}
	}
}
