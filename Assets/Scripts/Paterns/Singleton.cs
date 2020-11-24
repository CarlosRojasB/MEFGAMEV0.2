public class Singleton<T>
{
	#region Fields
	/// <summary>
	/// The instance.
	/// </summary>
	public static T instance;
	#endregion

	/// <summary>
	/// Use this for initialization.
	/// </summary>
	public Singleton(T @class)
	{
		if (instance == null)
			instance = @class;
		
	}
}