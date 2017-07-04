parser grammar JavadocParser;

options { tokenVocab=JavadocLexer; }

file : file_element* EOF;

file_element
  : javadoc
  | code
  ;

code : Printable+;

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
  : Doc_start description Doc_ws tag_section Doc_end
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

tag_section
  : standard_tags
  ;

standard_tags
  : standard_tag*
  ;
  
standard_tag
  : Tag_start Doc_ws description
  ;

inline_tag
  : Open_brace Tag_start  Doc_ws inline_tag_components Doc_ws Close_brace
  ;

// Comments are written in HTML - The text must be written in HTML, in that they
// should use HTML entities  and  HTML  tags.
description_components
  : description_component*
  ;

description_component
  : html_element
  | inline_tag
  | {Support.isNotTagOrHtml(_input)}? Doc_text
  | Doc_ws
  ;

inline_tag_components
  : inline_tag_component*
  ;

inline_tag_component
  : {Support.isNotTagOrHtml(_input)}? Doc_text
  | html_element
  ;

// Fuzzy match of HTML elements.
// Some of the element names are too general (like a), and seem to
// mess up the grammar.
html_element
  : Html_open Doc_ws Doc_text Doc_ws Html_close
  ;
