package hello;

import org.springframework.beans.factory.annotation.Autowired;

import javax.persistence.*;
import javax.validation.constraints.NotNull;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name="testlogin")
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    public User()
    {

    }

    public User(String emailId,String password){

        this.emailId=emailId;
        this.password=password;

    }

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "userId")
    private Long userId;
    @Column(name = "emailId", unique = true, nullable = false)

    private String emailId;
    @Column(name = "password", nullable = false)
    private String password;

    @OneToMany(cascade = CascadeType.ALL)
    //@JoinColumn(name = "transactionId" ,referencedColumnName = "transactionId")
    private Set<Transaction> userTransactionList = new HashSet<>();

    public String getEmailId() {
        return emailId;
    }

    public void setEmailId(String emailId) {
        this.emailId = emailId;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

}