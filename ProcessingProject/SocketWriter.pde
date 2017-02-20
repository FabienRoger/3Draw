
import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketException;

public class SocketWriter implements Runnable{

    private final Socket sock;
    private final  Position p;
    private PrintWriter writer = null;
    private BufferedInputStream reader = null;

    public SocketWriter(Socket sock, Position p){
        this.sock = sock;
        this.p = p;
    }

    //Le lineement lancÃ© dans un thread sÃ©parÃ©
    public void run(){
        System.err.println("Lancement du lineement de la connexion cliente");

        boolean closeConnexion = false;
        //tant que la connexion est active, on linee les demandes
        while(!sock.isClosed()){

            try {
                writer = new PrintWriter(sock.getOutputStream());
                reader = new BufferedInputStream(sock.getInputStream());

                //On attend la demande du client
                String response = read();
                InetSocketAddress remote = (InetSocketAddress)sock.getRemoteSocketAddress();

                //On linee la demande du client en fonction de la commande envoyÃ©e
                String toSend = "";

                String[] split = response.split(":");

                String positionString="";

                response = split[0];

                if(split.length == 2)
                  positionString = split[1];

                switch(response.toUpperCase()){
                    case "START":
                        String debug = "";
                        debug = "Thread : " + Thread.currentThread().getName() + ". ";
                        debug += "Demande de l'adresse : " + remote.getAddress().getHostAddress() +".";
                        debug += " Sur le port : " + remote.getPort() + ".\n";
                        debug += "\t -> Commande recue :" + response + ":\n";
                        System.err.println("\n" + debug);
                        System.err.println("start position="+positionString);
                        p.setPositionString(positionString);
                        break;
                    case "RESET":
                        p.setPositionString(positionString);
                        break;
                    case "GET":
                        String toSendString =this.p.getPositionString();
                        if(!sendList.isEmpty()){
                          toSendString+="#";
                          toSendString+=sendList.get(0);
                          sendList.remove(0);
                        }
                        writer.write(toSendString);
                        writer.flush();
                        break;
                    case "CLOSE":
                        toSend = "Communication terminee";
                        closeConnexion = true;
                        break;
                    default :
                        toSend = "Commande inconnue !";
                        break;
                }

                //On envoie la reponse au client
                writer.write(toSend);
                writer.flush();

                if(closeConnexion){
                    System.err.println("COMMANDE CLOSE DETECTEE ! ");
                    writer = null;
                    reader = null;
                    sock.close();
                    break;
                }
            }catch(SocketException e){
                System.err.println("LA CONNEXION A ETE INTERROMPUE ! ");
                break;
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    //La mÃ©thode que nous utilisons pour lire les rÃ©ponses
    private String read() throws IOException{
        String response = "";
        int stream;
        byte[] b = new byte[4096];
        stream = reader.read(b);
        try{
          response = new String(b, 0, stream);
        }catch(Exception e){}
        System.out.println(response);
        return response;
    }
}