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
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;

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
    public ModelAndView login(ModelAndView mav, HttpSession session, Model model,
                              @RequestParam(value = "EMAIL2", required = false, defaultValue = "0") String id,
                              @RequestParam(value = "PWD2", required = false) String pwd,
                              @RequestParam(value = "PWD22", required = false) String pwd2,
                              @RequestParam(value = "NICKNAME2", required = false) String nickname) {
        System.out.println("--------홈------------");
        mav.addObject("users", loginUsers.size());
        try {
            Member name = (Member)session.getAttribute("mem");
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
    public ModelAndView main(Model model, String id, HttpServletResponse response, String saveId,
             String oldpwd, String pwd, String pwd2, String nickname, HttpSession session) {
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
                session.setMaxInactiveInterval(10);
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
                mav.setViewName("home");
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
            mav.setViewName("home");
        }
        mav.setViewName("home");
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
    public ModelAndView createroom(Model model, HttpSession session, String name, String pw) {
        ModelAndView mav = new ModelAndView();
        MainServer server = serverList.get(1);
        Room room = server.create();
        model.addAttribute("roomId", room.getID());
        model.addAttribute("roomPw", room.getPassword());
        mav.setViewName("createroom");
        return mav;
    }
}