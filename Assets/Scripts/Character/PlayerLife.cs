using UnityEngine;

public class PlayerLife : MonoBehaviour
{
    #region Information
    [Header("Information")]
    [SerializeField] GameObject model;
    [SerializeField] AudioSource audDeath;
    public static System.Action staticDeath;
    #endregion

    #region Components
    MovementCharacter move;
    [Header("Components")]
    public ParticleSystem particleSystem;
    #endregion

    private void Awake()
    {
        move = GetComponent<MovementCharacter>();

        staticDeath = Death;
    }

    public void Death()
    {
        model.SetActive(false);

        particleSystem.gameObject.SetActive(true);

        audDeath.Play();
        particleSystem.Play();

        move.StopMove(() => 
        {
            Singleton<ManagerScene>.instance.GoToLose();
        });
    }
}