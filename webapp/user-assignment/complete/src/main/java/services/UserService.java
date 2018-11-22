package services;


import dao.UserRepository;
import model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {

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


