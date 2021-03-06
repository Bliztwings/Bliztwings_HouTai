<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<%@ taglib prefix='fmt' uri="http://java.sun.com/jsp/jstl/fmt" %>  
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path;
	String realPath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "storeBusiness";
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>门店收衣</title>

	<link type="text/css" href="<%=basePath%>/zui-1.5.0/css/zui.min.css" rel="stylesheet" />
	<script type="text/javascript" src="<%=basePath%>/zui-1.5.0/lib/jquery/jquery.js"></script>
	<script type="text/javascript" src="<%=basePath%>/zui-1.5.0/js/zui.min.js"></script>
	<script type="text/javascript" src="<%=basePath%>/zui-1.5.0/lib/datatable/zui.datatable.js"></script>
	<link type="text/css" href="<%=basePath%>/zui-1.5.0/lib/datatable/zui.datatable.css" rel="stylesheet" />
	<script src="<%=basePath%>/js/jquery/jquery.form.js" type="text/javascript"></script>
	<script type="text/javascript" src="<%=basePath%>/js/jquery/jquery.json-2.2.js"></script>
	
	<!--  art.dialog  -->
	<link href="<%=basePath%>/js/artDialog4.1.7/skins/blue.css" rel="stylesheet" type="text/css" />
	<script src="<%=basePath%>/js/artDialog4.1.7/artDialog.js" type="text/javascript"></script>
	<script src="<%=basePath%>/js/artDialog4.1.7/plugins/iframeTools.source.js" type="text/javascript"></script>
		
	<!--  Ztree  -->
    <link rel="stylesheet" href="<%=basePath%>/zui-1.5.0/lib/datetimepicker/datetimepicker.min.css">
    <script src="<%=basePath%>/zui-1.5.0/lib/datetimepicker/datetimepicker.min.js"></script>
    
    <!-- vue1.0 -->
    <link rel="stylesheet" type="text/css" href="<%=basePath%>/js/vue1.0/iview.css">
    <script type="text/javascript" src="<%=basePath%>/js/vue1.0/vue.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>/js/vue1.0/vue-resource.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>/js/vue1.0/iview.min.js"></script>

	<style type="text/css">
		.nav_tit {
			height: 40px;
			font: 14px/40px 'Microsoft Yahei';
			color: #000;
			padding-left: 25px;
			background-image: url(<%=basePath%>/common/images/public/next.gif);
			background-repeat: no-repeat;
			background-position: 10px 13px;
			background-color: #EDF6FA;
			border-bottom: 1px double #D7E4EA;
		}

		.nav_tit em {
			height: 40px;
			font: 14px/40px 'Microsoft Yahei';
			color: #000;
			float: left;
		}
</style>


