package com.class3601.social.common;

public class MessageStore {
	
	private String message;
	
	public MessageStore() {	
		setMessage("");
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	
	public void appendToMessage(String text) {
		message = message + text;
	}

}
