package com.example;

import com.fasterxml.jackson.databind.ObjectMapper;
import jdk.internal.org.objectweb.asm.TypeReference;
import jdk.nashorn.internal.parser.JSONParser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.configurationprocessor.json.JSONObject;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import javax.servlet.http.HttpSession;
import javax.websocket.Session;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

@Component
public class SocketHandler extends TextWebSocketHandler {
    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private HashMap<Integer, MainServer> serverList;

    static HashMap<String, WebSocketSession> user = new HashMap<>();
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        HttpSession httpsession = (HttpSession) session.getAttributes().get("session");
        Member mem = (Member)httpsession.getAttribute("mem");
        Room room = (Room)httpsession.getAttribute("room");
        MainServer server = serverList.get(16);
        System.out.println("소켓 실행 : " + session.getId());
        String roomid = (String)httpsession.getAttribute("roomid");
        String roompw = (String)httpsession.getAttribute("roompw");

        user.put(session.getId(), session);
        System.out.println("mem.getEmail() : " + mem.getEmail());
        System.out.println("session : " + session);
        System.out.println("roomid : " + roomid);
        //System.out.println("room.getID() : " + room.getID());
        /*server.connectuser(mem.getEmail(), session, room.getID()); //id값에 따라 어케되는지*/
        server.connectuser(mem.getNickname(), session, roomid); //id값에 따라 어케되는지
        Set<String> keys = user.keySet();
        for (String key : keys) {
            System.out.println("유저3 : " + key);
        }
        System.out.println("유저2 : " + user.values());

        Set<String> keys2 = server.getUser_nick().keySet();
        for (String key : keys2) {
            System.out.println("유저4 : " + key);
        }


        System.out.println("현재인원 : " + server.getUser_list().size() + ", 사이즈? : " + server.getUser_nick().size());
        super.afterConnectionEstablished(session); // 부모 실행
        //Server.connectuser(nick, session, roomid);
        //System.out.println("현재인원 : " + Server.getUser_list().size() + " " + Server.getUser_nick().size());

    }// 웹소켓 연결시 실행

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        HttpSession httpsession = (HttpSession) session.getAttributes().get("session");
        MainServer server = serverList.get(16);
        String msg = message.getPayload();
        System.out.println("메세지온거 = " + msg);
        //JSONObject jsonObject = new JSONObject();
        String nick = null;
        String roomID = null;
        String roomPW = null;
        if (msg.startsWith("{\"type\":\"chat")) {
            Chat chat = objectMapper.readValue(msg, Chat.class);
            nick = chat.getUserNickName();
            roomID = chat.getRoomID();
            roomPW = chat.getRoomPW();
        }

        if (msg.startsWith("{\"type\":\"CHAT")) {
            Chat chat = objectMapper.readValue(msg, Chat.class);
            roomID = chat.getRoomID();
            roomPW = chat.getRoomPW();
        }

        System.out.println("roomID : " + roomID);
        System.out.println("sessionid : " + httpsession.getAttribute("roomid"));
        /*ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> map = new HashMap<String, Object>();


        map = mapper.readValue(message, new TypeReference<Map<String, String>>(){});*/

        /*if (roomID.equals(httpsession.getAttribute("roomid")) && roomPW.equals(httpsession.getAttribute("roompw"))) {*/
            for (User user : server.getUser_list().values()) {
                WebSocketSession wss = user.getWss();

                if (msg.startsWith("{\"type\":\"chat")) {
                    System.out.println(msg + "msg userNickName" + nick);
                    wss.sendMessage(new TextMessage(msg));
                } else {
                    if (!wss.equals(session)) { //자기자신에게 안보내기
                        wss.sendMessage(new TextMessage(msg));
                    }
                }
            }

        /*if(chat.getType().equals("chat")){
            System.out.println("chat임");
        }*/
    }// handleTextMessage : 메시지를 수신시 실행

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        HttpSession httpsession = (HttpSession) session.getAttributes().get("session");
        String nick = (String) httpsession.getAttribute("idid");

        super.afterConnectionClosed(session, status); // 부모 실행
        user.remove(session.getId(), session);
        System.out.println("소켓 종료 : " + nick);
    }// afterConnectionClosed : 웹 소켓 close시 실행
}
