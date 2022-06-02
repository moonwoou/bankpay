<!-- ���������� PG���� sample ����ó�� ������-->
<%@ page import="java.util.*" contentType="text/html;charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>

<!-- ���������� ���� KFTCPayNew.class �� �����-->
<jsp:useBean id="pay" class="KFTCPayNew"/>

<%
  String str = "";
  
  // �������۸�� �ʱ�ȭ
  pay.InitialMsg();
  
  // ���������� ���� TX���� ���α׷��� ��ġ�� ����IP
  pay.SetEnvParameter("TX_IP",    "127.0.0.1");           
  
  // TX�������� ��� PORT (TX������ Listen �ϰ� �ִ� ��Ʈ��ȣ)
  pay.SetEnvParameter("TX_SERV_PORT",  "5000");
 
  // TX������ �������� �۽� �� �������� �ִ� ��� �ð� (��)
  // �� TX������ �������������� �������� �۽� �� ����ϴ� �ð����� ���� ��
  pay.SetEnvParameter("TX_TIME_OUT",     "30");
 
  // TX������ ������� �۽� �� �������� �ִ� ��� �ð� (��)
  pay.SetEnvParameter("CANCEL_TIME_OUT", "30");
  // ������û �������κ��� �Ѱܹ��� form�� ������ �о hd_ �Ǵ� tx_�� ���۵Ǵ� ������ ������ �����Ѵ�.
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
  
  // PG�� ���â�� �Ķ����
  String hd_firm_name = request.getParameter("hd_firm_name");
  
   
  /* ������û �������κ��� �Ѱܹ��� form �� �ܿ� ������ �ʿ��� �߰� ������ �����Ѵ�.
   *
   * 1) �̿��� �Աݰ��� (�ʼ�)
   *   - �̿����� �Աݰ��¹�ȣ�� '-'���� ���ڸ� �Է�
   *
   * 2) ����� �����ʵ� (�ɼ�) 
   *   - �̿������� �����Ӱ� ����� �� �ִ� �ʵ��̸� �ִ� 80����Ʈ  �Է°���
   *     (��, �� ���νĺ� ������ ���Ȼ� �ΰ��� ������ �Է����� ����)
   *   - ����PG���� ���� ������ �������� �ʼ��� �Է��ؾ� ��  
   *     "��ü��(�������ڿ�, �ִ�5�ڸ�)^����ڹ�ȣ^��ü��(��ü)^��ǥ��ȭ��ȣ"
   *     (��)"�׽�Ʈ���^1234567890^Bankpay������ü�׽�Ʈ���^02-531-1825" 
   */   
  pay.setPayMsg("tx_receipt_acnt", (String)"�̿��� �Աݰ���");  
  pay.setPayMsg("tx_user_define",  (String)"�̿��� ���Ǽ�����");
    
  /***********************************************************
   * ��ŷ� ����Ͽ� �ݾ� �ʵ尪�� ���� ������ ���θ� �ݵ�� Ȯ���ؾ� ��!!
   * 
   *   ������û �������� �ݾ������� ��ŷ� ���� �������� �ʾҴ��� 
   *   �̿����� ���� DB�� ����Ǿ� �ִ� ��ǰ���� ���������κ��� ���޹��� ���� ��ġ�ϴ��� ���Ѵ�.
   *   �ݾ��� ����ġ �Ұ�� ������ ���ɼ��� �ִ°������� ������ �������� �ʰ� ���� ó���ϵ��� ��.
   ************************************************************/   
   String payAmount = (String)request.getParameter("tx_amount");  // ������������ ���޹��� �����ݾװ�
   String dbAmount  = (String)"�̿����� �˰� �ִ� ���� ��ǰ��";             // �̿����� �˰� �ִ� ���� ��ǰ��
   
   if (payAmount.equals(dbAmount) == false) 
   {
       // �ݾ��� ����ġ�� ��������� ������ �������� �ʰ� ����ó���ϵ��� ��
       // (ex) ����ó��ȭ������ forwarding �ϴµ��� ���� �ʿ�
       return;
   }  
  
  // TX������ ������ �����ϰ� ó�� ������� �޾ƿ��� �κ�
  int result = pay.getPayProc();
  /************************************************************
       �Ʒ��� ���䰪���� �ʿ�� �ϴ� �ʵ尪�� ȹ���ϴ� �κ�
  ************************************************************/
  String wi              = pay.getPayMsg("wi");  			 // ��ó������� ActivX�� PG������ �Ϸ�â���� �����ֱ� ���� ����ϴ� ��(��ȣȭ�Ǿ� ����)
  String hd_resp_code    = pay.getPayMsg("hd_resp_code");    // �������� �����ڵ�(����:000, ����:000�̿��� ��)
  String hd_msg_type     = pay.getPayMsg("hd_msg_type");     // ��������� ����
  String hd_approve_no   = pay.getPayMsg("hd_approve_no");   // ���̿��� ���ι�ȣ
  String hd_serial_no    = pay.getPayMsg("hd_serial_no");    // ��ŷ���ȣ
  String hd_pay_date     = pay.getPayMsg("hd_pay_date");     // ��ŷ�����(YYYYMMDD)
  String hd_trans_time   = pay.getPayMsg("hd_trans_time");   // ��ŷ��ð�(YYYYMMDDhhmmss) ��1)
  String tx_receipt_date = pay.getPayMsg("tx_receipt_date"); // ���Ա�����(YYYYMMDD)
  String tx_amount       = pay.getPayMsg("tx_amount");       // ��ŷ��ݾ�(�������� �����ϵ� �ּҴ����� 10��) ��2)
  String tx_fee          = pay.getPayMsg("tx_fee");          // ���̿���(���θ�) �Աݽ� ������ ������
  String tx_age_check    = pay.getPayMsg("tx_age_check");    // �񿬷�üũ �ŷ�����(Y19 or N19)
  String tx_user_define  = pay.getPayMsg("tx_user_define");  // ������ �����ʵ�(80 bytes)
  String tx_receipt_bank = pay.getPayMsg("tx_receipt_bank"); // ���Աݰ����� �����ڵ�
  String tx_receipt_acnt = pay.getPayMsg("tx_receipt_acnt"); // ���Աݰ����� ���¹�ȣ
  //�� �������������� �����ϴ� �����Ϸ� �˾�â�� ������� �ʰ�
  // �̿����� �����Ϸ�â�� ���� ����ϴ� ���(JsResult(), WebResult() �Լ��� ȣ������ �ʴ� ���),
  // ��~�� �׸񿡼� ������ �Ķ���͸� ����ϵ��� �Ѵ�.
  
  /********************************************************************************
      ��1) �������ƿ� �߻��� �ŷ��� ��ŷ����ڿ� ��ŷ��ð��� ��¥�� �ٸ� �� ����
          �� ��� �ŷ����ڴ� hd_pay_date �� ���� �Ǹ�, �ŷ��ð��� �ΰ������� �����
      ��2) �ŷ��ݾ��� ��� �̿���(���θ�)�� ������û �������� ���� ��ŷ� ���� 
         ������ �� �����Ƿ� ���� ���������ؾ� �� ���� ��ġ�ϴ� �� Ȯ���ؾ� ��
  ********************************************************************************/
  
  /********************************************************************
       �ŷ������ ���� �޴� ó���� ���� ���� ����     
  *********************************************************************/
  int DB_FLAG   = 1; // �̿���(���θ�)���� �����ؾ� ��  ���� (1:�̿�������DB�ݿ�������, 0:�̿�������DB�ݿ����н�)
  int db_result = 0; // UpdateDB_True(), UpdateDB_False()ȣ�� ����� ������ ���� (0:����, -1:����)

  /*******************************************************************************
       �Ʒ��� �����¿��� ���������� ��ݵǾ��� ��� ó������
  ********************************************************************************/
  
  if (hd_resp_code.equals("000") == true)
  {
    /***************************************************************************
    [�߿�!] ������� ������ ���� ��� �������������κ��� ���ŵ� �����ŷ��ݾװ��� �̿���(���θ�)�� ������ �ִ� �����ݾװ��� ���Ѵ�.
                               �̿���(���θ�)�� �����ݾװ��� DB���� �о���� ����� ������
         (���Ǻ����� ����� ��� �̿�� PC���� ���� �������� ���θ� �ݵ�� üũ�ؾ� ��)
    
               ��1) DB���� �о�� ��� 
          String check_amount = String(DB���� �о�� �ݾװ�);
               ��2) ���ǹ���� ���(���� ��ü�� ���ǵ� ���¿���....) 
          String check_amount = (String)Session.GetAttribute("...");
    ****************************************************************************/
     if (tx_amount.equals(check_amount) == true)  
     {
       /*****************************************************************************
        * ���⿡ �̿��� ���� DB�� ���� ����� �ݿ��ϴ� ���� ���α׷� �ڵ带 �����Ѵ�.   
        [�߿�!] �ŷ��ݾ׿� �̻��� ������ Ȯ���� �� �̿���(���θ�) DB�� �ش���� ����ó�� �Ǿ����� �ݿ���
                              ���� DB��  �ݿ��� �������̸� DB_FLAG = 1 �� �����ϰ�, ������ ��� DB_FLAG = 0 �� �����Ѵ�.                                            
       ******************************************************************************/
 	  if (DB_FLAG == 1)  
 	  {
 	    // �̿���(���θ�) ����ó��(DB UPDATE �۾���)�� ���������� ó���Ǿ��� ��� UpdateDB_True()ȣ���ϰ�  �ŷ��� �����Ű���� ��
 	    db_result = pay.UpdateDB_True();
 	  }
 	  else         
 	  {
 	    // �̿���(���θ�) ����ó��(DB UPDATE �۾���)�� �������� ���  UpdateDB_False() ȣ���Ͽ� �ŷ� ��������� �߻��ǵ��� ��
 	    db_result = pay.UpdateDB_False();
 	  }
     }  
     else
     {
 	  // �ŷ��ݾ׿� �̻��� ���� ��� UpdateDB_False() ȣ���Ͽ� �ŷ� ��������� �߻��ǵ��� ��.
 	  // [�߿�!] �� ��� �̿��� ����Ʈ�� ���� ��ŷ ���ɼ��� �����Ƿ� ��ڰ� Ȯ���� �� �ֵ��� ó���ϱ⸦ ������
       db_result = pay.UpdateDB_False();
     }
  }// end of "������ 000"
  else 
  {
	  /*****************************************************************************
       * ���⿡ �̿��� ���� DB�� ���� ����� �ݿ��ϴ� ���� ���α׷� �ڵ带 �����Ѵ�.
       - �������� ������ �ƴ� ��������� ���ٸ� �����۾����� ������� �״�� �̿��� ����DB�� �ݿ��ϵ��� ��
                              ���� DB��  �ݿ��� �������̸� DB_FLAG = 1 �� �����ϰ�, ������ ��� DB_FLAG = 0 �� �����Ѵ�.                                                   
      ******************************************************************************/            
  }// end of "������ != 000"
  
  if (DB_FLAG == 0)
  {
    /********************************************************************************************
      DB Update �۾��� ���а� �ִ� ����̹Ƿ� DB�� �����Ͽ� ����Ȯ����� �α� ���� ó�� ����
    ********************************************************************************************/
  }  
  if (DB_FLAG == 1 && db_result < 0)
  {
    /********************************************************************************************
     * UpdateDB_True() �Ǵ� UpdateDB_False() �Լ��� ȣ���� ������ ���
                        �����ڰ� Ȯ���� �� �ֵ��� ���⿡ ���α׷� �ڵ带 �����Ѵ�.(�α� �� �˶�)
    ********************************************************************************************/
  }
  
  //pay ��ü�� ����� ������  
  pay.FinishMsg();
