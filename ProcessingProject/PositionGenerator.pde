
public class PositionGenerator {
    // Adresse IP et port de l'ordinateur unity. Par dÃ©faut le localhost (127.0.0.1)
    private final String host = "127.0.0.1";
    //private final int port = 2312;
    private final int port = 2313;
    private final Position p = new Position();

    public PositionGenerator()
    {
        SocketServer ts = new SocketServer(host, port,p);
        ts.open();
        System.out.println("Serveur initialisÃ© sur host:"+host+" port"+port);
    }

    public void setNewPosition(float x, float y, float z)
    {
        this.p.setNewPosition(x,y,z);
    }

    public void simulateRandomPosition(float a)
    {
        p.setRandomNewPosition(a);
    }
    
    //private float scaleFactor = 0.001f;
    public void updateCord(float x,float y,float z){
      this.p.setNewPosition(x,y,z);
      //this.p.setNewPosition(x*scaleFactor,-z*scaleFactor,-y*scaleFactor);
    }
}