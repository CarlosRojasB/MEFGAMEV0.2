public class Stalactites : TPool 
{
    private void Awake()
    {
        new Singleton<Stalactites>(this);
    }
}