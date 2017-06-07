package com.class3601.social.actions;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.models.Post;
import org.apache.struts2.interceptor.ServletRequestAware;
import com.class3601.social.common.MessageStore;
import com.opensymphony.xwork2.ActionSupport;
import com.persistence.HibernateDatabasePostManager;

public class GetPostAction extends ActionSupport implements ServletRequestAware {
    private static String PARAMETER_1 = "start";
    private static String PARAMETER_2 = "end";
    private static String PARAMETER_3 = "type";

	private static final long serialVersionUID = 1L;
    private static String XML_1 = 
    		"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n\n" +
    				"<posts>";
	private static String startPost = "\n   <post>";
    private static String startID = "\n      <id>";
    private static String endID = "</id>";
    private static String startTitle = "\n      <title>";
    private static String endTitle = "</title>";
    private static String startAuthor = "\n      <author>";
    private static String endAuthor = "</author>";
    private static String startVotes = "\n      <votes>";
    private static String endVotes = "</votes>";
    private static String startComments = "\n      <comments>";
    private static String endComments = "</comments>";
    private static String startTime = "\n      <time>";
    private static String endTime = "</time>";
    private static String startFlags = "\n      <flags>";
    private static String endFlags = "</flags>";
	private static String endPost = "\n   </post>";
    private static String XML_END = "\n</posts>";

	private MessageStore messageStore;
	private HttpServletRequest request;
	
	public String execute() throws Exception {
		// HttpServletRequest request = ServletActionContext.getRequest();
		// preferred method is to implement ServletRequestAware interface
		// http://struts.apache.org/2.0.14/docs/how-can-we-access-the-httpservletrequest.html
	
		//http://localhost:8080/social/initial?parameter1=dog&parameter2=cat
		//http://localhost:8080/social/initial?parameter1=dog&parameter2=error

		String  parameter1 = getServletRequest().getParameter(PARAMETER_1);
		String  parameter2 = getServletRequest().getParameter(PARAMETER_2);
		String  parameter3 = getServletRequest().getParameter(PARAMETER_3);

		int from = Integer.parseInt(parameter1);
		int to = Integer.parseInt(parameter2);
		
		messageStore = new MessageStore();	

		HibernateDatabasePostManager manager = new HibernateDatabasePostManager();	
		List<Post> l = null;
		if (parameter3.equals("v")) {
			l = manager.getPostsByVotedTill(from, to);
		}
		if (parameter3.equals("n")) {	
			l = manager.getPostsByTimeTill(from, to);
		}
		System.out.println("\n\n\n hhhb " + parameter2 + " " + to + " fdasfd " + l);

		if (l == null)
			return "fail";
		messageStore.appendToMessage(XML_1);
		for (int x = 0; x < l.size(); x++) {
			messageStore.appendToMessage(startPost);	
			messageStore.appendToMessage(startID);
			messageStore.appendToMessage(l.get(x).getPostIdPrimarKey());
			messageStore.appendToMessage(endID);
			messageStore.appendToMessage(startTitle);
			messageStore.appendToMessage(l.get(x).getTitle());
			messageStore.appendToMessage(endTitle);
			messageStore.appendToMessage(startAuthor);
			messageStore.appendToMessage(l.get(x).getAuthor());
			messageStore.appendToMessage(endAuthor);
			messageStore.appendToMessage(startVotes);
			messageStore.appendToMessage(l.get(x).getVotes() + "");
			messageStore.appendToMessage(endVotes);
			messageStore.appendToMessage(startComments);
			messageStore.appendToMessage(l.get(x).getNumberOfComments() + "");
			messageStore.appendToMessage(endComments);
			messageStore.appendToMessage(startTime);
			messageStore.appendToMessage(l.get(x).getTimeCreated().toString());
			messageStore.appendToMessage(endTime);
			messageStore.appendToMessage(startFlags);
			messageStore.appendToMessage(l.get(x).getFlags() + "");
			messageStore.appendToMessage(endFlags);
			messageStore.appendToMessage(endPost);
		}
		messageStore.appendToMessage(XML_END);
		
		
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
