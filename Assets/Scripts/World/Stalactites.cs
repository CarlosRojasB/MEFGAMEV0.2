using UnityEngine;

public class Stalactites : TPool
{
    public static Stalactites instance;

    #region Components
    [Header("Components")]
    [SerializeField] public Transform player;
    [SerializeField] ParticlesManager particlesmanager;
    #endregion

    public override void Awake()
    {
        base.Awake();

        instance = this;

        for (int i = 0; i < transform.childCount; i++)
            transform.GetChild(i).gameObject.GetComponent<Stalactita>().particlesManager = particlesmanager;
    }
}