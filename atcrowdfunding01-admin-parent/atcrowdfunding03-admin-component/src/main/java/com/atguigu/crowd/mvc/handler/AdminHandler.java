package com.atguigu.crowd.mvc.handler;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.service.api.AdminService;
import com.atguigu.crowd.util.constant.CrowdConstant;
import com.github.pagehelper.PageInfo;

@Controller
public class AdminHandler {
	
	@Autowired
	private AdminService adminService;
	@RequestMapping("/admin/update.html")
	public String update(Admin admin, @RequestParam("pageNum") Integer pageNum, @RequestParam("keyword") String keyword) {
		adminService.update(admin);
		return "redirect:/admin/get/page.html?pageNum=" + pageNum + "&keyword=" + keyword;
	}
	
	@RequestMapping("/admin/to/edit/page.html")
	public String toEditPage(@RequestParam("adminId") Integer adminId, ModelMap modelMap) {
		Admin admin = adminService.getAdminById(adminId);
		
		modelMap.addAttribute("admin", admin);
		return "admin-edit";
	}
	
	@RequestMapping("/admin/save.html")
	public String save(Admin admin) {
		adminService.saveAdmin(admin);
		
		return "redirect:/admin/get/page.html?pageNum=" + Integer.MAX_VALUE;
	}
	
	@RequestMapping("/admin/remove/{adminId}/{pageNum}/{keyword}.html")
	public String remove(@PathVariable("adminId") Integer adminId,
							@PathVariable("pageNum") Integer pageNum,
							@PathVariable("keyword") String keyword) {
		
		adminService.remove(adminId);
		
		// 尝试方案1：直接转发到admin-page.jsp，会显示没有数据
		// return "admin-page";
		
		// 尝试方案2：转发到/admin/get/page.html地址，一旦刷新页面会重复执行删除浪费性能
		// return "forward:/admin/get/page.html";
		
		// 尝试方案3：重定向到/admin/get/page.html地址
		// 同时为了保持原本页面的和查询关键词再附加pageNum和keyword两个请求参数
		return "redirect:/admin/get/page.html?pageNum=" + pageNum + "&keyword=" + keyword;
	}
	
	@RequestMapping("/admin/get/page.html")
	public String getPageInfo(@RequestParam(value="keyword", defaultValue="") String keyword, 
							@RequestParam(value="pageNum", defaultValue="1") Integer pageNum, 
							@RequestParam(value="pageSize", defaultValue="5") Integer pageSize,
							ModelMap modelMap) {
		// 调用Service获取PageInfo对象
		PageInfo<Admin> pageInfo = adminService.getPageInfo(keyword, pageNum, pageSize);
		
		// 将PageInfo对象存入模型中
		modelMap.addAttribute(CrowdConstant.AttR_NAME_PAGE_INFO, pageInfo);
		
		return "admin-page";
	}
	@RequestMapping("admin/do/logout.html")
	public String doLogout(HttpSession session) {
		// 强制session失效
		session.invalidate();
		return "redirect:/admin/to/login/page.html";
	}
	
	@RequestMapping("/admin/do/login.html")
	public String doLogin(@RequestParam("loginAcct") String loginAcct, @RequestParam("userPswd") String userPswd, HttpSession session) {
		
		// 调用Service方法执行登录检查
		// 这个方法能够返回admin对象说明登录成功，如果账号、密码不正确则会抛出异常
		Admin admin = adminService.getAdminByLoginAcct(loginAcct, userPswd);
		
		// 将登录成功返回的admin
		session.setAttribute(CrowdConstant.ATTR_NAME_LOGIN_ADMIN, admin);
	
		
		return "redirect:/admin/to/main/page.html";
		
	}
	
}
