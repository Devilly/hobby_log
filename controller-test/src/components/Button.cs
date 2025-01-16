using Godot;
using System;

public partial class Button : Node2D
{
	[Export]
	private string action;

	public override void _Process(double delta)
	{
		QueueRedraw();
	}

    public override void _Draw()
    {
		if(Input.IsActionPressed(action)) {
			DrawCircle(Vector2.Zero, 20, Colors.White);
		} else {
			DrawArc(Vector2.Zero, 20, 0, 2 * MathF.PI, 360, new Color(Colors.White) { A = .3f }, 2, true);
		}		
    }
}