package com.atguigu.crowd.test;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.crowd.entity.Admin;
import com.atguigu.crowd.entity.Role;
import com.atguigu.crowd.mapper.AdminMapper;
import com.atguigu.crowd.mapper.RoleMapper;
import com.atguigu.crowd.service.api.AdminService;

// �����ϱ�Ǳ�Ҫ��ע�⣬Spring����Junit
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:spring-persist-mybatis.xml", "classpath:spring-persist-tx.xml"})
public class CrowdTest {
	
	@Autowired
	private DataSource dataSource;
	
	@Autowired
	private AdminMapper adminMapper;
	
	@Autowired
	private AdminService adminService;
	
	@Autowired
	private RoleMapper roleMapper;
	
	@Test
	public void testRoleSave() {
		for(int i = 0; i < 235; i++) {
			roleMapper.insert(new Role(null, "role" + i));
		}
	}
	
	@Test
	public void test() {
		for(int i = 0; i < 238; i++ ) {
			adminMapper.insert(new Admin(null, "loginAcct" + i, "userPswd" + i, "userName" + i, "email" + i, null));
		}
	}
	
	@Test
	public void testTx() {
		
		Admin admin = new Admin(null, "jerry", "123456", "����", "jerry@qq.com", null);
		adminService.saveAdmin(admin);
		
	}
	
	
	@Test
	public void testLog() {
		Logger logger = LoggerFactory.getLogger(CrowdTest.class);
		
		logger.debug("hello i am debug level");
		logger.debug("hello i am debug level");
		logger.debug("hello i am debug level");
		
		logger.info("Info level");
		logger.info("Info level");
		
		logger.warn("warn level");
		logger.warn("warn level");
		
		logger.error("error level");
		logger.error("error level");
		
	}
	@Test
	public void testInsertAdmin() {
		Admin admin = new Admin(null, "tom", "123123", "��ķ", "tom@qq.com", null);
		int count = adminMapper.insert(admin);
		System.out.println(count);
	}
	@Test
	public void testConnection() throws SQLException {
		Connection connection = dataSource.getConnection();
		System.out.println(connection);
	}
}
