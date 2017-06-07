package com.class3601.social.actions;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts2.interceptor.ServletRequestAware;
import com.class3601.social.common.MessageStore;
import com.opensymphony.xwork2.ActionSupport;
import com.persistence.HibernateDatabasePostManager;

public class CommentAction extends ActionSupport implements ServletRequestAware {
	
	private static final long serialVersionUID = 1L;
    private static String PARAMETER_1 = "id";
    private static String PARAMETER_2 = "text";
    private static String XML_1 = 
    		"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n\n" +
    				"<stuff>\n" +
    					"   <parameter>";
    private static String XML_2 = 
    					"</parameter>\n" +
    					"   <parameter>";
    private static String XML_3 = 
						"</parameter>\n";
    
    private static String XML_4 = "</stuff>\n";

	private MessageStore messageStore;
	private HttpServletRequest request;
	
	public String execute() throws Exception {
		// HttpServletRequest request = ServletActionContext.getRequest();
		// preferred method is to implement ServletRequestAware interface
		// http://struts.apache.org/2.0.14/docs/how-can-we-access-the-httpservletrequest.html
	
		//http://localhost:8080/social/initial?parameter1=dog&parameter2=cat
		//http://localhost:8080/social/initial?parameter1=dog&parameter2=error
		String parameter1 = getServletRequest().getParameter(PARAMETER_1);
		String  parameter2 = getServletRequest().getParameter(PARAMETER_2);
		messageStore = new MessageStore();
		
		messageStore.appendToMessage(XML_1);
		messageStore.appendToMessage("ID: ");
		messageStore.appendToMessage(parameter1);
		messageStore.appendToMessage(XML_2);
		messageStore.appendToMessage("Text: ");
		messageStore.appendToMessage(parameter2);
		messageStore.appendToMessage(XML_3);
		messageStore.appendToMessage(XML_4);
		
		HibernateDatabasePostManager manager = new HibernateDatabasePostManager();
		manager.addComment(parameter1, parameter2);

		return "success";
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
