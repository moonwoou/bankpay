<!-- ���������� PG����  Sample ������û ������ -->
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>��ũ���� �׽�Ʈ ������</title>
</head>

<body  bgcolor="ivory" text="black" link="blue" vlink="purple" alink="red">


<script type="text/javascript">
	function OnPayButtonClick() {
		var form = document.request;
		if(form.canHaveHTML) { // detect IE
			document.charset = form.acceptCharset;
		}
		form.submit();
	}
</script>

<!-- �Ʒ� bankpay.jsp�� ��θ� �̿��� ȯ�濡 �°� ����(���� pay.jsp�� ������ ���丮�� ��ġ��Ų��.) -->
<form name="request" method="post" action="bankpay.jsp" target=INVISIBLE accept-charset="euc-kr">
<p>&nbsp;</p>
<p align="center"><font color="blue"><b>Bankpay Sample ����������</b></font></p>
<table border=1 >


<!-- ��ü�� ���� ��ȣ : �������������κ��� �ο����� ���ι�ȣ 8 �ڸ��� �����Ѵ�.  -->
<tr>
<td>hd_approve_no</td>
<td><input type="text" name="hd_approve_no" value="19000000"/></td>
<td>��ü�� ���� ��ȣ : �������������κ��� �ο����� ���ι�ȣ 8 �ڸ��� �����Ѵ�.</td>
</tr>

<!-- ���� ��û�� ���� �ŷ���ȣ 7�ڸ� : 0000001~9999999 ������ ���� �Է�.
     �ŷ��Ǻ��� ���� ä���Ǿ�� �ϸ�, �ŷ��� �������� �ߺ����� �ʰ� ������ ���̾�� ��. -->
<tr>
<td>hd_serial_no</td>
<td><input type="text" name="hd_serial_no" value="0000001"/></td>
<td>���� ��û�� ���� �ŷ���ȣ 7�ڸ� : 0000001~9999999 ������ ���� �Է�.�ŷ��Ǻ��� ���� ä���Ǿ�� �ϸ�, �ŷ��� �������� �ߺ����� �ʰ� ������ ���̾�� ��.</td>
</tr>

<!-- tx_user_key -->
<!-- <tr> -->
<!-- <td>tx_user_key</td> -->
<!-- <td><input type="text" name="tx_user_key" value=""/></td> -->
<!-- <td>hd_serial_no�� 0000000���� ������ �� tx_user_key ����. hd_serial_no�� ������� �ʰ� �̿����� ������ �ŷ���ȣ�� ����� �� ���</td> -->
<!-- </tr> -->

<!-- ���������� ǥ�õ� ������� �����Ѵ�. -->
<tr>
<td>hd_firm_name</td>
<td><input type="text" name="hd_firm_name" value="OO���θ�"/></td>
<td>���������� ǥ�õ� ������� �����Ѵ�.</td>
</tr>

<!-- ���������� ǥ�õ� ��ǰ���� �����Ѵ�.(�ִ� 10�ڸ�)-->
<tr>
<td>hd_item_name</td>
<td><input type="text" name="hd_item_name" value="�׽�Ʈ��ǰ"/></td>
<td>���������� ǥ�õ� ��ǰ���� �����Ѵ�.(�ִ� 10�ڸ�)</td>
</tr>

<!-- ������ ������ �ݾ��� �����Ѵ�. -->
<tr>
<td>tx_amount</td>
<td><input type="text" name="tx_amount" value="50000"/></td>
<td>������ ������ �ݾ��� �����Ѵ�.</td>
</tr>

<!-- ���⼭���� ���ݿ����� �������ü�� ��� ���� -->
<!-- ���ݿ������������ü/���ݿ����� �߱� ����� �ŷ��� ���� Y�� �����Ѵ�. -->
<tr>
<td>tx_bill_yn</td>
<td><input type="text" name="tx_bill_yn" value="Y"></td>
<td>���⼭���� ���ݿ����� �������ü�� ��� ����. ���ݿ������������ü/���ݿ����� �߱� ����� �ŷ��� ���� Y�� �����Ѵ�.</td>
</tr>

<!-- �ΰ���ġ�� ���  -->
<tr>
<td>tx_vat_yn</td>
<td><input type="text" name="tx_vat_yn" value="Y"><br/></td>
<td>�ΰ���ġ�� ���</td>
</tr>

