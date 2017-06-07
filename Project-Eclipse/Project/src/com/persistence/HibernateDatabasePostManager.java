package com.persistence;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;

import org.hibernate.HibernateException;
import org.hibernate.ObjectNotFoundException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.common.BookingLogger;
import com.common.Messages;
import com.models.Comment;
import com.models.Post;

public class HibernateDatabasePostManager extends AbstractHibernateDatabaseManager {

	private static String POST_TABLE_NAME = "POST";
	private static String POST_CLASS_NAME = "Post";

	private static String SELECT_ALL_POSTS = "from " + POST_CLASS_NAME
			+ " as post";
	private static String SELECT_POST_WITH_ID = "from "
			+ POST_CLASS_NAME + " as post where post.postIdPrimarKey = ?";

	private static String METHOD_GET_ALL = "getAllPosts";
	private static String RESET_ALL = "resetAllPosts";

	private static final String DROP_TABLE_SQL = "drop table "
			+ POST_TABLE_NAME + ";";

	private static final String CREATE_TABLE_SQL = "create table " + POST_TABLE_NAME + "(POST_ID_PRIMARY_KEY char(36) primary key,"
			+ "TITLE tinytext, AUTHOR tinytext, VOTES integer, FLAGS integer, TIME_CREATED timestamp, NUMBER_OF_COMMENTS integer);";
  

	
	private static HibernateDatabasePostManager manager;

	public HibernateDatabasePostManager() {
		super();
	}

	/**
	 * Returns default instance.
	 * 
	 * @return
	 */
	public synchronized static HibernateDatabasePostManager getDefault() {
		
		if (manager == null) {
			manager = new HibernateDatabasePostManager();
		}
		return manager;
	}
	
	
	
	/**
	 * Returns post from the database found for a given name.
	 * If not found returns null.
	 * 
	 * @param name
	 * @return
	 */
	
