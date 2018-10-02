package hello;

import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
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