<script type="text/javascript">

	//$('#datatable').datatable({fixedHeaderOffset: 41, checkable: true});
	jQuery(document).ready(function(){
		$("#queryKey").focus();
	});
	
	// 新增衣物
	function addClothes(){
		var cardNumber =$("#cardNumber").val();
		var memberId =$("#memberId").val();
		var orderCode =$("#orderCode").val();
		var orderId =$("#orderId").val();
		var queryKey =$("#queryKey").val();
		var mobilePhone =$("#mobilePhone").val();
		
		if(mobilePhone ==null || mobilePhone ==""){
			art.dialog.alert("新用户,请完善信息！");
			return;
		}
		art.dialog.open( '<%=basePath%>/storeBusiness/addClothes?orderId='+orderId+'&cardNumber='+cardNumber+'&memberId='+memberId+'&orderCode='+orderCode+'&queryKey='+queryKey, {
			title : '新增衣物',
			width : '100%',
			height : 800,
			lock : false,
			close:function (){
				queryMember();
			}
		});
	}
	
	
	// 结账
	function checkout(){
		
		var clothesCount =$("#clothesCount").val();
		if(clothesCount==null || clothesCount==0){
			art.dialog.alert("没有待结算的衣物!");
			return;
		}
		var cardNumber =$("#cardNumber").val();
		var memberId =$("#memberId").val();
		var orderCode =$("#orderCode").val();
		var orderId =$("#orderId").val();
		var arrears=0;
		// 判断是否办卡，没有办卡，只能选择现金支付
		art.dialog.open( '<%=basePath%>/storeBusiness/checkout?orderId='+orderId+'&cardNumber='+cardNumber+'&memberId='+memberId+'&orderCode='+orderCode+'&arrears='+arrears, {
			title : '选择结算方式',
			width : 500,
			height : 200,
			lock : false,
			close:function (){
				// 查询会员订单
				queryMember();
			}
		});
		
	}
	
	// 删除未送洗的衣服
	function deleteClothes(id){
		
		art.dialog.confirm('确实要删除该衣服吗？', function () {
			jQuery.ajax({
				url : "<%=basePath%>/storeBusiness/deleteClothes",
				type : "post",
				cache : false,
				dataType : "json",
				data : {'id':id},
				success : function(data, textStatus) {
					if (data.resultCode == "0") {
						art.dialog.alert(data.resultMsg);
					} else {
						art.dialog.alert(data.resultMsg,function(){
							queryMember();
						});
					}
				}
			});
		}, function () {
		});
		
	}
	//  查询
	function queryMember(queryKey){
		if(queryKey==null || queryKey==''){
			queryKey =$("#queryKey").val();
		}
		if(queryKey==null || queryKey ==''){
			art.dialog.alert("请输入手机号或者会员卡号!");
			return;
		}
		location.href = encodeURI("<%=basePath%>/storeBusiness/queryMember?queryKey="+queryKey);
	}
	
	// 增加用户信息
	function addMember(){
		art.dialog.open( '<%=basePath%>/member/beforeAdd', {
			title : '添加会员',
			width : 600,
			height : 500,
			lock : true,
			close:function (){
				var mobilePhone = art.dialog.data('mobilePhone'); // 读取子窗口返回的数据 
				$("#queryKey").val(mobilePhone);
				queryMember();
			}
		});
	}
	
	//注册键盘事件
	document.onkeydown = function(e) {
	    //捕捉回车事件
	    var ev = (typeof event!= 'undefined') ? window.event : e;
	    if(ev.keyCode == 13 && document.activeElement.id == "queryKey") {
	    	//document.getElementById("queryMember11").click();
	    	//alert("获取到内容：" + document.activeElement.value);
	    	queryMember(document.activeElement.value);
	    }
	}
	
	// 获取衣服附件
	function showAttach(clothesId){
		art.dialog.open( '<%=basePath%>/storeBusiness/showAttach?clothesId='+clothesId, {
			title : '衣服附件信息',
			width : 600,
			height : 300,
			lock : true
		});
	}
	
	// 显示照片
	function showPhoto(clothesId){
		art.dialog.open( '<%=basePath%>/storeBusiness/showPhoto?clothesId='+clothesId, {
			title : '照片列表',
			width : '100%',
			height : 800,
			lock : false,
			close:function (){
				
			}
		});
	}
	
	// 修改衣服
	function editClothes(clothesId){
		art.dialog.open( '<%=basePath%>/storeBusiness/editClothes?clothesId='+clothesId, {
			title : '修改衣物',
			width : '100%',
			height : 800,
			lock : false,
			close:function (){
				queryMember();
			}
		});
	}
	// 欠费洗涤
	function arrearsWashing(){
		var clothesCount =$("#clothesCount").val();
		if(clothesCount==null || clothesCount==0){
			art.dialog.alert("请选择送洗的衣物!");
			return;
		}
		var cardNumber =$("#cardNumber").val();
		var memberId =$("#memberId").val();
		var orderCode =$("#orderCode").val();

		art.dialog.confirm('确定欠费送洗该衣服吗？', function () {
			jQuery.ajax({
				url : "<%=basePath%>/storeBusiness/arrearsWashing",
				type : "post",
				cache : false,
				dataType : "json",
				data : {'orderCode':orderCode,'cardNumber':cardNumber,memberId:'memberId'},
				success : function(data, textStatus) {
					if (data.resultCode == "0") {
						art.dialog.alert(data.resultMsg);
					} else {
						art.dialog.alert(data.resultMsg,function(){
							queryMember();
						});
					}
				}
			});
		}, function () {
		});
		
	}
</script>
</head>

