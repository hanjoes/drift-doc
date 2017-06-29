grammar Javadoc;

file : file_element* EOF;

file_element
  : javadoc
  | code
  ;

code : plain_text;

// Based on javadoc manpage.

// A comment is a description followed by tags - The description begins after 
// the  starting  delimiter  /**  and  continues until the tag section.  
//
// The tag section starts with the first character @ that begins a line 
// (ignoring leading asterisks and white space).  
//
// It is possible to have a comment with only tags and no description.  
// The description cannot  continue after  the  tag  section begins.
javadoc
  : Doc_start description tag_section Doc_end
  ;

tag_section
  : standard_tags
  ;
  
description
  : description_components
  ;

// Standard and in-line tags - A tag is a special keyword within a doc comment
// that the  Javadoc tool can process.   
// 
// The Javadoc tool has standalone tags, which appear as @tag, 
// and in-line tags, which appear within braces, as {@tag}.  
// To be interpreted, a standalone tag must appear at the beginning of a line,
// ignoring leading asterisks, white space and comment separator  (/**).   
// 
// This means you can use the @ character elsewhere in the text and it will not 
// be interpreted as the start of a tag. If you want to start a line with the @
// character and not have it be interpreted, use the HTML entity &#064;.   
// 
// Each standalone tag has associated text, which includes any text following 
// the tag up to, but not including, either the next tag, or the end of the doc
// comment. 
// 
// This associated text can span multiple lines. An in-line  tag  is               
// allowed and interpreted anywhere that text is allowed. Example:
//
// @deprecated As of JDk 1.1, replaced by {@link #setBounds(int,int,int,int)}                                                   
//

// Some of the tags below could contain other tags, thus using description
// would be safe because description is the most comprehensive text 
// representation in this grammar.
standard_tags
  : standard_tag*
  ;
  
standard_tag
  : '@' tag_name description
  ;

inline_tag
  : '{' '@' tag_name description '}'
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
tag_name
  :'author'
  |'code'
  |'docRoot'
  |'deprecated'
  |'exception'
  |'inheritDoc'
  |'link'
  |'linkplain'
  |'literal'
  |'param'
  |'return'
  |'see'
  |'serial'
  |'serialData'
  |'serialField'
  |'since'
  |'throws'
  |'value'
  |'version'
  ;

// Comments are written in HTML - The text must be written in HTML, in that they
// should use HTML entities  and  HTML  tags.
description_components
  : description_component*
  ;

description_component
  : html_element
  | plain_text
  | inline_tag
  ;

plain_text: Printable+;

// Fuzzy match of HTML elements.
// Some of the element names are too general (like a), and seem to
// mess up the grammar.
html_element
  : '<' Printable+ '>'
  | '</' Printable+ '>'
  ;

// TODO: Other languages?
Printable
  : ~[ \n\r\t\u000B\u000C\u0000]
  ;
  
Doc_start
  : '/**' '*'*
  ;
  
Doc_end
  : '*'* '*/'
  ;

WS : [ \n\r\t\u000B\u000C\u0000]+ -> channel(HIDDEN);
