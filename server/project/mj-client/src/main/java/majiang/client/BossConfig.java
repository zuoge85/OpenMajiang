package majiang.client;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * @author zuoge85@gmail.com on 2016/12/7.
 */
@Component
@ConfigurationProperties(prefix = "net.boss")
public class BossConfig {
    private String publicKey;

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    @Override
    public String toString() {
        return "BossConfig{" +
                "publicKey='" + publicKey + '\'' +
                '}';
    }
}
