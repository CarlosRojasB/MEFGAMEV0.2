using System.Collections;
using UnityEngine;

public class ChunkExit : MonoBehaviour
{
    public delegate void ExitAction();
    public static event ExitAction OnChunkExited;

    private bool exited = false;

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.tag == "Player")
        {
            if (!exited)
            {
                exited = true;
                OnChunkExited();

                Destroy(transform.parent.gameObject);
            }
        }
    }
}