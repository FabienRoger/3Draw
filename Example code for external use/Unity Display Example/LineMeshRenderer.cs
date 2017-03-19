using UnityEngine;
using System.Collections;

public class LineMeshRenderer : MonoBehaviour {
	
	public Vector3[] pos;
	public Vector3[] sizes;
	int nbCorner = 8;
	int nbTriangles = 3*2*(6+12*2); // (6 faces + 2 * 12 outer edges(iner and outer)) * 2 triangles per rect * 3 cord per triangles
	private Vector3 halfV = new Vector3 (0.5f, 0.5f, 0.5f);
	private Vector3 doubleV = new Vector3 (2,2,2);
	private MeshFilter filter;
	private bool u = false;
	// Use this for initialization
	void Start () {
		filter = GetComponent<MeshFilter> ();
		filter.mesh = CreateMesh ();
	}

	// Update is called once per frame
	void Update () {
//		if (Input.GetKeyDown ("u")) {
//			if (!u) {
//				u = true;
//				filter.mesh = CreateMesh ();
//			}
//		} else {
//			u = false;
//		}
		if (Input.GetKey ("u")) {
			filter.mesh = CreateMesh ();
		}
			
	}
	public void UpdateMesh(){
		filter.mesh = CreateMesh ();
	}

	Mesh CreateMesh(){
		Mesh mesh = new Mesh ();
		if (sizes.Length == 1) {
			Vector3 size = sizes [0];
			sizes = new Vector3[pos.Length];
			for (int i = 0; i < pos.Length; i++) {
				sizes [i] = size;
			}
		}

		if (pos.Length == sizes.Length) {
			
			mesh.Clear ();
			Vector3[] vertices = new Vector3[pos.Length*nbCorner];
			int[] triangles = new int[pos.Length*3*nbTriangles];
			Vector2[] uvs = new Vector2[vertices.Length];
			Vector3[][] corners = new Vector3[pos.Length][];
			for (int i = 0; i < pos.Length; i++) {
				corners [i] = GenerateCorners (i);
				for (int j = 0; j < nbCorner; j++) {
					vertices[i*nbCorner+j] = corners[i][j];
				}
			}

			int[][] cubesT = new int[pos.Length][];
			for (int i = 0; i < pos.Length; i++) {
				cubesT [i] = GenerateTriangles (i);
				for (int j = 0; j < nbTriangles; j++) {
					triangles[i* nbTriangles * 3+j] = cubesT[i][j];
				}
			}
				
			for(int i = 0; i < vertices.Length; i++){
				if((i%2) == 0){
					uvs[i] = new Vector2(0,0);
				}else{
					uvs[i] = new Vector2(1,1);
				}
			}

			mesh.vertices = vertices;
			mesh.triangles = triangles;
			mesh.uv = uvs;
			mesh.RecalculateBounds ();
			mesh.RecalculateNormals ();
			mesh.Optimize ();

		}
		return mesh;
	}

	Vector3[] GenerateCorners(int i){
		Vector3[] r = new Vector3[nbCorner];
		Vector3 posI = pos [i];
		Vector3 sizesI = sizes [i];
		sizesI.Scale (halfV);
		posI =posI-sizesI;
		sizesI.Scale (doubleV);
		r [0] = new Vector3(posI.x,posI.y,posI.z);
		r [1] = new Vector3(posI.x,posI.y+sizesI.y,posI.z);
		r [2] = new Vector3(posI.x,posI.y+sizesI.y,posI.z+sizesI.z);
		r [3] = new Vector3(posI.x,posI.y,posI.z+sizesI.z);
		r [4] = new Vector3(posI.x+sizesI.x,posI.y,posI.z);
		r [5] = new Vector3(posI.x+sizesI.x,posI.y+sizesI.y,posI.z);
		r [6] = new Vector3(posI.x+sizesI.x,posI.y+sizesI.y,posI.z+sizesI.z);
		r [7] = new Vector3(posI.x+sizesI.x,posI.y,posI.z+sizesI.z);
		return r;
	}

