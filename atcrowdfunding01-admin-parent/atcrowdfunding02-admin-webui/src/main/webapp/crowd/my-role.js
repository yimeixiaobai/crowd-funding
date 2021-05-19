
function fillAuthTree() {
	
	// 1.发送Ajax请求查询Auth数据
	var ajaxReturn = $.ajax({
		"url" : "assign/get/all/auth.json",
		"type": "post",
		"async": false,
		"dataType":"json",
		
	});
	if(ajaxReturn.status != 200) {
		layer.msg(ajaxReturn.status + " " + ajaxReturn.statusText);
		return ;
	}
	// 从响应结果中获取data
	var authList = ajaxReturn.responseJSON.data;
	
	var setting = {
		"data": {
			"simpleData": {
				"enable": true,
				"pIdKey" : "categoryId"
			},
			"key" : {
				"name" : "title"
			}
		},
		"check": {
			"enable": true
		}
	};
	$.fn.zTree.init($("#authTreeDemo"), setting, authList);
	
	var zTreeObj = $.fn.zTree.getZTreeObj("authTreeDemo");
	
	zTreeObj.expandAll(true);
	// 查询已分配的Auth_id组成的数组
	ajaxReturn = $.ajax({
		"url" : "assign/get/assigned/auth/id/by/role/id.json",
		"type": "post",
		"async": false,
		"dataType":"json",
		"data": {
			"roleId" : window.roleId
		}
	});
	
	if(ajaxReturn.status != 200) {
		layer.msg(ajaxReturn.status + " " + ajaxReturn.statusText);
		return ;
	}
	// 从响应结果中获取data
	var authIdArray = ajaxReturn.responseJSON.data;
	
	// 显示多选框
	
	for(var i = 0; i < authIdArray.length; i++) {
		var authId = authIdArray[i];
		
		var treeNode = zTreeObj.getNodeByParam("id", authId);
		
		zTreeObj.checkNode(treeNode, true, false);
	}
	
}

function showConfirmModal(roleArray) {
	$("#confirmModal").modal("show");
	
	
	$("#roleNameDiv").empty();
	
	window.roleIdArray = [];
	for(var i = 0; i < roleArray.length; i++) {
		var role = roleArray[i];
		var roleName = role.roleName;
		
		$("#roleNameDiv").append(roleName + "<br/>");
		
		var roleId = role.roleId;
		window.roleIdArray.push(roleId);
	}
}

/**
 * 执行分页，生成页面效果
 */
function generatePage() {
	
	// 1.获取分页数据
	var pageInfo = getPageInfoRemote();
	
	// 2.填充表格
	fillTableBody(pageInfo);
	$("#summaryBox").prop("checked", false);
}

/**
 * 远程访问服务器端程序获取pageInfo数据
 * @returns
 */
function getPageInfoRemote() {
	
	// 调用$.ajax()函数发送请求并接受$.ajax()函数的返回值
	var ajaxResult = $.ajax({
		"url" : "role/get/page/info.json",
		"type": "post",
		"data": {
			"pageNum": window.pageNum,
			"pageSize": window.pageSize,
			"keyword": window.keyword
		},
		"async": false,
		"dataType":"json",
	});
	
//	console.log(ajaxResult);
	
	// 判断响应状态码
	var statusCode = ajaxResult.status;
	if(statusCode != 200) {
		layer.msg("服务端程序调用失败！")
		return null;
	}
	
	var resultEntity = ajaxResult.responseJSON;
	
	var result = resultEntity.result;
	
	if(result == "FAILED") {
		layer.msg = result.message;
		return null;
	}
	
	return resultEntity.data;
}

/**
 * 填充表格
 * @param pageInfo
 * @returns
 */
function fillTableBody(pageInfo) {
	
	$("#rolePageBody").empty();
	$("#Pagination").empty();
	if(pageInfo == null || pageInfo == undefined || pageInfo.list == null || pageInfo.list.length == 0) {
		$("#rolePageBody").append("<tr><td colspan='4'>抱歉！没有查询到您要的数据</td></tr>");
		return;
	}
	
	for(var i = 0; i < pageInfo.list.length; i++) {
		var role = pageInfo.list[i];
		var roleId = role.id;
		var roleName = role.name;
		
		var numberTd = "<td>" + (i + 1) + "</td>";
		var checkboxTd = "<td><input id=" + roleId + " class='itemBox' type='checkbox'></td>";
		var roleNameTd = "<td>" + roleName + "</td>";
		
		var checkBtn = "<button type='button' id="+ roleId +" class='btn btn-success btn-xs checkBtn'><i class='glyphicon glyphicon-check'></i></button>";
		
		var pencilBtn = "<button type='button' id="+ roleId +" class='btn btn-primary btn-xs pencilBtn'><i class='glyphicon glyphicon-pencil'></i></button>";
		
		var removeBtn = "<button type='button' id="+ roleId +" class='btn btn-danger btn-xs removeBtn'><i class='glyphicon glyphicon-remove'></i></button>";
		
		var buttonTd = "<td>" + checkBtn + " " + pencilBtn + " " + removeBtn + "</td>";
		
		var tr = "<tr>" + numberTd + checkboxTd + roleNameTd + buttonTd + "</tr>";
		
		$("#rolePageBody").append(tr);
		
		generateNavigator(pageInfo);
	}
}

/**
 * 生成分页页面导航条
 * @param pageInfo
 * @returns
 */
function generateNavigator(pageInfo) {
	var totalRecord = pageInfo.total;
	var properties = {
		"num_edge_entries": 3, //边缘页数
		"num_display_entries": 5, //主体页数
		"callback": paginationCallback,
		"items_per_page": pageInfo.pageSize, //每页显示1项
		"current_page":pageInfo.pageNum - 1,
		"prev_text": "上一页",
		"next_text": "下一页"
		}
	$("#Pagination").pagination(totalRecord, properties);
}
/**
 * 翻页时的回调
 * @param pageIndex
 * @param jQuery
 * @returns
 */
function paginationCallback(pageIndex, jQuery) {
	window.pageNum = pageIndex + 1;
	generatePage();
	
	return false;
}