using System.Collections.Generic;

public record Body
{
	public int bodyIndex { get; init; }
	public bool tracked { get; init; }
	public IList<Joint> joints { get; init; }
}