package com.example;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import javax.servlet.http.HttpSession;
import java.util.Map;

public class SocketHandlerInterceptor implements HandshakeInterceptor {
    @Override   //                계정정보가져오기
    public boolean beforeHandshake(ServerHttpRequest serverHttpRequest, ServerHttpResponse serverHttpResponse, WebSocketHandler webSocketHandler, Map<String, Object> map) throws Exception {
        ServletServerHttpRequest request = (ServletServerHttpRequest) serverHttpRequest;
        HttpSession session = request.getServletRequest().getSession();

        map.put("session", session); //웹소켓에 http세션정보 넣기, 웹소켓에서도 http세션쓸수있게
        return true;
    }

    @Override
    public void afterHandshake(ServerHttpRequest serverHttpRequest, ServerHttpResponse serverHttpResponse, WebSocketHandler webSocketHandler, Exception e) {

    }
}