%>

<html>
<head>
  <title>���������� ������ü PG ���ȭ��</title>  
  <script type="text/javascript">
    // PG���������� ���� ����ó�� ����� �����ֱ� ���� �Լ�
//     function JsResult()
//     {
<%--       var jswi = "<%=wi%>"; --%>
//       payResult(jswi);
//     }
    
 	  // PG���˾�â�� ���� ����ó�� ����� �����ֱ� ���� �Լ�
    function WebResult()
    {
    	if(<%=hd_resp_code %>!='000') { // �����ڵ� �˾�â
			  leftPosition = (screen.width-360)/2-10;
	 		  topPosition = (screen.height-300)/2-50;
	     	window.open('about:blank','BANKPAYPOPUP','top='+topPosition+',left='+leftPosition+',height=300,width=360,status=no,dependent=no,scrollbars=no,resizable=no');
			
	    	document.frmResult.target = 'BANKPAYPOPUP';
	    	document.frmResult.action = 'https://www.bankpay.or.kr:7443/wallet/bankpaypg/respcode/'+<%=hd_resp_code %>+'.html';
			  document.frmResult.submit();
    	} else {	// �����Ϸ� �˾�â
			  leftPosition = (screen.width-720)/2-10;
			  topPosition = (screen.height-600)/2-50;
	    	window.open('about:blank','BANKPAYPOPUP','top='+topPosition+',left='+leftPosition+',height=600,width=720,status=no,dependent=no,scrollbars=no,resizable=no');
			
	    	document.frmResult.target = 'BANKPAYPOPUP';
	    	document.frmResult.action = "https://www.bankpay.or.kr:7443/CompleteBankPay.do";
			  document.frmResult.submit();
    	}
    }
  </script>
