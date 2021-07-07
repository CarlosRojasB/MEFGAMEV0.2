using System.Collections;
using System.IO;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;

public class ConfigurationAndroid : MonoBehaviour
{

#if UNITY_ANDROID
    [SerializeField] TextMeshProUGUI myText;

    private string nextScene = "QRScaner";

    private bool obbisok = false;

    private bool loading = false;

    private bool replacefiles = false; //true if you wish to over copy each time

    private string[] paths =
    {
    "Vuforia/Polygonus-MEF.dat",

    "Vuforia/Polygonus-MEF.xml",
    };
    void Update()
    {
        if (Application.platform == RuntimePlatform.Android)
        {
            if (Application.dataPath.Contains(".obb") && !obbisok)
            {
                StartCoroutine(CheckSetUp());

                obbisok = true;
            }
        }
        else
        {
            if (!loading)
            {
                StartApp();
            }
        }
    }


    public void StartApp()
    {
        loading = true;

        Singleton<ManagerScene>.instance.GoToAr();
    }

    public IEnumerator CheckSetUp()
    {
        //Check and install!
        for (int i = 0; i < paths.Length; ++i)
        {
            yield return StartCoroutine(PullStreamingAssetFromObb(paths[i]));
        }

        //yield return new WaitForSeconds(3f);

        StartApp();
    }

    //Alternatively with movie files these could be extracted on demand and destroyed or written over
    //saving device storage space, but creating a small wait time.
    public IEnumerator PullStreamingAssetFromObb(string sapath)
    {
        if (!File.Exists(Application.persistentDataPath + "/" + sapath) || replacefiles)
        {
            UnityWebRequest unpackerWWW = new UnityWebRequest(Application.streamingAssetsPath + "/" + sapath);

            unpackerWWW.method = "GET";
            unpackerWWW.downloadHandler = new DownloadHandlerBuffer();


            yield return unpackerWWW.SendWebRequest();

            if (unpackerWWW.isNetworkError)
            {
                Debug.Log("Error unpacking:" + unpackerWWW.error + " path: " + unpackerWWW.url);

                yield break; //skip it
            }
            else
            {
                string path = Application.persistentDataPath + "/" + sapath;

                Debug.Log("Extracting " + sapath + " to Persistant Data");

                byte[] data = (((DownloadHandlerBuffer)unpackerWWW.downloadHandler).data);

                string downloadedData = string.Join(",", data.Select(x => x.ToString()));

                Debug.Log($"Downloaded data: {downloadedData}");

                string directory = Path.GetDirectoryName(path);

                if (!Directory.Exists(directory))
                {
                    Directory.CreateDirectory(directory);
                }

                if (!File.Exists(path))
                {
                    using (var file = File.Create(path, data.Length))
                    {
                        file.Write(data, 0, data.Length);
                    }
                }                
                //could add to some kind of uninstall list?
            }
        }
        yield return 0;
    }
    //private void Start()
    //{
    //    PassTheScene();
    //}
    //void CheckFilesAndroid()
    //{
    //    //AndroidJavaClass up = new AndroidJavaClass("com.unity3d.player.UnityPlayer");

    //    //var ca = up.GetStatic<AndroidJavaObject>("currentActivity");

    //    //AndroidJavaObject packageManager = ca.Call<AndroidJavaObject>("getPackageManager");

    //    //var pInfo = packageManager.Call<AndroidJavaObject>("getPackageInfo", Application.identifier, 0);

    //    //Debug.Log("versionCode:" + pInfo.Get<int>("versionCode"));

    //    //if (!File.Exists(OBBPath))
    //    //{

    //    //}
    //    //else
    //    //{

    //    //}
    //}
    //void PassTheScene()
    //{
    //    int tmpNumber = 0;
    //    for (var i = 0; i < SceneManager.sceneCountInBuildSettings; i++)
    //    {           
    //        var x = SceneUtility.GetScenePathByBuildIndex(i);
    //        Debug.Log("Esta es mi pruba: " + x);

    //        tmpNumber = i;           
    //    }
    //    if (tmpNumber > 1)
    //    {
    //        Singleton<ManagerScene>.instance.GoToAr();
    //    }
    //    else
    //    {
    //        myText.text = "Please retry the download";
    //    }



    //}

#endif
}
