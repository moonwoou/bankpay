<!-- 금융결제원 PG서비스  Sample 결제요청 페이지 -->
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>뱅크페이 테스트 페이지</title>
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

<!-- 아래 bankpay.jsp의 경로를 이용기관 환경에 맞게 수정(기존 pay.jsp와 동일한 디렉토리에 위치시킨다.) -->
<form name="request" method="post" action="bankpay.jsp" target=INVISIBLE accept-charset="euc-kr">
<p>&nbsp;</p>
<p align="center"><font color="blue"><b>Bankpay Sample 결제페이지</b></font></p>
<table border=1 >


<!-- 업체의 승인 번호 : 금융결제원으로부터 부여받은 승인번호 8 자리를 기입한다.  -->
<tr>
<td>hd_approve_no</td>
<td><input type="text" name="hd_approve_no" value="19000000"/></td>
<td>업체의 승인 번호 : 금융결제원으로부터 부여받은 승인번호 8 자리를 기입한다.</td>
</tr>

<!-- 결제 요청에 대한 거래번호 7자리 : 0000001~9999999 사이의 값을 입력.
     거래건별로 별도 채번되어야 하며, 거래일 기준으로 중복되지 않고 유일한 값이어야 함. -->
<tr>
<td>hd_serial_no</td>
<td><input type="text" name="hd_serial_no" value="0000001"/></td>
<td>결제 요청에 대한 거래번호 7자리 : 0000001~9999999 사이의 값을 입력.거래건별로 별도 채번되어야 하며, 거래일 기준으로 중복되지 않고 유일한 값이어야 함.</td>
</tr>

<!-- tx_user_key -->
<!-- <tr> -->
<!-- <td>tx_user_key</td> -->
<!-- <td><input type="text" name="tx_user_key" value=""/></td> -->
<!-- <td>hd_serial_no를 0000000으로 셋팅한 후 tx_user_key 설정. hd_serial_no를 사용하지 않고 이용기관의 고유한 거래번호를 사용할 때 사용</td> -->
<!-- </tr> -->

<!-- 전자지갑에 표시될 기관명을 세팅한다. -->
<tr>
<td>hd_firm_name</td>
<td><input type="text" name="hd_firm_name" value="OO쇼핑몰"/></td>
<td>전자지갑에 표시될 기관명을 세팅한다.</td>
</tr>

<!-- 전자지갑에 표시될 물품명을 세팅한다.(최대 10자리)-->
<tr>
<td>hd_item_name</td>
<td><input type="text" name="hd_item_name" value="테스트물품"/></td>
<td>전자지갑에 표시될 물품명을 세팅한다.(최대 10자리)</td>
</tr>

<!-- 실제로 결제할 금액을 기입한다. -->
<tr>
<td>tx_amount</td>
<td><input type="text" name="tx_amount" value="50000"/></td>
<td>실제로 결제할 금액을 기입한다.</td>
</tr>

<!-- 여기서부터 현금영수증 발행대상업체인 경우 세팅 -->
<!-- 현금영수증발행대상업체/현금영수증 발급 대상인 거래에 대해 Y로 세팅한다. -->
<tr>
<td>tx_bill_yn</td>
<td><input type="text" name="tx_bill_yn" value="Y"></td>
<td>여기서부터 현금영수증 발행대상업체인 경우 세팅. 현금영수증발행대상업체/현금영수증 발급 대상인 거래에 대해 Y로 세팅한다.</td>
</tr>

<!-- 부가가치세 대상  -->
<tr>
<td>tx_vat_yn</td>
<td><input type="text" name="tx_vat_yn" value="Y"><br/></td>
<td>부가가치세 대상</td>
</tr>

<!-- 부가가치세 금액 : 미입력 또는 "0" 입력시 (결제금액-tx_svc_charge-tx_bill_deduction) / 11 로 자동계산 -->
<tr>
<td>tx_bill_vat</td>
<td><input type="text" name="tx_bill_vat" value="0"><br/></td>
<td>부가가치세 금액 : 미입력 또는 "0" 입력시 (결제금액-tx_svc_charge-tx_bill_deduction) / 11 로 자동계산</td>
</tr>

<!-- 봉사료  --> 
<tr>
<td>tx_svc_charge</td>
<td><input type="text" name="tx_svc_charge" value="0"><br/></td>
<td>봉사료.</td>
</tr>

<!-- 세금(TAX) --> 
<tr>
<td>tx_bill_tax</td>
<td><input type="text" name="tx_bill_tax" value="0"><br/></td>
<td>세금(TAX)</td>
</tr>

<!-- 현금영수증 제외대상금액 --> 
<tr>
<td>tx_bill_deduction</td>
<td><input type="text" name="tx_bill_deduction" value="0"><br/></td>
<td>현금영수증 제외대상금액. 여기까지 현금영수증 발행대상업체인 경우 입력할 항목임</td>
</tr>

<!-- 여기까지 현금영수증 발행대상업체인 경우 입력할 항목임 -->

<!-- 연령 제한 체크 필드 연령에 무관하게 결제할 경우는 생략 가능하다. ex) 19세 미만에게 결제 불가할 경우는 'N19' -->
<tr>
<td>tx_age_check</td>
<td><input type="text" name="tx_age_check" value="Y19"></td>
<td>연령 제한 체크 필드 연령에 무관하게 결제할 경우는 생략 가능하다. ex) 19세 미만에게 결제 불가할 경우는 'N19' </td>
</tr>



<!-- 간편결제기능 사용여부 (Y/N) -->                        
<tr>
<td>sbp_service_use</td>
<td><input type="text" name="sbp_service_use" value="Y"/></td>
<td>간편결제기능 사용여부 (Y/N) 미기재시 Y</td>
</tr>
        
<!-- 간편결제기능 우선표시 여부 (Y/N) -->        
<tr>
<td>sbp_tab_first</td>
<td><input type="text" name="sbp_tab_first" value="N"/></td>
<td>간편결제기능 우선표시 여부 (Y/N) 미기재시 Y</td>
</tr>

<!-- 일반결제시 기본으로 보여줄 금융기관(은행/증권) -->        
<!-- <tr> -->
<!-- <td>hd_default_institution</td> -->
<!-- <td><input type="text" name="hd_default_institution" value="STOCK"/></td> -->
<!-- <td>일반결제시 기본으로 보여줄 금융기관("BANK" or "STOCK"), 미기재시 "BANK"</td> -->
<!-- </tr> -->

<!-- 보증금거래 대상 여부 -->
<!-- <tr> -->
<!-- <td>tx_guarantee</td> -->
<!-- <td><input type="text" name="tx_guarantee" value="N"/></td> -->
<!-- <td>보증금거래 대상 여부. 조달청 보증금 납부기관만 해당함("Y" or "N")</td> -->
<!-- </tr> -->

<!-- 테스트/운영 선택 -->        
<tr>
<td>bankpayURL</td>
<td><input type="text" name="bankpayURL" value="https://pgtest.kftc.or.kr:7743/StartBankPay.do"/></td>
<td>테스트 : https://pgtest.kftc.or.kr:7743/StartBankPay.do <br/> 운영 : https://www.bankpay.or.kr:7443/StartBankPay.do 미기재시 운영으로 접속</td>
</tr>

</table>

<p align="center"> 
	<input type=button onClick="OnPayButtonClick()" value="결제 요청"/>
</p>

<!-- 실제 사용시 display:none으로 셋팅 -->
<DIV style="display:none; float:left;">
	<IFRAME id=INVISIBLE name=INVISIBLE height="200" width="1000"></IFRAME>
</DIV>
</form>

</body>
</html>