package com.example;

import java.util.HashSet;
import java.util.Random;
import java.util.Set;
import java.util.UUID;

public class Room {
    private String ID;
    private String name;
    private String password;
    private Set<String> usernicks;
    private int player;
    double rand = Math.random();
    String srand = Double.toString(rand);
    Room() {
        this.ID = UUID.randomUUID().toString();
        this.name = name;
        this.usernicks = new HashSet<>();

        this.password = srand.substring(srand.length() - 11, srand.length() - 1);
    }

    public boolean join(String nick, String pw) {
        if (!password.equals(pw)) {
            System.out.println("비번 미일치 : " + nick + " / " + password + ", " + pw);
            return false;
        }
        usernicks.add(nick);
        player = usernicks.size();
        return true;
    }

    public void exit(String nick) {
        System.out.println("방 퇴장 : " + nick + " / " + ID);
        usernicks.remove(nick);
        player = usernicks.size();
    }

    public String getID() {
        return ID;
    }
    public void setID(String ID) {
        this.ID = ID;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public int getPlayer() {
        return player;
    }
    public void setPlayer(int player) {
        this.player = player;
    }

    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    public Set<String> getUsers() {
        return usernicks;
    }
    public void setUsers(Set<String> users) {
        this.usernicks = users;
    }
}
