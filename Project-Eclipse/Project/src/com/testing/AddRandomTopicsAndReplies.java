package com.testing;





import java.util.Random;

import org.junit.Test;

import com.models.*;
import com.persistence.HibernateDatabaseCommentManager;
import com.persistence.HibernateDatabasePostManager;


public class AddRandomTopicsAndReplies  {

	@Test
	public void testLoginAndCounter() throws Exception {
	    HibernateDatabasePostManager pm = new HibernateDatabasePostManager();
	    pm.setupTable();
	    HibernateDatabaseCommentManager cm = new HibernateDatabaseCommentManager();
	    cm.setupTable();
	    
	    String[] a = {"Are social networking sites effective, or are they just a sophisticated means for stalking people?",
	    		"Is torture justified when used for national security?",
	    		"Should cell phones be banned in schools?",
	    		"Is peer pressure harmful or beneficial to individuals?",
	    		"Should violent video games be banned?",
	    		"Should the death penalty be taken away completely?",
	    		"Are beauty pageants a way to objectifying women?",
	    		"Should cigarettes be banned from society?",
	    		"Is it unethical to eat meat?",
	    		"Should homework be banned?",
	    		"Can people move in together before they are married?",
	    		"Do celebrities make for bad role models?",
	    		"Are credit cards are more harmful than debit cards?",
	    		"Should the concept of zoos should be nullified?",
	    		"Should fried foods come with a warning?",
	    		"Should sex education be banned in middle schools?",
	    		"All schools should make it a requirement to teach arts and music to their students?",
	    		"Should juveniles be tried and treated as adults?",
	    		"Is human cloning justified, and should it be allowed?",
	    		"Has nuclear energy destroyed our society?",
	    		"Should parents not purchase war or destruction type toys for their children?",
	    		"Should animal dissections be banned in schools?",
	    		"Should plastic bags be banned?",
	    		"Are humans too dependent on computers?",
	    		"Are security cameras an invasion of our privacy?",
	    		"Should gay marriages be legalized?",
	    		"Is co-education a good idea?",
	    		"Does money motivates people more than any other factor in the workplace?",
	    		"Is it ethical for companies to market their products to children?",
	    		"Is age an important factor in relationships?",
	    		"Should school attendance be made voluntary in high school?",
	    		"Is the boarding school system beneficial to children?",
	    		"Are curfews effective in terms of keeping teens out of trouble?",
	    		"Should libraries have a list of books that are banned?",
	    		"Will posting students� grades on bulletin boards publicly motivate them to perform better or is it humiliating?",
	    		"Do school uniforms help to improve the learning environment?",
	    		"How far is competition necessary in regards to the learning process?",
	    		"Can bullying in schools be stopped? How so?",
	    		"Is it important for all schools to conduct mandatory drug testing on their students?"};
	    
	    String[] b = {"Yes", "No", "Maybe"};
	    Random random = new Random();

	    for (int x = 0; x < 100; x++) {
	    	Post p = new Post();
	    	p.setTitle(a[random.nextInt(38 - 0 + 1) + 0]);
	    	//p.setTitle("" + x);
	    	p.setVotes(random.nextInt(5000 - 0 + 1) + 0);
	    	p.setAuthor("anon");
	    
	    	for (int i = 0; i < random.nextInt(38 - 0 + 1) + 0; i++) {
	    		Comment c = new Comment();
 	    		c.setTitle(b[random.nextInt(2 - 0 + 1) + 0]);
 	    		c.setVotes(random.nextInt(5000 - 0 + 1) + 0);
	    		c.setAuthor("anon");
	    		p.addComments(c);
		    	Thread.sleep(1000);
	    	}
	    	pm.add(p);
	    	Thread.sleep(1000);
	    }

	  
	}
}
