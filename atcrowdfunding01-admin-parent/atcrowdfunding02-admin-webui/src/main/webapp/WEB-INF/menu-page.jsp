<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp"%>
<link rel="stylesheet" href="ztree/zTreeStyle.css"/>
<script type="text/javascript" src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="crowd/my-menu.js"></script>
<script type="text/javascript">
	$(function() {
		
		generateTree();
		
		$("#treeDemo").on("click", ".addBtn", function() {
			
			window.pid = this.id;
			$("#menuAddModal").modal("show");
			return false;
		});
		
		$("#menuSaveBtn").click(function() {
			
			var name = $.trim($("#menuAddModal [name=name]").val());
			var url = $.trim($("#menuAddModal [name=url]").val());
			var icon = $("#menuAddModal [name=icon]:checked").val();
			
			$.ajax({
				"url":"menu/save.json",
				"type": "post",
				"data": {
					"pid": window.pid,
					"name": name,
					"url": url,
					"icon": icon
				},
				"dataType": "json",
				"success": function(response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
						
						//重新加载树形结构
						generateTree();
					}
					if(result == "FAILED") {
						layer.msg("操作成功！" + reponse.message);
					}
				},
				"error": function(response) {
					layer.msg(response.status + " " + response.statusText);
				},
			})
			
			$("#menuAddModal").modal("hide");
			
			// 清空表单
 			$("#menuResetBtn").click();
			
		});
		
		$("#treeDemo").on("click", ".editBtn", function() {
			
			window.id = this.id;
			$("#menuEditModal").modal("show");
			
			// 获取zTreeObj
			var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
			
			// 根据 id 属性查询节点对象
			// 用来搜索节点的属性名
			var key = "id";
			
			// 用来搜索节点的属性值
			var value = window.id;
			
			var currentNode = zTreeObj.getNodeByParam(key, value);
			
			// 回显数据
			$("#menuEditModal [name=name]").val(currentNode.name);
			$("#menuEditModal [name=url]").val(currentNode.url);
			$("#menuEditModal [name=icon]").val([currentNode.icon]);
			return false;
		});
		
		$("#menuEditBtn").click(function() {
			
			var name = $.trim($("#menuEditModal [name=name]").val());
			var url = $.trim($("#menuEditModal [name=url]").val());
			var icon = $("#menuEditModal [name=icon]:checked").val();
			
			$.ajax({
				"url":"menu/update.json",
				"type": "post",
				"data": {
					"id": window.id,
					"name": name,
					"url": url,
					"icon": icon
				},
				"dataType": "json",
				"success": function(response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
						
						//重新加载树形结构
						generateTree();
					}
					if(result == "FAILED") {
						layer.msg("操作成功！" + reponse.message);
					}
				},
				"error": function(response) {
					layer.msg(response.status + " " + response.statusText);
				},
			})
			
			$("#menuEditModal").modal("hide");
			
		});
		
		$("#treeDemo").on("click", ".removeBtn", function() {
			
			window.id = this.id;
			$("#menuConfirmModal").modal("show");
			
			// 获取zTreeObj
			var zTreeObj = $.fn.zTree.getZTreeObj("treeDemo");
			
			// 根据 id 属性查询节点对象
			// 用来搜索节点的属性名
			var key = "id";
			
			// 用来搜索节点的属性值
			var value = window.id;
			
			var currentNode = zTreeObj.getNodeByParam(key, value);
			
			$("#removeNodeSpan").html("【<i class='" + currentNode.icon + "'></i>" + currentNode.name + "】");
			return false;
		});
		
		$("#confirmBtn").click(function() {
			$.ajax({
				"url":"menu/remove.json",
				"type": "post",
				"data": {
					"id": window.id
				},
				"dataType": "json",
				"success": function(response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
						
						//重新加载树形结构
						generateTree();
					}
					if(result == "FAILED") {
						layer.msg("操作成功！" + reponse.message);
					}
				},
				"error": function(response) {
					layer.msg(response.status + " " + response.statusText);
				},
			})
			
			$("#menuConfirmModal").modal("hide");
			
		});
	})
</script>

<body>

	<%@include file="/WEB-INF/include-nav.jsp"%>
	<div class="container-fluid">
		<div class="row">
			<%@include file="/WEB-INF/include-sidebar.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">

				<div class="panel panel-default">
					<div class="panel-heading">
						<i class="glyphicon glyphicon-th-list"></i> 权限菜单列表
						<div style="float: right; cursor: pointer;" data-toggle="modal"
							data-target="#myModal">
							<i class="glyphicon glyphicon-question-sign"></i>
						</div>
					</div>
					<div class="panel-body">
						<ul id="treeDemo" class="ztree">
						</ul>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%@include file="/WEB-INF/modal-menu-add.jsp" %>
	<%@include file="/WEB-INF/modal-menu-confirm.jsp" %>
	<%@include file="/WEB-INF/modal-menu-edit.jsp" %>
</body>
</html>