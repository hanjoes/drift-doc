lexer grammar JavadocLexer;

Doc_start
  : Doc_open -> mode(JAVADOC)
  ;

WS : [ \n\r\t\u000B\u000C\u0000]+ -> channel(HIDDEN);

Printable
  : ~[ \n\r\t\u000B\u000C\u0000]
  ;

fragment Doc_open
  : '/**' '*'*
  ;

mode JAVADOC;


Doc_end
  : Doc_close  -> mode(DEFAULT_MODE)
  ;

Tag_start
  : '@' Doc_text
  ;

Doc_ws : [ \n\r\t\u000B\u000C\u0000]+;

Open_brace
  : '{'
  ;

Close_brace
  : '}'
  ;

Html_open
  : '<'
  | '</'
  ;

Html_close
  : '>'
  ;

Doc_text
  : Doc_printable+
  ;


fragment Doc_close
  : '*'* '*/'
  ;

fragment Doc_printable
  : ~[ <>{}\n\r\t\u000B\u000C\u0000]
  ;

// +--------------+-------------+
// |     Tag      | Introduced  |
// |              | in JDK      |
// +--------------+-------------+
// |@author       | 1.0         |
// |{@code}       | 1.5         |
// |{@docRoot}    | 1.3         |
// |@deprecated   | 1.0         |
// |@exception    | 1.0         |
// |{@inheritDoc} | 1.4         |
// |{@link}       | 1.2         |
// |{@linkplain}  | 1.4         |
// |{@literal}    | 1.5         |
// |@param        | 1.0         |
// |@return       | 1.0         |
// |@see          | 1.0         |
// |@serial       | 1.2         |
// |@serialData   | 1.2         |
// |@serialField  | 1.2         |
// |@since        | 1.1         |
// |@throws       | 1.2         |
// |{@value}      | 1.4         |
// |@version      | 1.0         |
// +--------------+-------------+
//Tag_name
//  :'author'
//  |'code'
//  |'docRoot'
//  |'deprecated'
//  |'exception'
//  |'inheritDoc'
//  |'link'
//  |'linkplain'
//  |'literal'
//  |'param'
//  |'return'
//  |'see'
//  |'serial'
//  |'serialData'
//  |'serialField'
//  |'since'
//  |'throws'
//  |'value'
//  |'version'
//  ;
