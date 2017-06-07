package com.class3601.social.actions;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.interceptor.ServletRequestAware;
import com.class3601.social.common.MessageStore;
import com.opensymphony.xwork2.ActionSupport;
import com.persistence.HibernateDatabasePostManager;

public class VotesAction extends ActionSupport implements ServletRequestAware {
	
	private static final long serialVersionUID = 1L;
    private static String PARAMETER_1 = "type";
    private static String PARAMETER_2 = "id";

    private static String XML_1 = 
    		"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n\n" +
    				"<stuff>\n";
    private static String XML_2 ="   <votes>";
    private static String XML_3 = "</votes>\n";
    
    private static String XML_4 = "</stuff>\n";

	private MessageStore messageStore;
	private HttpServletRequest request;
	
	public String execute() throws Exception {
		// HttpServletRequest request = ServletActionContext.getRequest();
		// preferred method is to implement ServletRequestAware interface
		// http://struts.apache.org/2.0.14/docs/how-can-we-access-the-httpservletrequest.html
	
		String parameter1 = getServletRequest().getParameter(PARAMETER_1);
		String  parameter2 = getServletRequest().getParameter(PARAMETER_2);

		messageStore = new MessageStore();
		
		
		HibernateDatabasePostManager manager = new HibernateDatabasePostManager();
		if (parameter1.equals("up")) {
			int k = manager.upVote(parameter2);
			if (k != 999999999) {
				messageStore.appendToMessage(XML_1);
				messageStore.appendToMessage(XML_2);
				messageStore.appendToMessage("" + k);
				messageStore.appendToMessage(XML_3);
				messageStore.appendToMessage(XML_4);
				return "success";
			}
			else
				return "fail";
		}
		if (parameter1.equals("down")) {
			int k = manager.downVote(parameter2);
			if (k != 999999999) {
				messageStore.appendToMessage(XML_1);
				messageStore.appendToMessage(XML_2);
				messageStore.appendToMessage("" + k);
				messageStore.appendToMessage(XML_3);
				messageStore.appendToMessage(XML_4);
				return "success";
			}
			else
				return "fail";
		}
		if (parameter1.equals("doubleup")) {
			int k = manager.doubleUp(parameter2);
			if (k != 999999999) {
				messageStore.appendToMessage(XML_1);
				messageStore.appendToMessage(XML_2);
				messageStore.appendToMessage("" + k);
				messageStore.appendToMessage(XML_3);
				messageStore.appendToMessage(XML_4);
				return "success";
			}
			else
				return "fail";
		}
		if (parameter1.equals("doubledown")) {
			int k = manager.doubleDown(parameter2);
			if (k != 999999999) {
				messageStore.appendToMessage(XML_1);
				messageStore.appendToMessage(XML_2);
				messageStore.appendToMessage("" + k);
				messageStore.appendToMessage(XML_3);
				messageStore.appendToMessage(XML_4);
				return "success";
			}
			else
				return "fail";
		}
		else
			return "fail";
	}
	

	public MessageStore getMessageStore() {
		return messageStore;
	}

	public void setMessageStore(MessageStore messageStore) {
		this.messageStore = messageStore;
	}


	@Override
	public void setServletRequest(HttpServletRequest request) {
		this.request = request;
	}
	
	private HttpServletRequest getServletRequest() {
		return request;
	}

}
