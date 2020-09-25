package com.example;

import org.springframework.web.socket.WebSocketSession;

public class User {
    private WebSocketSession wss;
    private String roomid;

    public User(WebSocketSession wss, String roomid) {
        this.wss = wss;
        this.roomid = roomid;
    }

    public WebSocketSession getWss() { return wss; }
    public String getRoomid() { return roomid; }
    public void setWss(WebSocketSession wss) { this.wss = wss; }
    public void setRoomid(String roomid) { this.roomid = roomid; }
}
