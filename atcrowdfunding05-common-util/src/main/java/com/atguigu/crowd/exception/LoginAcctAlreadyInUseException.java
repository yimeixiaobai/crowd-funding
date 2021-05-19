package com.atguigu.crowd.exception;


/**
 * 保存或者更新Admin时如果检测到登录账号重复就抛出这个异常
 * @author chao wang
 *
 */
public class LoginAcctAlreadyInUseException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public LoginAcctAlreadyInUseException() {
		super();
	}

	public LoginAcctAlreadyInUseException(String arg0, Throwable arg1, boolean arg2, boolean arg3) {
		super(arg0, arg1, arg2, arg3);
	}

	public LoginAcctAlreadyInUseException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	public LoginAcctAlreadyInUseException(String arg0) {
		super(arg0);
	}

	public LoginAcctAlreadyInUseException(Throwable arg0) {
		super(arg0);
	}

	
}
