using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Random = UnityEngine.Random;

public class WorldGenerator : MonoBehaviour
{
    public LevelChunkData firstChunk;
    LevelChunkData previuosChunk;
    public LevelChunkData[] levelChunkdata;

    public int chunkToSpawn = 8;
    Vector3 spawnPosition;

    float linearChunkPercentage = 70;

    void OnEnable()
    {
        ChunkExit.OnChunkExited += PickAndSpawnChunk;
    }

    private void OnDisable()
    {
        ChunkExit.OnChunkExited -= PickAndSpawnChunk;
    }

    void Awake()
    {
        previuosChunk = firstChunk;

        for (int i = 0; i < chunkToSpawn; i++)
            PickAndSpawnChunk();
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

        bool souhtNorthChucnk = false;

        for (int i = 0; i < allowedChunkList.Count; i++)
        {
            if (allowedChunkList[i].entryDirection == LevelChunkData.Direction.South
                &&
                allowedChunkList[i].exitDirection == LevelChunkData.Direction.North)
            {
                if (Random.Range(0, 101) <= linearChunkPercentage)
                {
                    linearChunkPercentage -= (70f / 3f);

                    nextChunk = allowedChunkList[i];

                    souhtNorthChucnk = true;

                    break;
                }
            }
        }

        if (!souhtNorthChucnk)
        {
            linearChunkPercentage = 70;

            nextChunk = allowedChunkList[Random.Range(0, allowedChunkList.Count)];
        }
        return nextChunk;
    }

    private void PickAndSpawnChunk()
    {
        LevelChunkData chunkToSpawn = PickNextChunk();

        GameObject NextChunk = chunkToSpawn.levelChunk;

        previuosChunk = chunkToSpawn;     
        
        Instantiate(NextChunk, spawnPosition, Quaternion.identity, transform);
    }
}