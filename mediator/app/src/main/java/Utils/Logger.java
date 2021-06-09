package Utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetSocketAddress;
import java.net.Socket;

public class Logger {
    private static String host = "192.168.43.89";
    private static int port = 3000;

    public static void sendData(String msg) {

//        Socket socket = new Socket();
//        try {
//            socket.connect(new InetSocketAddress(host,port));
//
//            PrintWriter writer= new PrintWriter(socket.getOutputStream());
//
//            writer.println(msg);
//
//            writer.close();
//            socket.close();
//        } catch (IOException e) {
//            e.printStackTrace();
//        }
    }
}
