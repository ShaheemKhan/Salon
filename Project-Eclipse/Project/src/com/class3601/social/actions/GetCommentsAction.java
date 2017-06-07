package com.class3601.social.actions;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import com.models.Comment;
import org.apache.struts2.interceptor.ServletRequestAware;
import com.class3601.social.common.MessageStore;
import com.opensymphony.xwork2.ActionSupport;
import com.persistence.HibernateDatabasePostManager;

public class GetCommentsAction extends ActionSupport implements ServletRequestAware {
    private static String PARAMETER_1 = "start";
    private static String PARAMETER_2 = "end";
    private static String PARAMETER_3 = "type";
    private static String PARAMETER_4 = "id";

	private static final long serialVersionUID = 1L;
    private static String XML_1 = 
    		"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n\n" +
    				"<comments>";
	private static String startComment = "\n   <comment>";
    private static String startID = "\n      <id>";
    private static String endID = "</id>";
    private static String startTitle = "\n      <title>";
    private static String endTitle = "</title>";
    private static String startAuthor = "\n      <author>";
    private static String endAuthor = "</author>";
    private static String startVotes = "\n      <votes>";
    private static String endVotes = "</votes>";
    private static String startTime = "\n      <time>";
    private static String endTime = "</time>";
    private static String startFlags = "\n      <flags>";
    private static String endFlags = "</flags>";
	private static String endComment = "\n   </comment>";
    private static String XML_END = "\n</comments>";

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
		String  parameter4 = getServletRequest().getParameter(PARAMETER_4);


		int from = Integer.parseInt(parameter1);
		int to = Integer.parseInt(parameter2);
		
		messageStore = new MessageStore();

		
		HibernateDatabasePostManager manager = new HibernateDatabasePostManager();	
		List<Comment> l = manager.getObjectWithPostID(parameter4).getCommentList();
		if (parameter3.equals("n")) {
			Collections.sort(l, new Comparator<Comment>() {
		        @Override
		        public int compare(Comment o2, Comment o1) {
		            return o1.getTimeCreated().compareTo(o2.getTimeCreated());
		        }
		    });
			if (to > l.size() && to != 25)
				return "fail";
			if (!(to > l.size()))
				l = l.subList(from, to);
		}
		if (parameter3.equals("v")) {
			Collections.sort(l, new Comparator<Comment>() {
		        @Override
		        public int compare(Comment o2, Comment o1) {
		            return o1.getVotes() - o2.getVotes();
		        }
		    });
			if (to > l.size() && to != 25)
				return "fail";
			if (!(to > l.size()))
				l = l.subList(from, to);
		}
		System.out.println("\n\n\n hhhb " + parameter2 + " " + to + " fdasfd " + l);

		messageStore.appendToMessage(XML_1);
		for (int x = 0; x < l.size(); x++) {
			messageStore.appendToMessage(startComment);	
			messageStore.appendToMessage(startID);
			messageStore.appendToMessage(l.get(x).getCommentIdPrimarKey());
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
			messageStore.appendToMessage(startTime);
			messageStore.appendToMessage(l.get(x).getTimeCreated().toString());
			messageStore.appendToMessage(endTime);
			messageStore.appendToMessage(startFlags);
			messageStore.appendToMessage(l.get(x).getFlags() + "");
			messageStore.appendToMessage(endFlags);
			messageStore.appendToMessage(endComment);
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
