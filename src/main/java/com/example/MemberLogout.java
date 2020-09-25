package com.example;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class MemberLogout {
	private MemberDao memberDao;
	private JdbcTemplate jdbcTemplate;
	public MemberLogout(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	public void logout() {
		Member member = memberDao.selectByEmail(MemberLogin.loginEmail);
		System.out.println(MemberLogin.loginEmail + "님 로그아웃 되었습니다.");
		MainController.state = 0;
		
		KeyHolder keyHolder = new GeneratedKeyHolder();
		jdbcTemplate.update(new PreparedStatementCreator() {
			@Override
			public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
				PreparedStatement pstmt = con.prepareStatement(
						"insert into LOGINLOG(LOGINLOG_STATUS, LOGINLOG_REGDATE, MEMBER_NUMBER) values(?, ?, ?)", new String[] { "ID" });
				pstmt.setString(1, "Logout");
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