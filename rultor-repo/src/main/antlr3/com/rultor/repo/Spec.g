/**
 * Copyright (c) 2009-2013, rultor.com
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met: 1) Redistributions of source code must retain the above
 * copyright notice, this list of conditions and the following
 * disclaimer. 2) Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following
 * disclaimer in the documentation and/or other materials provided
 * with the distribution. 3) Neither the name of the rultor.com nor
 * the names of its contributors may be used to endorse or promote
 * products derived from this software without specific prior written
 * permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT
 * NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
 * THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */
grammar Spec;

@header {
    package com.rultor.repo;
    import java.util.Collection;
    import java.util.LinkedList;
    import org.apache.commons.lang3.StringEscapeUtils;
}

@lexer::header {
    package com.rultor.repo;
}

@lexer::members {
    @Override
    public void emitErrorMessage(String msg) {
        throw new IllegalArgumentException(msg);
    }
}

@parser::members {
    private transient Grammar grammar;
    public void setGrammar(final Grammar grm) {
        this.grammar = grm;
    }
    @Override
    public void emitErrorMessage(String msg) {
        throw new IllegalArgumentException(msg);
    }
}

spec returns [Variable<?> ret]
    :
    composite
    { $ret = $composite.ret; }
    EOF
    ;

composite returns [Composite ret]
    @init { final Collection<Variable<?>> vars = new LinkedList<Variable<?>>(); }
    :
    TYPE
    '('
    (
        first=variable
        { vars.add($first.ret); }
        (
            ','
            next=variable
            { vars.add($next.ret); }
        )*
    )*
    ')'
    { $ret = new Composite($TYPE.text, vars); }
    ;

variable returns [Variable<?> ret]
    :
    composite
    { $ret = $composite.ret; }
    |
    NAME
    { $ret = new Reference(this.grammar, $NAME.text); }
    |
    TEXT
    { $ret = new Text(StringEscapeUtils.unescapeJava($TEXT.text)); }
    |
    BOOLEAN
    { $ret = new Constant<Boolean>(new Boolean($BOOLEAN.text.equals("TRUE"))); }
    |
    INTEGER
    { $ret = new Constant<Integer>(Integer.valueOf($INTEGER.text)); }
    |
    LONG
    { $ret = new Constant<Long>(Long.valueOf($LONG.text.substring(0, $LONG.text.length() - 1))); }
    |
    DOUBLE
    { $ret = new Constant<Double>(Double.valueOf($DOUBLE.text)); }
    ;

BOOLEAN
    :
    'TRUE' | 'FALSE'
    ;

TYPE
    :
    PACKAGE ('.' PACKAGE)+
    ;

NAME
    :
    LETTER (LETTER | DIGIT | '-')+
    ;

TEXT :
    '"' ('\\"' | ~'"')* '"'
    { this.setText(this.getText().substring(1, this.getText().length() - 1).replace("\\\"", "\"")); }
    |
    '\'' ('\\\'' | ~'\'')* '\''
    { this.setText(this.getText().substring(1, this.getText().length() - 1).replace("\\'", "'")); }
    ;

INTEGER
    :
    ( '-' | '+' )? DIGIT+
    ;

LONG
    :
    ( '-' | '+' )? DIGIT+ ('L' | 'l')
    ;

DOUBLE
    :
    ( '-' | '+' )? DIGIT+ '.' DIGIT+
    ;

fragment LETTER
    :
    ( 'a' .. 'z' | 'A' .. 'Z')
    ;
fragment DIGIT
    :
    ( '0' .. '9' )
    ;
fragment PACKAGE
    :
    LETTER (LETTER | DIGIT | '$')*
    ;

SPACE
    :
    ( ' ' | '\t' | '\n' | '\r' )+
    { skip(); }
    ;