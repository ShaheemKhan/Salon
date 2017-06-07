package com.persistence;


import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.common.BookingLogger;
import com.common.Messages;

public abstract class AbstractHibernateDatabaseManager {
	
	private static String DELETE_ALL = "delete from  " ;
	
	
	
	abstract boolean setupTable();
	public abstract String getClassName();
	public abstract String getTableName();
	
	

	/**
	 * Closes current Hibernate session.
	 * Uses Hibernate utility to do so.
	 */
	protected void closeSession(){
		
		try {
			HibernateUtil.closeTheThreadLocalSession();
		}
		catch (HibernateException ex) {
			ex.printStackTrace();
		}	
	}
	
	/**
	 * Rolls back given transaction and logs it to the log file.
	 * 
	 * @param transaction
	 */
	protected void rollback (Transaction transaction){
		
		try {
			if (transaction != null) 
				transaction.rollback();
		}
		catch (HibernateException exception) {
			BookingLogger.getDefault().severe(this, Messages.METHOD_ROLLBACK, Messages.HIBERNATE_FAILED, exception);
		}	
	}
	
	/**
	 * Adds given object to the database.
	 * Returns true if add is successful, otherwise returns false.
	 * 
	 * @param object
	 * @return
	 */
	public synchronized boolean add(Object object){
		
		Transaction transaction = null;
		Session session = null;
		boolean errorResult = false;
		
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			session.save(object);
			transaction.commit();
			session.flush();
			return true;	
		}
		catch (HibernateException exception) {
			rollback(transaction);
			exception.printStackTrace();
			//BookingLogger.getDefault().severe(this, Messages.METHOD_ADD, Messages.HIBERNATE_FAILED, exception);					
			return errorResult;
		}	
		catch (RuntimeException exception) {
			rollback(transaction);
			exception.printStackTrace();
			//BookingLogger.getDefault().severe(this, Messages.METHOD_ADD, Messages.GENERIC_FAILED, exception);
			return errorResult;
		}
		finally {
			closeSession();
		}
	}
	
	/**
	 * Updates given object in the database.
	 * Returns true if update is successful, otherwise returns false.
	 * 
	 * @param object
	 * @return
	 */
	public synchronized boolean update(Object object){
		
		Transaction transaction = null;
		Session session = null;
		boolean errorResult = false;
		
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			session.update(object);
			transaction.commit();
			
			return true;	
		}
		catch (HibernateException exception) {
			rollback(transaction);
			//BookingLogger.getDefault().severe(this, Messages.METHOD_UPDATE, Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		}		
		catch (RuntimeException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, Messages.METHOD_UPDATE, Messages.GENERIC_FAILED, exception);
			return errorResult;
		}
		finally {
			closeSession();
		}
	}
	
	/**
	 * Updates given update object in the database and adds given add object to the database.
	 * If one of the given objects is null it does not perform its database operation.
	 * Returns true if database operation is successful, otherwise returns false. 
	 * 
	 * @param updateObject
	 * @param addObject
	 * @return
	 */
	public synchronized boolean updateAndAdd(Object updateObject, Object addObject){
		
		Transaction transaction = null;
		Session session = null;
		boolean errorResult = false;
		
		if (updateObject == null) {
			return add(addObject);
		}
		if (addObject == null) {
			return update(updateObject);
		} 
		
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			session.update(updateObject);
			session.save(addObject);
			transaction.commit();
			return true;	
		}
		catch (HibernateException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, Messages.METHOD_UPDATE_AND_ADD, Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		}		
		catch (RuntimeException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, Messages.METHOD_UPDATE_AND_ADD, Messages.GENERIC_FAILED, exception);
			return errorResult;
		}
		finally {
			closeSession();
		}
	}
	
	/**
	 * Deletes given object from the database.
	 * Returns true if successful, otherwise returns false.
	 * 
	 * @param object
	 * @return
	 */
	public synchronized boolean delete(Object object){
		
		Session session = null;
		Transaction transaction = null;
		boolean errorResult = false;
		
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			session.delete(object);
			transaction.commit();
			return true;
		}
		catch (HibernateException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, Messages.METHOD_DELETE, Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		}	
		catch (RuntimeException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, Messages.METHOD_DELETE, Messages.GENERIC_FAILED, exception);
			return errorResult;
		}
		finally {
			closeSession();
		}
	}

	/**
	 * Deletes all database entries based on the class where method is called.
	 * 
	 * @return
	 */
	public synchronized boolean deleteAll(){
		
		Session session = null;
		Transaction transaction = null;
		boolean errorResult = false;
		
		try {
			session = HibernateUtil.getCurrentSession();
			transaction = session.beginTransaction();
			SQLQuery query = session.createSQLQuery(DELETE_ALL + getTableName());
			query.executeUpdate();
			transaction.commit();
			return true;
		}
		catch (HibernateException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, Messages.METHOD_DELETE_ALL, Messages.HIBERNATE_FAILED, exception);
			return errorResult;
		}	
		catch (RuntimeException exception) {
			rollback(transaction);
			BookingLogger.getDefault().severe(this, Messages.METHOD_DELETE_ALL, Messages.GENERIC_FAILED, exception);
			return errorResult;
		}
		finally {
			closeSession();
		}
	}
}

