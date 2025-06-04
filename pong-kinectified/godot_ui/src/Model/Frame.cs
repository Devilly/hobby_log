using System.Collections.Generic;

public record Frame
{
	public IList<Body> bodies { get; init; }
}