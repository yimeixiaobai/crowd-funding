<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<%@include file="/WEB-INF/include-head.jsp"%>
<link rel="stylesheet" href="css/pagination.css">
<script type="text/javascript" src="jquery/jquery.pagination.js"></script>
<link rel="stylesheet" href="ztree/zTreeStyle.css"/>
<script type="text/javascript" src="ztree/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="crowd/my-role.js"></script>
<script type="text/javascript">
	$(function() {
		// 1.为分页操作准备初始化数据
		window.pageNum = 1;
		window.pageSize = 5;
		window.keyword = "";

		// 2. 调用执行分页的函数
		generatePage();
		
		$("#searchBtn").click(function() {
			// 获取关键词数据
			window.keyword = $("#keywordInput").val();
			
			generatePage();
		});
		
		$("#showAddModalBtn").click(function() {
			$('#addModal').modal('show');
		});
		
		$("#saveRoleBtn").click(function() {
			var roleName = $.trim($("#addModal [name=roleName]").val());
			
			$.ajax({
				"url" : "role/save.json",
				"type": "post",
				"data": {
					"name": roleName
				},
				"dataType":"json",
				"success": function(response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
						
						window.pageNum = 999999;
						// 2. 调用执行分页的函数
						generatePage();
					}
					if(result == "FAILED") {
						layer.msg("操作失败！" + response.msg);
					}
				},
				"error": function(response) {
					layer.msg(response.status + " " + response.statusText);
				}
			});
			
			$("#addModal").modal("hide");
			
			// 清理模态框
			$("#addModal [name=roleName]").val("");
			
			
		});
		
		// 给页面上的铅笔按钮绑定单击响应函数，打开模态框
// 		$(".pencilBtn").click(function() {
// 			console.log("1111111");
// 			alert("aaaaaaa");
// 		})
		
		$("#rolePageBody").on("click", ".pencilBtn", function() {
			$("#editModal").modal("show");
			var roleName = $(this).parent().prev().text();
			
			window.roleId = this.id;
			
			$("#editModal [name=roleName]").val(roleName);
		});
		
		$("#updateRoleBtn").click(function() {
			
			var roleName = $("#editModal [name=roleName]").val();
			$.ajax({
				"url" : "role/update.json",
				"type": "post",
				"data": {
					"id": window.roleId,
					"name": roleName
				},
				"dataType":"json", // 服务器端返回的数据方式
				"success": function(response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
						
						// 2. 调用执行分页的函数
						generatePage();
					}
					if(result == "FAILED") {
						layer.msg("操作失败！" + response.msg);
					}
				},
				"error": function(response) {
					layer.msg(response.status + " " + response.statusText);
				}
			});
			
			$("#editModal").modal("hide");
			
		});
		
		$("#removeRoleBtn").click(function() {
			
			var requestBody = JSON.stringify(window.roleIdArray);
			
			console.log(window.roleIdArray);
			$.ajax({
				"url" : "role/remove/by/role/id/array.json",
				"type": "post",
				"data": requestBody,
				"contentType": "application/json;charset=UTF-8",
				"dataType":"json", // 服务器端返回的数据方式
				"success": function(response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
						
						// 2. 调用执行分页的函数
						generatePage();
					}
					if(result == "FAILED") {
						layer.msg("操作失败！" + response.msg);
					}
				},
				"error": function(response) {
					layer.msg(response.status + " " + response.statusText);
				}
			});
			
			$("#confirmModal").modal("hide");
			
		})
		
		// 给单条删除绑定单击响应函数
		$("#rolePageBody").on("click", ".removeBtn", function() {
			
			var roleName = $(this).parent().prev().text();
			var roleArray = [{
				roleId:this.id,
				roleName:roleName
			}]
			showConfirmModal(roleArray);
		});
		
		$("#summaryBox").click(function() {
			
			// 获取当前多选框自身的状态
			var currentStatus = this.checked;
			
			// 去设置其他多选框
			$(".itemBox").prop("checked", currentStatus);
		});
		
		// 11.全选、全不选的反向操作
		$("#rolePageBody").on("click", ".itemBox", function() {
			
			// 获取当前已经选中的.itemBox的数量
			var checkedBoxCount = $(".itemBox:checked").length;
			// 获取全部的.itemBox的数量
			var totalBoxCount = $(".itemBox").length;
			
			$("#summaryBox").prop("checked", totalBoxCount == checkedBoxCount);
			
		});
		
		// 12.给批量删除的按钮绑定单击响应函数
		$("#batchRemoveBtn").click(function() {
			
			var roleArray = [];
			$(".itemBox:checked").each(function() {
				
				// 使用this引用当前遍历得到的多选框
				var roleId = this.id;
				
				var roleName = $(this).parent().next().text();
				roleArray.push({
					"roleId":roleId,
					"roleName": roleName
				});
			});
			console.log(roleArray);
			// 检查roleArray是否为0
			if(roleArray.length == 0) {
				layer.msg("请至少选择一个删除");
				return ;
			}
			
			showConfirmModal(roleArray);
		});
		
		// 给分配权限按钮绑定单击响应函数
		$("#rolePageBody").on("click", ".checkBtn", function() {
			
			window.roleId = this.id;
			$("#assignModal").modal("show");
			
			fillAuthTree();
		});
		
		$("#assignBtn").click(function() {
			
			// 收集被勾选的节点
			var authIdArray = [];
			
			var zTreeObj = $.fn.zTree.getZTreeObj("authTreeDemo");
			
			var checkedNodes = zTreeObj.getCheckedNodes();
			
			for(var i = 0; i < checkedNodes.length; i++) {
				var checkedNode = checkedNodes[i];
				var authId = checkedNode.id;
				authIdArray.push(authId);
			}
			// 向后端发送保存请求
			var requestBody = {
				"authIdArray": authIdArray,
				"roleId": [window.roleId]
			}
			requestBody = JSON.stringify(requestBody);
			$.ajax({
				"url": "assign/do/role/assign/auth.json",
				"type": "post",
				"data": requestBody,
				"contentType": "application/json;charset=UTF-8",
				"dataType": "json",
				"success": function(response) {
					var result = response.result;
					if(result == "SUCCESS") {
						layer.msg("操作成功！");
					}
					if(result == "FAILED") {
						layer.msg("操作失败！" + response.msg);
					}
				},
				"error": function(response) {
					layer.msg(response.status + " " + response.statusText);
				}
			});
			$("#assignModal").modal("hide");
		});
	});
