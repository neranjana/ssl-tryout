package com.neranjana.ssltryout.zuulexample;

import com.netflix.zuul.ZuulFilter;

import com.netflix.zuul.exception.ZuulException;
import org.springframework.beans.factory.InitializingBean;


public class PreFilter  extends ZuulFilter implements InitializingBean {


    @Override
    public String filterType() {
        return "pre";
    }

    @Override
    public int filterOrder() {
        return 1;
    }

    @Override
    public boolean shouldFilter() {
        return true;
    }

    @Override
    public Object run() throws ZuulException {

        return null;
    }

    @Override
    public void afterPropertiesSet() throws Exception {

    }
}
