using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StalackticaGenerator : MonoBehaviour
{
    #pragma warning disable CS0649
    #pragma warning disable CS0414

    [SerializeField]
    float fireRate, startTime;
    [SerializeField]
    GameObject[] pointToSpawn;
    [SerializeField]
    int cantidadToSpawn;

    List<Vector3> pointToSpawnPosition;

    private int stalacticaCounter = 0;
    private bool endStalactita = false;

    //[SerializeField] ObjectPool objPool;

    int lastPos;

    private void Awake()
    {
        pointToSpawnPosition = new List<Vector3>();
        lastPos = 0;
        // objPool = GetComponent<ObjectPool>();
    }

    private void Start()
    {
        // Invoke("InitializeSpawns", startTime);
    }

    public bool ActivatorStalacktitas(bool _activator)
    {
        if (_activator == true)
        {
            Invoke("InitializeSpawns", startTime);
        }

        return false;

    }
    private void InitializeSpawns()
    {
        foreach (GameObject item in pointToSpawn)
        {
            pointToSpawnPosition.Add(item.transform.position);
        }
        StartCoroutine(LaunchStalactita(fireRate));
    }

    private IEnumerator LaunchStalactita(float fireRate)
    {
        int nextPointToSpawn = UnityEngine.Random.Range(0, pointToSpawnPosition.Count);
        if (lastPos == nextPointToSpawn)
        {
            //ChangeSpawnPos
            StartCoroutine(LaunchStalactita(fireRate));
            yield break;
        }
        else
        {
            //Normal Instanciate

            GameObject myStalactita = TPool.Instance.GetPooleObject();
            if (myStalactita != null && stalacticaCounter < cantidadToSpawn)
            {
                stalacticaCounter += 1;
                //Get spawnPos
                Vector3 stalctitaPos = pointToSpawnPosition[nextPointToSpawn];

                //Change stalactita position 
                myStalactita.transform.position = stalctitaPos;
                myStalactita.SetActive(true);

            }

            else
            {
                yield break;
            }
        }
        lastPos = nextPointToSpawn;
        yield return new WaitForSeconds(fireRate);
        StartCoroutine(LaunchStalactita(fireRate));
    }
}