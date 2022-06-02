<!-- ���������� PG���� sample ����ȯ�� ������-->
<%@ page import="java.util.*" contentType="text/html;charset=euc-kr" %>

<!-- ���������� ���� KFTCPayNew.class �� �����-->
<jsp:useBean id="pay" class="KFTCPayNew"/>

<%
	String str = "";
	String TempValue;

	//�������۸�� �ʱ�ȭ
	pay.InitialMsg();
	
	/* TX�������� ��� ���� ������ ���� */
	pay.SetEnvParameter("TX_IP",           "127.0.0.1"); // TX������ ��ġ�� ������ IP
	pay.SetEnvParameter("TX_SERV_PORT",    "5000");      // TX������ Listen�ϰ� �ִ� PORT��ȣ		
	pay.SetEnvParameter("TX_TIME_OUT",     "30");        // TX�������� �Ϲݰŷ����� ��Ŵ�� �ִ�ð� (��)
	pay.SetEnvParameter("CANCEL_TIME_OUT", "30");        // TX�������� ��Ұŷ����� ��Ŵ�� �ִ�ð� (��)
	
	// �� TX������ ������ ���� TIMEOUT ���� ������ �������� ������ �� �ֱ⿡ ���� ������ �߰� ����
	pay.SetEnvParameter("TX_TIMEOUT",      "30");        // TX�������� �Ϲݰŷ����� ��Ŵ�� �ִ�ð� (��)
	pay.SetEnvParameter("CANCEL_TIMEOUT",  "30");        // TX�������� ��Ұŷ����� ��Ŵ�� �ִ�ð� (��)
	

	// ȯ�ҿ�û �������κ��� �Ѱܹ��� form�� ������ �о hd_ �Ǵ� tx_�� ���۵Ǵ� ������ ������ �����Ѵ�.	
	/* [���� ] ���üҽ������� ȯ�ҿ�û ������(refund.html)�κ��� '��ü���ι�ȣ','�ŷ���ȣ', '���ŷ�����', 'ȯ������',
	 *      'ȯ�ҿ�û�ݾ�', '��û��������' ���������ϰ� �Ǿ� ������, ���� ȯ�ұ�� �����ÿ��� �ش� ������ ��� �̿��� ���������� DB��ȸ�Ͽ�  �����ص� ������. 
	 */
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
	
	/* '��û��������', '��ü���ι�ȣ','�ŷ���ȣ', '���ŷ�����', 'ȯ������', 'ȯ�ҿ�û�ݾ�' ���� �̿��� ���������� �����ϰ��� �� ��� �Ʒ����� ���� */
	/*
	pay.setPayMsg("hd_cancel_type",        "....");   // (�ʼ�) ��û�������� ('RD':�ǽð�ȯ�ҿ�û, 'RQ':�ǽð�ȯ�Ұ����ȸ)
	pay.setPayMsg("hd_approve_no",         "....");   // (�ʼ�) �̿������ι�ȣ
	pay.setPayMsg("hd_serial_no",          "....");   // (�ʼ�) ���ŷ� �ŷ���ȣ
	pay.setPayMsg("hd_pay_date",           "....");   // (�ʼ�) ���ŷ� ���� (YYYYMMDD)
	pay.setPayMsg("tx_partial_cancel_cnt", "....");   // (�ʼ�) ȯ������ 
	pay.setPayMsg("tx_amount",             "....");   // (�ʼ�) ȯ�ҿ�û�ݾ� (ȯ�Ұ����ȸ('RQ')�ÿ��� ���ʿ�)
	*/
		
	/* ȯ�ҿ�û �������κ��� �Ѱܹ��� form �� �ܿ� ������ �ʿ��� �߰� ������ �����Ѵ�. */	
	pay.setPayMsg("hd_msg_type",           "EFT");    // (�ʼ�) �������ܱ��� ("EFT" ������ ���)
	pay.setPayMsg("hd_msg_code",           "0420");   // (�ʼ�) ������������ ("0420" ������ ���)
	pay.setPayMsg("tx_out_acnt_no",           "....");   // �̿��� ȯ�Ұ��� (�ǽð� ȯ���� ��� �ʼ�)
	
	
	// TX������ ������ �����ϰ� ó�� ������� �޾ƿ��� �κ�
	int result = pay.getPayProc();

	/************************************************************
	�Ʒ��� ������� ���� ���� ���� �������������� ó���� ��������� Ȯ���ϴ� �κ�
	************************************************************/
	String hd_resp_code			 = pay.getPayMsg("hd_resp_code");   // ȯ������  �����ڵ�(����:000, ����:000�̿��� �� - �󼼳��� �����ڵ尡�̵� ����)
	String hd_msg_type 			 = pay.getPayMsg("hd_msg_type");    // �������� ����
	String hd_approve_no 		 = pay.getPayMsg("hd_approve_no");  // �̿��� ���ι�ȣ
	String hd_serial_no 		 = pay.getPayMsg("hd_serial_no");   // �ŷ���ȣ
	String hd_pay_date 			 = pay.getPayMsg("hd_pay_date");    // ���ŷ�����
	String hd_cancel_type 		 = pay.getPayMsg("hd_cancel_type"); // ȯ�ұ���(�̿������� �ǽð� ȯ��(RD)�� ��û�ص� ������ ����ȯ�ҷ� ó���Ǿ� �����û ���� ����ȯ�ҷ� ó���� ��� ����ȯ�ҷ� ó���Ǿ� (D)�� ����� ���� ���� ����)
	String hd_trans_time 		 = pay.getPayMsg("hd_trans_time");  // ó���ð�
	String tx_amount 			 = pay.getPayMsg("tx_amount");      // ȯ�ұݾ�	
	String tx_partial_cancel_cnt = pay.getPayMsg("tx_partial_cancel_cnt"); // ȯ������
	String tx_cancel_remain		 = pay.getPayMsg("tx_cancel_remain"); // ȯ�Ұ����ܾ�
	String tx_cancel_date		 = pay.getPayMsg("tx_cancel_date");   // ȯ����������
	
	// �������۸�� ����
	pay.FinishMsg();
