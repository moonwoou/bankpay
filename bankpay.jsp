<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%  
request.setCharacterEncoding("EUC-KR");

/*
 * Do not cache this page.
 */
response.setHeader("cache-control","no-cache");
response.setHeader("expires","-1");
response.setHeader("pragma","no-cache");

/*
 *	Get the form variable and HTTP header
 */
 String hd_msg_code		= request.getParameter("hd_msg_code");
 String hd_msg_type		= request.getParameter("hd_msg_type");
 String hd_approve_no	= request.getParameter("hd_approve_no");
 String hd_serial_no	= request.getParameter("hd_serial_no");
 String hd_firm_name	= request.getParameter("hd_firm_name");
 String hd_item_name	= request.getParameter("hd_item_name");
 String tx_amount		= request.getParameter("tx_amount");
 
 String tx_bill_yn		= request.getParameter("tx_bill_yn");
 String tx_vat_yn		= request.getParameter("tx_vat_yn");
 String tx_bill_vat		= request.getParameter("tx_bill_vat");
 String tx_svc_charge	= request.getParameter("tx_svc_charge");
 String tx_bill_tax		= request.getParameter("tx_bill_tax");
 String tx_bill_deduction = request.getParameter("tx_bill_deduction");
 String tx_age_check	= request.getParameter("tx_age_check");
 
 
 String sbp_service_use	= request.getParameter("sbp_service_use");
 String sbp_tab_first	= request.getParameter("sbp_tab_first");
 String returnURL		= request.getParameter("returnURL");
 
 
 String tx_guarantee		= request.getParameter("tx_guarantee");
 String tx_user_key			= request.getParameter("tx_user_key");
 String hd_default_institution = request.getParameter("hd_default_institution");
 String bankpayURL 			= request.getParameter("bankpayURL");

if (hd_msg_code == null || hd_msg_code.equals(""))				hd_msg_code = "0200";
if (hd_msg_type == null || hd_msg_type.equals(""))				hd_msg_type = "EFT";
if (hd_approve_no == null || hd_approve_no.equals(""))			hd_approve_no = "";
if (hd_serial_no == null || hd_serial_no.equals(""))			hd_serial_no = "";
if (hd_firm_name == null || hd_firm_name.equals(""))			hd_firm_name = "";
if (hd_item_name == null || hd_item_name.equals(""))			hd_item_name = "";
if (tx_amount == null || tx_amount.equals(""))					tx_amount = "";

if (tx_bill_yn == null || tx_bill_yn.equals(""))				tx_bill_yn = "N";  //
if (tx_vat_yn == null || tx_vat_yn.equals(""))					tx_vat_yn = "";
if (tx_bill_vat == null || tx_bill_vat.equals(""))				tx_bill_vat = ""; // 미입력시 자동계산
if (tx_svc_charge == null || tx_svc_charge.equals(""))			tx_svc_charge = "";
if (tx_bill_tax == null || tx_bill_tax.equals(""))				tx_bill_tax = "";
if (tx_bill_deduction == null || tx_bill_deduction.equals(""))	tx_bill_deduction = "";
if (tx_age_check == null || tx_age_check.equals(""))			tx_age_check = "";


if (sbp_service_use == null || sbp_service_use.equals(""))		sbp_service_use = "Y";
if (sbp_tab_first == null || sbp_tab_first.equals(""))			sbp_tab_first = "Y";
if (returnURL == null || returnURL.equals(""))					returnURL = "pay.jsp";

if (tx_guarantee == null || tx_guarantee.equals(""))			tx_guarantee = "N";
if (tx_user_key == null || tx_user_key.equals(""))				tx_user_key = "";
if (hd_default_institution == null || hd_default_institution.equals(""))	hd_default_institution = "";
if (bankpayURL == null || bankpayURL.equals(""))				bankpayURL = "https://www.bankpay.or.kr:7443/StartBankPay.do"; // 미지정시 운영


String ret = HttpUtils.getRequestURL(request).toString();
String termUrl = ret.substring(0, ret.lastIndexOf("/")) + "/auth_host.jsp";

String auth_msg = "";
boolean result = false;

if(hd_approve_no.equals("")){
	result = false;
	auth_msg = "hd_approve_no is null";
} else if(hd_serial_no.equals("")){
	result = false;
	auth_msg = "hd_serial_no is null";
} else if(hd_firm_name.equals("")){
	result = false;
	auth_msg = "hd_firm_name is null";
} else if(tx_amount.equals("")){
	result = false;
	auth_msg = "tx_amount is null";
} else {
	result = true;
}


