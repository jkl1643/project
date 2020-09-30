package com.example;

public class Chat {
    private String roomID;
    private String roomPW;
    private String userNickName;
    private String msg;

    public String getRoomID(){
        return roomID;
    }
    public void setRoomID(String roomID){
        this.roomID = roomID;
    }

    public String getRoomPW(){
        return roomPW;
    }
    public void setRoomPW(String roomPW){
        this.roomPW = roomPW;
    }

    public String getUserNickName(){
        return userNickName;
    }
    public void setUserNickName(String userNickName){
        this.userNickName = userNickName;
    }

    public String getMsg(){
        return msg;
    }
    public void setMsg(String msg){
        this.msg = msg;
    }
}
