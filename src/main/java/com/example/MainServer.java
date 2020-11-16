package com.example;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;

import java.io.IOException;
import java.util.HashMap;

public class MainServer {
    private ObjectMapper objectMapper;
    private HashMap<String, String> User_nick;
    private HashMap<String, User> User_list;
    private HashMap<String, Room> Room_list;

    MainServer() {
        Room_list = new HashMap<String, Room>(); //방목록
        User_nick = new HashMap<>();            //유저닉으로 아이디찾기
        User_list = new HashMap<>();            //아이디로 소켓찾기
        objectMapper = new ObjectMapper();
    }

    public void connectuser(String nick, WebSocketSession user, String roomid) {
        System.out.println("connectuser");
        if (User_nick.get(nick) != null) {
            User_list.remove(User_nick.get(nick));
            User_nick.remove(nick);
        }
        User newuser = new User(user, roomid);
        User_list.put(user.getId(), newuser);
        User_nick.put(nick, user.getId());

        System.out.println("유저 입장 : " + nick + " / " + roomid);
    }

    public void disconnectuser(String nick) throws JsonProcessingException {
        String roomid = User_list.get(User_nick.get(nick)).getRoomid();

        if(roomid.equals("lobby")) {
            User_list.remove(User_nick.get(nick));
            User_nick.remove(nick);
            String js = "";

            for (User user : User_list.values()) {
                WebSocketSession wss = user.getWss();
                try {
                    wss.sendMessage(new TextMessage(js));
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        } else {
            Room_list.get(roomid).exit(nick);
            if(Room_list.get(roomid).getPlayer() == 0) {
                Room_list.remove(roomid);
            }

            User_list.remove(User_nick.get(nick));
            User_nick.remove(nick);
        }
        System.out.println("유저 퇴장 : " + nick + " / " + roomid);
    }

    public Room create() {
        Room room = new Room();
        Room_list.put(room.getID(), room);
        Room_list.put(room.getPassword(), room);

        String js = "";

        try {
            js = objectMapper.writeValueAsString("a");
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        }
        System.out.println(Room_list.size());
        for(User user : User_list.values()) {
            WebSocketSession wss = user.getWss();
            try {
                wss.sendMessage(new TextMessage(js));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        System.out.println("방 생성");
        return room;
    }

    public void select(String roomID, String pw, String nick) {
        for(Room room : Room_list.values()) {
            if(room.getID().equals(roomID)) {
                room.join(nick, pw);
                System.out.println("방 입장 : " + nick + " / " + room.getName());
            }
        }
    }

    public HashMap<String, Room> getRoom_list() { return Room_list; }
    public void setRoom_list(HashMap<String, Room> Room_list) { this.Room_list = Room_list; }
    public HashMap<String, User> getUser_list() { return User_list; }
    public void setUser_list(HashMap<String, User> user_list) { User_list = user_list; }
    public HashMap<String, String> getUser_nick() { return User_nick; }
    public void setUser_nick(HashMap<String, String> user_nick) { User_nick = user_nick; }
}
