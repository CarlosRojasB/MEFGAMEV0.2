using UnityEngine;

public class Stalactites : TPool
{
    #region Components
    [Header("Components")]
    [SerializeField] public Transform player;
    [SerializeField] ParticlesManager particlesmanager;
    #endregion

    public override void Awake()
    {
        base.Awake();

        new Singleton<Stalactites>(this);

        for (int i = 0; i < transform.childCount; i++)
            transform.GetChild(i).gameObject.GetComponent<Stalactita>().particlesManager = particlesmanager;
    }
}