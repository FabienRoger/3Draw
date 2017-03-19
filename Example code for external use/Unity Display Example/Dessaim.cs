using UnityEngine;
using System;
using System.IO;
using System.Net.Sockets;
using System.Collections.Generic;

public class Dessaim : MonoBehaviour {

	public string host = "127.0.0.1";
	public int port = 2313;
	public float scaleFactor = 0.001f;
	public int wFRatio = 2;

	public GameObject line;
	public Shader shader;

	private LineMeshRenderer actLine;
	private List<Material> materials = new List<Material>();

	public bool socketReady = false;
	TcpClient socket;
	NetworkStream stream;
	StreamWriter writer;
	StreamReader reader;

	Boolean start = false;

	String initialPosition = null;

	private Transform sphereT;

	private String message;
	int co = 0;
	// Use this for initialization
	void Start()
	{
		actLine = transform.Find ("actLine").GetComponent<LineMeshRenderer>();
		sphereT = transform.Find ("Sphere");
		message = "LO";
		setupSocket();
	}

	// Update is called once per frame
	void Update()
	{
		if (Input.GetKeyDown(KeyCode.S))
		{
			if (start == true)
			{
				start = false;
				return;
			}
			else
			{
				start = true;
				Vector3 currentPosition = transform.position;
				String startPosition = currentPosition.x+","+ currentPosition.y + ","+currentPosition.z;
				if (initialPosition == null) initialPosition = startPosition;
				this.writeSocket("start:"+startPosition);
				return;
			}
		}

		if (!start)
			return;

		if (Input.GetKeyDown(KeyCode.R))
		{
			this.writeSocket("reset:" + initialPosition);
			return;
		}

		this.writeSocket("get");
		String s = readSocket();
		if (s.Length != 0)
		{

//			print (readSocket ());
//			print (s + " s");
			string[] infos = s.Split ('#');
			string[] coordinates = infos[0].Split(',');
//			print("H");
//			print(s);
//			print("Y");
//			string[] sarray = { message,s };
//			message = String.Join(" ", sarray);
//			message = new String(message,s);
//			message = message +""+ s;
//			print (message);
//			co++;
//			print(co+" co");
			try
			{
				float x = float.Parse(coordinates[0]);
				float y = float.Parse(coordinates[1]);
				float z = float.Parse(coordinates[2]);
				sphereT.localPosition = adaptPos(x,y,z);

				if (infos.Length > 1) {
					print (infos [1]);
					if(infos[1].Contains("CLEAR")){
						Destroy(transform.Find("Line(Clone)").gameObject);
						Destroy(transform.Find("Line(Clone)").gameObject);
					}else if(infos[1].Contains("NEWLINE")){
						String[] lInfos = infos[2].Split(';');
						GameObject l = Instantiate(line,gameObject.transform) as GameObject;
						//Material material = l.GetComponent<Material>();
						LineMeshRenderer lmr = l.GetComponent<LineMeshRenderer>();
						lmr.sizes=new Vector3[1];
						lmr.sizes[0]=adaptSize(float.Parse(lInfos[0])*wFRatio,float.Parse(lInfos[1])*wFRatio,float.Parse(lInfos[2])*wFRatio);

						int col = int.Parse(lInfos[3]);
						MeshRenderer meshRenderer = l.GetComponent<MeshRenderer>();
						materials.Add(new Material(shader));
						materials[materials.Count-1].color = getCol(col);
						meshRenderer.material = materials[materials.Count-1];

						lmr.pos=new Vector3[lInfos.Length-4];
						for(int i = 4;i<lInfos.Length;i++){
							String[] ptsInfo = lInfos[i].Split(',');
							lmr.pos[i-4]=adaptPosParent(float.Parse(ptsInfo[0]),float.Parse(ptsInfo[1]),float.Parse(ptsInfo[2]));
						}
						actLine.pos = new Vector3[0];
						actLine.UpdateMesh();
					}else if(infos[1].Contains("ADDPOINT")){
						String[] lInfos = infos[2].Split(',');
						Vector3[] npos = new Vector3[actLine.pos.Length+1];
						for(int i = 0;i<actLine.pos.Length;i++){
							npos[i]=actLine.pos[i];
						}
						npos[actLine.pos.Length]=adaptPos(float.Parse(lInfos[0]),float.Parse(lInfos[1]),float.Parse(lInfos[2]));
						actLine.pos=npos;
						actLine.sizes = new Vector3[1];
						actLine.sizes[0] = adaptSize(float.Parse(lInfos[3])*wFRatio,float.Parse(lInfos[4])*wFRatio,float.Parse(lInfos[5])*wFRatio);

						int col = int.Parse(lInfos[6]);
						MeshRenderer meshRenderer = actLine.GetComponent<MeshRenderer>();
						materials.Add(new Material(shader));
						materials[materials.Count-1].color = getCol(col);
						meshRenderer.material = materials[materials.Count-1];

						actLine.UpdateMesh();
					}

				}
				materials.Clear();
//				String[] messages = infos[1].Split('~');
//				if(!messages[1].Equals("EMPTY")){
//					if(message.Length<=int.Parse(messages[0])){
//						message+=messages[2];
//						print(message);
//					}
//				}
			}
			catch (FormatException ex)
			{
			}
		}
	}

	public void setupSocket()
	{
		try
		{
			socket = new TcpClient(host, port);
			stream = socket.GetStream();
			writer = new StreamWriter(stream);
			reader = new StreamReader(stream);
			socketReady = true;
		}
		catch (Exception e)
		{
			Debug.Log("Socket error:" + e);
		}
	}

	public string readSocket()
	{
		String result = "";
		if (stream.DataAvailable)
		{
			Byte[] inStream = new Byte[socket.SendBufferSize];
			stream.Read(inStream, 0, inStream.Length);
			result += System.Text.Encoding.UTF8.GetString(inStream);
		}
		return result;
	}


	public void writeSocket(string instruction)
	{
		if (!socketReady)
			return;
		writer.Write(instruction);
		writer.Flush();
	}

	private Vector3 adaptPos(float x, float y, float z){
		return new Vector3 (x * scaleFactor, -z * scaleFactor, -y * scaleFactor)+gameObject.transform.position;
	}

	private Vector3 adaptPosParent(float x, float y, float z){
		return new Vector3 (x * scaleFactor, -z * scaleFactor, -y * scaleFactor)+2*gameObject.transform.position;
	}

	private Vector3 adaptSize(float x, float y, float z){
		return new Vector3 (x * scaleFactor, z * scaleFactor, y * scaleFactor);
	}

	private Color getCol(int col){
		col*=-1;
		col-=1;
		float bl = (255-col%256)/255f;
		col-=col%256;
		col /= 256;
		float gr = (255-col%256)/255f;
		col-=col%256;
		col /= 256;
		float rd = (255-col%256)/255f;
		print(rd+" "+gr+" "+bl);
		return new Color (rd, gr, bl);
	}
}
