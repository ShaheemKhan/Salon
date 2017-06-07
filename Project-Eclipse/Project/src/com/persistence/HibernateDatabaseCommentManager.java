package com.persistence;

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

public class HibernateDatabaseCommentManager extends AbstractHibernateDatabaseManager {

	private static String COMMENT_TABLE_NAME = "COMMENT";
	private static String COMMENT_CLASS_NAME = "Comment";

	private static String SELECT_ALL_COMMENTS = "from " + COMMENT_CLASS_NAME
			+ " as comment";
	private static String SELECT_COMMENT_WITH_ID = "from "
			+ COMMENT_CLASS_NAME + " as comment where comment.commentIdPrimarKey = ?";

	private static String METHOD_GET_ALL = "getAllComments";
	private static String RESET_ALL = "resetAllComments";

	private static final String DROP_TABLE_SQL = "drop table "
			+ COMMENT_TABLE_NAME + ";";

	private static final String CREATE_TABLE_SQL = "create table " + COMMENT_TABLE_NAME + "(COMMENT_ID_PRIMARY_KEY char(36) primary key,"
			+ "TITLE tinytext, AUTHOR tinytext, VOTES integer, FLAGS integer, TIME_CREATED timestamp, POST_ID_FK char(36));";
  

	
	private static HibernateDatabaseCommentManager manager;

	public HibernateDatabaseCommentManager() {
		super();
	}

	/**
	 * Returns default instance.
	 * 
	 * @return
	 */
	public synchronized static HibernateDatabaseCommentManager getDefault() {
		
		if (manager == null) {
			manager = new HibernateDatabaseCommentManager();
		}
		return manager;
	}
	
	
	
	/**
	 * Returns comment from the database found for a given name.
	 * If not found returns null.
	 * 
	 * @param name
	 * @return
	 */
	
	public synchronized int upVote(String id) {
		Comment p = getObjectWithCommentID(id);
		if (p != null) {	
			p.incrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
		
	
	public synchronized int flagComment(String id) {
		Comment p = getObjectWithCommentID(id);
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
		return 999999999;
	}
	
	public synchronized int downVote(String id) {
		Comment p = getObjectWithCommentID(id);
		if (p != null) {	
			p.decrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
	
	public synchronized int doubleUp(String id) {
		Comment p = getObjectWithCommentID(id);
		if (p != null) {	
			p.incrementVotes();
			p.incrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
		
	
	public synchronized int doubleDown(String id) {
		Comment p = getObjectWithCommentID(id);
		if (p != null) {	
			p.decrementVotes();
			p.decrementVotes();
			update(p);
			return p.getVotes();
		}
		return 999999999;
	}
	
	@SuppressWarnings("unchecked")
	public synchronized Comment getObjectWithCommentID(String id) {
		
		Session session = null;
		Comment errorResult = null;

		try {
			session = HibernateUtil.getCurrentSession();
			Query query = session.createQuery(SELECT_COMMENT_WITH_ID);
			query.setParameter(0, id);
			List<Comment> comments = query.list();
			if (comments.isEmpty()) {
				return null;
			} else {
				Comment client = comments.get(0);
				return client;
			}
		} catch (ObjectNotFoundException exception) {
		//	BookingLogger.getDefault().severe(this,
			//		METHOD_GET_OBJECT_WITH_COMMENTID,
				//	Messages.OBJECT_NOT_FOUND_FAILED, exception);
			return errorResult;
		} catch (HibernateException exception) {
			//	BookingLogger.getDefault().severe(this,
				//METHOD_GET_OBJECT_WITH_COMMENTID, Messages.HIBERNATE_FAILED,
					//exception);
			return errorResult;
		} catch (RuntimeException exception) {
		//	BookingLogger.getDefault().severe(this,
			//		METHOD_GET_OBJECT_WITH_COMMENTID, Messages.GENERIC_FAILED,
				//	exception);
			return errorResult;
		} finally {
			closeSession();
		}
	}

	/**
	 * Returns all comments from the database.
	 * Upon error returns null.
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public synchronized List<Comment> getCommentsByTimeTill(int x, int y) {
		
		Session session = null;
		List<Comment> errorResult = null;

		try {
			session = HibernateUtil.getCurrentSession();
			System.out.println(session == null);
			Query query = session.createQuery(SELECT_ALL_COMMENTS);
			List<Comment> comments0 = query.list();
			List<Comment> comments;
			Collections.sort(comments0, new Comparator<Comment>() {
		        @Override
		        public int compare(Comment o2, Comment o1) {
		            return o1.getTimeCreated().compareTo(o2.getTimeCreated());
		        }
		    });
			if (y > comments0.size())
				comments = comments0;
			else
				comments = comments0.subList(x, y);
			return comments;
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
	public synchronized List<Comment> getCommentsByVotedTill(int x, int y) {
		
		Session session = null;
		List<Comment> errorResult = null;

		try {
			session = HibernateUtil.getCurrentSession();
			System.out.println(session == null);
			Query query = session.createQuery(SELECT_ALL_COMMENTS);
			List<Comment> comments0 = query.list();
			List<Comment> comments;
			Collections.sort(comments0, new Comparator<Comment>() {
		        @Override
		        public int compare(Comment o2, Comment o1) {
		            return o1.getVotes() - o2.getVotes();
		        }
		    });
			if (y > comments0.size())
				comments = comments0;
			else
				comments = comments0.subList(x, y);
			return comments;
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
		return COMMENT_TABLE_NAME;
	}

	/**
	 * Adds given comment (object) to the database.
	 * Sets comment's reset time to the current time.
	 *  
	 * @return
	 */
	public synchronized boolean add(Object object) {
		
		//Calendar calendar = Calendar.getInstance();
		//Comment comment = (Comment) object;
		//comment.setResetTime(new Timestamp(calendar.getTimeInMillis()));
		return super.add(object);
	}

	/**
	 * Resets all comments in the database.
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public synchronized boolean resetAllComments() {
		
		Session session = null;
		Transaction transaction = null;

		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			Query query = session.createQuery(SELECT_ALL_COMMENTS);
			List<Comment> comments = query.list();
			for (Iterator<Comment> iterator = comments.iterator(); iterator
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
		return COMMENT_CLASS_NAME;
	}
	
}
