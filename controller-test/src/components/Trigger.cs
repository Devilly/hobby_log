using Godot;
using System;

public partial class Trigger : Node2D
{
	private int width = 40;
	private int height = 60;

	[Export]
	private string action;

	public override void _Process(double delta)
	{
		QueueRedraw();
	}

    public override void _Draw()
    {
		var strenght = Input.GetActionStrength(action);
		var actionableHeight = height * strenght;

		DrawRect(new(-width / 2, 0, width, height), new Color(Colors.White) { A = .3f + .7f * strenght }, false, 3);
		DrawRect(new(-width / 2, height - actionableHeight, width, actionableHeight), new Color(Colors.White) { A = .3f + .7f * strenght }, true);
    }
}