<!-- 금융결제원 PG서비스 sample 결제처리 페이지-->
<%@ page import="java.util.*" contentType="text/html;charset=euc-kr" %>
<% request.setCharacterEncoding("euc-kr"); %>

<!-- 금융결제원 제공 KFTCPayNew.class 를 사용함-->
<jsp:useBean id="pay" class="KFTCPayNew"/>

<%
  String str = "";
  
  // 결제헬퍼모듈 초기화
  pay.InitialMsg();
  
  // 금융결제원 제공 TX서버 프로그램이 설치된 서버IP
  pay.SetEnvParameter("TX_IP",    "127.0.0.1");           
  
  // TX서버와의 통신 PORT (TX서버가 Listen 하고 있는 포트번호)
  pay.SetEnvParameter("TX_SERV_PORT",  "5000");
 
  // TX서버로 결제전문 송신 후 응답전문 최대 대기 시간 (초)
  // ※ TX서버가 금융결제원으로 결제전문 송신 후 대기하는 시간보다 길어야 함
  pay.SetEnvParameter("TX_TIME_OUT",     "30");
 
  // TX서버로 취소전문 송신 후 응답전문 최대 대기 시간 (초)
  pay.SetEnvParameter("CANCEL_TIME_OUT", "30");
  // 결제요청 페이지로부터 넘겨받은 form의 값들을 읽어서 hd_ 또는 tx_로 시작되는 값으로 전문을 구성한다.
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
  
  // PG웹 결과창용 파라미터
  String hd_firm_name = request.getParameter("hd_firm_name");
  
   
  /* 결제요청 페이지로부터 넘겨받은 form 값 외에 결제에 필요한 추가 정보를 설정한다.
   *
   * 1) 이용기관 입금계좌 (필수)
   *   - 이용기관의 입금계좌번호를 '-'없이 숫자만 입력
   *
   * 2) 사용자 정의필드 (옵션) 
   *   - 이용기관에서 자유롭게 사용할 수 있는 필드이며 최대 80바이트  입력가능
   *     (단, 고객 개인식별 정보등 보안상 민감한 정보는 입력하지 말것)
   *   - 제휴PG사의 경우는 다음의 형식으로 필수로 입력해야 함  
   *     "업체명(통장인자용, 최대5자리)^사업자번호^업체명(전체)^대표전화번호"
   *     (예)"테스트기관^1234567890^Bankpay계좌이체테스트기관^02-531-1825" 
   */   
  pay.setPayMsg("tx_receipt_acnt", (String)"이용기관 입금계좌");  
  pay.setPayMsg("tx_user_define",  (String)"이용기관 임의설정값");
    
  /***********************************************************
   * 해킹등에 대비하여 금액 필드값에 대한 위변조 여부를 반드시 확인해야 함!!
   * 
   *   결제요청 페이지의 금액정보가 해킹등에 의해 변조되지 않았는지 
   *   이용기관의 내부 DB상에 저장되어 있는 물품값과 웹페이지로부터 전달받은 값이 일치하는지 비교한다.
   *   금액이 불일치 할경우 위변조 가능성이 있는것임으로 결제를 진행하지 않고 오류 처리하도록 함.
   ************************************************************/   
   String payAmount = (String)request.getParameter("tx_amount");  // 웹페이지에서 전달받은 결제금액값
   String dbAmount  = (String)"이용기관이 알고 있는 실제 물품값";             // 이용기관이 알고 있는 실제 물품값
   
   if (payAmount.equals(dbAmount) == false) 
   {
       // 금액이 불일치한 경우임으로 결제를 진행하지 않고 오류처리하도록 함
       // (ex) 오류처리화면으로 forwarding 하는등의 로직 필요
       return;
   }  
  
  // TX서버로 전문을 전송하고 처리 결과값을 받아오는 부분
  int result = pay.getPayProc();
  /************************************************************
       아래는 응답값에서 필요로 하는 필드값을 획득하는 부분
  ************************************************************/
  String wi              = pay.getPayMsg("wi");  			 // ①처리결과를 ActivX나 PG웹결제 완료창으로 보여주기 위해 사용하는 값(암호화되어 있음)
  String hd_resp_code    = pay.getPayMsg("hd_resp_code");    // ②결제결과 응답코드(정상:000, 오류:000이외의 값)
  String hd_msg_type     = pay.getPayMsg("hd_msg_type");     // ③결제수단 구분
  String hd_approve_no   = pay.getPayMsg("hd_approve_no");   // ④이용기관 승인번호
  String hd_serial_no    = pay.getPayMsg("hd_serial_no");    // ⑤거래번호
  String hd_pay_date     = pay.getPayMsg("hd_pay_date");     // ⑥거래일자(YYYYMMDD)
  String hd_trans_time   = pay.getPayMsg("hd_trans_time");   // ⑦거래시각(YYYYMMDDhhmmss) 주1)
  String tx_receipt_date = pay.getPayMsg("tx_receipt_date"); // ⑧입금일자(YYYYMMDD)
  String tx_amount       = pay.getPayMsg("tx_amount");       // ⑨거래금액(원단위로 기재하되 최소단위는 10원) 주2)
  String tx_fee          = pay.getPayMsg("tx_fee");          // ⑩이용기관(쇼핑몰) 입금시 차감될 수수료
  String tx_age_check    = pay.getPayMsg("tx_age_check");    // ⑪연령체크 거래여부(Y19 or N19)
  String tx_user_define  = pay.getPayMsg("tx_user_define");  // ⑫사용자 정의필드(80 bytes)
  String tx_receipt_bank = pay.getPayMsg("tx_receipt_bank"); // ⑬입금계좌의 은행코드
  String tx_receipt_acnt = pay.getPayMsg("tx_receipt_acnt"); // ⑭입금계좌의 계좌번호
  //※ 금융결제원에서 제공하는 결제완료 팝업창을 사용하지 않고
  // 이용기관용 결제완료창을 따로 사용하는 경우(JsResult(), WebResult() 함수를 호출하지 않는 경우),
  // ②~⑭ 항목에서 적절한 파라미터를 사용하도록 한다.
  
  /********************************************************************************
      주1) 자정무렵에 발생한 거래는 ⑥거래일자와 ⑦거래시각의 날짜가 다를 수 있음
          이 경우 거래일자는 hd_pay_date 의 값이 되며, 거래시각은 부가정보로 사용함
      주2) 거래금액의 경우 이용기관(쇼핑몰)의 결제요청 페이지의 값이 해킹등에 의해 
         변조될 수 있으므로 필히 실제결제해야 할 값과 일치하는 지 확인해야 함
  ********************************************************************************/
  
  /********************************************************************
       거래결과에 따른 뒷단 처리를 위한 변수 선언     
  *********************************************************************/
  int DB_FLAG   = 1; // 이용기관(쇼핑몰)에서 세팅해야 할  변수 (1:이용기관내부DB반영성공시, 0:이용기관내부DB반영실패시)
  int db_result = 0; // UpdateDB_True(), UpdateDB_False()호출 결과값 저장할 변수 (0:성공, -1:실패)

  /*******************************************************************************
       아래는 고객계좌에서 정상적으로 출금되었을 경우 처리내용
  ********************************************************************************/
  
  if (hd_resp_code.equals("000") == true)
  {
    /***************************************************************************
    [중요!] 정상결제 응답을 받은 경우 금융결제원으로부터 수신된 최종거래금액값과 이용기관(쇼핑몰)이 가지고 있는 결제금액값을 비교한다.
                               이용기관(쇼핑몰)의 결제금액값은 DB에서 읽어오는 방식을 권장함
         (세션변수를 사용할 경우 이용고객 PC에서 변조 가능한지 여부를 반드시 체크해야 함)
    
               예1) DB에서 읽어온 경우 
          String check_amount = String(DB에서 읽어온 금액값);
               예2) 세션방식일 경우(세션 객체가 정의된 상태에서....) 
          String check_amount = (String)Session.GetAttribute("...");
    ****************************************************************************/
     if (tx_amount.equals(check_amount) == true)  
     {
       /*****************************************************************************
        * 여기에 이용기관 내부 DB에 결제 결과를 반영하는 관련 프로그램 코드를 구현한다.   
        [중요!] 거래금액에 이상이 없음을 확인한 뒤 이용기관(쇼핑몰) DB에 해당건이 정상처리 되었음을 반영함
                              내부 DB에  반영이 성공적이면 DB_FLAG = 1 로 세팅하고, 실패할 경우 DB_FLAG = 0 로 세팅한다.                                            
       ******************************************************************************/
 	  if (DB_FLAG == 1)  
 	  {
 	    // 이용기관(쇼핑몰) 내부처리(DB UPDATE 작업등)가 정상적으로 처리되었을 경우 UpdateDB_True()호출하고  거래를 종료시키도록 함
 	    db_result = pay.UpdateDB_True();
 	  }
 	  else         
 	  {
 	    // 이용기관(쇼핑몰) 내부처리(DB UPDATE 작업등)가 실패했을 경우  UpdateDB_False() 호출하여 거래 취소전문이 발생되도록 함
 	    db_result = pay.UpdateDB_False();
 	  }
     }  
     else
     {
 	  // 거래금액에 이상이 있을 경우 UpdateDB_False() 호출하여 거래 취소전문이 발생되도록 함.
 	  // [중요!] 이 경우 이용기관 사이트에 대한 해킹 가능성이 있으므로 운영자가 확인할 수 있도록 처리하기를 권장함
       db_result = pay.UpdateDB_False();
     }
  }// end of "응답결과 000"
  else 
  {
	  /*****************************************************************************
       * 여기에 이용기관 내부 DB에 결제 결과를 반영하는 관련 프로그램 코드를 구현한다.
       - 응답결과가 정상이 아닌 경우임으로 별다른 검증작업없이 결과값을 그대로 이용기관 내부DB에 반영하도록 함
                              내부 DB에  반영이 성공적이면 DB_FLAG = 1 로 세팅하고, 실패할 경우 DB_FLAG = 0 로 세팅한다.                                                   
      ******************************************************************************/            
  }// end of "응답결과 != 000"
  
  if (DB_FLAG == 0)
  {
    /********************************************************************************************
      DB Update 작업에 실패가 있는 경우이므로 DB와 관련하여 원인확인토록 로깅 등의 처리 구현
    ********************************************************************************************/
  }  
  if (DB_FLAG == 1 && db_result < 0)
  {
    /********************************************************************************************
     * UpdateDB_True() 또는 UpdateDB_False() 함수의 호출이 실패한 경우
                        운영담당자가 확인할 수 있도록 여기에 프로그램 코드를 구현한다.(로깅 및 알람)
    ********************************************************************************************/
  }
  
  //pay 객체의 사용을 종료함  
  pay.FinishMsg();
