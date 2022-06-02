<!-- ���������� PG���� sample ������� ������-->
<%@ page import="java.util.*" contentType="text/html;charset=euc-kr" %>

<!-- ���������� ���� KFTCPayNew.class �� �����-->
<jsp:useBean id="pay" class="KFTCPayNew"/>

<%
	String str = "";

    // �������۸�� �ʱ�ȭ
	pay.InitialMsg();
	
	/* TX�������� ��� ���� ������ ���� */		
	pay.SetEnvParameter("TX_IP",           "127.0.0.1"); // TX������ ��ġ�� ������ IP
	pay.SetEnvParameter("TX_SERV_PORT",    "5000");      // TX������ Listen�ϰ� �ִ� PORT��ȣ	
	pay.SetEnvParameter("TX_TIMEOUT",      "30");        // TX�������� �Ϲݰŷ����� ��Ŵ�� �ִ�ð� (��)
	pay.SetEnvParameter("CANCEL_TIMEOUT",  "30");        // TX�������� ��Ұŷ����� ��Ŵ�� �ִ�ð� (��)
		
	// ��ҿ�û �������κ��� �Ѱܹ��� form�� ������ �о hd_ �Ǵ� tx_�� ���۵Ǵ� ������ ������ �����Ѵ�.	
	/* [���� ] ���üҽ������� ��ҿ�û ������(cancel.html)�κ��� '��ü���ι�ȣ','�ŷ���ȣ', '���ŷ�����', '���ŷ��ݾ�' ����
	 *        �����ϰ� �Ǿ� ������, ���� ��ұ�� �����ÿ��� �ش� ���鵵 ��� �̿��� ���������� DB��ȸ�Ͽ�  �����ص� ������. */	 
	Enumeration paraName=request.getParameterNames();
	while(paraName.hasMoreElements())
	{
		str = ((paraName.nextElement()).toString());
		String[] strValues = request.getParameterValues(str);		
		if ((str.substring(0, 3)).equals("hd_") || (str.substring(0,3)).equals("tx_"))
	    {
	      pay.setPayMsg(str, strValues[0]);
	    }
	}
	/* '��ü���ι�ȣ','�ŷ���ȣ', '���ŷ�����', '���ŷ��ݾ�' ���� �̿��� ���������� �����ϰ��� �� ��� �Ʒ����� ���� */
	/*
	pay.setPayMsg("hd_approve_no",         "....");   // (�ʼ�) �̿������ι�ȣ
	pay.setPayMsg("hd_serial_no",          "....");   // (�ʼ�) ���ŷ� �ŷ���ȣ
	pay.setPayMsg("hd_pay_date",           "....");   // (�ʼ�) ���ŷ� ���� (YYYYMMDD)
	pay.setPayMsg("tx_amount",             "....");   // (�ʼ�) ���ŷ� �ݾ�
	*/
	 	
	/* ��ҿ�û �������κ��� �Ѱܹ��� form �� �ܿ� ������ �ʿ��� �߰� ������ �����Ѵ�. */	
	pay.setPayMsg("hd_msg_type",           "EFT");    // (�ʼ�) �������ܱ��� ("EFT" ������ ���)
	pay.setPayMsg("hd_msg_code",           "0420");   // (�ʼ�) ������������ ("0420" ������ ���)
	pay.setPayMsg("hd_cancel_type",        "M");      // (�ʼ�) ���Ÿ�� ("M" ������ ���)
	pay.setPayMsg("tx_partial_cancel_cnt", "1");      // (�ʼ�) ������� ("1" ������ ���)
	pay.setPayMsg("hd_password",           "....");   // (�ʼ�) PG���� ����� ���� �߱޹��� �̿��� ���� ������ �н����� 
	
	// TX������ ������ �����ϰ� ó�� ������� �޾ƿ��� �κ�
	int result = pay.getPayProc();

	/************************************************************
             �Ʒ��� ������������ ��ȸ�ϴ� �κ��̸�, �ʿ��� �ʵ常 �����Ͽ� ��밡��
    ************************************************************/
	String hd_resp_code		=	pay.getPayMsg("hd_resp_code");   // ���ʰ�� �����ڵ�(����:000, ����:000�̿��� ��)
	String hd_msg_type 		=  	pay.getPayMsg("hd_msg_type");    // �������� ����
	String hd_approve_no 	= 	pay.getPayMsg("hd_approve_no");  // �̿��� ���ι�ȣ
	String hd_serial_no 	= 	pay.getPayMsg("hd_serial_no");   // �ŷ���ȣ
	String hd_pay_date 		= 	pay.getPayMsg("hd_pay_date");    // ���ŷ�����
	String hd_cancel_type 	= 	pay.getPayMsg("hd_cancel_type"); // ��ұ���
	String hd_trans_time 	=  	pay.getPayMsg("hd_trans_time");  // ó���ð�
	String tx_amount 		= 	pay.getPayMsg("tx_amount");      // �ŷ��ݾ�(��ұݾ�)
	String tx_user_define 	=  	pay.getPayMsg("tx_user_define"); // ����� �����ʵ�(80 bytes)
	
	// �������۸�� ����
	pay.FinishMsg();
%>

<html>
<head>
	<title>BankPay ����׽�Ʈ ��� ȭ��</title>
	<style type=text/css>
	<!-- td {  font-family: ����; font-size: 11pt; } -->
	</style>
</head>

<body bgcolor="ivory">
	<p>&nbsp;</p>
	<p align="center"><font color="blue"><b>���ó�� ���</b></font></p><p>&nbsp;</p>

	<!-- ��� ��� ��� -->
	<p>
	<table align="center" border="1">
	<tr><td width=130>������</td>  <td width=170>��</td></tr>
	<tr><td>hd_resp_code</td>      <td><font color=red><%=hd_resp_code%></font></td></tr>
	<tr><td>hd_msg_type</td>       <td><%=hd_msg_type%></td></tr>
	<tr><td>hd_approve_no</td>     <td><%=hd_approve_no%></td></tr>
	<tr><td>hd_serial_no</td>      <td><%=hd_serial_no%></td></tr>
	<tr><td>hd_pay_date</td>       <td><%=hd_pay_date%></td></tr>
	<tr><td>hd_trans_time</td>     <td><%=hd_trans_time%></td></tr>
	<tr><td>tx_amount</td>         <td><%=tx_amount%></td></tr>	
	<tr><td>tx_user_define</td>    <td><%=tx_user_define%></td></tr>
	</table>
	
	<br/><br/><br/><br/>	
	
	<table align="center" border="1">
	<tr><td>�����ڵ忹��ǥ</td><td>���</td></tr>
	<tr><td>000</td><td>��� �ŷ� ����</td></tr>
	<tr><td>901</td><td>��Ʈ��ũ ���� ����</td></tr>
	<tr><td>903</td><td>�ŷ� �ð� �ʰ� ����</td></tr>
	<tr><td>912</td><td>��й�ȣ ����</td></tr>
	<tr><td>993</td><td>�ŷ� ���� ����</td></tr>
	<tr><td>994</td><td>���ŷ� ����</td></tr>				
	</table>
	
</body>
</html>