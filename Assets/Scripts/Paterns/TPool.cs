using System.Collections.Generic;
using UnityEngine;

public class TPool : MonoBehaviour
{
    public GameObject[] objectsToPool; 
    public int amountPool;

    List<GameObject> pooledObjects;

    public virtual void Awake()
    {
        pooledObjects = new List<GameObject>();

        GameObject obj;

        for (int i = 0; i < amountPool; i++)
        {
            obj = Instantiate(objectsToPool[Random.Range(0, objectsToPool.Length)], transform);
            obj.SetActive(false);
            pooledObjects.Add(obj);
        }
    }

    public GameObject GetPooleObject()
    {
        for (int i = 0; i < amountPool; i++)
        {
            if (!pooledObjects[i].activeSelf)
                return pooledObjects[i];
        }

        return null;
    }
}