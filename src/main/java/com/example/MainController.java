package com.example;

//import com.sun.org.apache.xpath.internal.operations.Mod;

import org.python.util.PythonInterpreter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@Controller
public class MainController {
    private static final ApplicationContext ctx = new AnnotationConfigApplicationContext(JavaConfig.class);
    public static int login = 0;
    public static int delaccount = 0;
    public static int delmemo = 0;
    public static int editaccount = 0;
    public static String userid2 = null;
    public static String userNickname = null;
    public static int state = 1;
    public static Hashtable loginUsers = new Hashtable();
    public static MainServer server;
    private static PythonInterpreter interpreter;

    @Autowired
    private HashMap<Integer, MainServer> serverList;

    @Autowired
    private MemberDao memberDao;
    public void setMemberDao(MemberDao memberDao) {
        this.memberDao = memberDao;
    }

    @RequestMapping("/editaccount2")
    public ModelAndView editaccount2(ModelAndView mav, Model model, String id, String saveId,
                                    String oldpwd, String pwd, String pwd2, String nickname) {
        mav.addObject("unknown_email", false);
        mav.addObject("email_pwd_match", false);
        mav.addObject("email_pwd_match2", false);
        mav.addObject("logout", false);
        mav.addObject("delaccount", false);
        mav.addObject("wrongemail", false);
        mav.addObject("created_account", false);
        mav.addObject("error", false);
        mav.addObject("users", loginUsers.size());
        mav.addObject("loginduplicate", false);
        mav.addObject("login", 1);
        mav.addObject("editaccount", false);
        mav.addObject("chkpwd", false);
        mav.addObject("currentpwd", false);

        ChangeInfoService changeInfoSvc = ctx.getBean("changeInfoSvc", ChangeInfoService.class);
        try {
            editaccount = 0;
            changeInfoSvc.changePassword(userid2, oldpwd, pwd, pwd2, nickname);
            System.out.println("정보를 수정했습니다.\n");
            mav.addObject("editaccount", true);
        } catch (MemberNotFoundException e) {
            System.out.println("존재하지 않는 이메일입니다.\n");
            editaccount = 0;
        } catch (WrongIdPasswordException e) {
            System.out.println("이메일과 암호가 일치하지 않습니다.\n");
            editaccount = 0;
        } catch (PasswordNotMatchException e) {
            System.out.println("확인 비밀번호가 일치하지 않습니다.");
            mav.addObject("chkpwd", true);
            editaccount = 0;
        } catch (PasswordNotMatchException2 e) {
            System.out.println("현재 비밀번호가 일치하지 않습니다.");
            mav.addObject("currentpwd", true);
            editaccount = 0;
        }

        mav.setViewName("home");
        return mav;
    }

	@RequestMapping("/logout")
    public ModelAndView logout(ModelAndView mav, HttpSession session, Model model) {
        mav.addObject("unknown_email", false);
        mav.addObject("email_pwd_match", false);
        mav.addObject("email_pwd_match2", false);
        mav.addObject("logout", false);
        mav.addObject("delaccount", false);
        mav.addObject("wrongemail", false);
        mav.addObject("created_account", false);
        mav.addObject("error", false);
        mav.addObject("users", loginUsers.size());
        mav.addObject("loginduplicate", false);
        Member name = (Member)session.getAttribute("mem");
        login = 0;
        try {
            if (login == 0) {
                mav.addObject("login", 0);
            } else {
                mav.addObject("login", 1);
            }
            System.out.println("로그아웃 = " + login);

            MemberLogout lgo = ctx.getBean("lgo", MemberLogout.class);
            mav.addObject("loginduplicate", false);
            mav.addObject("logout", true);
            lgo.logout();
            Enumeration e = loginUsers.keys();
            while (e.hasMoreElements()) {
                String a = (String) e.nextElement();
                System.out.println("loginuser = " + loginUsers.get(a));
                if (loginUsers.get(a).equals(name.getEmail())) {
                    loginUsers.remove(name.getEmail());
                    System.out.println(" " + name.getEmail() + "해쉬 사라짐");
                    session.invalidate();
                }
            }
        } catch (Exception e){

        }
        mav.setViewName("home");
        return mav;
    }

