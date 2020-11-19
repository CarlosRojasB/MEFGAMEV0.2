using UnityEngine;

public class StalactitaAtack : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.transform.parent.tag == "Player")
           Singleton<ManagerScene>.instance.GoToLose();
    }
}