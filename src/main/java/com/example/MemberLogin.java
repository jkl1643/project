package com.example;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import javax.sql.DataSource;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class MemberLogin { //이메일과 암호 입력해서 이메일이 있고 이메일과 암호가 일치하면 로그인완료
    private MemberDao memberDao;
    public static String loginEmail;
    private JdbcTemplate jdbcTemplate;

    public MemberLogin(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public void login(String email, String inputPassword) throws IOException {
        loginEmail = email;
        Member member = memberDao.selectByEmail(email);
        if (member == null)
            throw new MemberNotFoundException();
        member.checkLogin(email, inputPassword);
        MainController.state = 1; //여기들어가면 State=1
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement pstmt = con.prepareStatement(
                        "insert into LOGINLOG(LOGINLOG_STATUS, LOGINLOG_REGDATE, MEMBER_NUMBER) values(?, ?, ?)", new String[]{"member_number"});
                pstmt.setString(1, "Login");
                pstmt.setString(2, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                pstmt.setLong(3, member.getId());
                return pstmt;
            }
        }, keyHolder);
        Number keyValue = keyHolder.getKey();
        member.setId(keyValue.longValue());
    }

    public void setMemberDao(MemberDao memberDao) {
        this.memberDao = memberDao;
    }
}
