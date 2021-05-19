<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp" %>
<script type="text/javascript">
	$(function() {
		$("#asyncBtn").click(function() {
			console.log("发送请求之前");
			$.ajax({
				"url": "test/ajax/async.html",
				"type": "post",
				"dataType": "text",
				"async": false, // 关闭异步操作，在一个线程中安按顺序执行
				"success": function(response) {
					console.log("发送请求之中：" + response);
				}
			});
			
			console.log("发送请求之后");
		});
	});
</script>
<body>

	<%@include file="/WEB-INF/include-nav.jsp" %> %>
	<div class="container-fluid">
		<div class="row">
			<%@include file="/WEB-INF/include-sidebar.jsp" %>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<button id="asyncBtn">发送Ajax请求</button>
			</div>
		</div>
	</div>
</body>
</html>