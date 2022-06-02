<!-- 금융결제원 PG서비스 sample 결제취소 페이지-->
<%@ page import="java.util.*" contentType="text/html;charset=euc-kr" %>

<!-- 금융결제원 제공 KFTCPayNew.class 를 사용함-->
<jsp:useBean id="pay" class="KFTCPayNew"/>

<%
	String str = "";

    // 결제헬퍼모듈 초기화
	pay.InitialMsg();
	
	/* TX서버와의 통신 관련 설정값 세팅 */		
	pay.SetEnvParameter("TX_IP",           "127.0.0.1"); // TX서버가 설치된 서버의 IP
	pay.SetEnvParameter("TX_SERV_PORT",    "5000");      // TX서버가 Listen하고 있는 PORT번호	
	pay.SetEnvParameter("TX_TIMEOUT",      "30");        // TX서버와의 일반거래전문 통신대기 최대시간 (초)
	pay.SetEnvParameter("CANCEL_TIMEOUT",  "30");        // TX서버와의 취소거래전문 통신대기 최대시간 (초)
		
	// 취소요청 페이지로부터 넘겨받은 form의 값들을 읽어서 hd_ 또는 tx_로 시작되는 값으로 전문을 구성한다.	
	/* [참고 ] 샘플소스에서는 취소요청 페이지(cancel.html)로부터 '업체승인번호','거래번호', '원거래일자', '원거래금액' 값을
	 *        수신하게 되어 있지만, 실제 취소기능 구현시에는 해당 값들도 모두 이용기관 서버내에서 DB조회하여  설정해도 무방함. */	 
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
	/* '업체승인번호','거래번호', '원거래일자', '원거래금액' 값을 이용기관 서버내에서 설정하고자 할 경우 아래로직 참조 */
	/*
	pay.setPayMsg("hd_approve_no",         "....");   // (필수) 이용기관승인번호
	pay.setPayMsg("hd_serial_no",          "....");   // (필수) 원거래 거래번호
	pay.setPayMsg("hd_pay_date",           "....");   // (필수) 원거래 일자 (YYYYMMDD)
	pay.setPayMsg("tx_amount",             "....");   // (필수) 원거래 금액
	*/
	 	
	/* 취소요청 페이지로부터 넘겨받은 form 값 외에 결제에 필요한 추가 정보를 설정한다. */	
	pay.setPayMsg("hd_msg_type",           "EFT");    // (필수) 결제수단구분 ("EFT" 고정값 사용)
	pay.setPayMsg("hd_msg_code",           "0420");   // (필수) 결제전문구분 ("0420" 고정값 사용)
	pay.setPayMsg("hd_cancel_type",        "M");      // (필수) 취소타입 ("M" 고정값 사용)
	pay.setPayMsg("tx_partial_cancel_cnt", "1");      // (필수) 취소차수 ("1" 고정값 사용)
	pay.setPayMsg("hd_password",           "....");   // (필수) PG서비스 사용을 위해 발급받은 이용기관 서버 인증서 패스워드 
	
	// TX서버로 전문을 전송하고 처리 결과값을 받아오는 부분
	int result = pay.getPayProc();

	/************************************************************
             아래는 응답전문값을 조회하는 부분이며, 필요한 필드만 추출하여 사용가능
    ************************************************************/
	String hd_resp_code		=	pay.getPayMsg("hd_resp_code");   // 취초결과 응답코드(정상:000, 오류:000이외의 값)
	String hd_msg_type 		=  	pay.getPayMsg("hd_msg_type");    // 결제수단 구분
	String hd_approve_no 	= 	pay.getPayMsg("hd_approve_no");  // 이용기관 승인번호
	String hd_serial_no 	= 	pay.getPayMsg("hd_serial_no");   // 거래번호
	String hd_pay_date 		= 	pay.getPayMsg("hd_pay_date");    // 원거래일자
	String hd_cancel_type 	= 	pay.getPayMsg("hd_cancel_type"); // 취소구분
	String hd_trans_time 	=  	pay.getPayMsg("hd_trans_time");  // 처리시각
	String tx_amount 		= 	pay.getPayMsg("tx_amount");      // 거래금액(취소금액)
	String tx_user_define 	=  	pay.getPayMsg("tx_user_define"); // 사용자 정의필드(80 bytes)
	
	// 결제헬퍼모듈 종료
	pay.FinishMsg();
%>

<html>
<head>
	<title>BankPay 취소테스트 결과 화면</title>
	<style type=text/css>
	<!-- td {  font-family: 돋움; font-size: 11pt; } -->
	</style>
</head>

<body bgcolor="ivory">
	<p>&nbsp;</p>
	<p align="center"><font color="blue"><b>취소처리 결과</b></font></p><p>&nbsp;</p>

	<!-- 취소 결과 출력 -->
	<p>
	<table align="center" border="1">
	<tr><td width=130>데이터</td>  <td width=170>값</td></tr>
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
	<tr><td>응답코드예제표</td><td>결과</td></tr>
	<tr><td>000</td><td>취소 거래 성공</td></tr>
	<tr><td>901</td><td>네트워크 연결 오류</td></tr>
	<tr><td>903</td><td>거래 시간 초과 오류</td></tr>
	<tr><td>912</td><td>비밀번호 오류</td></tr>
	<tr><td>993</td><td>거래 가격 상이</td></tr>
	<tr><td>994</td><td>원거래 없음</td></tr>				
	</table>
	
</body>
</html>