</head>

<body>
	<!-- PG�� ���â ȣ���ϱ� ���� �� -->
  <form name=frmResult id=frmResult method="post">
		<input type=hidden name=wi	value="<%=wi%>">
		<input type=hidden name=hd_firm_name	value="<%=hd_firm_name%>">
	</form>


  <!-- ��������(Active-X)����� ���� �ڹٽ�ũ��Ʈ ��ũ �� �Լ� ȣ�� -->
<!--PG������â������ ������� ����    <script type="text/javascript" src="https://www.bankpay.or.kr/BankPayEFT.js"></script-->
<!--PG������â������ ������� ����   <script type="text/javascript">InstallCertManager()</script> -->
<!--PG������â������ ������� ����   <script type="text/javascript">SmartUpdate()</script> -->

  <%  
  if (DB_FLAG == 1 && db_result == 0)  
  {
    /************************************************************************************
    [����!] �̿�� PC�� �ŷ���� â�� ����ִ� ��ũ��Ʈ. 
               �������������� �����ϴ� ��� â�� �������� �������� �Ʒ� ��ũ��Ʈ�� ������.
               �̿���� �ο�ó�� ���� ������ �����Ƿ� �״�� ����ϱ⸦ ������.
    ************************************************************************************/
  %>
  
      <!-- �̿�� PC�� ���ȭ��(������� �Ǵ� �����޽���)�� �����ֱ� ���� ��������(Active-X) ȣ�� -->
<!--       <script type="text/javascript">JsResult();</script>   -->
      
      <!-- �̿�� PC�� ���ȭ��(������� �Ǵ� �����޽���)�� �����ֱ� ���� PG�� �˾�â ȣ�� -->
      <script type="text/javascript">WebResult();</script>  
  <%
  }
  else     
  {
	// DB Update �۾��� �����߰ų�   UpdateDB ���� �Լ�ȣ�� �� ������  �̿�� PC���� ������� â�� �ݱ� ���� �Լ� ȣ��  
  	// �̷��� ��Ȳ���� �����忡�� ����� �Ǿ����� ���ΰ� ��Ȯġ ��������, ���� ��ݰ���� �ٽ� �ѹ� Ȯ���� �ʿ䰡 ������ �˸� 
  %>
   
      <script type="text/javascript">
      DestroyDlg();
      </script>
      <br/><br/>
      <center>[����] �����ڿ��� ���ǿ��!!</center>
  <%    
  }
  %>  

