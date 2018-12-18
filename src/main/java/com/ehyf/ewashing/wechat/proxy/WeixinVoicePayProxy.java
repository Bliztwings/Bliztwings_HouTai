package com.ehyf.ewashing.wechat.proxy;

import java.io.IOException;

import javax.servlet.GenericServlet;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

@WebServlet(urlPatterns = {"/weixinCallBack" })
public class WeixinVoicePayProxy extends GenericServlet{

    /**
     * 
     */
    private static final long serialVersionUID = 3806280650124290152L;

    private String targetBean;  
    private Servlet proxy; 
    
    @Override
    public void service(ServletRequest req, ServletResponse res)
            throws ServletException, IOException {
        proxy.service(req, res);
    }
    
    @Override  
    public void init() throws ServletException {  
        this.targetBean = getServletName();  
        getServletBean();  
        proxy.init(getServletConfig());  
    }  
    
    private void getServletBean() {  
        WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());  
        this.proxy = (Servlet) wac.getBean(targetBean);  
    }  

}
