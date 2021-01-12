using System.Collections.Generic;
using UnityEngine;

public class StalactitaGenerator : MonoBehaviour
{
    #pragma warning disable CS0649
    #pragma warning disable CS0414

    [SerializeField]
    Transform[] pointToSpawn;
    public static int level = 3;

    List<Stalactita> stalactites;
    public List<Stalactita> Pstalactitas
    {
        get { return stalactites; }
    }

    [SerializeField]
    Transform[] bigStalactites;

    #region Components
    [Header("Components")]
    [SerializeField]
    ChunkExit chunkExit;
    #endregion

    private void Awake()
    {
        stalactites = new List<Stalactita>();
    }

    private void Start()
    {
        SpawnStalcktitas();

        chunkExit.OnChunkLocalExited += () =>
        {
            for (int i = 0; i < stalactites.Count; i++)
                stalactites[i].gameObject.SetActive(false);
        };
    }

    private void SpawnStalcktitas()
    {
        List<Vector3> points = new List<Vector3>();

        foreach (Transform point in pointToSpawn)
            points.Add(point.position);

        for (int i = 0; i < pointToSpawn.Length - ((pointToSpawn.Length - level >= 0) ? (pointToSpawn.Length - level) : 0); i++)
        {
            GameObject stalactita = Stalactites.instance.GetPooleObject();

            if (stalactita != null)
            {
                int index = Random.Range(0, points.Count);

                Vector3 point = points[index];

                points.RemoveAt(index);

                stalactites.Add(stalactita.GetComponent<Stalactita>());

                stalactita.transform.position = point;

                stalactita.SetActive(true);
            }
            else
                Debug.Log("Estalactita no encontrada");
        }

        for (int i = 0; i < bigStalactites.Length; i++)
        {
            if (Random.Range(0, 2) == 1)
            {
                if (bigStalactites[i] != null)
                    bigStalactites[i].gameObject.SetActive(true);
            }
            else
            {
                if (bigStalactites[i] != null)
                    bigStalactites[i].gameObject.SetActive(false);
            }
        }
    }
}