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
		authMsg = "��������. ��������� �Ѱ����� �ʾҽ��ϴ�.";
	}
%>
<html>
<head>
<title>��ũ���� ���� ���� ������</title>
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