<!-- 异步表格   <body onload="ajaxReload()"> -->
<body id="content">

	<div class="nav_tit">
		<em>门店收衣</em>
	</div>
	<!-- 搜索条件 -->
	<form id="formId" name="formId" class="form-horizontal" role="form" method="post" action="<%=basePath%>/storeBusiness/queryMember">
		<div  style="padding-left: 10px; margin-top: 5px;">
			<input type="hidden" id="cardNumber" name="cardNumber" value="${memberCard.cardNumber}"/>
			<input type="hidden" id="memberId" name="memberId" value="${memberCard.memberId}"/>
			<input type="hidden" id="orderCode" name="orderCode" value="${orderCode}"/>
			<input type="hidden" id="orderId" name="orderId" value="${orderId}"/>
			<input type="hidden" id="mobilePhone" name="mobilePhone" value="${memberCard.mobilePhone}"/>
			<input type="hidden" id="clothesCount" value="${clothesCount}"/>
			<table cellpadding="0" cellspacing="0" border="0" width="100%" >
				<tr>
					<td width="10%">
						<div class="input-group" >
							<input id="queryKey" placeholder="手机号或者会员卡号或会员名称"  name="queryKey" value="${queryKey}" type="text" class="form-control" style="width: 200px;"> <!-- <span class="glyphicon glyphicon-star"></span> -->
						</div>
					</td>
					<td width="20px" align="left">
						<div class="input-group" style="padding-left: 10px;">
							<button class="btn btn-primary" type="button" id="queryMember11" onclick="queryMember()" style="margin-right: 10px;">查  询</button>
							<button class="btn btn-primary" type="button" id="transLogQueryBtn" onclick="addMember()" style="margin-right: 10px;">增加客户信息</button>
						</div>
					</td>
				</tr>
				
			</table>
			
			
			<table class="table  table-bordered" cellpadding="0" cellspacing="0" border="1" width="100%" >
				<tr>
					<td width="10%" align="right">
						姓名:
					</td>
					<td width="100px" align="left">
						${memberCard.memberName}
					</td>
					
					<td width="10%" align="right">
						会员卡号:
					</td>
					<td width="100px" align="left">
						<!-- <div id="cardNumber_div"></div> -->
						${memberCard.cardNumber}
					</td>
					
					<td width="10%" align="right">
						手机号:
					</td>
					<td width="100px" align="left">
						<div id="mobilePhone_div"></div>
						${memberCard.mobilePhone}
					</td>
				</tr>
				
				<tr>
					<td width="10%" align="right">
						会员卡名称:
					</td>
					<td width="100px" align="left">
						<!-- <div id="cardName_div"></div> -->
						<%-- ${memberCard.cardName} --%>
					</td>
					
					<td width="10%" align="right">
						卡状态:
					</td>
					<td width="100px" align="left">
						<!-- <div id="cardStatus_div"></div> -->
						${memberCard.cardStatus}
					</td>
					
					<td width="10%" align="right">
						卡余额:
					</td>
					<td width="100px" align="left">
						${memberCard.totalAmount}
					</td>
				</tr>
				
			</table>
	
		</div>
