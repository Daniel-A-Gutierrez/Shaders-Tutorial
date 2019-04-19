using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class gottablast : MonoBehaviour {
    public Material EffectMaterial;
    public int iterations;
    [Range(0, 8)]
    public int downres;
    [ExecuteInEditMode]
    public void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        RenderTexture rt = RenderTexture.GetTemporary(source.width, source.height);
        Graphics.Blit(source, rt);
        int width = source.width >> downres;
        int height = source.height >> downres;
        for(int i = 0; i < iterations; i++)
        {
            RenderTexture rt2 = RenderTexture.GetTemporary(width, height);
            Graphics.Blit(rt, rt2, EffectMaterial);
            RenderTexture.ReleaseTemporary(rt);//i think memory freeing?
            rt = rt2;
        }
        Graphics.Blit(rt, destination);
        RenderTexture.ReleaseTemporary(rt);
    }
    // Use this for initialization
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
