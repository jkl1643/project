package com.example;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import javax.servlet.http.HttpSession;
import java.util.HashMap;

@Component
public class SocketHandler extends TextWebSocketHandler {
    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private HashMap<Integer, MainServer> serverList;
    HashMap<String, WebSocketSession> user = new HashMap<>();
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        HttpSession httpsession = (HttpSession) session.getAttributes().get("session");
        //String nick = (String) httpsession.getAttribute("idid");
        //String roomid = (String) httpsession.getAttribute("roomid");
        MainServer server = serverList.get(1);
        System.out.println("소켓 실행 : " + session.getId());

        super.afterConnectionEstablished(session); // 부모 실행
        user.put(session.getId(), session);
        //Server.connectuser(nick, session, roomid);
        //System.out.println("현재인원 : " + Server.getUser_list().size() + " " + Server.getUser_nick().size());

    }// 웹소켓 연결시 실행

    @Override
    public void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
        HttpSession httpsession = (HttpSession) session.getAttributes().get("session");
        String msg = message.getPayload();
        System.out.println("메세지온거 = " + msg);

    }// handleTextMessage : 메시지를 수신시 실행

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
        HttpSession httpsession = (HttpSession) session.getAttributes().get("session");
        String nick = (String) httpsession.getAttribute("idid");

        super.afterConnectionClosed(session, status); // 부모 실행
        System.out.println("소켓 종료 : " + nick);
    }// afterConnectionClosed : 웹 소켓 close시 실행

}
