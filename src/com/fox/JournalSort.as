import com.GameInterface.DistributedValue;
import mx.utils.Delegate;
/**
 * ...
 * @author fox
 */
class com.fox.JournalSort {
	private var JournalWindow:DistributedValue;
	public static function main(swfRoot:MovieClip):Void {
		var s_app = new JournalSort(swfRoot);
		swfRoot.onLoad = function() {s_app.Load()};
		swfRoot.onUnload = function() {s_app.Unload()};
	}

	public function JournalSort() {
		JournalWindow = DistributedValue.Create("mission_journal_window");
	}

	public function Load() {
		JournalWindow.SignalChanged.Connect(Hook, this); 
		Hook(JournalWindow);
	}
	private function Hook(dv:DistributedValue){
		if (dv.GetValue() && !_global.com.fox.JournalHook){
			if (!_global.GUI.MissionJournal.JournalWindow.prototype.UpdateMissionDropdownBoxes){
				setTimeout(Delegate.create(this, Hook), 50,dv);
				return;
			}
			var f = function() {
				arguments.callee.base.apply(this, arguments);
				var selected = this.m_PlayfieldNames[this.m_PlayfieldIndexSelected];
				var first = this.m_PlayfieldNames.shift();
				this.m_PlayfieldNames.sortOn("name");
				this.m_PlayfieldNames.unshift(first);
				this.m_PlayfieldDropdown.dataProvider = this.m_PlayfieldNames;
				this.m_PlayfieldDropdown.rowCount = this.m_PlayfieldNames.length;
				for (var i = 0; i < this.m_PlayfieldNames; i++) {
					if ( this.m_PlayfieldName[i] == selected) this.m_PlayfieldDropdown.selectedIndex = i;
				}
				
			};
			f.base = _global.GUI.MissionJournal.JournalWindow.prototype.UpdateMissionDropdownBoxes;
			_global.GUI.MissionJournal.JournalWindow.prototype.UpdateMissionDropdownBoxes = f;
			_global.com.fox.JournalHook = true;
		}
	}

	public function Unload() {
		JournalWindow.SignalChanged.Disconnect(Hook, this); 
	}
}