// Operation succeeded 
if (result) 
{

%>
<html>
	<head>
		<title>금융결제원 뱅크페이</title>
	</head>
	<body OnLoad="onLoadProc();">
		<Script Language="JavaScript">
			var cnt = 0;
			var timeout = 600;
			var k_timeout = 1;
			var processed = false;
			var goon = false;
			var childwin = null;
    	
    	
			function popupIsClosed()
			{
				if(childwin) {
					if(childwin.closed) {
						if( !goon ) {
							if( !processed ) {
								processed = true;
								self.setTimeout("popupIsClosed()", 2000);
							}// else popError("인증처리 중 문제가 발생하였습니다.(1)");
						}
					} else {
						cnt++;
						if(cnt > timeout) {
							popError("작업시간이 초과되었습니다.");
						} else {
							self.setTimeout("popupIsClosed()", 1000);
						}
					}
				} else if ( childwin == null ) {
					cnt++;
					if ( cnt > k_timeout ) {
						popError("팝업창이 차단되었습니다. 팝업 차단을 해제해 주십시오.");
					} else {
						self.setTimeout("popupIsClosed()", 1000);
					}
					
				} else {
					popError("인증처리 중 문제가 발생하였습니다.(2)");
				}
			}

			function popError(arg)
			{
				if( childwin ) {
					childwin.close();
				}
				alert(arg);
			}

			function onLoadProc() 
			{			
				leftPosition = (screen.width-720)/2-10;
				topPosition = (screen.height-600)/2-50;
				childwin = window.open('about:blank','BANKPAYPOPUP', 'top='+topPosition+',left='+leftPosition+',height=600,width=720,status=no,dependent=no,scrollbars=no,resizable=no');
				
				document.postForm.target = 'BANKPAYPOPUP';
				document.postForm.submit();
				popupIsClosed();
			}
		
			
			function paramSet(hd_pi, hd_ep_type)
			{
				var frm = document.frmRet;
				frm.hd_pi.value = hd_pi;
				frm.hd_ep_type.value = hd_ep_type;
			}

			function proceed() {
				var frm = document.frmRet;
				goon = true;
				frm.submit();
			}
		</Script>

		<form name="postForm" action="<%=bankpayURL%>" method="POST">
			<input type=hidden name=hd_msg_code   	value="<%=hd_msg_code%>">
			<input type=hidden name=hd_msg_type 	value="<%=hd_msg_type%>">
			<input type=hidden name=hd_approve_no   value="<%=hd_approve_no%>">
			<input type=hidden name=hd_serial_no    value="<%=hd_serial_no%>">
			<input type=hidden name=hd_firm_name    value="<%=hd_firm_name%>">
			<input type=hidden name=hd_item_name    value="<%=hd_item_name%>">
			<input type=hidden name=tx_amount    	value="<%=tx_amount%>">
			<!-- 현금영수증 관련 파라미터 -->
			<input type=hidden name=tx_bill_yn      value="<%=tx_bill_yn%>">
			<input type=hidden name=tx_vat_yn      	value="<%=tx_vat_yn%>">
			<input type=hidden name=tx_bill_vat     value="<%=tx_bill_vat%>">
			<input type=hidden name=tx_svc_charge   value="<%=tx_svc_charge%>">
			<input type=hidden name=tx_bill_tax     value="<%=tx_bill_tax%>">
			<input type=hidden name=tx_bill_deduction  	value="<%=tx_bill_deduction%>">
			
			<input type=hidden name=tx_age_check   	value="<%=tx_age_check%>">
			
			<input type=hidden name=sbp_service_use value="<%=sbp_service_use%>">
			<input type=hidden name=sbp_tab_first   value="<%=sbp_tab_first%>">
			<input type=hidden name=termURL      	value="<%=termUrl%>">
			
			<input type=hidden name=tx_guarantee	value="<%=tx_guarantee%>">
 			<input type=hidden name=tx_user_key		value="<%=tx_user_key%>">
 			<input type=hidden name=hd_default_institution	value="<%=hd_default_institution%>">
		</form>
		
		
		<form name=frmRet method=post action="<%=returnURL%>">
			<!-- 암호화된 결제정보 파라미터 -->
			<input type=hidden name=hd_pi      		value="">
			<input type=hidden name=hd_ep_type      value="">
			
			<input type=hidden name=hd_msg_code   	value="<%=hd_msg_code%>">
			<input type=hidden name=hd_msg_type 	value="<%=hd_msg_type%>">
			
			<input type=hidden name=hd_approve_no   value="<%=hd_approve_no%>">
			<input type=hidden name=hd_serial_no    value="<%=hd_serial_no%>">
			<input type=hidden name=hd_firm_name    value="<%=hd_firm_name%>">
			<input type=hidden name=hd_item_name    value="<%=hd_item_name%>">
			<input type=hidden name=tx_amount    	value="<%=tx_amount%>">
			<!-- 현금영수증 관련 파라미터 -->
			<input type=hidden name=tx_bill_yn      value="<%=tx_bill_yn%>">
			<input type=hidden name=tx_vat_yn      	value="<%=tx_vat_yn%>">
			<input type=hidden name=tx_bill_vat     value="<%=tx_bill_vat%>">
			<input type=hidden name=tx_svc_charge   value="<%=tx_svc_charge%>">
			<input type=hidden name=tx_bill_tax     value="<%=tx_bill_tax%>">
			<input type=hidden name=tx_bill_deduction  	value="<%=tx_bill_deduction%>">
			
			<input type=hidden name=tx_age_check   	value="<%=tx_age_check%>">
			
			<input type=hidden name=tx_guarantee	value="<%=tx_guarantee%>">
			<input type=hidden name=tx_user_key		value="<%=tx_user_key%>">
		</form>
	</body>
</html>
<%
			return;	// done successfully
} 

// parameter is wrong
%>

<html>
	<script language=javascript>
		function onLoadProc()
		{
			if( "<%=auth_msg%>" != "" ) {
				alert("<%=auth_msg%>");
			}      
		}
	</script>
	<body onload="javascript:onLoadProc();"> 
	</body>
</html>
