using UnityEngine;

[CreateAssetMenu(menuName ="LevelChunkData")]
public class LevelChunkData : ScriptableObject
{
    public enum Direction
    {
        North,East,South,West
    }

    public Vector2 chunckSize = new Vector2(10f, 10f);

    public GameObject levelChunk;
    public Direction entryDirection;
    public Direction exitDirection;
}