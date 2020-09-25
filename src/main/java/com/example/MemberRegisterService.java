package com.example;


public class MemberRegisterService {
    private MemberDao memberDao; //DB에 업데이트 시키기위해 Dao가 필요

    public MemberRegisterService(MemberDao memberDao) { //Dao에 대한정보를 여기통해서 주입
        this.memberDao = memberDao;
    }

    public Long regist(RegisterRequest req) {
        Member member = memberDao.selectByEmail(req.getEmail()); //이메일 중복확인용
        if (member != null) { //같은이메일이있다
            throw new DuplicateMemberException("dup email " + req.getEmail());
        }
        Member newMember = new Member(req.getEmail(), req.getPassword(), req.getNickname(), req.getRegisterDate()); //맴버객체를 만듬 new Date()
        memberDao.insert(newMember); //Dao에 삽입
        return newMember.getId();
    }
}