%>

<html>
<head>
	<title>BankPay ȯ���׽�Ʈ ��� ȭ��</title>
	<style type=text/css>
	<!-- td {  font-family: ����; font-size: 11pt; } -->
	</style>
</head>

<body bgcolor="ivory">
<p></p>
<p align="center"><font color="blue"><b>ȯ��ó�� ���</b></font></p><p></p>

	<!-- ȯ�� ��� ��� -->
	<p>
	<table align="center" border="1">
	<tr><td width="130">������ </td>      <td width="170">��</td></tr>
	<tr><td>hd_resp_code</td>          <td><font color=red><%=hd_resp_code%></font></td></tr>
	<tr><td>hd_msg_type</td>           <td><%=hd_msg_type%></td></tr>
	<tr><td>hd_approve_no</td>         <td><%=hd_approve_no%></td></tr>
	<tr><td>hd_serial_no</td>          <td><%=hd_serial_no%></td></tr>
	<tr><td>hd_pay_date</td>           <td><%=hd_pay_date%></td></tr>
	<tr><td>tx_amount</td>             <td><%=tx_amount%></td></tr>	
	<tr><td>hd_cancel_type</td>        <td><%=hd_cancel_type%></td></tr>	
	<tr><td>tx_partial_cancel_cnt</td> <td><%=tx_partial_cancel_cnt%></td></tr>	
	<tr><td>tx_cancel_remain</td>      <td><%=tx_cancel_remain%></td></tr>	
	<tr><td>tx_cancel_date</td>        <td><%=tx_cancel_date%></td></tr>
	
	<tr><td></td><td></td></tr>

	<tr><td>�����ڵ忹��ǥ</td><td>���</td></tr>
	<tr><td>000</td><td>��� �ŷ� ����</td></tr>
	<tr><td>820</td><td>ȯ�ҿ�û�����Ϸ�</td></tr>
	<tr><td>821</td><td>�ش� ȯ�Ұŷ� ����(ȯ�� ó�� ��� ��ȸ��)</td></tr>
	<tr><td>822</td><td>�̿��� �Աݱݾ��� �ʰ��� ȯ�� �ŷ�(ȯ�� ó�� ��� ��ȸ��)</td></tr>
	<tr><td>901</td><td>��Ʈ��ũ ���� ����</td></tr>
	<tr><td>903</td><td>�ŷ� �ð� �ʰ� ����</td></tr>
	<tr><td>912</td><td>��й�ȣ ����</td></tr>
	<tr><td>930</td><td>�������νý��ۿ���</td></tr>
	<tr><td>960</td><td>��������</td></tr>
	<tr><td>981</td><td>���ŷ��ݾ��ʰ�</td></tr>
	<tr><td>982</td><td>ȯ����������</td></tr>
	<tr><td>993</td><td>�ݾ׻���</td></tr>
	<tr><td>994,350</td><td>���ŷ�����(�κ�ȯ�ҽ� ���� ȯ�������� �ߺ��Ǵ� ���)</td></tr>
	</table>
	
</body>
</html>
