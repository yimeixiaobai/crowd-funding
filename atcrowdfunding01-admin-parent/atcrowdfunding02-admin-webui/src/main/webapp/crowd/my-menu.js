
function generateTree() {
	$.ajax({
		"url": "menu/get/whole/tree.json",
		"type": "post",
		"dataType": "json",
		"success": function(response) {
			
			var result = response.result;
			if(result == "SUCCESS") {
				// 设置
				var setting = {
					"view": {
						"addDiyDom": myAddDiyDom,
						"addHoverDom": myAddHoverDom,
						"removeHoverDom": myRemoveHoverDom
					},
					"data": {
						"key": {
							"url":"mimi"
						}
					}
				};
				var zNodes = response.data;
				$.fn.zTree.init($("#treeDemo"), setting, zNodes);
			}
			if(result == "FAILED") {
				layer.msg(reponse.message);
			}
		},
		"error": function(response) {
			
		}
	})
}
function myAddHoverDom(treeId, treeNode) {
	
	
	var anchorId = treeNode.tId + "_a";
	
	var btnGroupId = treeNode.tId + "_btnGroup";
	if($("#" + btnGroupId).length > 0) {
		return;
	}
	
	// 准备各个按钮的 HTML 标签 
	var addBtn = "<a id='"+treeNode.id+"' class='addBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='添加子节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-plus rbg '></i></a>"; 
	var removeBtn = "<a id='"+treeNode.id+"' class='removeBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='删除节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-times rbg '></i></a>";
	var editBtn = "<a id='"+treeNode.id+"' class='editBtn btn btn-info dropdown-toggle btn-xs' style='margin-left:10px;padding-top:0px;' href='#' title='修改节点'>&nbsp;&nbsp;<i class='fa fa-fw fa-edit rbg '></i></a>";
	
	var level = treeNode.level;
	var btnHTML = "";
	if(level == 0) {
		btnHTML = addBtn;
	}
	if(level == 1) {
		btnHTML = addBtn + " " + editBtn;
		
		var length = treeNode.children.length;
		if(length == 0) {
			btnHTML += " " + removeBtn;
		}
	}
	if(level == 2) {
		btnHTML = editBtn + " " + removeBtn;
	}
	$("#" + anchorId).after("<span id='" + btnGroupId + "'>" + btnHTML + "</span>")
}

function myRemoveHoverDom(treeId, treeNode) {
	// 拼接按钮组的 id 
	var btnGroupId = treeNode.tId + "_btnGroup"; 
	// 移除对应的元素 
	$("#"+btnGroupId).remove();
}

function myAddDiyDom(treeId, treeNode) {
	console.log("treeId = " + treeId);
	console.log(treeNode)
	
	var spanId = treeNode.tId + "_ico";
	
	$("#" + spanId).removeClass().addClass(treeNode.icon);
}