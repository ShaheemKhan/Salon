package com.models;

import java.util.Date;
import java.sql.Timestamp;

import com.common.Messages;

public class Comment {
	private String commentIdPrimarKey;
	private String title;
	private String author;
	private int votes;
	private int flags;
	private Timestamp timeCreated;
	private Post post;

	public String toString() {
		return getTitle();
	}
	
	public Comment() {
		setTitle(Messages.UNKNOWN);
		setVotes(1);
		setFlags(0);
		Date date= new Date();
		setTimeCreated(new Timestamp(date.getTime()));
	}

	public boolean equals(Comment Post) {
		return getCommentIdPrimarKey().equals(Post.getCommentIdPrimarKey());
	}

	public String getCommentIdPrimarKey() {
		return commentIdPrimarKey;
	}


	public void setCommentIdPrimarKey(String PostIdPrimarKey) {
		this.commentIdPrimarKey = PostIdPrimarKey;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTitle() {
		return title;
	}
	
	public void setAuthor(String b) {
		this.author = b;
	}

	public String getAuthor() {
		return author;
	}



	public void updateFromPost(Comment Post) {
		setCommentIdPrimarKey(Post.getCommentIdPrimarKey());
		//setAddresses(Post.getAddresses());
		setTitle(Post.getTitle());
	}
	
	public Comment copy() {
		Comment Post = new Comment();
		Post.updateFromPost(this);
		return Post;
	}
	
	public int getVotes() {
		return votes;
	}
	
	public void setVotes(int cc) {
		votes = cc;
	}
	
	public void incrementVotes() {
		votes++;
	}
	
	public void decrementVotes() {
		votes--;
	}
	
	
	public int getFlags() {
		return flags;
	}
	
	public void setFlags(int cc) {
		flags = cc;
	}
	
	public void incrementFlags() {
		flags++;
	}
	
	public void decrementFlags() {
		flags--;
	}
	
	
	public Timestamp getTimeCreated() {
		return timeCreated;
	}
	
	public void setTimeCreated(Timestamp t) {
		timeCreated = t;
	}
	
	public Post getPost() {
		return post;
	}
	
	public void setPost(Post p) {
		this.post = p;
	}
}
