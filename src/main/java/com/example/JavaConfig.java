package com.example;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.tomcat.jdbc.pool.DataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

import java.util.HashMap;

@Configuration
public class JavaConfig {
    @Bean
    public DataSource dataSource() {
        DataSource ds = new DataSource();
        ds.setDriverClassName("com.mysql.jdbc.Driver");
        ds.setUrl("jdbc:mysql://localhost/zoomproject?characterEncoding=UTF-8&serverTimezone=UTC");
        ds.setUsername("zoomproject");
        ds.setPassword("zoomproject");
        ds.setInitialSize(2);
        ds.setMaxActive(10);
        ds.setTestWhileIdle(true);
        ds.setMinEvictableIdleTimeMillis(60000 * 3);
        ds.setTimeBetweenEvictionRunsMillis(10 * 1000);
        return ds;
    }

    @Bean
    public MemberDao memberDao() {
        return new MemberDao(dataSource());
    }
    
    @Bean
    public MemberRegisterService memberRegSvc() {
        return new MemberRegisterService(memberDao());
    }

    @Bean
    public checkIdPassword checkidpwd() {
        checkIdPassword checkidpwd = new checkIdPassword(dataSource());
        checkidpwd.setMemberDao(memberDao());
        return checkidpwd;
    }

    @Bean
    public MemberLogin lgn() {
        MemberLogin lgn = new MemberLogin(dataSource());
        lgn.setMemberDao(memberDao());
        return lgn;
    }

    @Bean
    public MemberLogout lgo() {
        MemberLogout lgo = new MemberLogout(dataSource());
        lgo.setMemberDao(memberDao());
        return lgo;
    }

    @Bean
    public ChangeInfoService changeInfoSvc(MemberDao memberDao) {
        ChangeInfoService changeInfoSvc = new ChangeInfoService();
        changeInfoSvc.setMemberDao(memberDao());
        return changeInfoSvc;
    }

    @Bean
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager tm = new DataSourceTransactionManager();
        tm.setDataSource(dataSource());
        return tm;
    }

    @Autowired
    ApplicationContext applicationContext;

    @Bean
    public ObjectMapper objectMapper()
    {
        return new ObjectMapper();
    }

    @Bean
    public HashMap<Integer, MainServer> ServerList() throws Exception {
        HashMap<Integer, MainServer> serverList = new HashMap<Integer, MainServer>();
        System.out.println("serverList");


        return serverList;
    }
}