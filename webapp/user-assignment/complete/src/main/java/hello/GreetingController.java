package hello;

import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Base64;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.atomic.AtomicLong;
import java.util.regex.Pattern;

//import netscape.javascript.JSObject;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.util.JSONPObject;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Profile;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;


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

    @Autowired
    private TransactionRepository transactionRepository;

    @Autowired
    private AttachementRepository attachementRepository;


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
    public String greeting(HttpServletRequest request, HttpServletResponse response) {


        String check = request.getHeader("Authorization");

        System.out.println("" + check);

        if (check == null) {
            //  response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return "You are not logged in";

        }
        // check if the user is in the system


        return "" + LocalDateTime.now() + " " + response.getStatus();

    }

    @RequestMapping(value = "/login", method = RequestMethod.GET, produces = "application/json")
    public void userLogin(HttpServletRequest request, HttpServletResponse response) {
        String authorization = request.getHeader("Authorization");
        if (authorization != null && authorization.startsWith("Basic")) {
            String base64Credentials = authorization.substring("Basic".length()).trim();
            String credentials = new String(Base64.getDecoder().decode(base64Credentials), Charset.forName("UTF-8"));
            // credentials = username:password
            final String[] values = credentials.split(":", 2);
            User user = userRepository.findUserByEmailId(values[0]);
            System.out.println(user);
            System.out.println("the values array is" + values[0] + " " + values[1]);
            if (user != null) {
                //compare the password
                String salt = BCrypt.gensalt(12);
                String p1 = user.getPassword();
                String p2 = BCrypt.hashpw(values[1], salt);
                System.out.println(p1 + "+" + p2);
                Boolean authenticated = p1.equals(p2);
                loggedInUser = user;
                System.out.println(" login");
            }
        }
    }

    @RequestMapping(value = "/gt", method = RequestMethod.GET, produces = "application/json")
    public ResponseEntity<String> getTransaction(HttpServletRequest request, HttpServletResponse response) throws JsonProcessingException {
        if (loggedInUser != null) {
            List<Transaction> transactionList = transactionRepository.findTransactionByUserUserId(loggedInUser.getUserId());


            ObjectMapper mapperObj = new ObjectMapper();
            String JSON = mapperObj.writeValueAsString(transactionList);
            System.out.println(JSON);


            return new ResponseEntity<String>(JSON, HttpStatus.OK);
        }

        return new ResponseEntity<String>("UnAuthorized", HttpStatus.UNAUTHORIZED);

    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET, produces = "application/json")
    public String logout(HttpServletRequest request, HttpServletResponse response) throws JsonProcessingException {
        loggedInUser = null;

        return "User Logged out";
    }


    @RequestMapping(value = "/transaction/{id}", method = RequestMethod.PUT, produces = "application/json")
    public ResponseEntity<String> updateTransaction(@PathVariable("id") String transactionId, HttpServletResponse response, @RequestBody Transaction transaction) throws IOException {
        if (loggedInUser != null) {
            if (transactionRepository.findTransactionByTransactionId(transactionId) != null) {
                Transaction got = transactionRepository.findTransactionByTransactionId(transactionId);
                transaction.setTransactionId(got.getTransactionId());
                transaction.setUser(loggedInUser);
                got = transaction;

                transactionRepository.save(got);
                ObjectMapper mapperObj = new ObjectMapper();
                String JSON = mapperObj.writeValueAsString(transaction);

                return new ResponseEntity<String>("Created"+JSON, HttpStatus.CREATED);
                //return JSON;


            } else {
                return new ResponseEntity<String>("Bad Request", HttpStatus.BAD_REQUEST);
            }

        } else {
            return new ResponseEntity<String>("Unauthorized", HttpStatus.UNAUTHORIZED);
        }


    }
    @RequestMapping(value = "/transaction/{id}/attachment/{attachmentId}", method = RequestMethod.PUT, produces = "application/json")
    public ResponseEntity<String> updateAttachment(@PathVariable("id") String transactionId, @PathVariable("attachmentId") String attachmentId, @RequestPart(value = "file") MultipartFile file) throws IOException {
        if (loggedInUser != null) {
            if (transactionRepository.findTransactionByTransactionId(transactionId) != null) {
                Transaction got = transactionRepository.findTransactionByTransactionId(transactionId);
                 if(attachementRepository.findAttachmentByAttachmentId(attachmentId) != null) {

                     Attachment existingAttachment = attachementRepository.findAttachmentByAttachmentId(attachmentId);
                     System.out.println("attachment"+existingAttachment.getUrl());
                     byte[] bytes = new byte[0];
                     bytes = file.getBytes();
                     Path path = Paths.get("\\META-INF.resources\\images\\" + file.getOriginalFilename());
                     //write the file to the correct place
                     Files.write(path, bytes);
                     existingAttachment.setUrl(path.toString());
                     attachementRepository.save(existingAttachment);

                     ObjectMapper mapperObj = new ObjectMapper();
                     String JSON = mapperObj.writeValueAsString(existingAttachment);

                     return new ResponseEntity<String>("Created"+JSON, HttpStatus.CREATED);

                 }
                 else {
                     return new ResponseEntity<String>("Bad Request: No attachment", HttpStatus.BAD_REQUEST);
                 }

            } else {
                return new ResponseEntity<String>("Bad Request: no transaction", HttpStatus.BAD_REQUEST);
            }

        } else {
            return new ResponseEntity<String>("Unauthorized", HttpStatus.UNAUTHORIZED);
        }


    }

    @RequestMapping(value = "/transaction/{id}", method = RequestMethod.DELETE, produces = "application/json")
    public ResponseEntity<String> deleteTransaction(@PathVariable("id") String transactionId, HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (loggedInUser == null) {
            return new ResponseEntity<String>("Unauthorized", HttpStatus.UNAUTHORIZED);

        } else if (loggedInUser != null) {

            if (transactionRepository.findTransactionByTransactionId(transactionId) != null) {

                transactionRepository.deleteById(transactionId);

                return new ResponseEntity<String>("NO COntent", HttpStatus.NO_CONTENT);
            } else {
                return new ResponseEntity<String>("Bad request", HttpStatus.BAD_REQUEST);

            }
        }


        return null;
    }
    @RequestMapping(value = "/transaction/{id}/attachment/{attachmentid}", method = RequestMethod.DELETE, produces = "application/json")
    public ResponseEntity<String> deleteAttachment(@PathVariable("id") String transactionId, @PathVariable("attachmentid") String attachmentId, HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (loggedInUser == null) {
            return new ResponseEntity<String>("Unauthorized", HttpStatus.UNAUTHORIZED);

        } else if (loggedInUser != null) {
            if (transactionRepository.findTransactionByTransactionId(transactionId) != null) {

                 if (attachementRepository.findAttachmentByAttachmentId(attachmentId)!= null) {
                     attachementRepository.deleteById(attachmentId);
                     return new ResponseEntity<String>("NO COntent", HttpStatus.NO_CONTENT);
                 }
                 else {
                     return new ResponseEntity<String>("Bad request", HttpStatus.BAD_REQUEST);
                 }

            } else {
                return new ResponseEntity<String>("Bad request", HttpStatus.BAD_REQUEST);

            }
        }


        return null;
    }

    @RequestMapping("/user")
    public List<User> getAllUsers() {

//        String check= request.getHeader("user-agent");
//        System.out.println(check);
        return greetingService.getAllGreetings();
    }

    @RequestMapping(value = "/user/register", method = RequestMethod.POST, produces = "application/json")
    public String addUser(@RequestBody User member) {

        System.out.println("" + member.getEmailId());

        String email = member.getEmailId();

        if (!isValid(member.getEmailId())) {
            return "invalid email address";
        }

        if (userRepository.findUserByEmailId(email) == null) {
            User loginigMember = new User();
            String salt = BCrypt.gensalt(12);
            loginigMember.setPassword(BCrypt.hashpw(member.getPassword(), salt));
            loginigMember.setEmailId(member.getEmailId());
            userRepository.save(loginigMember);

            return "new user added successfully";

        } else {
            return "You are in the system";
        }
    }

    @RequestMapping(value = "/transactions", method = RequestMethod.POST, produces = "application/json")
    public ResponseEntity<String> displayTransactions(@RequestBody Transaction transaction) {
       System.out.println(loggedInUser);
        // setting the uuui for the transaction
        if (loggedInUser != null) {
            UUID uuid = UUID.randomUUID();
            String stringUuid = uuid.toString();
            transaction.setTransactionId(stringUuid);
            transaction.setUser(loggedInUser);
            System.out.println("this is the id " + transaction.getTransactionId());
            transactionRepository.save(transaction);
            ObjectMapper mapperObj = new ObjectMapper();
            String JSON = null;
            try {
                JSON = mapperObj.writeValueAsString(transaction);
            } catch (JsonProcessingException e) {
                return new ResponseEntity<String>("Bad Request", HttpStatus.BAD_REQUEST);
            }
            System.out.println("this is done");
            return new ResponseEntity<String>(JSON, HttpStatus.CREATED);
        } else {
            return new ResponseEntity<String>("UnAuthorized", HttpStatus.UNAUTHORIZED);

        }

    }


    public static boolean isValid(String email) {
        String emailRegex = "^[a-zA-Z0-9_+&*-]+(?:\\." +
                "[a-zA-Z0-9_+&*-]+)*@" +
                "(?:[a-zA-Z0-9-]+\\.)+[a-z" +
                "A-Z]{2,7}$";

        Pattern pat = Pattern.compile(emailRegex);
        if (email == null)
            return false;
        return pat.matcher(email).matches();
    }


    @RequestMapping(value = "/gt/{id}/attachments", method = RequestMethod.GET, produces = "application/json")
    public ResponseEntity<String> getAttachment(@PathVariable("id") String transactionId, HttpServletRequest request, HttpServletResponse response) throws JsonProcessingException {
        if (loggedInUser != null) {
            List<Attachment> attachmentList = attachementRepository.findAttachmentByTransactionTransactionId(transactionId);


            ObjectMapper mapperObj = new ObjectMapper();
            String JSON = mapperObj.writeValueAsString(attachmentList);
            System.out.println(JSON);


            return new ResponseEntity<String>(JSON, HttpStatus.OK);
        }

        return new ResponseEntity<String>("UnAuthorized", HttpStatus.UNAUTHORIZED);

    }



    @PostMapping(value = "/transactions/{id}/attachments")
    public ResponseEntity<String> postAttachment(@PathVariable("id") String TransactionId, @RequestPart(value = "file") MultipartFile file) {

        if (loggedInUser != null) {
            byte[] bytes = new byte[0];
            try {
                bytes = file.getBytes();
                Path path = Paths.get("\\META-INF.resources\\images\\" + file.getOriginalFilename());
                //write the file to the correct place
                Files.write(path, bytes);


//        // setting the uuui for the transaction
//        if(loggedInUser!=nu
                UUID uuid = UUID.randomUUID();
                String stringUuid = uuid.toString();
                //find the trasactiom
                Transaction transaction = transactionRepository.findTransactionByTransactionId(TransactionId);
                if (transaction != null) {
                    Attachment attachment = new Attachment();
                    attachment.setAttachmentId(stringUuid);
                    attachment.setUrl(path.toString());
                    attachment.setTransaction(transaction);
                    attachementRepository.save(attachment);
                    ObjectMapper mapperObj = new ObjectMapper();
                    String JSON = null;
                    JSON = mapperObj.writeValueAsString(attachment);
                    return new ResponseEntity<String>(JSON, HttpStatus.CREATED);


                }
            } catch (IOException e) {
                e.printStackTrace();
                return new ResponseEntity<String>("Bad Request", HttpStatus.BAD_REQUEST);
            }

        } else {

            return new ResponseEntity<String>("UnAuthorized", HttpStatus.UNAUTHORIZED);

        }

    return null;
    }


    @Autowired
    S3Services s3Services;

    @Profile("aws")
    @PostMapping("/api/file/upload")
    public String uploadMultipartFile(@RequestParam("keyname") String keyName, @RequestParam("uploadfile") MultipartFile file) {
        s3Services.uploadFile(keyName, file);
        return "Upload Successfully. -> KeyName = " + keyName;
    }
}

