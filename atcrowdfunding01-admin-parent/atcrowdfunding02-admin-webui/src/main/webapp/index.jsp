<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- http://localhost:8080/atcrowdfunding02-admin-webui/index.jsp -->
<base href="http://${pageContext.request.serverName}:${pageContext.request.serverPort}${ pageContext.request.contextPath }/"/>
<script type="text/javascript" src="jquery/jquery-2.1.1.min.js"></script>
<script type="text/javascript">
	$(function() {
		$("#btn4").click(function() {
			
			var student = {
					"stuId" : 5,
					"stuName": "jom",
					"address": {
						"province": "广东",
						"city": "深圳",
						"street": "后端"
					},
					"subjectList": [
						{
							"subjectName":"javaSE",
							"subjectScore": 100,
						},
						{
							"subjectName":"javaSE",
							"subjectScore": 100,
						}
					],
					"map": {
						"key1" : "value1",
						"key2" : "value2",
					}
			};
			var requestBody = JSON.stringify(student);
			
			$.ajax({
				"url":"send/compose/object.json",
				"type":"post",
				"data": requestBody,
				"contentType":"application/json; charset=UTF-8", // 请求体类型
				"dataType":"json",
				"success": function(response) {
					console.log(response);
				},
				"error": function(response) {
					console.log(response);
				}
			});
		});
		
		$("#btn3").click(function() {
			var array = [5, 8, 12];
			
			var requestBody = JSON.stringify(array);
			$.ajax({
				"url":"send/array/three.html",
				"type":"post",
				"data": requestBody,
				"contentType":"application/json; charset=UTF-8", // 请求体类型
				"dataType":"text",
				"success": function(response) {
					alert(response);
				},
				"error": function(response) {
					alert(response);
				}
			})
		});
		
		$("#btn2").click(function() {
			$.ajax({
				"url":"send/array/two.html",
				"type":"post",
				"data": {
					"array[0]": 5,
					"array[1]": 8,
					"array[2]": 12,
				},
				"dataType":"text",
				"success": function(response) {
					alert(response);
				},
				"error": function(response) {
					alert(response);
				}
			})
		});
		
		$("#btn1").click(function() {
			$.ajax({
				"url":"send/array/one.html",
				"type":"post",
				"data": {
					"array": [5,8,12]
				},
				"dataType":"text",
				"success": function(response) {
					alert(response);
				},
				"error": function(response) {
					alert(response);
				}
			})
		})
	})
</script>
</head>
<body>
	<a href="test/ssm.html">测试SSM环境</a>
	
	<br>
	
	<button id="btn1">Test Array</button>
	
	<br>
	<br>
	<button id="btn2">Test Array2</button>
	
	<br>
	<br>
	<button id="btn3">Test Array3</button>
	
	
	<br>
	<br>
	<button id="btn4">Test Compose Object</button>
</body>
</html>