%>

<html>
<head>
  <title>금융결제원 계좌이체 PG 결과화면</title>  
  <script type="text/javascript">
    // PG전자지갑을 통해 결제처리 결과를 보여주기 위한 함수
//     function JsResult()
//     {
<%--       var jswi = "<%=wi%>"; --%>
//       payResult(jswi);
//     }
    
 	  // PG웹팝업창을 통해 결제처리 결과를 보여주기 위한 함수
    function WebResult()
    {
    	if(<%=hd_resp_code %>!='000') { // 에러코드 팝업창
			  leftPosition = (screen.width-360)/2-10;
	 		  topPosition = (screen.height-300)/2-50;
	     	window.open('about:blank','BANKPAYPOPUP','top='+topPosition+',left='+leftPosition+',height=300,width=360,status=no,dependent=no,scrollbars=no,resizable=no');
			
	    	document.frmResult.target = 'BANKPAYPOPUP';
	    	document.frmResult.action = 'https://www.bankpay.or.kr:7443/wallet/bankpaypg/respcode/'+<%=hd_resp_code %>+'.html';
			  document.frmResult.submit();
    	} else {	// 결제완료 팝업창
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
	<!-- PG웹 결과창 호출하기 위한 폼 -->
  <form name=frmResult id=frmResult method="post">
		<input type=hidden name=wi	value="<%=wi%>">
		<input type=hidden name=hd_firm_name	value="<%=hd_firm_name%>">
	</form>


  <!-- 전자지갑(Active-X)사용을 위한 자바스크립트 링크 및 함수 호출 -->
<!--PG웹결제창에서는 사용하지 않음    <script type="text/javascript" src="https://www.bankpay.or.kr/BankPayEFT.js"></script-->
<!--PG웹결제창에서는 사용하지 않음   <script type="text/javascript">InstallCertManager()</script> -->
<!--PG웹결제창에서는 사용하지 않음   <script type="text/javascript">SmartUpdate()</script> -->

  <%  
  if (DB_FLAG == 1 && db_result == 0)  
  {
    /************************************************************************************
    [주의!] 이용고객 PC에 거래결과 창을 띄워주는 스크립트. 
               금융결제원에서 제공하는 결과 창을 보여주지 않으려면 아래 스크립트를 삭제함.
               이용고객의 민원처리 등의 문제가 있으므로 그대로 사용하기를 권장함.
    ************************************************************************************/
  %>
  
      <!-- 이용고객 PC에 결과화면(정상출금 또는 오류메시지)을 보여주기 위한 전자지갑(Active-X) 호출 -->
<!--       <script type="text/javascript">JsResult();</script>   -->
      
      <!-- 이용고객 PC에 결과화면(정상출금 또는 오류메시지)을 보여주기 위한 PG웹 팝업창 호출 -->
      <script type="text/javascript">WebResult();</script>  
  <%
  }
  else     
  {
	// DB Update 작업이 실패했거나   UpdateDB 관련 함수호출 중 오류시  이용고객 PC에서 결제대기 창을 닫기 위한 함수 호출  
  	// 이러한 상황에선 고객통장에서 출금이 되었는지 여부가 명확치 않음으로, 추후 출금결과를 다시 한번 확인할 필요가 있음을 알림 
  %>
   
      <script type="text/javascript">
      DestroyDlg();
      </script>
      <br/><br/>
      <center>[주의] 관리자에게 문의요망!!</center>
  <%    
  }
  %>  

<!-- 아래부터는 결제결과를 보여줄 HTML 페이지 내용 -->
<!-- 실제 고객에게 보여줄 결과화면을 작성할때는 아래의 값중 필요값만을 추출하여 사용하면 됨 -->
  <br/><br/><br/><br/>
  <center><font color="blue"><b>결제처리 결과</b></font></center>
  
    <!-- 결제처리 결과를 화면에 출력 -->
    <table align="center" border="1">
      <tr><td width=130>데이터</td>  <td width=170>값</td></tr>
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


