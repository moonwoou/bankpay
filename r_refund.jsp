<!-- 금융결제원 PG서비스 sample 결제환불 페이지-->
<%@ page import="java.util.*" contentType="text/html;charset=euc-kr" %>

<!-- 금융결제원 제공 KFTCPayNew.class 를 사용함-->
<jsp:useBean id="pay" class="KFTCPayNew"/>

<%
	String str = "";
	String TempValue;

	//결제헬퍼모듈 초기화
	pay.InitialMsg();
	
	/* TX서버와의 통신 관련 설정값 세팅 */
	pay.SetEnvParameter("TX_IP",           "127.0.0.1"); // TX서버가 설치된 서버의 IP
	pay.SetEnvParameter("TX_SERV_PORT",    "5000");      // TX서버가 Listen하고 있는 PORT번호		
	pay.SetEnvParameter("TX_TIME_OUT",     "30");        // TX서버와의 일반거래전문 통신대기 최대시간 (초)
	pay.SetEnvParameter("CANCEL_TIME_OUT", "30");        // TX서버와의 취소거래전문 통신대기 최대시간 (초)
	
	// ※ TX서버의 버전에 따라 TIMEOUT 설정 관련한 변수명이 상이할 수 있기에 관련 설정값 추가 설정
	pay.SetEnvParameter("TX_TIMEOUT",      "30");        // TX서버와의 일반거래전문 통신대기 최대시간 (초)
	pay.SetEnvParameter("CANCEL_TIMEOUT",  "30");        // TX서버와의 취소거래전문 통신대기 최대시간 (초)
	

	// 환불요청 페이지로부터 넘겨받은 form의 값들을 읽어서 hd_ 또는 tx_로 시작되는 값으로 전문을 구성한다.	
	/* [참고 ] 샘플소스에서는 환불요청 페이지(refund.html)로부터 '업체승인번호','거래번호', '원거래일자', '환불차수',
	 *      '환불요청금액', '요청전문종류' 값을수신하게 되어 있지만, 실제 환불기능 구현시에는 해당 값들을 모두 이용기관 서버내에서 DB조회하여  설정해도 무방함. 
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
	
	/* '요청전문종류', '업체승인번호','거래번호', '원거래일자', '환불차수', '환불요청금액' 값을 이용기관 서버내에서 설정하고자 할 경우 아래로직 참조 */
	/*
	pay.setPayMsg("hd_cancel_type",        "....");   // (필수) 요청전문종류 ('RD':실시간환불요청, 'RQ':실시간환불결과조회)
	pay.setPayMsg("hd_approve_no",         "....");   // (필수) 이용기관승인번호
	pay.setPayMsg("hd_serial_no",          "....");   // (필수) 원거래 거래번호
	pay.setPayMsg("hd_pay_date",           "....");   // (필수) 원거래 일자 (YYYYMMDD)
	pay.setPayMsg("tx_partial_cancel_cnt", "....");   // (필수) 환불차수 
	pay.setPayMsg("tx_amount",             "....");   // (필수) 환불요청금액 (환불결과조회('RQ')시에는 불필요)
	*/
		
	/* 환불요청 페이지로부터 넘겨받은 form 값 외에 결제에 필요한 추가 정보를 설정한다. */	
	pay.setPayMsg("hd_msg_type",           "EFT");    // (필수) 결제수단구분 ("EFT" 고정값 사용)
	pay.setPayMsg("hd_msg_code",           "0420");   // (필수) 결제전문구분 ("0420" 고정값 사용)
	pay.setPayMsg("tx_out_acnt_no",           "....");   // 이용기관 환불계좌 (실시간 환불일 경우 필수)
	
	
	// TX서버로 전문을 전송하고 처리 결과값을 받아오는 부분
	int result = pay.getPayProc();

	/************************************************************
	아래는 응답받은 값을 통해 실제 금융결제원에서 처리된 결과값들을 확인하는 부분
	************************************************************/
	String hd_resp_code			 = pay.getPayMsg("hd_resp_code");   // 환불접수  응답코드(정상:000, 오류:000이외의 값 - 상세내역 응답코드가이드 참조)
	String hd_msg_type 			 = pay.getPayMsg("hd_msg_type");    // 결제수단 구분
	String hd_approve_no 		 = pay.getPayMsg("hd_approve_no");  // 이용기관 승인번호
	String hd_serial_no 		 = pay.getPayMsg("hd_serial_no");   // 거래번호
	String hd_pay_date 			 = pay.getPayMsg("hd_pay_date");    // 원거래일자
	String hd_cancel_type 		 = pay.getPayMsg("hd_cancel_type"); // 환불구분(이용기관에서 실시간 환불(RD)를 요청해도 기존에 익일환불로 처리되어 현재요청 역시 익일환불로 처리된 경우 익일환불로 처리되어 (D)를 결과로 받을 수도 있음)
	String hd_trans_time 		 = pay.getPayMsg("hd_trans_time");  // 처리시각
	String tx_amount 			 = pay.getPayMsg("tx_amount");      // 환불금액	
	String tx_partial_cancel_cnt = pay.getPayMsg("tx_partial_cancel_cnt"); // 환불차수
	String tx_cancel_remain		 = pay.getPayMsg("tx_cancel_remain"); // 환불가능잔액
	String tx_cancel_date		 = pay.getPayMsg("tx_cancel_date");   // 환불접수일자
	
	// 결제헬퍼모듈 종료
	pay.FinishMsg();
%>

<html>
<head>
	<title>BankPay 환불테스트 결과 화면</title>
	<style type=text/css>
	<!-- td {  font-family: 돋움; font-size: 11pt; } -->
	</style>
</head>

<body bgcolor="ivory">
<p></p>
<p align="center"><font color="blue"><b>환불처리 결과</b></font></p><p></p>

	<!-- 환불 결과 출력 -->
	<p>
	<table align="center" border="1">
	<tr><td width="130">데이터 </td>      <td width="170">값</td></tr>
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

	<tr><td>응답코드예제표</td><td>결과</td></tr>
	<tr><td>000</td><td>취소 거래 성공</td></tr>
	<tr><td>820</td><td>환불요청접수완료</td></tr>
	<tr><td>821</td><td>해당 환불거래 없음(환불 처리 결과 조회시)</td></tr>
	<tr><td>822</td><td>이용기관 입금금액을 초과한 환불 거래(환불 처리 결과 조회시)</td></tr>
	<tr><td>901</td><td>네트워크 연결 오류</td></tr>
	<tr><td>903</td><td>거래 시간 초과 오류</td></tr>
	<tr><td>912</td><td>비밀번호 오류</td></tr>
	<tr><td>930</td><td>서버내부시스템오류</td></tr>
	<tr><td>960</td><td>전문오류</td></tr>
	<tr><td>981</td><td>원거래금액초과</td></tr>
	<tr><td>982</td><td>환불차수오류</td></tr>
	<tr><td>993</td><td>금액상이</td></tr>
	<tr><td>994,350</td><td>원거래없음(부분환불시 기존 환불차수와 중복되는 경우)</td></tr>
	</table>
	
</body>
</html>
