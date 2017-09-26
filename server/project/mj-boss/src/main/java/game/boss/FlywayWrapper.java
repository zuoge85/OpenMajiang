package game.boss;

import org.flywaydb.core.Flyway;
import org.flywaydb.core.api.FlywayException;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.util.Arrays;

/**
 * @author zuoge85@gmail.com on 2017/8/8.
 */
public class FlywayWrapper {
    private boolean migrate = false;
    private boolean validate = true;
    private boolean clean = false;
    /**
     * 检查数据库并尝试恢复,如果开启这个，其他选项都无效
     */
    private boolean checkAndRest = false;

    private DataSource dataSource;
    private String[] locations;

    private Flyway flyway;

    @PostConstruct
    public void init() {
        Flyway flyway = new Flyway();
        flyway.setDataSource(dataSource);
        flyway.setLocations(locations);

        if (checkAndRest) {
            try {
                flyway.validate();
            } catch (FlywayException ex) {
                flyway.clean();
                flyway.migrate();
            }
        } else {
            if (clean) {
                flyway.clean();
            }
            if (migrate) {
                flyway.migrate();
            }
            if (validate) {
                flyway.validate();
            }
        }
    }

    public Flyway getFlyway() {
        return flyway;
    }

    public boolean isMigrate() {
        return migrate;
    }

    public void setMigrate(boolean migrate) {
        this.migrate = migrate;
    }

    public boolean isClean() {
        return clean;
    }

    public void setClean(boolean clean) {
        this.clean = clean;
    }

    public DataSource getDataSource() {
        return dataSource;
    }

    public void setDataSource(DataSource dataSource) {
        this.dataSource = dataSource;
    }

    public String[] getLocations() {
        return locations;
    }

    public void setLocations(String... locations) {
        this.locations = locations;
    }

    public boolean isValidate() {
        return validate;
    }

    public void setValidate(boolean validate) {
        this.validate = validate;
    }

    public void setFlyway(Flyway flyway) {
        this.flyway = flyway;
    }

    public boolean isCheckAndRest() {
        return checkAndRest;
    }

    public void setCheckAndRest(boolean checkAndRest) {
        this.checkAndRest = checkAndRest;
    }

    @Override
    public String toString() {
        return "FlywayWrapper{" +
                "migrate=" + migrate +
                ", validate=" + validate +
                ", clean=" + clean +
                ", checkAndRest=" + checkAndRest +
                ", dataSource=" + dataSource +
                ", locations=" + Arrays.toString(locations) +
                ", flyway=" + flyway +
                '}';
    }
}
