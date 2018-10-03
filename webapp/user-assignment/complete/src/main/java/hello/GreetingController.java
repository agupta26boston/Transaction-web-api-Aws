package hello;

import java.nio.charset.Charset;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;
import java.util.regex.Pattern;

//import netscape.javascript.JSObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.mindrot.jbcrypt.BCrypt;


import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RestController
public class GreetingController {

    private static final String template = "Hello, %s!";
    private final AtomicLong counter = new AtomicLong();
    private User loggedInUser;

    @Autowired
    private GreetingService greetingService;
    @Autowired
    private UserRepository userRepository;



//    @RequestMapping("/")
//    public void check(HttpServletResponse response){
//
//        System.out.println(" "+response.getStatus());
//        if (response.getStatus()!=200)
//        {
//
//            System.out.println("I am not logged in" );
//
//        }
//    }

    @RequestMapping("/time")
    public String greeting(HttpServletRequest request,HttpServletResponse response)

    {

        String check = request.getHeader("Authorization");

        System.out.println("" +check);

        if(check==null)
      {
         return  "You are not logged in";

      }
      // check if the user is in the system


            return "" +LocalDateTime.now();

    }

    @RequestMapping(value= "/login",method=RequestMethod.GET,produces = "application/json")
    public void userLogin(HttpServletRequest request,HttpServletResponse response)
    {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Basic")) {
            String base64Credentials = authorization.substring("Basic".length()).trim();
            String credentials = new String(Base64.getDecoder().decode(base64Credentials), Charset.forName("UTF-8"));
            // credentials = username:password
            final String[] values = credentials.split(":", 2);
            User user =(User) userRepository.findUserByEmailId(values[0]);
            System.out.println(userRepository.findUserByEmailId(values[0]));
            System.out.println("the values array is"+values[0]+ " "+values[1]);
            if (user != null) {
                //compare the password
                String salt= BCrypt.gensalt(12);
                String p1 = user.getPassword();
                String p2=BCrypt.hashpw(values[1],salt);
                System.out.println(p1+"+"+p2);
                Boolean authenticated=p1.equals(p2);
                loggedInUser=user;
                System.out.println(" login");
            }
        }
    }



    @RequestMapping("/user")
    public List<User> getAllUsers(){

//        String check= request.getHeader("user-agent");
//        System.out.println(check);
        return greetingService.getAllGreetings();
    }

    @RequestMapping(value="/user/register" ,method=RequestMethod.POST,produces = "application/json")
    public String addUser(@RequestBody User member){

        System.out.println("" +member.getEmailId());

        String email=member.getEmailId();

        if(!isValid(member.getEmailId())){
            return "invalid email address";
        }

        if(userRepository.findUserByEmailId(email)==null){
            User loginigMember = new User();
            String salt= BCrypt.gensalt(12);
            loginigMember.setPassword(BCrypt.hashpw(member.getPassword(),salt));
            loginigMember.setEmailId(member.getEmailId());
            userRepository.save(loginigMember);

            return "new user added successfully";

        }
        else {
            return  "You are in the system";
        }
    }
    @RequestMapping("/transactions")
    public void displayTransactions(@RequestBody User member){
        System.out.println("displaying all the transactions for the use");
    }


    public static boolean isValid(String email)
    {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\."+
                "[a-zA-Z0-9_+&*-]+)*@" +
                "(?:[a-zA-Z0-9-]+\\.)+[a-z" +
                "A-Z]{2,7}$";

        Pattern pat = Pattern.compile(emailRegex);
        if (email == null)
            return false;
        return pat.matcher(email).matches();
    }

    }

