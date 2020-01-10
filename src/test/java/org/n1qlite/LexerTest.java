package org.n1qlite;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.List;

import org.antlr.runtime.BitSet;
import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.atn.ATNConfigSet;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.tree.ParseTree;
import org.junit.Test;
import org.n1qlite.N1qlLexer;

public class LexerTest {
	public class TestListener extends N1qlBaseListener {
		private List<String> numbers = new ArrayList<String>();
		private List<Error> errors = new ArrayList<Error>();
		private TestErrorListener errorListener = new TestErrorListener();
		
		public List<String> getNumbers() { return numbers; }
		public List<Error> getErrors() { return errors; }
		public BaseErrorListener getErrorListener() { return errorListener; }
		
		@Override
		public void exitNumber(N1qlParser.NumberContext ctx) {
			numbers.add( ctx.getText() );
		}
		
		public class TestErrorListener extends BaseErrorListener {
			@Override
			public void syntaxError(Recognizer<?,?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {
				errors.add(new Error("Syntax Error"));
			}
			public void reportAmbiguity(Parser recognizer, DFA dfa, int startIndex, int stopIndex, boolean exact, BitSet ambigAlts, ATNConfigSet configs) {
				errors.add(new Error("Ambiguity Error"));
			}
			public void reportAttemptingFullContext(Parser recognizer, DFA dfa, int startIndex, int stopIndex, BitSet conflictingAlts, ATNConfigSet configs) {
				errors.add(new Error("Full Context Error"));
			}
			public void reportContextSensitivity(Parser recognizer, DFA dfa, int startIndex, int stopIndex, int prediction, ATNConfigSet configs) {
				errors.add(new Error("Context Sensitivity Error"));
			}
		}
	}
	
	public N1qlParser setup(String text) {
		N1qlLexer lexer = new N1qlLexer(CharStreams.fromString(text));
        CommonTokenStream tokens = new CommonTokenStream( lexer );
        N1qlParser parser = new N1qlParser( tokens );
        TestListener listener = new TestListener();
        parser.removeParseListeners();
        parser.addParseListener(listener);
        parser.removeErrorListeners();
        parser.addErrorListener(listener.getErrorListener());
        return parser;
	}

	@Test
    public void numberTest1() {
    	N1qlParser parser = setup("12345");
    	N1qlParser.NumberContext ctx = parser.number();
        TestListener stuff = (TestListener) parser.getParseListeners().get(0);
        
        assertEquals(0, stuff.getErrors().size());   // should find no errors
        assertEquals(1, stuff.getNumbers().size());  // should find one number
        assertEquals("12345", stuff.getNumbers().get(0)); 
    }
	
	@Test
    public void numberTest2() {
    	N1qlParser parser = setup("12.345");
    	N1qlParser.NumberContext ctx = parser.number();
        TestListener stuff = (TestListener) parser.getParseListeners().get(0);
        
        assertEquals(0, stuff.getErrors().size());   // should find no errors
        assertEquals(1, stuff.getNumbers().size());  // should find one number
        assertEquals("12.345", stuff.getNumbers().get(0)); 
    }
}