<!-- �ΰ���ġ�� �ݾ� : ���Է� �Ǵ� "0" �Է½� (�����ݾ�-tx_svc_charge-tx_bill_deduction) / 11 �� �ڵ���� -->
<tr>
<td>tx_bill_vat</td>
<td><input type="text" name="tx_bill_vat" value="0"><br/></td>
<td>�ΰ���ġ�� �ݾ� : ���Է� �Ǵ� "0" �Է½� (�����ݾ�-tx_svc_charge-tx_bill_deduction) / 11 �� �ڵ����</td>
</tr>

<!-- �����  --> 
<tr>
<td>tx_svc_charge</td>
<td><input type="text" name="tx_svc_charge" value="0"><br/></td>
<td>�����.</td>
</tr>

<!-- ����(TAX) --> 
<tr>
<td>tx_bill_tax</td>
<td><input type="text" name="tx_bill_tax" value="0"><br/></td>
<td>����(TAX)</td>
</tr>

<!-- ���ݿ����� ���ܴ��ݾ� --> 
<tr>
<td>tx_bill_deduction</td>
<td><input type="text" name="tx_bill_deduction" value="0"><br/></td>
<td>���ݿ����� ���ܴ��ݾ�. ������� ���ݿ����� �������ü�� ��� �Է��� �׸���</td>
</tr>

<!-- ������� ���ݿ����� �������ü�� ��� �Է��� �׸��� -->

<!-- ���� ���� üũ �ʵ� ���ɿ� �����ϰ� ������ ���� ���� �����ϴ�. ex) 19�� �̸����� ���� �Ұ��� ���� 'N19' -->
<tr>
<td>tx_age_check</td>
<td><input type="text" name="tx_age_check" value="Y19"></td>
<td>���� ���� üũ �ʵ� ���ɿ� �����ϰ� ������ ���� ���� �����ϴ�. ex) 19�� �̸����� ���� �Ұ��� ���� 'N19' </td>
</tr>



<!-- ���������� ��뿩�� (Y/N) -->                        
<tr>
<td>sbp_service_use</td>
<td><input type="text" name="sbp_service_use" value="Y"/></td>
<td>���������� ��뿩�� (Y/N) �̱���� Y</td>
</tr>
        
<!-- ���������� �켱ǥ�� ���� (Y/N) -->        
<tr>
<td>sbp_tab_first</td>
<td><input type="text" name="sbp_tab_first" value="N"/></td>
<td>���������� �켱ǥ�� ���� (Y/N) �̱���� Y</td>
</tr>

<!-- �Ϲݰ����� �⺻���� ������ �������(����/����) -->        
<!-- <tr> -->
<!-- <td>hd_default_institution</td> -->
<!-- <td><input type="text" name="hd_default_institution" value="STOCK"/></td> -->
<!-- <td>�Ϲݰ����� �⺻���� ������ �������("BANK" or "STOCK"), �̱���� "BANK"</td> -->
<!-- </tr> -->

<!-- �����ݰŷ� ��� ���� -->
<!-- <tr> -->
<!-- <td>tx_guarantee</td> -->
<!-- <td><input type="text" name="tx_guarantee" value="N"/></td> -->
<!-- <td>�����ݰŷ� ��� ����. ����û ������ ���α���� �ش���("Y" or "N")</td> -->
<!-- </tr> -->

<!-- �׽�Ʈ/� ���� -->        
<tr>
<td>bankpayURL</td>
<td><input type="text" name="bankpayURL" value="https://pgtest.kftc.or.kr:7743/StartBankPay.do"/></td>
<td>�׽�Ʈ : https://pgtest.kftc.or.kr:7743/StartBankPay.do <br/> � : https://www.bankpay.or.kr:7443/StartBankPay.do �̱���� ����� ����</td>
</tr>

</table>

<p align="center"> 
	<input type=button onClick="OnPayButtonClick()" value="���� ��û"/>
</p>

<!-- ���� ���� display:none���� ���� -->
<DIV style="display:none; float:left;">
	<IFRAME id=INVISIBLE name=INVISIBLE height="200" width="1000"></IFRAME>
</DIV>
</form>

</body>
</html>