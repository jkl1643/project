package com.example;

public class Chat {
    private String roomID;
    private String roomPW;
    private String userNickName;
    private String msg;
    private String type;
    private String userName;

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

    public String getType() {
        return type;
    }

    public void setType(String msg) {
        this.msg = msg;
    }

    public String getUserName() {
        return userName;
    }
    public void setUserName(String msg){
        this.userName = userName;
    }
}
