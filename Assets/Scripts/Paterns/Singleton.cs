
using UnityEngine;
public class Singleton<T>
{
	#region Fields
	public static T instance;
	#endregion

	public Singleton(T @class)
	{
		if (!(@class is MonoBehaviour))
		{
			if (instance == null)
				instance = @class;
		}
		else
		{
			if (instance == null)
			{
				instance = @class;

				Object.DontDestroyOnLoad((@class as MonoBehaviour).gameObject);
			}
			else
				Object.Destroy((@class as MonoBehaviour).gameObject);
		}
	}
}