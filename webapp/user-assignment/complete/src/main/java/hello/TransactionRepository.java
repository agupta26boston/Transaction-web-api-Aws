package hello;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface TransactionRepository extends JpaRepository<Transaction,String> {

    Transaction findTransactionByTransactionId(String transactionId);

    List<Transaction> findTransactionByUserUserId(Long userId);


}
