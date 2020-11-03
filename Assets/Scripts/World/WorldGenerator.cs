using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading;
using UnityEngine;
using Random = UnityEngine.Random;

public class WorldGenerator : MonoBehaviour
{
    public LevelChunkData[] levelChunkdata;
    public LevelChunkData firstChunk;

    private LevelChunkData previuosChunk;
    public Vector3 spawnOrigin;

    private Vector3 spawnPosition;
    public int chunkToSpawn = 10;
    private int Countchunkname = 0;

     void OnEnable()
    {
        TriggerExit.OnChunkExited += PickAndSpawnChunk;
    }

    private void OnDisable()
    {
        TriggerExit.OnChunkExited -= PickAndSpawnChunk;
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            PickAndSpawnChunk();
            Countchunkname++;
        }
    }

    private void Start()
    {
        previuosChunk = firstChunk;
        for (int i = 0; i < chunkToSpawn; i++)
        {
            PickAndSpawnChunk();
            Countchunkname++;

        }
    }

 

    LevelChunkData PickNextChunk()
    {
        List<LevelChunkData> allowedChunkList = new List<LevelChunkData>();
        LevelChunkData nextChunk = null;

        LevelChunkData.Direction nextRequiereDirection = LevelChunkData.Direction.North;

        switch (previuosChunk.exitDirection)
        {
            case LevelChunkData.Direction.North:
                nextRequiereDirection = LevelChunkData.Direction.South;
                spawnPosition = spawnPosition + new Vector3(0f, 0, previuosChunk.chunckSize.y);
               

                break;
            case LevelChunkData.Direction.East:
                nextRequiereDirection = LevelChunkData.Direction.West;
                spawnPosition = spawnPosition + new Vector3(previuosChunk.chunckSize.x, 0,0);
               
                break;
            case LevelChunkData.Direction.South:
                nextRequiereDirection = LevelChunkData.Direction.North;
                spawnPosition = spawnPosition + new Vector3(0f, 0, -previuosChunk.chunckSize.y);
               
                break;
            case LevelChunkData.Direction.West:
                nextRequiereDirection = LevelChunkData.Direction.East;
                spawnPosition = spawnPosition + new Vector3(-previuosChunk.chunckSize.x, 0, 0);
                
                break;
            default:
                break;
        }

        for (int i = 0; i < levelChunkdata.Length; i++)
        {
            if (levelChunkdata[i].entryDirection == nextRequiereDirection)
            {
                allowedChunkList.Add(levelChunkdata[i]);
            }
        }
        nextChunk = allowedChunkList[Random.Range(0, allowedChunkList.Count)];

        return nextChunk;
       

    }

    private void PickAndSpawnChunk()
    {
        Countchunkname++;

        LevelChunkData chunkToSpawn = PickNextChunk();        
        GameObject objFromChunk = chunkToSpawn.levelChunks[Random.Range(0, chunkToSpawn.levelChunks.Length)];
        objFromChunk.name = "Path" + Countchunkname;
        previuosChunk = chunkToSpawn;        
        Instantiate(objFromChunk, spawnPosition + spawnOrigin, Quaternion.identity);

    }

    public void UpdateSpawnOrigin(Vector3 originDelta)
    {
        spawnOrigin = spawnOrigin + originDelta;
    }



}
