using System.Collections;
using UnityEngine;
using EKTemplate;
using DG.Tweening;
using TMPro;
public class ColorButtons : MonoBehaviour
{

    public GameObject mergeButton;
    public GameObject mergeButtonFake;
    public GameObject mergeButtonShine;

    public GameObject btnRed;
    public GameObject btnBlue;
    public GameObject btnGreen;
    public GameObject btnYellow;

    public GameObject circleBlue;
    public GameObject circleGreen;
    public GameObject circleRed;
    public GameObject circleYellow;

    float green = 5;
    float greenTime = 1;
    bool checkGreen = false;
    public TextMeshProUGUI greenCountText;

    float blue = 5;
    float blueTime = 1;
    bool checkBlue = false;
    public TextMeshProUGUI blueCountText;


    float red = 5;
    float redTime = 1;
    bool checkRed = false;
    public TextMeshProUGUI redCountText;

    float yellow = 5;
    float yellowTime = 1;
    bool checkYellow = false;
    public TextMeshProUGUI yellowCountText;

    #region Circles
    IEnumerator BlueCircle()
    {
        yield return new WaitForSeconds(1);
        blueTime -= (1/blue);
        circleBlue.GetComponent<ProgressBarPro>().Value = blueTime;
        StartCoroutine(BlueCircle());
    }
    IEnumerator RedCircle()
    {
        yield return new WaitForSeconds(1);
        redTime -= (1 / red);
        circleRed.GetComponent<ProgressBarPro>().Value = redTime;
        StartCoroutine(RedCircle());
    }
    IEnumerator GreenCircle()
    {
        yield return new WaitForSeconds(1);
        greenTime -= (1 / green);
        circleGreen.GetComponent<ProgressBarPro>().Value = greenTime;
        StartCoroutine(GreenCircle());
    }
    IEnumerator YellowCircle()
    {
        yield return new WaitForSeconds(1);
        yellowTime -= (1 / yellow);
        circleYellow.GetComponent<ProgressBarPro>().Value = yellowTime;
        StartCoroutine(YellowCircle());
    }
    private void CloseCircles()
    {
        circleBlue.SetActive(false);
        circleRed.SetActive(false);
        circleGreen.SetActive(false);

        redTime = 1f;
        greenTime = 1f;
        blueTime = 1f;

        circleGreen.GetComponent<ProgressBarPro>().Value = 1f;
        circleRed.GetComponent<ProgressBarPro>().Value = 1f;
        circleBlue.GetComponent<ProgressBarPro>().Value = 1f;
    }
    #endregion
    public void MergeButton()
    {
        if (GameManager.instance.level == 1) // green and blue mix for orange
        { 
            btnGreen.SetActive(false);
            circleGreen.SetActive(false);

            btnBlue.SetActive(false);
            circleBlue.SetActive(false);

            btnYellow.SetActive(true);

            Vector3 tempYellow;
            tempYellow = Camera.main.ScreenToWorldPoint(btnYellow.transform.position);
            Instantiate(Resources.Load("Cloud"), tempYellow, Quaternion.identity);

            Vector3 tempRed;
            tempRed = Camera.main.ScreenToWorldPoint(btnRed.transform.position);
            Instantiate(Resources.Load("Cloud"), tempRed, Quaternion.identity);

            mergeButtonShine.SetActive(false);
            mergeButton.SetActive(false);
            mergeButtonFake.SetActive(false);
        } 
    }
    bool checkMergeButton = false;
    private void Update()
    {
        greenCountText.text = LevelContainer.instance.totalGreenCount.ToString();
        blueCountText.text = LevelContainer.instance.totalBlueCount.ToString();
        redCountText.text = LevelContainer.instance.totalRedCount.ToString();

        if(GameManager.instance.level == 1)
        {
           if( LevelContainer.instance.totalBlueCount == 0 && LevelContainer.instance.totalGreenCount == 0)
            {
                if (checkMergeButton) return;
                mergeButton.SetActive(true);
                mergeButtonShine.SetActive(true);
                checkMergeButton = true;
            }
        }
    }
    public void BlueButton()
    {
        btnBlue.GetComponent<Animator>().SetTrigger("Select");
        if (GameManager.instance.money < 55) return;
        GameManager.instance.money -= 55;
        StopAllCoroutines();
        CloseCircles();
        circleBlue.SetActive(true);
        StartCoroutine(BlueCircle());

        GameObject money = Instantiate(Resources.Load("minusmoney"), new Vector3(TapManager.instance.transform.position.x + Random.Range(-2.9f, 2.9f), TapManager.instance.transform.position.y + 2.7f, 
            TapManager.instance.transform.position.z + 1.75f), Quaternion.Euler(24f, 0, 0)) as GameObject;
        money.GetComponent<TextMeshPro>().text = "55$".ToString();

        money.transform.DOScale(1, 1.3f).SetEase(Ease.OutBounce).OnComplete(() =>
        {
            Destroy(money, 0.2f);
        });
        if (LevelContainer.instance.totalBlueCount > 0)
        {
            LevelContainer.instance.totalBlueCount--;
        }
        green = 5;
        red = 5;
        yellow = 5;
        checkGreen = false;
        checkRed = false;
        checkYellow = false;
        if (!checkBlue)
        {
            StartCoroutine(DelayBlue());
        }
        else
        {
            blue += 1;
            blueTime = 1f;

        }
        StartCoroutine(DelayBlue());
        IEnumerator DelayBlue()
        {
            checkBlue = true;
            TapManager.instance.selectBased = true;
            TapManager.instance.cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0f, 0.63f, 0.75f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(0.21f, 1f, 0.92f, 1);
            ChangeParticleSplashColor(0f, 0.63f, 0.75f);
            yield return new WaitForSeconds(blue);
            TapManager.instance.selectBased = false;
            checkBlue = false;
            blue = 5;
            circleBlue.SetActive(false);
            blueTime = 1f;
        }
    }
    public void RedButton()
    {
        btnRed.GetComponent<Animator>().SetTrigger("Select");
        if (GameManager.instance.money < 65) return;
        GameManager.instance.money -= 65;
        StopAllCoroutines();
        CloseCircles();
        circleRed.SetActive(true);
        StartCoroutine(RedCircle());

        GameObject money = Instantiate(Resources.Load("minusmoney"), new Vector3(TapManager.instance.transform.position.x + Random.Range(-2.9f, 2.9f), TapManager.instance.transform.position.y + 2.7f, 
            TapManager.instance.transform.position.z + 1.75f), Quaternion.Euler(24f, 0, 0)) as GameObject;
        money.GetComponent<TextMeshPro>().text = "65$".ToString();

        money.transform.DOScale(1, 1.3f).SetEase(Ease.OutBounce).OnComplete(() =>
        {
            Destroy(money, 0.2f);
        });
        if (LevelContainer.instance.totalRedCount > 0)
        {
            LevelContainer.instance.totalRedCount--;
        }

        green = 5;
        blue = 5;
        yellow = 5;
        checkBlue = false;
        checkGreen = false;
        checkYellow = false;
        if (!checkRed)
        {
            StartCoroutine(DelayRed());
        }
        else
        {
            red += 1;
            redTime = 1f;
        }
        StartCoroutine(DelayRed());
        IEnumerator DelayRed()
        {
            checkRed = true;
            TapManager.instance.selectBased = true;
            TapManager.instance.cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0.75f, 0f, 0f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(1f, 0.15f, 0.15f, 1);
            ChangeParticleSplashColor(0.75f, 0f, 0f);

            yield return new WaitForSeconds(red);
            TapManager.instance.selectBased = false;
            checkRed = false;
            red = 5;
            circleRed.SetActive(false);
            redTime = 1f;
        }
    }
    public void GreenButton()
    {
        btnGreen.GetComponent<Animator>().SetTrigger("Select");
        if (GameManager.instance.money < 85) return;
        GameManager.instance.money -= 85;
        StopAllCoroutines();
        CloseCircles();
        circleGreen.SetActive(true);
        StartCoroutine(GreenCircle());

        GameObject money = Instantiate(Resources.Load("minusmoney"), new Vector3(TapManager.instance.transform.position.x + Random.Range(-2.9f, 2.9f), TapManager.instance.transform.position.y + 2.7f, 
            TapManager.instance.transform.position.z + 1.75f), Quaternion.Euler(24f, 0, 0)) as GameObject;
        money.GetComponent<TextMeshPro>().text = "85$".ToString();
        money.transform.DOScale(1, 1.3f).SetEase(Ease.OutBounce).OnComplete(() =>
        {
            Destroy(money, 0.2f);
        });
        if (LevelContainer.instance.totalGreenCount > 0)
        {
            LevelContainer.instance.totalGreenCount--;
        }

        red = 5;
        blue = 5;
        yellow = 5;
        checkBlue = false;
        checkRed = false;
        checkYellow = false;
        if (!checkGreen)
        {
            StartCoroutine(DelayGreen());
        }
        else
        {
            green += 1;
            greenTime = 1f;
        }
        StartCoroutine(DelayGreen());
        IEnumerator DelayGreen()
        {
            checkGreen = true;
            TapManager.instance.selectBased = true;
            TapManager.instance.cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0.22f, 0.62f, 0.24f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(0.25f, 1f, 0.3f, 1);
            ChangeParticleSplashColor(0.22f, 0.62f, 0.24f);

            yield return new WaitForSeconds(green);
            TapManager.instance.selectBased = false;
            checkGreen = false;
            green = 5;
            circleGreen.SetActive(false);
            greenTime = 1f;
        }
    }
    public void YellowButton()
    {
        btnYellow.GetComponent<Animator>().SetTrigger("Select");
        if (GameManager.instance.money < 50) return;
        GameManager.instance.money -= 50;
        StopAllCoroutines();
        CloseCircles();
        circleYellow.SetActive(true);
        StartCoroutine(YellowCircle());

        GameObject money = Instantiate(Resources.Load("minusmoney"), new Vector3(TapManager.instance.transform.position.x + Random.Range(-2.9f, 2.9f), TapManager.instance.transform.position.y + 2.7f,
            TapManager.instance.transform.position.z + 1.75f), Quaternion.Euler(24f, 0, 0)) as GameObject;
        money.GetComponent<TextMeshPro>().text = "50$".ToString();
        money.transform.DOScale(1, 1.3f).SetEase(Ease.OutBounce).OnComplete(() =>
        {
            Destroy(money, 0.2f);
        });
        if (LevelContainer.instance.totalYellowCount > 0)
        {
            LevelContainer.instance.totalYellowCount--;
        }

        red = 5;
        blue = 5;
        green = 5;
        checkBlue = false;
        checkGreen = false;
        checkRed = false;
        if (!checkYellow)
        {
            StartCoroutine(DelayYellow());
        }
        else
        {
            yellow += 1;
            yellowTime = 1f;
        }
        StartCoroutine(DelayYellow());
        IEnumerator DelayYellow()
        {
            checkYellow = true;
            TapManager.instance.selectBased = true;
            TapManager.instance.cylinder.GetComponent<SkinnedMeshRenderer>().materials[1].color = new Color(0.75f, 0.72f, 0f, 1);
            LevelContainer.instance.PaintObj.GetComponent<PaintIn3D.P3dPaintDecal>().Color = new Color(1f, 1f, 0f, 1);
            ChangeParticleSplashColor(0.75f, 0.72f, 0f);

            yield return new WaitForSeconds(yellow);
            TapManager.instance.selectBased = false;
            checkYellow = false;
            yellow = 5;
            circleYellow.SetActive(false);
            yellowTime = 1f;
        }
    }
    public void ChangeParticleSplashColor(float _r,float _g, float _b)
    {
        LevelContainer.instance.PaintObj.GetChild(0).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
        LevelContainer.instance.PaintObj.GetChild(1).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
        LevelContainer.instance.PaintObj.GetChild(2).GetComponent<ParticleSystem>().startColor = new Color(_r, _g, _b, 1);
    }
}