	int[] GenerateTriangles(int i){
		int ic = i * nbCorner;
		int[] r = new int[nbTriangles];

		r[0] = ic+0;
		r[1] = ic+2;
		r[2] = ic+1;

		r[3] = ic+0;
		r[4] = ic+3;
		r[5] = ic+2;

		r[6] = ic+0;
		r[7] = ic+5;
		r[8] = ic+4;

		r[9] = ic+0;
		r[10] = ic+1;
		r[11] = ic+5;

		r[12] = ic+0;
		r[13] = ic+4;
		r[14] = ic+7;

		r[15] = ic+0;
		r[16] = ic+7;
		r[17] = ic+3;

		r[18] = ic+1;
		r[19] = ic+6;
		r[20] = ic+5;

		r[21] = ic+1;
		r[22] = ic+2;
		r[23] = ic+6;

		r[24] = ic+2;
		r[25] = ic+7;
		r[26] = ic+6;

		r[27] = ic+2;
		r[28] = ic+3;
		r[29] = ic+7;
		//
		r[30] = ic+4;
		r[31] = ic+5;
		r[32] = ic+6;

		r[33] = ic+4;
		r[34] = ic+6;
		r[35] = ic+7;


		if (i > 0) {
			int icm = (i - 1) * nbCorner;

			r [36] = ic+0;
			r [37] = ic+1;
			r [38] = icm+0;
			r [39] = ic+1;
			r [40] = icm+1;
			r [41] = icm+0;

			r [42] = ic+1;
			r [43] = ic+2;
			r [44] = icm+1;
			r [45] = ic+2;
			r [46] = icm+2;
			r [47] = icm+1;

			r [48] = ic+2;
			r [49] = icm+2;
			r [50] = ic+3;
			r [51] = ic+3;
			r [52] = icm+2;
			r [53] = icm+3;

			r [54] = ic+3;
			r [55] = ic+0;
			r [56] = icm+3;
			r [57] = ic+0;
			r [58] = icm+0;
			r [59] = icm+3;
			
			r [60] = ic+4;
			r [61] = icm+4;
			r [62] = ic+5;
			r [63] = ic+5;
			r [64] = icm+4;
			r [65] = icm+5;
			
			r [66] = ic+5;
			r [67] = ic+6;
			r [68] = icm+5;
			r [69] = ic+6;
			r [70] = icm+6;
			r [71] = icm+5;

			r [72] = ic+6;
			r [73] = ic+7;
			r [74] = icm+6;
			r [75] = ic+7;
			r [76] = icm+7;
			r [77] = icm+6;

			r [78] = ic+7;
			r [79] = ic+4;
			r [80] = icm+7;
			r [81] = ic+4;
			r [82] = icm+4;
			r [83] = icm+7;

			r [84] = ic+0;
			r [85] = icm+0;
			r [86] = ic+4;
			r [87] = ic+4;
			r [88] = icm+0;
			r [89] = icm+4;

			r [90] = ic+1;
			r [91] = ic+5;
			r [92] = icm+1;
			r [93] = ic+5;
			r [94] = icm+5;
			r [95] = icm+1;

			r [96] = ic+2;
			r [97] = icm+6;
			r [98] = icm+2;
			r [99] = ic+6;
			r [100] = icm+6;
			r [101] = icm+2;
			
			r [102] = ic+3;
			r [103] = icm+3;
			r [104] = ic+7;
			r [105] = ic+7;
			r [106] = icm+3;
			r [107] = icm+7;

			//BIS
			r [36+12*3*2] = ic+1;
			r [37+12*3*2] = ic+0;
			r [38+12*3*2] = icm+0;
			r [39+12*3*2] = ic+1;
			r [40+12*3*2] = icm+0;
			r [41+12*3*2] = icm+1;

			r [42+12*3*2] = ic+2;
			r [43+12*3*2] = ic+1;
			r [44+12*3*2] = icm+1;
			r [45+12*3*2] = ic+2;
			r [46+12*3*2] = icm+1;
			r [47+12*3*2] = icm+2;

			r [48+12*3*2] = ic+3;
			r [49+12*3*2] = icm+2;
			r [50+12*3*2] = ic+2;
			r [51+12*3*2] = ic+3;
			r [52+12*3*2] = icm+3;
			r [53+12*3*2] = icm+2;

			r [54+12*3*2] = ic+0;
			r [55+12*3*2] = ic+3;
			r [56+12*3*2] = icm+3;
			r [57+12*3*2] = ic+0;
			r [58+12*3*2] = icm+3;
			r [59+12*3*2] = icm+0;

			r [60+12*3*2] = ic+5;
			r [61+12*3*2] = icm+4;
			r [62+12*3*2] = ic+4;
			r [63+12*3*2] = ic+5;
			r [64+12*3*2] = icm+5;
			r [65+12*3*2] = icm+4;

			r [66+12*3*2] = ic+6;
			r [67+12*3*2] = ic+5;
			r [68+12*3*2] = icm+5;
			r [69+12*3*2] = ic+6;
			r [70+12*3*2] = icm+5;
			r [71+12*3*2] = icm+6;

			r [72+12*3*2] = ic+7;
			r [73+12*3*2] = ic+6;
			r [74+12*3*2] = icm+6;
			r [75+12*3*2] = ic+7;
			r [76+12*3*2] = icm+6;
			r [77+12*3*2] = icm+7;

			r [78+12*3*2] = ic+4;
			r [79+12*3*2] = ic+7;
			r [80+12*3*2] = icm+7;
			r [81+12*3*2] = ic+4;
			r [82+12*3*2] = icm+7;
			r [83+12*3*2] = icm+4;

			r [84+12*3*2] = ic+4;
			r [85+12*3*2] = icm+0;
			r [86+12*3*2] = ic+0;
			r [87+12*3*2] = ic+4;
			r [88+12*3*2] = icm+4;
			r [89+12*3*2] = icm+0;

			r [90+12*3*2] = ic+5;
			r [91+12*3*2] = ic+1;
			r [92+12*3*2] = icm+1;
			r [93+12*3*2] = ic+5;
			r [94+12*3*2] = icm+1;
			r [95+12*3*2] = icm+5;

			r [96+12*3*2] = ic+2;
			r [97+12*3*2] = icm+2;
			r [98+12*3*2] = icm+6;
			r [99+12*3*2] = ic+6;
			r [100+12*3*2] = icm+2;
			r [101+12*3*2] = icm+6;

			r [102+12*3*2] = ic+7;
			r [103+12*3*2] = icm+3;
			r [104+12*3*2] = ic+3;
			r [105+12*3*2] = ic+7;
			r [106+12*3*2] = icm+7;
			r [107+12*3*2] = icm+3;
		}
		return r;
	}

}
