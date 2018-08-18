package de.netherspace.apps.actojat.util;

import java.util.BitSet;

import org.antlr.v4.runtime.ANTLRErrorListener;
import org.antlr.v4.runtime.BaseErrorListener;
import org.antlr.v4.runtime.Parser;
import org.antlr.v4.runtime.RecognitionException;
import org.antlr.v4.runtime.Recognizer;
import org.antlr.v4.runtime.atn.ATNConfigSet;
import org.antlr.v4.runtime.dfa.DFA;

/**
 * A Custom ErrorListener that sets a certain error flag whenever an error occurs.
 */
public class SourceErrorListener extends BaseErrorListener implements ANTLRErrorListener {
	
	private boolean errorFlag;

	/**
	 * The default constructor.
	 */
	public SourceErrorListener() {
		super();
		this.errorFlag = false;
	}

	@Override
	public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine,
			String msg, RecognitionException e) {
		this.errorFlag = true;
		super.syntaxError(recognizer, offendingSymbol, line, charPositionInLine, msg, e);
	}

	@Override
	public void reportAmbiguity(Parser recognizer, DFA dfa, int startIndex, int stopIndex, boolean exact,
			BitSet ambigAlts, ATNConfigSet configs) {
		this.errorFlag = true;
		super.reportAmbiguity(recognizer, dfa, startIndex, stopIndex, exact, ambigAlts, configs);
	}

	/**
	 * Returns the error flag.
	 * @return true if an error occurred, false otherwise
	 */
	public boolean isErrorFlag() {
		return errorFlag;
	}

}
