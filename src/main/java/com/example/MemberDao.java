package com.example;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

public class MemberDao {
	private JdbcTemplate jdbcTemplate;
	public static int delaccount = 0;
	public MemberDao(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}
	public int count() {
		Integer count = jdbcTemplate.queryForObject("select count(*) from MEMBER", Integer.class);
		return count;
	}

	public RowMapper<Member> memRowMapper =
			new RowMapper<Member>() {
				@Override
				public Member mapRow(ResultSet rs, int rowNum) throws SQLException {
					// TODO Auto-generated method stub
					Member member = new Member(rs.getString("member_email"),
							rs.getString("member_password"),
							rs.getString("member_nickname"),
							rs.getTimestamp("member_regdate")
					);
					member.setId(rs.getLong("member_number"));
					return member;
				}
			};
	
	public Member selectByEmail(String email) {
		List<Member> results = jdbcTemplate.query("select * from MEMBER where member_email LIKE ?", memRowMapper, email);
		return results.isEmpty() ? null : results.get(0);
	}
	
	public Member selectByNickname(String nickname) {
		List<Member> results = jdbcTemplate.query("select * from MEMBER where member_nickname LIKE ?", memRowMapper, nickname);
		return results.isEmpty() ? null : results.get(0);
	}

	public List<Member> selectAll(){
		List<Member> results = jdbcTemplate.query("select * from MEMBER",
				(ResultSet rs, int rowNum) -> {
					Member member = new Member(rs.getString("member_email"),
							rs.getString("member_password"),
							rs.getString("member_nickname"),
							rs.getTimestamp("member_regdate")
					);
					member.setId(rs.getLong("ID"));
					return member;
				});
		return results;
	}
	
	public void update(Member member) {
		jdbcTemplate.update("update MEMBER set member_password = ?, member_nickname = ? where member_email LIKE ?",
				member.getPassword(), member.getNickname(), member.getEmail());
	}

	public void insert(final Member member) {
		KeyHolder keyHolder = new GeneratedKeyHolder();
		jdbcTemplate.update(new PreparedStatementCreator() {
			@Override
			public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
				PreparedStatement pstmt = con.prepareStatement(
						"insert into MEMBER(member_email, member_password, member_nickname, member_regdate) values(?, ?, ?, ?)", new String[] { "ID" });
				pstmt.setString(1, member.getEmail());
				pstmt.setString(2, member.getPassword());
				pstmt.setString(3, member.getNickname());
				pstmt.setString(4, LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
				return pstmt;
			}
		}, keyHolder);
		Number keyValue = keyHolder.getKey();
		member.setId(keyValue.longValue());
	}
	
	public void delete(String email, String password) {
		jdbcTemplate.update("delete from MEMBER where member_email LIKE ?", email);
		System.out.println(email + "님의 계정과 메모가 삭제 되었습니다.");
		delaccount = 1;
	}
	
	public List<Member> findpwd(String email, String nickname) {
		System.out.println("findpwd안");
		return jdbcTemplate.query("select * from MEMBER WHERE member_email LIKE ? AND member_nickname LIKE ?",
				(ResultSet rs, int rowNum) -> {
					Member member = new Member(rs.getString("member_email"),
							rs.getString("member_password"),
							rs.getString("member_nickname"),
							rs.getTimestamp("member_regdate"));
					member.setId(rs.getLong("member_number"));
			return member;
		}, email, nickname);
	}
}