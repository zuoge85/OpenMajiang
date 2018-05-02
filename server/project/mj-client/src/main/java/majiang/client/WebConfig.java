package majiang.client;

import com.fasterxml.jackson.core.JsonEncoding;
import com.fasterxml.jackson.databind.ObjectMapper;
import majiang.client.boss.BossClient;
import majiang.client.boss.BossClientHandler;
import majiang.client.portal.AdminAccount;
import majiang.client.portal.AdminAccountHandlerInterceptor;
import majiang.client.portal.ResultExceptionResolver;
import majiang.client.utils.JsonUtils;
import org.forkjoin.apikit.spring.*;
import org.hibernate.validator.HibernateValidator;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.HandlerExceptionResolver;
import org.springframework.web.servlet.config.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.nio.charset.Charset;
import java.util.List;

/**
 * @author zuoge85@gmail.com on 2017/1/7.
 */
@Configuration
@EnableWebMvc
public class WebConfig extends WebMvcConfigurerAdapter {
    @Value("${net.boss.address}")
    private String bossAddress;
    @Value("${net.boss.port}")
    private int bossPort;

    @Bean
    public BossClientHandler bossClientHandler() {
        return new BossClientHandler();
    }

    @Bean
    public BossClient bossClient() throws Exception {
        BossClient bossClient = new BossClient(
                bossAddress, bossPort, bossClientHandler()
        );
        bossClient.connect();
        return bossClient;
    }

    @Bean
    public ReloadableResourceBundleMessageSource messageSource() {
        ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasenames(
                "classpath:messages/message",
                "classpath:messages/form"
        );
        messageSource.setUseCodeAsDefaultMessage(true);
        messageSource.setCacheSeconds(0);
        return messageSource;
    }

    @Bean
    public ResultMappingJackson2JsonView view() {
        ResultMappingJackson2JsonView resultMappingJackson2JsonView = new ResultMappingJackson2JsonView();
        resultMappingJackson2JsonView.setEncoding(JsonEncoding.UTF8);
        resultMappingJackson2JsonView.setObjectMapper(objectMapper());
        return resultMappingJackson2JsonView;
    }


    @Bean
    public ObjectMapper objectMapper() {
        return JsonUtils.create(false);
    }

    @Bean
    public ResultExceptionResolver exceptionResolver() {
        return new ResultExceptionResolver();
    }

    @Bean
    public AdminAccountHandlerInterceptor adminAccountHandlerInterceptor() {
        return new AdminAccountHandlerInterceptor();
    }


    @Bean
    public I18nResultJacksonHttpMessageConverter converter() {
        I18nResultJacksonHttpMessageConverter converter = new I18nResultJacksonHttpMessageConverter();
        converter.setEncoding(JsonEncoding.UTF8);
        converter.setObjectMapper(objectMapper());
        return converter;
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/**").addResourceLocations("classpath:/static/");
    }

    @Override
    public Validator getValidator() {
        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.setProviderClass(HibernateValidator.class);
        validator.setValidationMessageSource(messageSource());
        return validator;
    }

    @Override
    public void configureViewResolvers(ViewResolverRegistry registry) {
//        registry.enableContentNegotiation(
//                view()
//        );
        registry.freeMarker();
    }

    @Override
    public void configureMessageConverters(List<HttpMessageConverter<?>> converters) {
        converters.add(converter());
    }
//    <mvc:view-resolvers>
//        <mvc:content-negotiation>
//            <mvc:default-views>
//                <bean class="org.forkjoin.apikit.spring.ResultMappingJackson2JsonView">
//                    <property name="objectMapper" ref="objectMapper"/>
//                    <property name="encoding" value="UTF8"/>
//                </bean>
//            </mvc:default-views>
//        </mvc:content-negotiation>
//    </mvc:view-resolvers>

    @Override
    public void configureHandlerExceptionResolvers(List<HandlerExceptionResolver> exceptionResolvers) {
        exceptionResolvers.add(exceptionResolver());
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new NoCacheInterceptor(Charset.forName("UTF-8")) {
            @Override
            public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
                response.setHeader("Access-Control-Allow-Origin", "*");
                response.setHeader("Access-Control-Allow-Methods", "*");
                response.setHeader("Access-Control-Allow-Headers", AdminAccountHandlerInterceptor.ADMIN_ACCOUNT_TOKEN_HEADER_NAME);
                response.setHeader("Access-Control-Allow-Headers", AdminAccountHandlerInterceptor.AGENT_ACCOUNT_TOKEN_HEADER_NAME);
                return super.preHandle(request, response, handler);
            }
        });
        registry.addInterceptor(adminAccountHandlerInterceptor());
    }

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> argumentResolvers) {
        argumentResolvers.add(new AccountParamArgumentResolver(AdminAccount.class));
    }
}
