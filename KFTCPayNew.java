import java.net.*;
import java.io.*;
import java.util.*;
import sun.misc.*;

public class KFTCPayNew 
{
	int ResultValue = 0;
	boolean dbalreadysend = false;

	Socket socket;
	DataInputStream input;
	DataOutputStream output;
	
	
	byte[] totsendmsg, totrevmsg, totmsg, up_totmsg, buf, headbuf, tempbyte, plainbyte, epbyte, decbyte, buffer ;
	String TX_IP, IPGUMLOG;
	String sendmsg, returnstr, temp, tempmsg, namestr, valuestr, responsecode, What, wi, plainstr, epstr, sendflag;
	String revplainstr, revepstr, DATA_FLAG, TOTAL_DATA, DATA;
	
	String E_SYSTEM, E_SYSTEM_STR, E_JUMIN_NO, E_JUMIN_NO_STR, E_NODE, E_NODE_STR, E_CUT_OFF, E_CUT_OFF_STR, E_TIME_OUT;
	String E_TIME_OUT_STR, E_M_SIGN_FAIL, E_M_SIGN_FAIL_STR, E_M_DEC_FAIL, E_M_DEC_FAIL_STR, E_M_PASS_FAIL, E_M_PASS_FAIL_STR;
	String E_M_INIT_FAIL, E_M_INIT_FAIL_STR, E_M_FINISH_FAIL, E_M_FINISH_FAIL_STR, E_M_ENC_FAIL, E_M_ENC_FAIL_STR, E_M_SKEY_FAIL;
	String E_M_SKEY_FAIL_STR, E_PG_DEC_FAIL, E_PG_DEC_FAIL_STR, E_PG_IPC_FAIL, E_PG_IPC_FAIL_STR, E_PG_ENC_FAIL, E_PG_ENC_FAIL_STR;
	String E_PG_CANCLE, E_PG_CANCLE_STR, E_PG_INIT_FAIL, E_PG_INIT_FAIL_STR, E_CGI_TIME_OUT, E_CGI_TIME_OUT_STR, E_PG_TIME_OUT, E_PG_TIME_OUT_STR;
	
	boolean isres_code, cancel_flag, isconnect;
	
	int CANCEL_TIME_OUT, TX_TIME_OUT;
	int get_size, readbytes, totbytes, nbytes, plain_len, ep_len, startindex, endindex;
	int rev_plain_len, rev_ep_len, revendindex, revstartindex, filesize, compare;
	int DATA_LEN, SEND_DATA_LEN, TOTAL_DATA_LEN, TX_SERV_PORT, ERROR_TIMEOUT;
	
	// TX 서버와의 연결 시도 시간을 설정 
	int CONNECT_TIMEOUT = 10;
	
	Vector namevc = new Vector();
	Vector valuevc = new Vector();
	
	BASE64Encoder encoder = new BASE64Encoder();
	BASE64Decoder decoder = new BASE64Decoder();
	
	public void setPayMsg(String name, String value)
	{
      // "hd_" 이거나 "tx_" 인것만 SET한다.
      if (!name.substring(0,3).equals("hd_") &&
                       !name.substring(0,3).equals("tx_"))
         return;
 
		/* 고객의 암호화된 결제 정보일 경우 */
		if(name.equals("hd_pi"))
		{
			epstr = value;
		}
		else
		{
			plainstr = plainstr + "|" + name + "`" + value;
		}
		
		/* 취소 전문일 경우 */
		if((name.equals("hd_msg_code")) && (value.equals("0420")))
		{
			cancel_flag = true;
		}
	}
	
	public String getPayMsg(String name)
	{
		int k = 0;
		returnstr = "";
		if(name.equals("wi"))
		{
			returnstr = wi;
		}
		else
		{
			for(int i=0; i < namevc.size(); i++)
			{
				returnstr = namevc.elementAt(i).toString();
				if(name.equals(returnstr))
				{
					returnstr = valuevc.elementAt(i).toString();
					k = i;
					break;
				}
				else
				{
					returnstr = "";
				}
			}
		}
		return returnstr;
	}
	
