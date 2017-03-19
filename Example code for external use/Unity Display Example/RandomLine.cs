using UnityEngine;
using System.Collections;

public class RandomLine : MonoBehaviour {
	public Vector3 scaler;

	private LineMeshRenderer lmr;
	// Use this for initialization
	void Start () {
		lmr = GetComponent<LineMeshRenderer> ();
	}
	
	// Update is called once per frame
	void Update () {
		if (Input.GetKeyDown ("space")) {
			for (int i = 0; i < lmr.pos.Length; i++) {
				Vector3 v = Random.insideUnitSphere;
				v.Scale (scaler);
				lmr.pos [i] = v;
			}
		
		} 
	}
}
