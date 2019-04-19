using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class ReplaceShader : MonoBehaviour 
{
    public Shader Replacement;
    // Use this for initialization
    public void OnEnable()
    {
        if(Replacement != null)
        {
            GetComponent<Camera>().SetReplacementShader(Replacement, "");//normally "RenderType" but if we want auto replacement with the first subshader we just pass an empty string
        }
    }

    public void OnDisable()
    {
        GetComponent<Camera>().ResetReplacementShader();
    }
    void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
