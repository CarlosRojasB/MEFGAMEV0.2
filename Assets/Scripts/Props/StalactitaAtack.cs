using UnityEngine;

public class StalactitaAtack : MonoBehaviour
{
    PlayerLife _plLife;

    private void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Player")
        {
            _plLife = other.GetComponent<PlayerLife>();
            _plLife.PlLifes--;

           Singleton<ManagerScene>.instance.GoToLose();
        }
    }
}