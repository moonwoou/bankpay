<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="java.util.*"%>
<%
	/*
	 * Do not cache this page.
	 */
	response.setHeader("cache-control","no-cache");
	response.setHeader("expires","-1");
	response.setHeader("pragma","no-cache");

	/*
	 *	Get the form elements
	 */
	String hd_ep_type	= request.getParameter("hd_ep_type");
	String hd_pi	= request.getParameter("hd_pi");
	String errCode = "";
	String authMsg = "";
	if (hd_pi == null || "".equals(hd_pi)) {
		authMsg = "인증실패. 인증결과를 넘겨주지 않았습니다.";
	}
%>
<html>
<head>
<title>뱅크페이 결제 서비스 진행중</title>
<script type="text/javascript">
	function unload_me()
	{
		if( "<%=authMsg%>" != "" ) {
			alert("<%=authMsg%>");
		}
		
		top.opener.paramSet("<%=hd_pi%>", "<%=hd_ep_type%>");
		top.opener.proceed();

 		parent.close();

	}
</script>
</head>
<body onload="unload_me();">
</body>
</html>
