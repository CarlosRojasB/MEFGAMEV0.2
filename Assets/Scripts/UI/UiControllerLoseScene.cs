using UnityEngine;
using TMPro;

public class UiControllerLoseScene : MonoBehaviour
{
    #pragma warning disable CS0649

    TextMeshProUGUI finalScoreTxt;
    private void Start()
    {
        GameObject score = GameObject.Find("Distance Score Txt");

        if (score != null)
            finalScoreTxt.text = score.GetComponent<TextMeshProUGUI>().text;
    }
}