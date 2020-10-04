package com.example;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

@Configuration
@EnableWebSocket
public class SocketConfig implements WebSocketConfigurer {
    @Autowired
    SocketHandler socketHandler;
    private Object CamHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(socketHandler, "/game").addInterceptors(new SocketHandlerInterceptor());
        registry.addHandler(new CamHandler(), "/socket").setAllowedOrigins("*");
        System.out.println("소켓 핸들러");
    }
}
