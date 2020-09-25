package com.example;

import java.util.Date;

public class RegisterRequest {
    private String email;
    private String password;
    private String confirmPassword;
    private String nickname;
    private int gamelog;
    private Date registerDate;

    public int getGamelog() {
        return gamelog;
    }

    public void setGamelog(int gamelog) {
        this.gamelog = gamelog;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getConfirmPassword() {
        return confirmPassword;
    }

    public void setConfirmPassword(String confirmPassword) {
        this.confirmPassword = confirmPassword;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public boolean isPasswordEqualToConfirmPassword() {
        return password.equals(confirmPassword);
    }

    public Date getRegisterDate() {
        return registerDate;
    }

    public void setRegisterDate(Date registerDate) {
        this.registerDate = registerDate;
    }
}
