package com.atguigu.crowd.util;

import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.HttpServletRequest;

import com.atguigu.crowd.util.constant.CrowdConstant;

public class CrowdUtil {
	
	/**
	 * 对明文字符串进行加密
	 * @param source
	 * @return
	 */
	public static String md5(String source) {
		
		if(source == null || source.length() == 0) {
			throw new RuntimeException(CrowdConstant.MESSAGE_STRING_INVALIDATE);
		}
		
		
		try {
			// 3.获取MessageDigest对象
			String algorithm = "md5";
			MessageDigest messageDigest = MessageDigest.getInstance(algorithm);
			byte[] input = source.getBytes();
			byte[] output = messageDigest.digest(input);
			
			
			int signum = 1;
			BigInteger bigInteger = new BigInteger(signum, output);
			int radix = 16;
			String encoded = bigInteger.toString(radix).toUpperCase();
			return encoded;
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return null;
	}
	/**
	  *  判断请求是否为Ajax请求
	 * @param request
	 * @return
	 */
	public static boolean judgeRequestType(HttpServletRequest request) {
		
		String acceptHeader = request.getHeader("Accept");
		String xRequestHeader = request.getHeader("X-Requested-With");
		
		return (acceptHeader != null && acceptHeader.contains("application/json")) || (xRequestHeader != null && xRequestHeader.equals("XMLHttpRequest"));
	}
}
