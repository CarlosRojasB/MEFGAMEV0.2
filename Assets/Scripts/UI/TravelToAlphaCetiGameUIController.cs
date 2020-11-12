using UnityEngine;
using TMPro;

public class TravelToAlphaCetiGameUIController : MonoBehaviour
{
    #pragma warning disable CS0649

    //Atributes for GameScene
    float counter;
    private float millesize = 1000;

    #region Score
    [Header("Score")]
    [SerializeField] TextMeshProUGUI distanceTxt;
    #endregion

    private void Update()
    {
        counter += Time.deltaTime;

        ActualizarScoreDistance();        
    }

    public void ActualizarScoreDistance()
    {
        distanceTxt.text = "Distance: " + counter.ToString("F1") + " Ft";

        if (counter >= millesize)
        {
            distanceTxt.text = "Distance" + (counter / millesize).ToString("F1") + "mille";
        }
    }
}