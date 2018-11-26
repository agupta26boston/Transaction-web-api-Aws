package hello;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.regex.Pattern;

public interface UserRepository extends JpaRepository<User,Long> {

    User findUserByEmailId(String emailId);



}
