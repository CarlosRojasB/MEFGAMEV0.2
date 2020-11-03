using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPool : GeneralSingleton<ObjectPool>
{
    public List<GameObject> pooledObjects;
    public GameObject objectToPool;
    public int amountPool;

    protected override void Awake()
    {
        
    }

    private void Start()
    {
        pooledObjects = new List<GameObject>();
        GameObject tmp;
        for (int i = 0; i < amountPool; i++)
        {
            tmp = Instantiate(objectToPool);
            tmp.SetActive(false);
            pooledObjects.Add(tmp);
        }
    }

    public GameObject GetPooleObject()
    {
        for (int i = 0; i < amountPool; i++)
        {
            if (!pooledObjects[i].activeInHierarchy)
            {
                return pooledObjects[i];
            }
        }

        return null;
    }
}
