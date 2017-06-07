package com.models;

import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.sql.Timestamp;

import com.common.Messages;
import com.models.Comment;

public class Post {
	private String postIdPrimarKey;
	private String title;
	private String author;
	private int votes;
	private int flags;
	private int numberOfComments;
	private List<Comment> commentList;
	private Timestamp timeCreated;

	public String toString() {
		return getTitle();
	}
	
	public Post() {
		setTitle(Messages.UNKNOWN);
		setVotes(1);
		setFlags(0);
		setNumberOfComments(0);
		Date date= new Date();
		setTimeCreated(new Timestamp(date.getTime()));
		setCommentList(new ArrayList<Comment>());
	}

	public boolean equals(Post Post) {
		return getPostIdPrimarKey().equals(Post.getPostIdPrimarKey());
	}

	public String getPostIdPrimarKey() {
		return postIdPrimarKey;
	}


	public void setPostIdPrimarKey(String PostIdPrimarKey) {
		this.postIdPrimarKey = PostIdPrimarKey;
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



	public void updateFromPost(Post Post) {
		setPostIdPrimarKey(Post.getPostIdPrimarKey());
		//setAddresses(Post.getAddresses());
		setTitle(Post.getTitle());
		setVotes(Post.getVotes());
		setFlags(Post.getFlags());
		setNumberOfComments(Post.getNumberOfComments());
		setTimeCreated(Post.getTimeCreated());
		setCommentList(Post.getCommentList());
	}
	
	public void addComments(Comment c) {
		incrementNumberOfComments();
		getCommentList().add(c);
	}
	
	public Post copy() {
		Post Post = new Post();
		Post.updateFromPost(this);
		return Post;
	}
	
	public int getNumberOfComments() {
		return numberOfComments;
	}
	
	public void setNumberOfComments(int cc) {
		numberOfComments = cc;
	}
	
	public void incrementNumberOfComments() {
		numberOfComments++;
	}
	
	public void decrementNumberOfComments() {
		numberOfComments--;
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
	
	public List<Comment> getCommentList() {
		return commentList;
	}
	
	public void setCommentList(List<Comment> c) {
		this.commentList = c;
	}
}
