package game.boss.services;

import com.isnowfox.core.net.message.Message;
import com.isnowfox.service.AbstractAsyncService;
import game.admin.SettingMsg;
import game.boss.dao.dao.SettingDao;
import game.boss.dao.entity.SettingDO;
import game.boss.model.User;
import game.boss.net.BossService;
import mj.net.handler.MessageHandler;
import mj.net.message.login.Radio;
import mj.net.message.login.SysSetting;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;

/**
 * 异步服务，请注意线程安全
 *
 * @author zuoge85 on 14-1-8.
 */
@Service
public final class SettingService {
    public static final int DEFAULT_ID = 1;

    @Autowired
    private SettingDao settingDao;

    @Autowired
    private BossService bossService;

    private SettingDO setting;


    @PostConstruct
    private void init(){
        SettingDO setting = settingDao.get(DEFAULT_ID);
        if (setting == null) {
            setting = new SettingDO();
            setting.setId(DEFAULT_ID);
        }
        setting.setInitGold(100);
        this.setting = setting;
    }

    public SettingDO getSetting() {
        return setting;
    }

    public SysSetting getSettingMsg() {
        return settingMsg;
    }

    public void change(SettingMsg payMsg) {
        if(!StringUtils.equals(payMsg.getRadio(), setting.getRadio())){
            bossService.writeToAll(new Radio(payMsg.getRadio()));
        }
        BeanUtils.copyProperties(payMsg, setting);
    }


    private SysSetting settingMsg = new SysSetting(){
        @Override
        public String getRadio() {
            return setting.getRadio();
        }

        @Override
        public String getNotice() {
            return setting.getNotice();
        }

        @Override
        public String getPayInfo() {
            return setting.getPayInfo();
        }

        @Override
        public String getAgreement() {
            return setting.getAgreement();
        }
    };
}