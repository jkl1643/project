package com.example;

public class ChangeInfoService {
	private MemberDao memberDao;
	public void changePassword(String email, String oldPwd, String newPwd, String newPwd2, String nickname) {
		Member member = memberDao.selectByEmail(email);

		if (member == null) {
			throw new MemberNotFoundException();
		} else if (!newPwd.equals(newPwd2)) {
			throw new PasswordNotMatchException();
		}

		if (!oldPwd.equals(member.getPassword())) {
			throw new PasswordNotMatchException2();
		}

		if (newPwd.isEmpty()) {
		} else {
			member.changePassword(oldPwd, newPwd);
			memberDao.update(member);
		}

		if (nickname.isEmpty()) {
		} else {
			member.changeNickname(nickname);
			memberDao.update(member);
		}
	}
	
	public void setMemberDao(MemberDao memberDao) {
		this.memberDao = memberDao;
	}
}