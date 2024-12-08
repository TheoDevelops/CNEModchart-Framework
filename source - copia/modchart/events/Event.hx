package modchart.events;

import modchart.Manager;

class Event
{
    /**
     * The beat where the event will be executed
     */
	public var name:String;
    public var beat:Float;
    public var field:Int;

    public var callback:Event->Void;
	public var parent:EventManager;

	private var mercy:Bool = false;
    public var fired:Bool = false;

	public var active:Bool = false;


    public function new(beat:Float, callback:Event->Void, parent:EventManager, ?mercy:Bool = false)
    {
        this.beat = beat;
        this.callback = callback;
		this.mercy = mercy;

		this.parent = parent;
    }
    public function update(curBeat:Float)
    {
        if (curBeat >= beat) {
            callback(this);

            fired = !mercy;
        }
    }
	public function create() {}
	
    public function setModPercent(name, value, field)
    {
        Manager.instance.setPercent(name.toLowerCase(), value, field);
    }
	public function getModPercent(name, field):Float
	{
		return Manager?.instance?.getPercent(name, field) ?? 0;
	}
}