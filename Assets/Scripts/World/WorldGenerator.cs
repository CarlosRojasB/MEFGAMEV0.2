using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class WorldGenerator : MonoBehaviour
{
    public LevelChunkData[] levelChunkdata;
    public LevelChunkData firstChunk;

    LevelChunkData previuosChunk;
    public Vector3 spawnOrigin;

    Vector3 spawnPosition;
    public int chunkToSpawn = 10;
    int Countchunkname = 0;

    float speed;

    void OnEnable()
    {
        ChunkExit.OnChunkExited += PickAndSpawnChunk;
    }

    private void OnDisable()
    {
        ChunkExit.OnChunkExited -= PickAndSpawnChunk;
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.T))
        {
            PickAndSpawnChunk();
            Countchunkname++;
        }
    }

    void Awake()
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
                allowedChunkList.Add(levelChunkdata[i]);

        }

        nextChunk = allowedChunkList[Random.Range(0, allowedChunkList.Count)];

        return nextChunk;
    }

    private void PickAndSpawnChunk()
    {
        Countchunkname++;

        LevelChunkData chunkToSpawn = PickNextChunk(); 
        
        GameObject objFromChunk = chunkToSpawn.levelChunks[Random.Range(0, chunkToSpawn.levelChunks.Length)];

        previuosChunk = chunkToSpawn;     
        
        Instantiate(objFromChunk, spawnPosition + spawnOrigin, Quaternion.identity, transform);
    }

    public void UpdateSpawnOrigin(Vector3 originDelta)
    {
        spawnOrigin = spawnOrigin + originDelta;
    }
}