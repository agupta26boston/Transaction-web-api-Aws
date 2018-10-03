package hello;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Service
public class GreetingService  {

    @Autowired
    UserRepository userRepository;

    private List<User> users= new ArrayList<>();

    public List<User> getAllGreetings(){
        return users;
    }

    public void addUser(User greeting){

            users.add(greeting);
        }
    }


