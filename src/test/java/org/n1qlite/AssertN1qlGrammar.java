package org.n1qlite;

import static org.junit.Assert.assertEquals;

import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.ParserRuleContext;

public class AssertN1qlGrammar {
	static public N1qlParser parse(String str) {
        N1qlLexer lexer = new N1qlLexer(CharStreams.fromString(str));
        N1qlParser parser = new N1qlParser(new CommonTokenStream(lexer));
        return parser;
	}
	
	static public void assertTreeEquals(ParserRuleContext type, String str) {
		new N1qlBaseVisitor<Void>().visit(type);
		assertEquals( type.getText(), str );
	}
	
	static public void assertTree(ParserRuleContext type) {
		new N1qlBaseVisitor<Void>().visit(type);
	}
	
	static public void assertNotTree(ParserRuleContext type) {
		try {
			assertTree(type);
		} catch(Exception e) {
			return;
		}
		throw new RuntimeException("ParseTree created when it should not");
	}
}
