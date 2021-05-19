package com.atguigu.crowd.exception;


/**
 * 保存或者更新Admin时如果检测到登录账号重复就抛出这个异常
 * @author chao wang
 *
 */
public class LoginAcctAlreadyInUseForUpdateException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public LoginAcctAlreadyInUseForUpdateException() {
		super();
	}

	public LoginAcctAlreadyInUseForUpdateException(String arg0, Throwable arg1, boolean arg2, boolean arg3) {
		super(arg0, arg1, arg2, arg3);
	}

	public LoginAcctAlreadyInUseForUpdateException(String arg0, Throwable arg1) {
		super(arg0, arg1);
	}

	public LoginAcctAlreadyInUseForUpdateException(String arg0) {
		super(arg0);
	}

	public LoginAcctAlreadyInUseForUpdateException(Throwable arg0) {
		super(arg0);
	}

	
}
