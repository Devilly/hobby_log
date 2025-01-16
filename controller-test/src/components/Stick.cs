using Godot;
using System;

public partial class Stick : Node2D
{
	[Export]
	private string negativeX;

	[Export]
	private string positiveX;

	[Export]
	private string negativeY;

	[Export]
	private string positiveY;

	public override void _Process(double delta)
	{
		QueueRedraw();
	}

    public override void _Draw()
    {
		var inputVector = Input.GetVector(negativeX, positiveX, negativeY, positiveY);

        DrawArc(Vector2.Zero, 50, 0, 2 * MathF.PI, 360, new(1, 1, 1, .3f), 2, true);
		DrawCircle(inputVector * 20, 35, new Color(Colors.White) { A = .3f + inputVector.Length() * .7f });
    }
}