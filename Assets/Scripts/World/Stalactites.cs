public class Stalactites : TPool 
{
    public override void Awake()
    {
        base.Awake();

        new Singleton<Stalactites>(this);
    }
}