    @RequestMapping("/home")
    public ModelAndView login(ModelAndView mav, HttpSession session, Model model, HttpServletResponse response,
                              @RequestParam(value = "EMAIL2", required = false, defaultValue = "0") String id,
                              @RequestParam(value = "PWD2", required = false) String pwd,
                              @RequestParam(value = "PWD22", required = false) String pwd2,
                              @RequestParam(value = "NICKNAME2", required = false) String nickname) throws IOException {
        System.out.println("--------홈------------");
        mav.addObject("users", loginUsers.size());
        try {
            Member mem = (Member)session.getAttribute("mem");
            if(mem != null){
                mav.setViewName("main");
                return mav;
            }
            login = 0;
        } catch (Exception e) {
            login = 1;
        }


        mav.addObject("unknown_email", false);
        mav.addObject("email_pwd_match", false);
        mav.addObject("email_pwd_match2", false);
        mav.addObject("logout", false);
        mav.addObject("delaccount", false);
        mav.addObject("wrongemail", false);
        mav.addObject("created_account", false);
        mav.addObject("error", false);
        mav.addObject("id", id);
        mav.addObject("loginduplicate", false);
        mav.addObject("editaccount", false);
        mav.addObject("chkpwd", false);
        mav.addObject("currentpwd", false);


        /*interpreter = new PythonInterpreter();
        interpreter.exec("from java.lang import System");
        interpreter.exec("System.out.println('hi')");
        interpreter.execfile("C:/Users/Yu/Desktop/cam.py");*/

        if(login == 0) {
            mav.addObject("login", 0);
        } else {
            mav.addObject("login", 1);
        }
        System.out.println("login = " + login);
        System.out.println("delaccount = " + delaccount);

        RegisterRequest req = new RegisterRequest();

        if (login != 1 && delaccount != 1) {
            req.setEmail(id);
            req.setNickname(nickname);
            req.setPassword(pwd);
            req.setConfirmPassword(pwd2);
        }

        if (!id.equals("0")) { //회원가입 아아디에 값을 입력했을때
            if (!req.isPasswordEqualToConfirmPassword()) {
                mav.setViewName("home");
                mav.addObject("email_pwd_match", true);
                System.out.println("암호와 확인이 일치하지 않습니다.\n");
                return mav;
            }
            //회원가입 정보들을 입력하지 않앗을때
            if (id.isEmpty() || pwd.isEmpty() || pwd2.isEmpty() || nickname.isEmpty()) {
                mav.addObject("error", true);
                mav.setViewName("home");
                return mav;
            }

            try {
                MemberRegisterService memberRegSvc = ctx.getBean("memberRegSvc", MemberRegisterService.class);
                memberRegSvc.regist(req); //회원가입
                Member member2 = memberDao.selectByEmail(id);
                mav.addObject("created_account", true);
            } catch (DuplicateMemberException e) {
                mav.addObject("error", true);
                System.out.println("이미 존재하는 이메일입니다.\n");
            } catch (Exception e) {
                mav.addObject("error", true);
            }
            MemberLogin.loginEmail = id;
            System.out.println("계정생성 = " + id);
            id = "0";
            req.setEmail("0");
            mav.setViewName("home");
            return mav;
        } else {
            mav.setViewName("home");
        }
        id = "0";
        return mav;
    }

    @RequestMapping("/newaccount")
    public ModelAndView newaccount(ModelAndView mav) {
        mav.setViewName("newaccount");
        return mav;
    }

