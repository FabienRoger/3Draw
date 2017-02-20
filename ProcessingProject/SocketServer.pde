
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;

/**
 * Permet de gÃ©rer plusieurs sockets clients consommateurs de coordonnÃ©es, pae exemple 2 clients unity sur 2 machines diffÃ©rentes.
 */
public class SocketServer {

    private final int port;
    private final String host;
    private final Position p;
    private ServerSocket server = null;
    private boolean isRunning = true;

    public SocketServer(String host, int port, Position p){
        this.host = host;
        this.port = port;
        this.p = p;
        try {
            this.server = new ServerSocket(port, 100, InetAddress.getByName(host));
        } catch (UnknownHostException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void open(){
        //Toujours dans un thread Ã  part vu qu'il est dans une boucle infinie
        Thread t = new Thread(new Runnable(){
            public void run(){
                while(isRunning == true){

                    try {
                        //On attend une connexion d'un client
                        Socket client = server.accept();

                        //Une fois recue, on la linee dans un thread sÃ©parÃ©
                        System.out.println("Connexion cliente recue.");
                        Thread t = new Thread(new SocketWriter(client,p));
                        t.start();

                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

                try {
                    server.close();
                } catch (IOException e) {
                    e.printStackTrace();
                    server = null;
                }
            }
        });

        t.start();
    }

    public void close(){
        isRunning = false;
    }
}