</script>
<body>

	<%@include file="/WEB-INF/include-nav.jsp"%>
	<div class="container-fluid">
		<div class="row">
			<%@include file="/WEB-INF/include-sidebar.jsp"%>
			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title">
							<i class="glyphicon glyphicon-th"></i> 数据列表
						</h3>
					</div>
					<div class="panel-body">
						<form class="form-inline" role="form" style="float: left;">
							<div class="form-group has-feedback">
								<div class="input-group">
									<div class="input-group-addon">查询条件</div>
									<input id="keywordInput" class="form-control has-success" type="text"
										placeholder="请输入查询条件">
								</div>
							</div>
							<button id="searchBtn" type="button" class="btn btn-warning">
								<i class="glyphicon glyphicon-search"></i> 查询
							</button>
						</form>
						<button id="batchRemoveBtn" type="button" class="btn btn-danger"
							style="float: right; margin-left: 10px;">
							<i class=" glyphicon glyphicon-remove"></i> 删除
						</button>
						<button type="button" id="showAddModalBtn" class="btn btn-primary"
							style="float: right;">
							<i class="glyphicon glyphicon-plus"></i> 新增
						</button>
						<br>
						<hr style="clear: both;">
						<div class="table-responsive">
							<table class="table  table-bordered">
								<thead>
									<tr>
										<th width="30">#</th>
										<th width="30"><input id="summaryBox" type="checkbox"></th>
										<th>名称</th>
										<th width="100">操作</th>
									</tr>
								</thead>
								<tbody id="rolePageBody" style="text-align: center;">
								</tbody>
								<tfoot>
									<tr>
										<td colspan="6" align="center">
											<div id="Pagination" class="pagination">
												<!-- 这里显示分页 -->
											</div>
										</td>
									</tr>

								</tfoot>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<%@include file="/WEB-INF/modal-role-add.jsp"%>
	<%@include file="/WEB-INF/modal-role-edit.jsp"%>
	<%@include file="/WEB-INF/modal-role-confirm.jsp"%>
	<%@include file="/WEB-INF/modal-role-assign-auth.jsp" %>
</body>
</html>