	public int getPayProc()
	{
		/* TX 서버로 전송할 전문 생성 */
		sendmakemsg();
		
		/* TX 서버와 일정 시간동안 연결 시도 */
		connect();
		
		if(!(ResultValue < 0))
			/* 결제 정보 전문 전송 */	
			sendsocket();
			
		if(!(ResultValue < 0))
			/* 결제 정보 응답 전문 수신 */
			receivesocket();

		if(!(ResultValue < 0))
			/* 응답 전문 분석 */
			MsgParse();

		SetWiMsg();
		
		return ResultValue;
	}
	
	public int FinishMsg()
	{
		try
		{
			/* 정상 처리 되었으나 DB 결과를 보내지 않은 경우 */
			if (responsecode.equals("000") && (dbalreadysend == false) && (cancel_flag == false))
			{
				updatesendsocket("DB_TRUE");
			}
			else
			{
				closesocket();
			}
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
		return ResultValue;
	}
	
	public int UpdateDB_True()
	{
		try
		{
			if (responsecode.equals("000"))
			{				
				updatesendsocket("DB_TRUE");
			}
			else
			{
				closesocket();
			}
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
		return ResultValue;
	}
	
	public int UpdateDB_False()
	{
		try
		{
			if (responsecode.equals("000"))
			{				
				updatesendsocket("DB_FALSE");
			}
			else
			{
				closesocket();
			}
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
		return ResultValue;
	}
	
	public void updatesendsocket(String DBFLAG)
	{
		try
		{
			dbalreadysend = true;
			nbytes = 0;
			byte[] tempbuf = new byte[1];	
			socket.setSoTimeout((int)(100));
						
			try
			{
				nbytes = input.read(tempbuf,0,1);
				ResultValue = -1;				
			}
			catch(IOException ie)
			{				
				String up_plainstr = plainstr + "|tx_db_flag`" + DBFLAG;
		
				byte[] up_plainbyte = up_plainstr.getBytes();
				up_totmsg = new byte[(up_plainbyte.length + 15)];
		
				up_makebyte("A", 0);
				up_makebyte(makezero((""+(up_plainbyte.length+10)),4), 1);
				up_makebyte(makezero((""+(up_plainbyte.length)),5), 5);
				up_makebyte(makezero("00000", 5), 10);
				up_makebyte(up_plainstr, 15);
		
				output.write(up_totmsg);
				output.flush();
			}			
			closesocket();
		}
		catch(Exception e)
		{
			ResultValue = -1;			
		}
	}
	
	public void InitialMsg()
	{
		plainstr = "";
		epstr = "";
		isconnect = true;
		
		E_SYSTEM							=	"930";
		E_SYSTEM_STR					=	"시스템 오류";

		E_JUMIN_NO						=	"900";
		E_JUMIN_NO_STR					=	"주민등록번호 오류";

		E_NODE							=	"901";
		E_NODE_STR						=	"네트워크 연결 오류";

		E_CUT_OFF						=	"902";
		E_CUT_OFF_STR					=	"Payment Gateway Cut Off Time";

		E_TIME_OUT						=	"903";
		E_TIME_OUT_STR					=	"TIME_OUT 경과";
		
		E_CGI_TIME_OUT					=	"904";
		E_CGI_TIME_OUT_STR			=	"TX 서버 TIME_OUT 경과";
		
		E_PG_TIME_OUT					=	"905";             
		E_PG_TIME_OUT_STR				=	"PG 서버 TIME_OUT 경과";
		
		E_M_SIGN_FAIL					=	"910";
		E_M_SIGN_FAIL_STR				=	"쇼핑몰 서명 오류";
		E_M_DEC_FAIL					=	"911";
		E_M_DEC_FAIL_STR				=	"쇼핑몰 복호화 또는 서명 검증 오류";
		E_M_PASS_FAIL					=	"912";
		E_M_PASS_FAIL_STR				=	"쇼핑몰 인증서 암호 오류";
		E_M_INIT_FAIL					=	"913";
		E_M_INIT_FAIL_STR				=	"쇼핑몰 암호모듈 초기화 오류";
		E_M_FINISH_FAIL				=	"914";
		E_M_FINISH_FAIL_STR			=	"쇼핑몰 암호모듈 초기화 오류";
		E_M_ENC_FAIL					=	"915";
		E_M_ENC_FAIL_STR				=	"쇼핑몰 암호화 오류";
		E_M_SKEY_FAIL					=	"916";
		E_M_SKEY_FAIL_STR				=	"쇼핑몰 생성키 처리 오류";

		E_PG_DEC_FAIL					=	"920";
		E_PG_DEC_FAIL_STR				=	"PG의 검증 또는 서명 오류";
		E_PG_IPC_FAIL					=	"921";
		E_PG_IPC_FAIL_STR				=	"PG에서 IPC 오류";
		E_PG_ENC_FAIL					=	"922";
		E_PG_ENC_FAIL_STR				=	"PG의 암호화 또는 서명 오류";
		E_PG_CANCLE						=	"923";
		E_PG_CANCLE_STR				=	"PG의 취소전문 처리 후 오류";
		E_PG_INIT_FAIL					=	"924";
		E_PG_INIT_FAIL_STR			=	"PG의 암호모듈 초기화 오류";
		
		totsendmsg = new byte[1005];
		totrevmsg = new byte[10000];
		TOTAL_DATA = "";
		
	}
	
	
	public String base64encoding(byte[] bytes) {
		BASE64Encoder encoder = new BASE64Encoder();
		String m_strEncodedString = encoder.encodeBuffer(bytes);

		return m_strEncodedString;
	}

	public byte[] base64decoding(String str) {
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] m_DecodedBytes = null;

		try {
			m_DecodedBytes = decoder.decodeBuffer(str);
		}catch(Exception e) {
		}

		return m_DecodedBytes;
	}
	
	
	public void sendmakemsg()
	{
		plainbyte = plainstr.getBytes();
		plain_len = plainbyte.length;
		
		epbyte = base64decoding(epstr);
		ep_len = epbyte.length;
		
		totmsg = new byte[(plain_len + ep_len + 10)];
		
		makebyte(makezero((""+plain_len),5), 0);
		makebyte(makezero((""+ep_len),5), 5);
		makebyte(plainstr, 10);
		makebinarybyte((plain_len+10));
		
		temp = new String(totmsg);
	}
	
	public void connect() 
	{
		int timeout = 0;
		isconnect = true;
		
		while(isconnect)
		{
			try 
			{
				socket = new Socket(TX_IP, TX_SERV_PORT);
				input = new DataInputStream(new BufferedInputStream(socket.getInputStream()));
				output = new DataOutputStream(new BufferedOutputStream(socket.getOutputStream()));
				// 연결된 소켓에서 얻은 출력 스트림으로 PrintStream 인스턴스를 생성한다.
			
				isconnect = false;
			} catch(Exception exc) 
			{
				try
				{
					MakeErrMsg(E_NODE);
               System.out.println(exc.getMessage().trim() + "[" + TX_IP + "][" +"]" );
					ResultValue = -1;
			
					if(timeout == CONNECT_TIMEOUT)
					{
						isconnect = false;
						break;
					}
					else
					{
						timeout++;
						try
						{
							Thread.sleep((long)1000);
						}
						catch(Exception e)
						{
						}
					}
				}
				catch(Exception e)
				{
				}
			}
		}
	}
	
	void sendsocket()
	{
		try
		{
			int remain_len = totmsg.length;
			
			while(true)
			{
				if(remain_len > 1000)
				{
					if(remain_len == totmsg.length)
					{
						sendflag = "B";
						startindex = 0;
						endindex = (startindex + 1000 - 1);
					}
					else
					{
						sendflag = "M";
						startindex = (endindex + 1);
						endindex = (startindex + 1000 - 1);
					}
				
					SEND_DATA_LEN = 1000;
					remain_len = (remain_len - 1000);
				}
				else
				{
					if(remain_len == totmsg.length)
					{
						sendflag = "A";
						startindex = 0;
						endindex = totmsg.length;
						SEND_DATA_LEN = totmsg.length;
						
						totsendmsg = new byte[(SEND_DATA_LEN+5)];
					}
					else
					{
						sendflag = "E";
						startindex = (endindex + 1);
						endindex = (startindex + remain_len - 1);
						SEND_DATA_LEN = (endindex - startindex +1);
						
						totsendmsg = new byte[(SEND_DATA_LEN+5)];
					}
				
				}
				
				TOTAL_DATA_LEN = TOTAL_DATA_LEN + SEND_DATA_LEN;
			
				makesendbyte(sendflag, 0);
				makesendbyte(makezero(("" + SEND_DATA_LEN),4), 1);
				transbyte(startindex, endindex);
				
				output.write(totsendmsg);
				output.flush();
			
				if((sendflag.equals("A")) || (sendflag.equals("E")))
				{
					break;
				}
			}
		}
		catch(Exception e)
		{
			ResultValue = -1;
			MakeErrMsg(E_SYSTEM);
		}
	}
	
	void up_sendsocket()
	{
		try
		{

		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
	}
	
	void receivesocket()
	{
		int timeout = 0;
		boolean int_read = true;
		isconnect = true;
		DATA_FLAG = "";
		
		if(cancel_flag)
		{
			ERROR_TIMEOUT = CANCEL_TIME_OUT;
		}
		else
		{
			ERROR_TIMEOUT = TX_TIME_OUT;
		}
		
		boolean istimeout = false;
		while(isconnect)
		{
			try
			{
				if(!(istimeout))
				{
					timeout++;
					
					if(timeout==ERROR_TIMEOUT)
					{
						MakeErrMsg(E_CGI_TIME_OUT);
						break;
					}
					else
					{
						socket.setSoTimeout((int)(1000 * ERROR_TIMEOUT));
						Thread.sleep((long)1000);
					}
				}
			}
			catch(Exception e)
			{
				break;
			}
			
			if(!(ResultValue == -1))
				Flag_Read(input);
			if(!(ResultValue == -1))
				Header_Read(input);
			if(!(ResultValue == -1))
				Data_Read(input);
			
			if((DATA_FLAG.equals("A")) || (DATA_FLAG.equals("E")))
			{
				isconnect = false;
				break;
			}
		}
		

		try
		{
			rev_plain_len = Integer.parseInt(new String(totrevmsg,0,5));
			rev_ep_len = Integer.parseInt(new String(totrevmsg,5,5));
		}
		catch(Exception e)
		{
			rev_plain_len = 0;
			rev_ep_len = 0;
		}
	}
	
	void Flag_Read(DataInputStream input)
	{
		try
		{
			headbuf = new byte[1];
			readbytes = headbuf.length;
			totbytes = 0;
			What = "";
			
 			nbytes = input.read(headbuf,0,readbytes);

 			if (nbytes > 0)
 			{
 				totbytes+=nbytes;
  			
     		temp = new String(headbuf,0,nbytes);
     		What += temp;
 			}
 			else 
 			{
 				ResultValue = -1;
 			}

			DATA_FLAG = What;
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
	}
	
	void Header_Read(DataInputStream input)
	{
		try
		{
			headbuf = new byte[4];
			readbytes = headbuf.length;
			totbytes = 0;
			DATA_LEN = 0;
			What = "";

			while(true)
			{
	 			nbytes = input.read(headbuf,0,readbytes);
	
	 			if (nbytes > 0)
	 			{
   				totbytes+=nbytes;
   			
       		temp = new String(headbuf,0,nbytes);
       		What += temp;

     			if(totbytes==headbuf.length) break;
     			else readbytes-=nbytes;
   			}
   			else
   			{
   				ResultValue = -1;
   				break;
   			}
			}
			try
			{
				DATA_LEN = Integer.parseInt(What);
			}
			catch(NumberFormatException ne)
			{
				ResultValue = -1;
			}
		}
		catch(Exception e)
		{
		}
	}
	
	void Data_Read(DataInputStream input)
	{
		try
		{
			headbuf = new byte[DATA_LEN];
			readbytes = headbuf.length;
			totbytes = 0;
			What = "";

			while(true)
			{
				nbytes = input.read(headbuf,0,readbytes);
    		if (nbytes > 0)
   			{
   				totbytes+=nbytes;
	    			
     			temp = new String(headbuf,0,nbytes);
       		What += temp;

     			if(totbytes==DATA_LEN) break;
     			else readbytes-=nbytes;
 	   		}
   			else
   			{
   				ResultValue = -1;
   				break;
   			}
			}
			
			if(DATA_FLAG.equals("B"))
			{
				revstartindex = 0;
				revendindex = (1000-1);
			}
			else if(DATA_FLAG.equals("M"))
			{
				revstartindex = (revendindex + 1);
				revendindex = (revstartindex + 1000);
			}
			else if(DATA_FLAG.equals("A"))
			{
				revstartindex = 0;
				revendindex = (DATA_LEN - 1);
			}
			else if(DATA_FLAG.equals("E"))
			{
				revstartindex = (revendindex + 1);
				revendindex = (revstartindex + DATA_LEN);
			}
			
			for(int i=0; i < headbuf.length; i++)
			{
				totrevmsg[(revstartindex+i)] = headbuf[i];
			}

			DATA = What;
			TOTAL_DATA = TOTAL_DATA + What;
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
	}
	
	void MsgParse()
	{
		String str = "";
		int start = 0;
		int end = 0;
		String namestr = "";
		String valuestr = "";

		revplainstr = new String(totrevmsg,10,(rev_plain_len));
		tempbyte = (revplainstr.trim()).getBytes();
		
		for(int i=0; i<tempbyte.length; i++)
		{
			if((""+tempbyte[i]).equals("124"))
			{
				start = i;

				if((end > 0) &&(start > 1) && (start > end))
				{
					valuestr = new String(tempbyte, (end+1), (start-end-1));
					valuevc.addElement(valuestr);
					
					if(namestr.equals("hd_resp_code"))
					{
						responsecode = valuestr;
					}
				}
			}
			else if((""+tempbyte[i]).equals("96"))
			{
				end = i;

				namestr = new String(tempbyte, (start+1),(end-start-1));
				namevc.addElement(namestr);
				
			}
			else if(i==(tempbyte.length-1))
			{
				valuestr = new String(tempbyte, (end+1), (i-end));
				valuevc.addElement(valuestr);
			}
			
			if(namestr.equals("hd_resp_code"))
			{
				isres_code = true;
			}
		}
		
		if(namevc.size() > valuevc.size())
		{
			valuevc.addElement("");
		}
		
		tempbyte = new byte[rev_ep_len];
		for(int i=0; i < tempbyte.length ; i++)
		{
			tempbyte[i] = totrevmsg[10 + rev_plain_len + i];
		}
		
		if(rev_ep_len > 0)
		{
			revepstr = base64encoding(tempbyte);
			
			byte[] revepbyte1 = revepstr.getBytes();
			byte[] revepbyte2 = revepbyte1;
			int j=0;
			int k = 0;
			revepstr = "";
			
			for(int i=0; i<revepbyte1.length; i++)
			{
				if(!("" + revepbyte1[i]).toString().equals("10"))
				{
					revepbyte2[j] = revepbyte1[i];
					j++;
				}
				else
				{
					String tmps = new String(revepbyte2,k,(j-k));
					revepstr = revepstr + tmps.trim();
					k = j;
				}
			}
		}
				

	}
	
	void closesocket() 
	{
		try
		{
			output.close();
			input.close();
			socket.close();
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
	}
	
	void SetWiMsg()
	{
		try
		{
			
			if(!(isres_code))
			{
				Set_Plain_VC();
				wi = plainstr + "|hd_resp_code`" + responsecode;
				ResultValue = -1;
				closesocket();
			}
			else
			{
				wi = revplainstr;
			}			
		
			if(Integer.parseInt(responsecode) < 700)
			{
				wi = wi + "|wi_msg`" + revepstr;
			}
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
	}
	
	void Set_Plain_VC()
	{
		String str = "";
		int start = 0;
		int end = 0;
		namestr = "";
		String valuestr = "";
		
		for(int i=0; i<plain_len; i++)
		{
			if((""+plainbyte[i]).equals("124"))
			{
				start = i;

				if((end > 0) &&(start > (1)) && (start > end))
				{
					valuestr = new String(plainbyte, (end+1), (start-end-1));
					valuevc.addElement(valuestr);

					valuestr = "";
				}
			}
			else if((""+plainbyte[i]).equals("96"))
			{
				end = i;

				namestr = new String(plainbyte, (start+1),(end-start-1));
				namevc.addElement(namestr);
			}
			else if(i==(plain_len-1))
			{
				valuestr = new String(plainbyte, (end+1), (i-end));
				valuevc.addElement(valuestr);
				valuestr = "";
			}
		}
		
		namevc.addElement("hd_resp_code");
		valuevc.addElement(responsecode);
		
	}
	
	void MakeErrMsg(String errstr)
	{
		responsecode = errstr;
	}
	
	void makebyte(String str, int startindex)
	{
		byte[] temp = str.getBytes();
		
		int si = startindex;
		int i = 0;
		while(true)
		{
			if(i < temp.length) 
			{
				totmsg[si] = temp[i];
				si++;
				i++;
			}else
				break;
		}
	}
	
	void up_makebyte(String str, int startindex)
	{
		try
		{
			
			
		byte[] temp = str.getBytes();
		
		int si = startindex;
		int i = 0;
		while(true)
		{
			if(i < temp.length) 
			{
				up_totmsg[si] = temp[i];
				si++;
				i++;
			}else
				break;
		}
		
		
		}
		catch(Exception e)
		{
			ResultValue = -1;
		}
	}
	
	void makesendbyte(String str, int startindex)
	{
		byte[] temp = str.getBytes();
		
		int si = startindex;
		int i = 0;
		while(true)
		{
			if(i < temp.length) 
			{
				totsendmsg[si] = temp[i];
				si++;
				i++;
			}else
				break;
		}
	}
	
	void makebinarybyte(int si)
	{
		for(int i=0; i < epbyte.length; i++)
		{
			totmsg[(si+i)] = epbyte[i];
		}
	}
	
	void transbyte(int si, int ei)
	{
		for(int i=0; i < SEND_DATA_LEN; i++)
		{
			totsendmsg[(i+5)] = totmsg[(si+i)];
		}
	}
	
	String makezero(String str, int tot_len)
	{
		int sr_len = (tot_len - str.length());
		for(int i=0; i < sr_len; i++)
		{
			str = "0" + str;
		}
		return str;
	}

   // 기존의 환경화일을 읽어서 SET하는 방식은 부하문제가 있어서 
   // 항목이 몇개 안되므로 사용자가 직접 Set하도록 한다.
   public void SetEnvParameter(String Param, String Value)
   {
      if (Param.equals("TX_IP"))
         TX_IP = Value;
      else if (Param.equals("TX_SERV_PORT"))
         TX_SERV_PORT = Integer.parseInt(Value);
      else if (Param.equals("TX_TIME_OUT"))
         TX_TIME_OUT = Integer.parseInt(Value);
      else if (Param.equals("CANCEL_TIME_OUT"))
         CANCEL_TIME_OUT = Integer.parseInt(Value);
      else if (Param.equals("IPGUMLOG"))
         IPGUMLOG = Value;
   }
}