<br style="border: 1px;border-color: fff"/>
<article>
		<!-- 表格-->
		<div class="segment">
			<div id="dtFromData"></div>
			
			<div style="padding-right: 10px;">
				<div class="input-group" style="padding-left: 10px;padding-bottom: 5px;">
					<button class="btn btn-primary" type="button" id="transLogQueryBtn" onclick="addClothes()" style="margin-right: 10px;">添衣</button>
					<button class="btn btn-primary" type="button" id="transLogQueryBtn" onclick="checkout()" style="margin-right: 10px;">结账</button>
					<button class="btn btn-primary" type="button" id="transLogQueryBtn" onclick="arrearsWashing()" style="margin-right: 10px;">欠费洗涤</button>
				</div>
			</div>
			
			<div style="padding-left: 10px; padding-right: 10px;">
				<table class="table datatable table-bordered  table-hover" id="datatable">
					<thead>
						<tr>
							<th class='text-center' data-col-class='text-center' data-width='10%' class='text-primary'>门店</th>
							<th class='text-center' data-col-class='text-center' data-width='10%' class='text-primary'>衣物条码</th>
							<th class='text-center' data-col-class='text-center' data-width='10%' class='text-primary'>服务类型</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>衣物名称</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>颜色</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>品牌</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>附件</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>瑕疵</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>衣物价格</th>
							<!-- <th class='text-center' data-col-class='text-center' data-width='10%'>服务费</th> -->
							<th class='text-center' data-col-class='text-center' data-width='10%'>小计</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>照片</th>
							<th class='text-center' data-col-class='text-center' data-width='10%'>操作</th>
						</tr>
					</thead>
					<!-- 同步表格 -->
					<tbody>
 						<!--  PageHelper -->
						<c:forEach items="${clothesList}" var="clothes">
							<tr>
								<td class='text-center'>${clothes.storeName}</td>
							    <td class='text-center'>${clothes.barCode}</td>
							    <td class='text-center'>${clothes.serviceType}</td>
							    <td class='text-center'>${clothes.clothesName}</td>
							    <td class='text-center'>${clothes.color}</td>
							    <td class='text-center'>${clothes.brand}</td>
							    <td class='text-center' onclick="showAttach('${clothes.id}')">${clothes.attachment}</td>
							    <td class='text-center'>${clothes.flaw}</td>
							    <td class='text-center'>${clothes.price}元</td>
							    <%-- <td class='text-center'>${clothes.serviceFee}元</td> --%>
							    <td class='text-center'>${clothes.price}元</td>
							    
							    <td class='text-center'>
								    <c:if test="${clothes.hasPhoto=='1'}" >
										<a href="javascript:void(0)" onclick="showPhoto('${clothes.id}')">照片</a>
									</c:if>		
							    </td>
							    					    
							    <td class='text-center'>
							    	<%-- <c:if test="${clothes.status=='0'}">
							    		<a href="javascript:void(0)" onclick="deleteClothes('${clothes.id}')">删除</a>
							    	</c:if>
							    	
							    	<c:if test="${clothes.status!='0'}">
							    		<a href="javascript:void(0)" onclick="deleteClothes('${clothes.id}')">&nbsp;</a>
							    	</c:if> --%>
							    	<a href="javascript:void(0)" onclick="deleteClothes('${clothes.id}')">删除</a>|
							    	<a href="javascript:void(0)" onclick="editClothes('${clothes.id}')">修改</a>
							    </td>
							</tr>
						</c:forEach>
					</tbody>
					
					<tfoot>
						<td align="right" colspan="11">		
						<!--  PageHelper -->	
						<jsp:include page="../../inc/page_PageHelper.jsp">
								<jsp:param name="path" value="/storeBusiness" />
						</jsp:include></td>
					</tfoot>
				</table>
			</div>
			
			
			<c:if test="${orderCode !=null && orderCode !=''}">
				<div style="color: red;margin: 10px;font-size: 15px">订单编号：${orderCode}&nbsp;&nbsp;&nbsp;衣服件数：${clothesCount} 件</div>
			</c:if>
			
		</div>
		</article>
	</form>
</body>

<script type="text/javascript">
$('table.datatable').datatable({	
	sortable: true,
	checkable: false,
	storage: false,
    //checkedClass: "checked",
	fixedHeaderOffset: 0
	
});

var total = parseInt('${page.total}');
var pageNum = parseInt('${page.pageNum}');
var pageSize = parseInt('${page.pageSize}');


var vm = new Vue({
    el: '#content',
    data: {
        pagination: {
        	total : total,
        	pageNum : pageNum,
        	pageSize : pageSize
        },
    },
	methods: {
		    search: function(nextPage) {
		    	var paras = $("#formId").serialize();
		    	var pageParas = '&pageNum='+nextPage+'&pageSize='+this.pagination.pageSize;
		    	location.href = '<%=basePath%>/store/list?'+paras+pageParas;
		    },
		    doSearch: function(){
		    	var paras = $("#formId").serialize();
		    	location.href = '<%=basePath%>/store/list?'+paras;
		    },
		    resetSearch : function(){
		    	location.href = '<%=basePath%>/store/list';
		    }
	}
});   
</script>
</html>