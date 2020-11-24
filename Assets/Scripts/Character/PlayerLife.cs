using UnityEngine;

public class PlayerLife : MonoBehaviour
{
    #region Information
    [Header("Information")]
    [SerializeField] GameObject model;
    #endregion

    #region Components
    MovementCharacter move;
    [Header("Components")]
    public ParticleSystem particleSystem;
    #endregion

    private void Awake()
    {
        move = GetComponent<MovementCharacter>();
    }

    public void Death()
    {
        model.SetActive(false);

        particleSystem.gameObject.SetActive(true);

        particleSystem.Play();

        move.StopMove(() => 
        {
            Singleton<ManagerScene>.instance.GoToLose();
        });

    }
}