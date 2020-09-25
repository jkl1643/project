package com.example;

@SuppressWarnings("serial")
public class DuplicateMemberException extends RuntimeException {
    public DuplicateMemberException(String message) {
        super(message);
    }
}
