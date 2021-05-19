package com.atguigu.crowd.mvc.config;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;

import com.atguigu.crowd.exception.LoginAcctAlreadyInUseException;
import com.atguigu.crowd.exception.LoginAcctAlreadyInUseForUpdateException;
import com.atguigu.crowd.exception.LoginFailedException;
import com.atguigu.crowd.util.CrowdUtil;
import com.atguigu.crowd.util.ResultEntity;
import com.atguigu.crowd.util.constant.CrowdConstant;
import com.google.gson.Gson;

@ControllerAdvice
public class CrowdExceptionResolver {
	
	@ExceptionHandler(value=LoginAcctAlreadyInUseForUpdateException.class)
	public ModelAndView resolveLoginAcctAlreadyInUseForUpdateException(LoginAcctAlreadyInUseForUpdateException exception, HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String viewName = "system-error";
		return commonResolve(viewName, exception, request, response);
	}
	
	@ExceptionHandler(value=LoginAcctAlreadyInUseException.class)
	public ModelAndView resolveLoginAcctAlreadyInUseException(LoginAcctAlreadyInUseException exception, HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String viewName = "admin-add";
		return commonResolve(viewName, exception, request, response);
	}
	
	@ExceptionHandler(value=LoginFailedException.class)
	public ModelAndView resolveLoginFailedException(LoginFailedException exception, HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String viewName = "admin-login";
		return commonResolve(viewName, exception, request, response);
	}
	
	@ExceptionHandler(value=ArithmeticException.class)
	public ModelAndView resolveMathException(ArithmeticException exception, HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String viewName = "system-error";
		return commonResolve(viewName, exception, request, response);
	}
	
	@ExceptionHandler(value = NullPointerException.class)
	public ModelAndView resolveNullPointerException(NullPointerException exception, HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String viewName = "system-error";
		return commonResolve(viewName, exception, request, response);
	}
	
	private ModelAndView commonResolve(String viewName, Exception exception, HttpServletRequest request, HttpServletResponse response) throws IOException {
boolean judgeResult = CrowdUtil.judgeRequestType(request);
		
		if(judgeResult) {
			ResultEntity<Object> resultEntity = ResultEntity.failed(exception.getMessage());
			
			Gson gson = new Gson();
			
			String json = gson.toJson(resultEntity);
			
			response.getWriter().write(json);
			
			return null;
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.addObject(CrowdConstant.ATTR_NAME_EXCEPTION, exception);
		
		modelAndView.setViewName(viewName);
		return modelAndView;
	}
}