    @RequestMapping("/main")
    public ModelAndView main(Model model,
                             @RequestParam(value = "loginId", required = false) String id,
                             @RequestParam(value = "loginPw", required = false) String pwd,
                             HttpServletResponse response, String saveId,
             String oldpwd, String pwd2, String nickname, HttpSession session) {
        System.out.println("-------------메인 ----------------");
        ModelAndView mav = new ModelAndView();
        mav.addObject("unknown_email", false);
        mav.addObject("email_pwd_match", false);
        mav.addObject("email_pwd_match2", false);
        mav.addObject("logout", false);
        mav.addObject("delaccount", false);
        mav.addObject("wrongemail", false);
        mav.addObject("select_date", false);
        mav.addObject("insert_memo", false);
        mav.addObject("created_account", false);
        mav.addObject("delmemo", false);
        mav.addObject("currentpwd", false);
        mav.addObject("editaccount", false);
        mav.addObject("chkpwd", false);
        mav.addObject("created_memo", false);
        mav.addObject("error", false);
        mav.addObject("login", 0);
        mav.addObject("loginduplicate", false);
        mav.addObject("users", loginUsers.size());

        Member name2 = (Member)session.getAttribute("mem");
        Member member = memberDao.selectByEmail(id);
        MemberLogin lgn = ctx.getBean("lgn", MemberLogin.class);

        if(name2 == null){
            Enumeration en = loginUsers.keys();
            while (en.hasMoreElements()) {
                String key = en.nextElement().toString();
                System.out.println(key + " : " + loginUsers.get(key));
                if (key.equals(member.getEmail())) {
                    try {
                        lgn.login(id, pwd);
                        loginUsers.put(id, id);
                        session.setAttribute("mem", member);
                    } catch (Exception e){
                        System.out.println("에러");
                    }
                }
            }
        }
        session.setAttribute("idid", id);
        delaccount = 0;
        model.addAttribute("userid", id);

        System.out.println("delaccount = " + delaccount);
        System.out.println("delmemo = " + delmemo);
        System.out.println("editaccount = " + editaccount);

        if(login == 1) {
            mav.addObject("id2", id);
        }

        name2 = (Member)session.getAttribute("mem");
        String idid = (String) session.getAttribute("idid");
        if (name2 == null) { //이전에 로그인 한적이 없을때
            Member name = (Member) session.getAttribute("mem");
            System.out.println("name = " + name);

            Enumeration en = loginUsers.keys();
            while (en.hasMoreElements()) {
                String key = en.nextElement().toString();
                System.out.println(key + " : " + loginUsers.get(key));
                if (key.equals(member.getEmail())) {
                    mav.addObject("loginduplicate", true);
                    mav.setViewName("home");
                    return mav;
                }
            }

            System.out.println("해쉬테이블 인원 : " + String.valueOf(loginUsers.size()));
            mav.addObject("users", loginUsers.size());

            try {
                lgn.login(id, pwd); //로그인
                loginUsers.put(id, id);
                session.setAttribute("mem", member);
                //session.setMaxInactiveInterval(10);
                mav.addObject("login", 1);
                System.out.println("id = " + id + ", pwd = " + pwd);
                userid2 = MemberLogin.loginEmail;
                userNickname = nickname;
                model.addAttribute("userid", userid2);
                login = 1; //로그인을했을때
                if (saveId != null) {
                    Cookie cookie = new Cookie("saveId", id);
                    response.addCookie(cookie);
                }
                mav.setViewName("main");
            } catch (MemberNotFoundException e) {
                System.out.println("존재하지 않는 이메일입니다.2\n");
                mav.addObject("unknown_email", true);
                id = "0";
                mav.setViewName("home");
            } catch (WrongIdPasswordException e) {
                System.out.println("이메일과 암호가 일치하지 않습니다.\n");
                mav.addObject("email_pwd_match", true);
                id = "0";
                mav.setViewName("home");
            } catch (IOException e) {
                id = "0";
                mav.setViewName("home");
            } catch (NullPointerException e) {
                id = "0";
                mav.setViewName("home");
            }
        } else {
            mav.setViewName("main");
        }
        //mav.setViewName("home");
        return mav;
    }

