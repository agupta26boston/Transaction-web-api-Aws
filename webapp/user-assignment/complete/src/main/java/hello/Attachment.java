package hello;

import javax.persistence.*;


@Entity
@Table(name = "attachment")
public class Attachment {
    @Id
    @Column(unique = true, nullable = false)
    private String attachmentId;

    @OneToOne(targetEntity=Transaction.class)
    private Transaction transaction;

    private String url;

    public String getAttachmentId() {
        return attachmentId;
    }

    public void setAttachmentId(String attachmentId) {
        this.attachmentId = attachmentId;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Transaction getTransaction() {
        return transaction;
    }

    public void setTransaction(Transaction transaction) {
        this.transaction = transaction;
    }
}
