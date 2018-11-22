package dao;

import model.Attachment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface AttachementRepository extends JpaRepository<Attachment,String> {
    List<Attachment> findAttachmentByTransactionTransactionId(String transactionId);

    Attachment findAttachmentByAttachmentId(String attachmentId);


}
