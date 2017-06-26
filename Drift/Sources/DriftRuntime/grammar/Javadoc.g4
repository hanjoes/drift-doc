grammar Javadoc;

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
  : description tag_section
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
  : '@' Standard_tag_name description
  ;

inline_tag
  : '{' '@' Inline_tag_name description '}'
  ; 
  
// Comments are written in HTML - The text must be written in HTML, in that they
// should use HTML entities  and  HTML  tags.
description_components
  : description_component*
  ;

description_component
  : plain_text 
  | html_element
  | inline_tag
  ;

plain_text: Character+;

// TOOD: Support attribute.
html_element
  : '<' HTML_tag '>'
  | '<' '/' HTML_tag '>'
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
  
Standard_tag_name
  : 'author'
  | 'deprecated'
  | 'exception'
  | 'param'
  | 'return'
  | 'see'
  | 'serial'
  | 'serialData'
  | 'serialField'
  | 'since'
  | 'throws'
  | 'version'
  ;
  
Inline_tag_name
  : 'code'
  | 'docRoot'
  | 'inheritDoc'
  | 'link'
  | 'linkplain'
  | 'literal'
  | 'value'
  ;
  
WS : [ \n\r\t\u000B\u000C\u0000]+ -> channel(HIDDEN);

// TODO: Other wide languages like Chinese?
Character
  : [\u0000-\uFFFF]
  ;
  
  
HTML_tag
  : '!DOCTYPE'
  | 'a'
  | 'abbr'
  | 'address'
  | 'area'
  | 'article'
  | 'aside'
  | 'audio'
  | 'b'
  | 'base'
  | 'bdi'
  | 'bdo'
  | 'blockquote'
  | 'body'
  | 'br'
  | 'button'
  | 'canvas'
  | 'caption'
  | 'cite'
  | 'code'
  | 'col'
  | 'colgroup'
  | 'command'
  | 'datalist'
  | 'dd'
  | 'del'
  | 'details'
  | 'dfn'
  | 'div'
  | 'dl'
  | 'dt'
  | 'em'
  | 'embed'
  | 'fieldset'
  | 'figcaption'
  | 'figure'
  | 'footer'
  | 'form'
  | 'h1'
  | 'h2'
  | 'h3'
  | 'h4'
  | 'h5'
  | 'h6'
  | 'head'
  | 'header'
  | 'hgroup'
  | 'hr'
  | 'html'
  | 'i'
  | 'iframe'
  | 'img'
  | 'input'
  | 'ins'
  | 'kbd'
  | 'keygen'
  | 'label'
  | 'legend'
  | 'li'
  | 'link'
  | 'map'
  | 'mark'
  | 'menu'
  | 'meta'
  | 'meter'
  | 'nav'
  | 'noscript'
  | 'object'
  | 'ol'
  | 'optgroup'
  | 'option'
  | 'output'
  | 'p'
  | 'param'
  | 'pre'
  | 'progress'
  | 'q'
  | 'rp'
  | 'rt'
  | 'ruby'
  | 's'
  | 'samp'
  | 'script'
  | 'section'
  | 'select'
  | 'small'
  | 'source'
  | 'span'
  | 'strong'
  | 'style'
  | 'sub'
  | 'summary'
  | 'sup'
  | 'table'
  | 'tbody'
  | 'td'
  | 'textarea'
  | 'tfoot'
  | 'th'
  | 'thead'
  | 'time'
  | 'title'
  | 'tr'
  | 'track'
  | 'u'
  | 'ul'
  | 'var'
  | 'video'
  | 'wbr'
  ;