    @RequestMapping("/delaccount")
    public ModelAndView delaccount(Model model, String id, String pwd) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("email_pwd_match2", false);
        delaccount = 1;
        mav.addObject("wrongemail", false);
        mav.setViewName("delaccount");
        return mav;
    }

    @RequestMapping("/checkdelaccount")
    public ModelAndView checkdelaccount(Model model, String delid, String delpwd) {
        ModelAndView mav = new ModelAndView();
        mav.addObject("email_pwd_match2", false);
        mav.addObject("wrongemail", false);
        if (delaccount == 1) {
            checkIdPassword checkidpwd = ctx.getBean("checkidpwd", checkIdPassword.class);
            System.out.println("아디 = " + delid + "비번 = " + delpwd);
            try {
                checkidpwd.checkidpassword(delid, delpwd);
                MemberDao memberDao = ctx.getBean("memberDao", MemberDao.class);
                memberDao.delete(delid, delpwd);
                mav.addObject("delaccount", true);
                login = 0;
                delaccount = 0;
                mav.setViewName("home");
            } catch (MemberNotFoundException e) {
                mav.setViewName("delaccount");
                mav.addObject("wrongemail", true);
                System.out.println("잘못된 아이디 입력입니다.");
                return mav;
            } catch (WrongIdPasswordException e) {
                mav.setViewName("delaccount");
                mav.addObject("email_pwd_match2", true);
                System.out.println("아이디와 비밀번호가 일치하지 않습니다.");
                return mav;
            } catch (NotMatchException e) {
                mav.setViewName("delaccount");
                mav.addObject("wrongemail", true);
                System.out.println("잘못된 아이디 입력입니다.");
                return mav;
            }
        }
        mav.setViewName("checkdelaccount");
        delaccount = 0;
        return mav;
    }

    @RequestMapping("/editaccount")
    public ModelAndView editaccount(Model model) {
        ModelAndView mav = new ModelAndView();
        editaccount = 1;
        System.out.println("userid22 = " + userid2);
        model.addAttribute("userid", userid2);
        model.addAttribute("userpassword", userNickname);
        mav.setViewName("editaccount");
        return mav;
    }

    @RequestMapping("/findaccount")
    public ModelAndView findaccount(Model model) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("findaccount");
        return mav;
    }

    @RequestMapping("/findpwd")
    public ModelAndView findpwd(Model model, String id, String nickname) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("findpwd");
        return mav;
    }

    @RequestMapping("/resultfindpwd")
    public ModelAndView resultfindpwd(Model model, String id, String nickname) {
        ModelAndView mav = new ModelAndView();
        List<Member> results2 = memberDao.findpwd(id, nickname);
        model.addAttribute("result", results2);
        Member member = memberDao.selectByEmail(id);
        try {
            mav.addObject("realemail", member.getEmail());
        } catch (Exception e){
            mav.addObject("realemail", "0");
        }
        mav.addObject("inputid", id);

        try {
            mav.addObject("realnickname", member.getNickname());
        } catch (Exception e){
            mav.addObject("realnickname", "/*987/");
        }
        mav.addObject("inputnickname", nickname);
        mav.setViewName("resultfindpwd");
        return mav;
    }

    @RequestMapping("/gamescreen")
    public ModelAndView gamescreen(Model model) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("gamescreen");
        return mav;
    }

    @RequestMapping("/createroom")
    public ModelAndView createroom(Model model, HttpSession session, HttpServletResponse response, String name, String pw) throws IOException {
        ModelAndView mav = new ModelAndView();
        System.out.println("------------createroom------------");
        Member mem = (Member) session.getAttribute("mem");

        /*serverList.put(mem.getId().intValue(), new MainServer());*/
        //serverList.put(1, new MainServer());

        /*MainServer server = serverList.get(mem.getId().intValue());*/
        //MainServer server = serverList.get(1);
        Room room2 = (Room) session.getAttribute("room");
        if((Member)session.getAttribute("mem") == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('로그인이 필요합니다.'); location.href='home';</script>");
            out.flush();
            return mav;
        }
        if(room2 == null){ //여기 세션에서 방이 만들어지지않았을때
            //serverList.put(1, new MainServer());
            serverList.put(16, new MainServer());
            System.out.println("서버리스트밸류 : " + serverList.values());
            MainServer server = serverList.get(16);
            Room room = server.create();

            model.addAttribute("roomId", room.getID());
            model.addAttribute("roomPw", room.getPassword());
            session.setAttribute("create", "create");
            session.setAttribute("room", room);
            System.out.println("만든사람1 방번호 : " + room.getID() + ", 비밀번호 : " + room.getPassword() + ", 서버 : " + serverList.get(mem.getId().intValue()));
            model.addAttribute("User_list", server.getUser_nick().keySet());
            Set<String> keys2 = server.getUser_nick().keySet();
            for (String key : keys2) {
                System.out.println("유저44 : " + key);
            }
            System.out.println("id1 : " + room.getID() + ", pw1 : " + room.getPassword());
            return joinroom(model, session, response, mem.getNickname(), room.getID(), room.getPassword());
        } else {

        }

        //이 세션에서 방이 만들어진적있을때
        System.out.println("return");
        System.out.println("id11 : " + room2.getID() + ", pw11 : " + room2.getPassword());
        return joinroom(model, session, response, mem.getNickname(), room2.getID(), room2.getPassword());
    }

    @RequestMapping("/joinroom")
    public ModelAndView joinroom(Model model, HttpSession session, HttpServletResponse response, String name,
                                 @RequestParam(value = "roomId", required = false) String ID,
                                 @RequestParam(value = "roomPw", required = false) String PW) throws IOException {
        ModelAndView mav = new ModelAndView();
        System.out.println("-----------joinroom---------");

        if((Member)session.getAttribute("mem") == null) {
            response.setContentType("text/html; charset=UTF-8");
            PrintWriter out = response.getWriter();
            out.println("<script>alert('로그인이 필요합니다.'); location.href='home';</script>");
            out.flush();
            return mav;
        }
        Member mem = (Member) session.getAttribute("mem");
        Room room = (Room) session.getAttribute("room");
        model.addAttribute("username", mem.getNickname());
        try {
            for (Integer key : serverList.keySet()) {
                server = serverList.get(key);
                System.out.println("리스트 : " + key + String.valueOf(key));
                System.out.println("리스트2 : " + server.getRoom_list());
                //key랑 비교해야지
                System.out.println("server.getRoom_list().get(key.toString()).getID() : " + server.getRoom_list().get(ID).getID() + ", ID : " + ID);
                if (server.getRoom_list().get(ID).getID().equals(ID)) {
                    break;
                } else {
                }
            }
        } catch (Exception e){

        }
        server = serverList.get(16);
        //MainServer server =
        //MainServer server = serverList.get(mem.getId().intValue()); //서버번호를 서버 고유아이디로해야할듯
        //MainServer server = serverList.get(mem.getId().intValue());
        if(room == null) { //이 세션에서 방만들어진적없을때 방입장으로 들어갔을때
            System.out.println("아이디 : " + server.getRoom_list().get(ID) + "ID : " + ID);
            if (ID.equals(server.getRoom_list().get(ID).getID())) {
                System.out.println("방번호같음 : ");
                session.setAttribute("roomid", ID);
                session.setAttribute("roompw", PW);
                if(name == null) {
                    name = mem.getNickname();
                }
                server.select(ID, PW, name);
                model.addAttribute("User_list", server.getUser_nick().keySet());
                System.out.println("id2 : " + ID + ", pw2 : " + PW);
                mav.setViewName("c");
                return mav;
            }
        } else { //방생성으로 들어갔을때
            session.setAttribute("roomid", ID);
            session.setAttribute("roompw", PW);
            server.select(room.getID(), room.getPassword(), mem.getNickname());
            model.addAttribute("User_list", server.getUser_nick().keySet());
            mav.setViewName("c");
            System.out.println("id3 : " + room.getID() + ", pw3 : " + room.getPassword());
            return mav;
        }
        System.out.println("ID : " + ID + ", PW : " + PW);

        /*if(name == null)
            name = mem.getNickname();
        server.select(ID, PW, name); //방생성한 번호 비번으로 만들기랑 방번호 방비번 입력해서 하는걸로 조건

        System.out.println("만든사람2 방번호 : " + ID + ", 비밀번호 : " + PW + ", name : " + name);
        model.addAttribute("User_list", server.getUser_nick().keySet());
        System.out.println("유저ㅓㅓ");
        Set<String> keys2 = server.getUser_nick().keySet();
        for (String key : keys2) {
            System.out.println("유저444 : " + key);
        }
        mav.setViewName("createroom");*/
        return mav;
    }
    @GetMapping("/refreshuserlist")
    public ModelAndView RefreshUserlist(Model model, HttpSession session) {
        ModelAndView mav = new ModelAndView();
        Member mem = (Member) session.getAttribute("mem");
        Room room = (Room) session.getAttribute("room");
        //String roomid = (String)
        //MainServer Server = serverList.get(mem.getId().intValue());
        MainServer Server = serverList.get(16);
        /*try {
            for (Integer key : serverList.keySet()) {
                server = serverList.get(key);
                System.out.println("리스트 : " + key + String.valueOf(key));
                System.out.println("리스트2 : " + server.getRoom_list());
                //key랑 비교해야지
                System.out.println("server.getRoom_list().get(key.toString()).getID() : " + server.getRoom_list().get(room.getID()).getID() + ", ID : " + room.getID());
                if (server.getRoom_list().get(room.getID()).getID().equals(room.getID())) {
                    break;
                } else {
                }
            }
        } catch (Exception e){

        }*/

        model.addAttribute("User_list", Server.getUser_nick().keySet());
        mav.setViewName("Game_userlist"); // room 만든후 .
        return mav;
    }

    @GetMapping("/cam")
    public ModelAndView cam(Model model){
        ModelAndView mav = new ModelAndView();

        mav.setViewName("cam");
        return mav;
    }

}