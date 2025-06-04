using Godot;
using System.Text.Json;
using System.Collections.Generic;
using System.Linq;

[GlobalClass]
public partial class KinectConnection : Node
{
	[Export]
	public Sprite2D Video;

	private WebSocketPeer bodyClient = new();
	private WebSocketPeer colorClient = new();

	public override void _Ready()
	{
		var urlBase = "ws://127.0.0.1:1337";
		bodyClient.ConnectToUrl($"{urlBase}/body");
		colorClient.ConnectToUrl($"{urlBase}/color");
	}

	public override void _Process(double delta)
	{
		List<byte[]> bodyPackets = ProcessPeer(bodyClient);
		if (bodyPackets.Any())
		{
			var serializedJson = bodyPackets[^1].GetStringFromUtf8();
			var json = JsonSerializer.Deserialize<Frame>(serializedJson);

			ProcessBodyFrame(json);
		}

		List<byte[]> colorPackets = ProcessPeer(colorClient);
		if (colorPackets.Any())
		{
			ProcessColorFrame(colorPackets[^1]);
		}
	}

	private static List<byte[]> ProcessPeer(WebSocketPeer peer)
	{
		peer.Poll();
		var packets = new List<byte[]>();

		if (peer.GetReadyState() == WebSocketPeer.State.Open)
		{
			while (peer.GetAvailablePacketCount() > 0)
			{
				packets.Add(peer.GetPacket());
			}
		}
		else if (peer.GetReadyState() == WebSocketPeer.State.Connecting)
		{
			GD.Print($"Connection to {peer.GetRequestedUrl()} opening");
		}
		else if (peer.GetReadyState() == WebSocketPeer.State.Closing)
		{
			GD.Print($"Connection to {peer.GetRequestedUrl()} closing");
		}
		else if (peer.GetReadyState() == WebSocketPeer.State.Closed)
		{
			GD.Print($"""Connection to {peer.GetRequestedUrl()} closed with code "{peer.GetCloseCode()}" and reason "{peer.GetCloseReason()}" """);
		}

		return packets;
	}

	public void ProcessColorFrame(byte[] data)
	{
		var image = new Image();
		image.LoadJpgFromBuffer(data);
		var texture = new ImageTexture();
		texture.SetImage(image);
		Video.Texture = texture;
	}

	public void ProcessBodyFrame(Frame frame)
	{
		IEnumerable<Joint> trackedHeads =
			from body in frame.bodies
			where body.tracked == true
			from joint in body.joints
			where joint.jointType == 3
			select joint;
	}
}