	public synchronized int upVote(String id) {
		Post p = getObjectWithPostID(id);
		if (p != null) {	
			p.incrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
		
	
	public synchronized int flagPost(String id) {
		Post p = getObjectWithPostID(id);
		if (p != null) {	
			p.incrementFlags();
			update(p);
			int x = p.getVotes() + 5;
			if (p.getFlags() == x) {
				super.delete(p);
				return -1;
			}
			return p.getFlags();
		}
		else
			return 999999999;
	}
	
	public synchronized int downVote(String id) {
		Post p = getObjectWithPostID(id);
		if (p != null) {	
			p.decrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
	
	public synchronized int doubleUp(String id) {
		Post p = getObjectWithPostID(id);
		if (p != null) {	
			p.incrementVotes();
			p.incrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
		
	
	public synchronized int doubleDown(String id) {
		Post p = getObjectWithPostID(id);
		if (p != null) {	
			p.decrementVotes();
			p.decrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
	
	public Post addComment (String id, String c1) {
		Post p = getObjectWithPostID(id);
		//delete(p);
		Comment c = new Comment();
		c.setTitle(c1);
		c.setAuthor("anon");
		p.addComments(c);
		System.out.println(p.getCommentList());
		update(p);
		return p;
	}
	
	public synchronized Post getObjectWithPostID(String id) {
		
		Session session = null;
		Post errorResult = null;

		try {
			session = HibernateUtil.getCurrentSession();
			Query query = session.createQuery(SELECT_POST_WITH_ID);
			query.setParameter(0, id);
			Post aPost = (Post) query.uniqueResult();
			return aPost;
		} catch (ObjectNotFoundException exception) {
		//	BookingLogger.getDefault().severe(this,
			//		METHOD_GET_OBJECT_WITH_POSTID,
				//	Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return errorResult;
		} catch (HibernateException exception) {
			//	BookingLogger.getDefault().severe(this,
				//METHOD_GET_OBJECT_WITH_POSTID, Messages.HIBERNATE_FAILED,
					//exception);
			return errorResult;
		} catch (RuntimeException exception) {
		//	BookingLogger.getDefault().severe(this,
			//		METHOD_GET_OBJECT_WITH_POSTID, Messages.GENERIC_FAILED,
				//	exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}

	/**
	 * Returns all posts from the database.
	 * Upon error returns null.
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public synchronized List<Post> getPostsByTimeTill(int x, int y) {
		
		Session session = null;
		List<Post> errorResult = null;

		try {
			session = HibernateUtil.getCurrentSession();
			System.out.println(session == null);
			Query query = session.createQuery(SELECT_ALL_POSTS);
			List<Post> posts0 = query.list();			
			Collections.sort(posts0, new Comparator<Post>() {
		        @Override
		        public int compare(Post o2, Post o1) {
		            return o1.getTimeCreated().compareTo(o2.getTimeCreated());
		        }
		    });
			
			if (y > posts0.size() && y != 25)
				return null;
			else if (y > posts0.size())
				return posts0;
			else
				return posts0.subList(x, y);
		} catch (ObjectNotFoundException exception) {
			BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
					Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return errorResult;
		} catch (HibernateException exception) {
		//	BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
			//		Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		} catch (RuntimeException exception) {
			//BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
				//	Messages.GENERIC_FAILED, exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}
	@SuppressWarnings("unchecked")
	public synchronized List<Post> getPostsByVotedTill(int x, int y) {
		
		Session session = null;
		List<Post> errorResult = null;

		try {
			session = HibernateUtil.getCurrentSession();
			System.out.println(session == null);
			Query query = session.createQuery(SELECT_ALL_POSTS);
			List<Post> posts0 = query.list();
			List<Post> posts;
			Collections.sort(posts0, new Comparator<Post>() {
		        @Override
		        public int compare(Post o2, Post o1) {
		            return o1.getVotes() - o2.getVotes();
		        }
		    });
			if (y > posts0.size() && y != 25)
				posts = posts0;
			else
				posts = posts0.subList(x, y);
			return posts;
		} catch (ObjectNotFoundException exception) {
			BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
					Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return errorResult;
		} catch (HibernateException exception) {
		//	BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
			//		Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		} catch (RuntimeException exception) {
			//BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
				//	Messages.GENERIC_FAILED, exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}
	
	@SuppressWarnings("unchecked")
	public synchronized List<Post> search(String q, int x, int y) {
		
		Session session = null;
		List<Post> errorResult = null;

		try {
			session = HibernateUtil.getCurrentSession();
			System.out.println(session == null);
			Query query = session.createQuery(SELECT_ALL_POSTS);
			List<Post> posts0 = query.list();
			
			List<Post> posts = new ArrayList<Post>();
			for (int k = 0; k < posts0.size(); k++) {
				String f = posts0.get(k).getTitle();
				if (Arrays.asList(f.substring(0, f.length()-1).split(" ")).contains(q))
					posts.add(posts0.get(k));
			}
			if (y > posts.size()) {
				return posts;
			}
			else {
				posts = posts.subList(x, y);
			}
			return posts;
		} catch (ObjectNotFoundException exception) {
			BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
					Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return errorResult;
		} catch (HibernateException exception) {
		//	BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
			//		Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		} catch (RuntimeException exception) {
			//BookingLogger.getDefault().severe(this, METHOD_GET_ALL,
				//	Messages.GENERIC_FAILED, exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}

	
	public String getTableName() {
		return POST_TABLE_NAME;
	}

	/**
	 * Adds given post (object) to the database.
	 * Sets post's reset time to the current time.
	 *  
	 * @return
	 */
	public synchronized boolean add(Object object) {
		
		//Calendar calendar = Calendar.getInstance();
		//Post post = (Post) object;
		//post.setResetTime(new Timestamp(calendar.getTimeInMillis()));
		return super.add(object);
	}

	/**
	 * Resets all posts in the database.
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public synchronized boolean resetAllPosts() {
		
		Session session = null;
		Transaction transaction = null;

		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_ALL_POSTS);
			List<Post> posts = query.list();
			for (Iterator<Post> iterator = posts.iterator(); iterator
					.hasNext();) {
				iterator.next();
			}
			transaction.commit();
			return true;
		} catch (ObjectNotFoundException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, RESET_ALL,
					Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return false;
		} catch (HibernateException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, RESET_ALL,
					Messages.HIBERNATE_FAILED, exception);
			return false;
		} catch (RuntimeException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, RESET_ALL,
					Messages.GENERIC_FAILED, exception);
			return false;
		} finally {
			closeSession();
		}
	}

	public boolean setupTable() {
		HibernateUtil.executeSQLQuery(DROP_TABLE_SQL);
		return HibernateUtil.executeSQLQuery(CREATE_TABLE_SQL);
	}

	public String getClassName() {
		return POST_CLASS_NAME;
	}
	
}