<!-- �Ʒ����ʹ� ��������� ������ HTML ������ ���� -->
<!-- ���� ������ ������ ���ȭ���� �ۼ��Ҷ��� �Ʒ��� ���� �ʿ䰪���� �����Ͽ� ����ϸ� �� -->
  <br/><br/><br/><br/>
  <center><font color="blue"><b>����ó�� ���</b></font></center>
  
    <!-- ����ó�� ����� ȭ�鿡 ��� -->
    <table align="center" border="1">
      <tr><td width=130>������</td>  <td width=170>��</td></tr>
      <tr><td>hd_resp_code</td>      <td><font color=red><%=hd_resp_code%></font></td></tr>
      <tr><td>hd_msg_type</td>       <td><%=hd_msg_type%></td></tr>
      <tr><td>hd_approve_no</td>     <td><%=hd_approve_no%></td></tr>
      <tr><td>hd_serial_no</td>      <td><%=hd_serial_no%></td></tr>
      <tr><td>hd_pay_date</td>       <td><%=hd_pay_date%></td></tr>
      <tr><td>hd_trans_time</td>     <td><%=hd_trans_time%></td></tr>
      <tr><td>tx_receipt_date</td>   <td><%=tx_receipt_date%></td></tr>
      <tr><td>tx_amount</td>         <td><%=tx_amount%></td></tr>
      <tr><td>tx_fee</td>            <td><%=tx_fee%></td></tr>
      <tr><td>tx_age_check</td>      <td><%=tx_age_check%></td></tr>
      <tr><td>tx_user_define</td>    <td><%=tx_user_define%></td></tr>
      <tr><td>tx_receipt_bank</td>   <td><%=tx_receipt_bank%></td></tr>
      <tr><td>tx_receipt_acnt</td>   <td><%=tx_receipt_acnt%></td></tr>
    </table>
  </body>
</html>


