using UnityEngine;

public class Stalactites : TPool
{
    #region Components
    [Header("Components")]
    [SerializeField] public Transform player;
    #endregion

    public override void Awake()
    {
        base.Awake();

        new Singleton<Stalactites>(this);
    }
}