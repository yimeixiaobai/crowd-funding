package com.atguigu.crowd.exception;

/**
 * 表示用户没有登录就访问资源的异常
 * @author chao wang
 *
 */
public class AccessForbiddenExcetion extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public AccessForbiddenExcetion() {
		super();
	}

	public AccessForbiddenExcetion(String arg0, Throwable arg1, boolean arg2, boolean arg3) {
		super(arg0, arg1, arg2, arg3);
	}

	public AccessForbiddenExcetion(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	public AccessForbiddenExcetion(String arg0) {
		super(arg0);
	}

	public AccessForbiddenExcetion(Throwable arg0) {
		super(arg0);
	}
	
	

}
