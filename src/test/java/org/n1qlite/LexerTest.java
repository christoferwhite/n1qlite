package org.n1qlite;

import static org.n1qlite.AssertN1qlGrammar.assertTree;
import static org.n1qlite.AssertN1qlGrammar.assertTreeEquals;
import static org.n1qlite.AssertN1qlGrammar.assertNotTree;
import static org.n1qlite.AssertN1qlGrammar.parse;

import org.junit.Ignore;
import org.junit.Test;

public class LexerTest {

	@Test
    public void number1() {
		assertTreeEquals( parse("12345").pNumber(), "12345" );
		assertTreeEquals( parse("   12345").pNumber(), "12345" );
		assertTreeEquals( parse("   12345   ").pNumber(), "12345" );
        assertTreeEquals( parse("12.345").pNumber(), "12.345");
        assertTreeEquals( parse("-35.260E-5").pNumber(), "-35.260E-5");
    }
	
	@Ignore     // JDW: this is better, but not working yet
	@Test
    public void number6() {
        assertNotTree( parse("12 23 45").testNumber());
    }
	
	@Ignore
	@Test
    public void number7() {
        assertNotTree( parse("abc").testNumber());
    }

}
