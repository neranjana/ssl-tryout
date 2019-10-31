package com.nernajana.ssltryout.mutualauthenabledclient;

import feign.Response;
import feign.codec.ErrorDecoder;

public class FeignClientErrorDecoder implements ErrorDecoder {
    @Override
    public Exception decode(String methodKey, Response response) {
        return null;
    }
}
