/*
 * [The "BSD license"]
 *  Copyright (c) 2014 Terence Parr
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *  1. Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *  2. Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 *  3. The name of the author may not be used to endorse or promote products
 *     derived from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 *  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 *  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 *  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 *  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 *  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 *  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
 *
 * Converted from Apple's doc, http://tinyurl.com/n8rkoue, to ANTLR's
 * meta-language.
 */
grammar Swift;

@lexer::members {
public static final int BLOCK_COMMENT = 2;
//public static final int LINE_COMMENT = 3;
}

top_level : statement* EOF ;

// GRAMMAR OF A STATEMENT

statement
// : assignment_statement ';'?
 : expression ';'?
 | declaration ';'?
 | loop_statement ';'?
 | branch_statement ';'?
 | labeled_statement ';'?
 | control_transfer_statement ';'?
 | defer_statement ';'?
 | do_statement ';'?
 | compiler_control_statement
 ;

statements : statement+ ;

// GRAMMAR OF A LOOP STATEMENT

loop_statement
 : for_in_statement
 | while_statement
 | repeat_while_statement
 ;

// GRAMMAR OF A FOR_IN STATEMENT

for_in_statement : 'for' 'case'? pattern 'in' expression where_clause? code_block  ;

// GRAMMAR OF A WHILE STATEMENT

while_statement : 'while' condition_list code_block  ;

condition_list : condition (',' condition)* ;
condition
 : availability_condition
 | case_condition
 | optional_binding_condition
 | expression
 ;

case_condition : 'case' pattern initializer ;
optional_binding_condition
 : 'let' pattern initializer
 | 'var' pattern initializer
 ;

// GRAMMAR OF A REPEAT-WHILE STATEMENT

repeat_while_statement : 'repeat' code_block 'while' expression ;

// GRAMMAR OF A BRANCH STATEMENT

branch_statement
 : if_statement
 | guard_statement
 | switch_statement
 ;

// GRAMMAR OF AN IF STATEMENT

if_statement : 'if' condition_list code_block else_clause? ;
else_clause
 : 'else' code_block
 | 'else' if_statement
 ;

// GRAMMAR OF A GUARD STATEMENT

guard_statement : 'guard' condition_list 'else' code_block ;

// GRAMMAR OF A SWITCH STATEMENT

switch_statement : 'switch' expression '{' switch_cases? '}'  ;
switch_cases : switch_case switch_cases? ;
switch_case
 : case_label statements
 | default_label statements
 ;
case_label : 'case' case_item_list ':' ;
case_item_list
 : pattern where_clause?
 | pattern where_clause? ',' case_item_list
 ;
default_label : 'default' ':' ;
where_clause : 'where' where_expression ;
where_expression : expression ;

// GRAMMAR OF A LABELED STATEMENT

labeled_statement
 : statement_label loop_statement
 | statement_label if_statement
 | statement_label switch_statement
 ;
statement_label : label_name ':' ;
label_name : identifier  ;

// GRAMMAR OF A CONTROL TRANSFER STATEMENT

control_transfer_statement
 : break_statement
 | continue_statement
 | fallthrough_statement
 | return_statement
 | throw_statement
 ;

// GRAMMAR OF A BREAK STATEMENT

break_statement : 'break' label_name? ;

// GRAMMAR OF A CONTINUE STATEMENT

continue_statement : 'continue' label_name? ;

// GRAMMAR OF A FALLTHROUGH STATEMENT

fallthrough_statement : 'fallthrough'  ;

// GRAMMAR OF A RETURN STATEMENT

return_statement : 'return' expression? ;

// GRAMMAR OF A DEFER STATEMENT

defer_statement : 'defer' code_block ;

// GRAMMAR OF A DO STATEMENT

do_statement : 'do' code_block catch_clauses? ;
catch_clauses : catch_clause catch_clauses? ;
catch_clause : 'catch' pattern? where_clause? code_block ;

// GRAMMAR OF A THROW STATEMENT
throw_statement : 'throw' expression ;

// GRAMMAR OF A COMPILER CONTROL STATEMENT

compiler_control_statement
 : conditional_compilation_block
// | line_control_statement
 ;

// GRAMMAR OF A BUILD CONFIGURATION STATEMENT

conditional_compilation_block : if_directive_clause elseif_directive_clauses? else_directive_clause ;
if_directive_clause : if_directive compilation_condition statements? ;
elseif_directive_clauses : elseif_directive_clause+ ;
elseif_directive_clause : elseif_directive compilation_condition statements? ;
else_directive_clause : else_directive statements? ;

if_directive : '#if' ;
elseif_directive : '#elseif' ;
else_directive : '#else' ;
endif_directive : '#endif' ;

compilation_condition
 : platform_condition
 | identifier
 | boolean_literal
 | '(' compilation_condition ')'
 | '!' compilation_condition
// | compilation_condition '&&' compilation_condition TODO: conflicting operator
// | compilation_condition '||' compilation_condition
 ;

platform_condition
 : 'os' '(' operating_system ')'
 | 'arch' '(' architecture ')'
// | 'swift' '(' '>=' swift_version ')' TODO: Disambiguate with operator
 ;

operating_system : 'macOX' | 'iOS' | 'watchOS' | 'tvOS' ;
architecture : 'i386' | 'x86_64' | 'arm' | 'arm64' ;
swift_version : Decimal_literal  '.' Decimal_literal ;

// GRAMMAR OF A LINE CONTROL STATEMENT
//
//line_control_statement
// : '#sourceLocation' '(' 'file:' file_name ',' 'line:' line_number ')' TODO: line could be arg name
// | '#sourceLocation' '(' ')'
// ;
//
//line_number : Decimal_literal ;
//file_name : Static_string_literal ;

// GRAMMAR OF AN AVAILABILITY CONDITION

availability_condition : '#available' '(' availability_arguments ')' ;

availability_arguments : availability_argument (',' availability_argument)* ;

availability_argument : Platform | '*' ;

Platform : Platform_name WS? Platform_version ;

fragment
Platform_name
 : 'iOS' | 'iOSApplicationExtension'
 | 'macOS' | 'macOSApplicationExtension'
 | 'watchOS'
 | 'tvOS'
 ;

fragment
Platform_version
 : Decimal_digit+
 | Decimal_digit+ '.' Decimal_digit+
 | Decimal_digit+ '.' Decimal_digit+ '.' Decimal_digit+
 ;

// Generic Parameters and Arguments

// GRAMMAR OF A GENERIC PARAMETER CLAUSE

generic_parameter_clause : '<' generic_parameter_list '>' ;
generic_parameter_list : generic_parameter (',' generic_parameter)* ;
generic_parameter
 : type_name
 | type_name ':' type_identifier
 | type_name ':' protocol_composition_type
 ;

generic_where_clause : 'where' requirement_list ;
requirement_list : requirement | requirement ',' requirement_list ;
requirement : conformance_requirement | same_type_requirement ;

conformance_requirement
 : type_identifier ':' type_identifier
 | type_identifier ':' protocol_composition_type
 ;
same_type_requirement : type_identifier same_type_equals type ;

// GRAMMAR OF A GENERIC ARGUMENT CLAUSE

generic_argument_clause : '<' generic_argument_list '>' ;
generic_argument_list : generic_argument (',' generic_argument)* ;
generic_argument : type ;

// context-sensitive. Allow < as pre, post, or binary op
//lt : {_input.LT(1).getText().equals("<")}? operator ;
//gt : {_input.LT(1).getText().equals(">")}? operator ;
// Declarations

// GRAMMAR OF A DECLARATION

declaration
 : import_declaration
 | constant_declaration
 | variable_declaration
 | typealias_declaration
 | function_declaration
 | enum_declaration
 | struct_declaration
 | class_declaration
 | protocol_declaration
 | initializer_declaration
 | deinitializer_declaration
 | extension_declaration
 | subscript_declaration
 | operator_declaration
 | precedence_group_declaration
 ;

declarations : declaration+ ;


// GRAMMAR OF A TOP-LEVEL DECLARATION

// top_level_declaration : statements? ; entrance moved to top.

// GRAMMAR OF A CODE BLOCK

code_block : '{' statements? '}' ;

// GRAMMAR OF AN IMPORT DECLARATION

import_declaration : attributes? 'import' import_kind? import_path  ;
import_kind : 'typealias' | 'struct' | 'class' | 'enum' | 'protocol' | 'var' | 'func'  ;
import_path : import_path_identifier | import_path_identifier '.' import_path  ;
import_path_identifier : identifier | operator  ;

// GRAMMAR OF A CONSTANT DECLARATION

constant_declaration : attributes? declaration_modifiers? 'let' pattern_initializer_list  ;
pattern_initializer_list : pattern_initializer (',' pattern_initializer)* ;

/** rule is ambiguous. can match "var x = 1" with x as identifier_pattern
 *  OR with x as expression_pattern.
 *  ANTLR resolves in favor or first choice: x is identifier_pattern,
 *  1 is initializer.
 */
pattern_initializer : pattern initializer? ;
initializer : assignment_operator expression ;

// GRAMMAR OF A VARIABLE DECLARATION

variable_declaration
 : variable_declaration_head pattern_initializer_list
 | variable_declaration_head variable_name type_annotation code_block
 | variable_declaration_head variable_name type_annotation getter_setter_block
 | variable_declaration_head variable_name type_annotation getter_setter_keyword_block
 | variable_declaration_head variable_name type_annotation initializer? willSet_didSet_block
 | variable_declaration_head variable_name type_annotation type_annotation initializer? willSet_didSet_block
 ;

variable_declaration_head : attributes? declaration_modifiers? 'var'  ;
variable_name : identifier  ;

getter_setter_block
 : code_block
 | '{' getter_clause setter_clause?'}'
 | '{' setter_clause getter_clause '}'
 ;
getter_clause : attributes? mutation_modifier? 'get' code_block  ;
setter_clause : attributes? mutation_modifier? 'set' setter_name? code_block  ;
setter_name : '(' identifier ')'  ;

getter_setter_keyword_block : '{' getter_keyword_clause setter_keyword_clause?'}' | '{' setter_keyword_clause getter_keyword_clause '}'  ;
getter_keyword_clause : attributes? mutation_modifier? 'get'  ;
setter_keyword_clause : attributes? mutation_modifier? 'set'  ;

willSet_didSet_block
 : '{' willSet_clause didSet_clause?'}'
 | '{' didSet_clause willSet_clause '}'
 ;
willSet_clause : attributes? 'willSet' setter_name? code_block  ;
didSet_clause : attributes? 'didSet' setter_name? code_block  ;

// GRAMMAR OF A TYPE ALIAS DECLARATION

typealias_declaration : attributes? access_level_modifier? 'typealias' typealias_name generic_parameter_clause? typealias_assignment ;
typealias_name : identifier  ;
typealias_assignment : assignment_operator type  ;

// GRAMMAR OF A FUNCTION DECLARATION
function_declaration
 : function_head function_name generic_parameter_clause? function_signature generic_where_clause? function_body? ;

function_head : attributes? declaration_modifiers? 'func'  ;
function_name : identifier |  operator  ;
function_signature
 : parameter_clause 'throws'? function_result?
 | parameter_clause 'rethrows' function_result?
 ;
function_result : arrow_operator attributes? type  ;
function_body : code_block  ;
parameter_clause : '(' ')' |  '(' parameter_list ')'  ;
parameter_list : parameter (',' parameter)*  ;
parameter : external_parameter_name? local_parameter_name type_annotation? variadic_parameter_notation? default_argument_clause? ;
external_parameter_name : identifier ;
local_parameter_name : identifier ;
default_argument_clause : assignment_operator expression  ;

// GRAMMAR OF AN ENUMERATION DECLARATION

enum_declaration
 : attributes? access_level_modifier? union_style_enum
 | attributes? access_level_modifier? raw_value_style_enum
 ;
union_style_enum : 'indirect'? 'enum' enum_name generic_parameter_clause? type_inheritance_clause? generic_where_clause? '{' union_style_enum_members?'}' ;
union_style_enum_members : union_style_enum_member union_style_enum_members? ;
union_style_enum_member : declaration | union_style_enum_case_clause | compiler_control_statement ;
union_style_enum_case_clause : attributes? 'indirect'? 'case' union_style_enum_case_list  ;
union_style_enum_case_list : union_style_enum_case | union_style_enum_case ',' union_style_enum_case_list  ;
union_style_enum_case : enum_case_name tuple_type? ;
enum_name : identifier  ;
enum_case_name : identifier  ;
raw_value_style_enum : 'enum' enum_name generic_parameter_clause? type_inheritance_clause generic_where_clause? '{' raw_value_style_enum_members '}' ;
raw_value_style_enum_members : raw_value_style_enum_member raw_value_style_enum_members? ;
raw_value_style_enum_member : declaration | raw_value_style_enum_case_clause | compiler_control_statement ;
raw_value_style_enum_case_clause : attributes? 'case' raw_value_style_enum_case_list ;
raw_value_style_enum_case_list : raw_value_style_enum_case | raw_value_style_enum_case ',' raw_value_style_enum_case_list  ;
raw_value_style_enum_case : enum_case_name raw_value_assignment? ;
raw_value_assignment : assignment_operator raw_value_literal  ;
raw_value_literal : numeric_literal | Static_string_literal | boolean_literal ;

// GRAMMAR OF A STRUCTURE DECLARATION

struct_declaration : attributes? access_level_modifier? 'struct' struct_name generic_parameter_clause? type_inheritance_clause? generic_where_clause? struct_body  ;
struct_name : identifier ;
struct_body : '{' struct_members? '}' ;

struct_members : struct_member struct_members? ;
struct_member : declaration | compiler_control_statement ;

// GRAMMAR OF A CLASS DECLARATION

class_declaration
 : attributes? access_level_modifier? 'final'? 'class' class_name
   generic_parameter_clause? type_inheritance_clause? generic_where_clause? class_body
 | attributes? 'final' access_level_modifier? 'class' class_name
   generic_parameter_clause? type_inheritance_clause? generic_where_clause? class_body
 ;
class_name : identifier ;
class_body : '{' class_members? '}' ;

class_members : class_member class_members? ;
class_member: declaration | compiler_control_statement ;

// GRAMMAR OF A PROTOCOL DECLARATION

protocol_declaration : attributes? access_level_modifier? 'protocol' protocol_name type_inheritance_clause? protocol_body ;
protocol_name : identifier ;
protocol_body : '{' protocol_members? '}' ;

protocol_members : protocol_member protocol_members? ;

protocol_member
 : protocol_property_declaration
 | protocol_method_declaration
 | protocol_initializer_declaration
 | protocol_subscript_declaration
 | protocol_associated_type_declaration
 | typealias_declaration
 ;

// GRAMMAR OF A PROTOCOL PROPERTY DECLARATION

protocol_property_declaration : variable_declaration_head variable_name type_annotation getter_setter_keyword_block ;

// GRAMMAR OF A PROTOCOL METHOD DECLARATION

protocol_method_declaration : function_head function_name generic_parameter_clause? function_signature generic_where_clause? ;

// GRAMMAR OF A PROTOCOL INITIALIZER DECLARATION

protocol_initializer_declaration
 : initializer_head generic_parameter_clause? parameter_clause 'throws'? generic_where_clause?
 | initializer_head generic_parameter_clause? parameter_clause 'rethrows' generic_where_clause?
 ;

// GRAMMAR OF A PROTOCOL SUBSCRIPT DECLARATION

protocol_subscript_declaration : subscript_head subscript_result getter_setter_keyword_block ;

// GRAMMAR OF A PROTOCOL ASSOCIATED TYPE DECLARATION

protocol_associated_type_declaration : attributes? access_level_modifier? 'associatedtype' typealias_name type_inheritance_clause? typealias_assignment? ;

// GRAMMAR OF AN INITIALIZER DECLARATION

initializer_declaration
 : initializer_head generic_parameter_clause? parameter_clause 'throws'? initializer_body
 | initializer_head generic_parameter_clause? parameter_clause 'rethrows' initializer_body
 ;

initializer_head
 : attributes? declaration_modifiers? 'init'
 | attributes? declaration_modifiers? 'init' '?'
 | attributes? declaration_modifiers? 'init' '!'
 ;

initializer_body : code_block ;

// GRAMMAR OF A DEINITIALIZER DECLARATION

deinitializer_declaration : attributes? 'deinit' code_block  ;

// GRAMMAR OF AN EXTENSION DECLARATION

extension_declaration
 : attribute? access_level_modifier? 'extension' type_identifier type_inheritance_clause? extension_body
 | attribute? access_level_modifier? 'extension' type_identifier generic_where_clause extension_body
 ;
extension_body : '{' extension_members? '}' ;

extension_members : extension_member+ ;
extension_member : declaration | compiler_control_statement ;

// GRAMMAR OF A SUBSCRIPT DECLARATION

subscript_declaration
 : subscript_head subscript_result code_block
 | subscript_head subscript_result getter_setter_block
 | subscript_head subscript_result getter_setter_keyword_block
 ;

subscript_head : attributes? declaration_modifiers? 'subscript' parameter_clause ;
subscript_result : arrow_operator attributes? type ;

// GRAMMAR OF AN OPERATOR DECLARATION

operator_declaration : prefix_operator_declaration | postfix_operator_declaration | infix_operator_declaration  ;

prefix_operator_declaration : 'prefix' 'operator' operator ;
postfix_operator_declaration : 'postfix' 'operator' operator ;
infix_operator_declaration : 'infix' 'operator' operator infix_operator_group? ;

infix_operator_group : precedence_group_name ;

// GRAMMAR OF A PRECEDENCE GROUP DECLARATION

precedence_group_declaration : 'precedencegroup' precedence_group_name '{' precedence_group_attributes? '}' ;

precedence_group_attributes : precedence_group_attribute precedence_group_attributes? ;
precedence_group_attribute
 : precedence_group_relation
 | precedence_group_assignment
 | precedence_group_associativity
 ;

precedence_group_relation
 : 'higherThan' ':' precedence_group_names
 | 'lowerThan' ':' precedence_group_names
 ;

precedence_group_assignment : 'assignment' ':' boolean_literal ;

precedence_group_associativity
 : 'associativity' ':' 'left'
 | 'associativity' ':' 'right'
 | 'associativity' ':' 'none'
 ;

precedence_group_names : precedence_group_name | precedence_group_name ',' precedence_group_names ;
precedence_group_name : identifier ;

// GRAMMAR OF A DECLARATION MODIFIER

declaration_modifier
 : 'class' | 'convenience' | 'dynamic' | 'final' | 'infix' | 'lazy' | 'optional' | 'override' | 'postfix' | 'prefix' | 'required' | 'static' | 'unowned' | 'unowned' '(' 'safe' ')' | 'unowned' '(' 'unsafe' ')' | 'weak'
 | access_level_modifier
 | mutation_modifier
 ;
declaration_modifiers : declaration_modifier declaration_modifiers? ;

access_level_modifier
 : 'internal' | 'internal' '(' 'set' ')'
 | 'private' | 'private' '(' 'set' ')'
 | 'fileprivate' | 'fileprivate' '(' 'set' ')'
 | 'public' | 'public' '(' 'set' ')'
 | 'open' | 'open' '(' 'set' ')'
 ;

mutation_modifier
 : 'mutating'
 | 'nonmutating'
 ;

// Patterns

// GRAMMAR OF A PATTERN

pattern
 : wildcard_pattern type_annotation?
 | identifier_pattern type_annotation?
 | value_binding_pattern
 | tuple_pattern type_annotation?
 | enum_case_pattern
 | optional_pattern
 | 'is' type
 | pattern 'as' type
 | expression_pattern
 ;

// GRAMMAR OF A WILDCARD PATTERN

wildcard_pattern : '_'  ;

// GRAMMAR OF AN IDENTIFIER PATTERN

identifier_pattern : identifier ;

// GRAMMAR OF A VALUE_BINDING PATTERN

value_binding_pattern : 'var' pattern | 'let' pattern  ;

// GRAMMAR OF A TUPLE PATTERN

tuple_pattern : '(' tuple_pattern_element_list? ')'  ;
tuple_pattern_element_list :	tuple_pattern_element (',' tuple_pattern_element)* ;
tuple_pattern_element : pattern | identifier ':' pattern ;

// GRAMMAR OF AN ENUMERATION CASE PATTERN

enum_case_pattern : type_identifier '.' enum_case_name tuple_pattern? ;

// GRAMMAR OF AN OPTIONAL PATTERN

optional_pattern : identifier_pattern '?' ;

// GRAMMAR OF A TYPE CASTING PATTERN

// integrated directly into pattern to avoid indirect left-recursion

// GRAMMAR OF AN EXPRESSION PATTERN

/** Doc says "Expression patterns appear only in switch statement case labels." */
expression_pattern : expression  ;

// Attributes

// GRAMMAR OF AN ATTRIBUTE

attribute : '@' attribute_name attribute_argument_clause? ;
attribute_name : identifier  ;
attribute_argument_clause : '('  balanced_tokens?  ')'  ;
attributes : attribute+ ;

balanced_tokens : balanced_token+ ;
balanced_token
 : '('  balanced_tokens? ')'
 | '[' balanced_tokens? ']'
 | '{' balanced_tokens? '}'
 | identifier | context_sensitive_keyword | literal | operator
 // TODO: | Any punctuation except ( ,  ')' , '[' , ']' , { , or }
 ;

// Expressions

// GRAMMAR OF AN EXPRESSION
expression : try_operator? prefix_expression binary_expressions? ;

expression_list : expression (',' expression)* ;

// GRAMMAR OF A PREFIX EXPRESSION

prefix_expression
  : prefix_operator postfix_expression
  | postfix_expression
  | in_out_expression
  ;

in_out_expression : '&' identifier ;

// GRAMMAR OF A TRY EXPRESSION

try_operator : 'try' '?' | 'try' '!' | 'try' ;

// GRAMMAR OF A BINARY EXPRESSION

binary_expression
  : binary_operator prefix_expression
// as far as I can tell, assignment is not a valid operator as it has no return type
// it is more properly a statement; commenting this next line out and moving to assignment_statement:
  | assignment_operator try_operator? prefix_expression
  | conditional_operator try_operator? prefix_expression
  | type_casting_operator
  ;

binary_expressions : binary_expression+ ;

// GRAMMAR OF A CONDITIONAL OPERATOR

conditional_operator : '?' try_operator? expression ':' ;

// GRAMMAR OF A TYPE_CASTING OPERATOR

type_casting_operator
  : 'is' type
  | 'as' type
  | 'as' '?' type
  | 'as' '!' type
  ;

// GRAMMAR OF A PRIMARY EXPRESSION

primary_expression
 : identifier generic_argument_clause?
 | literal_expression
 | self_expression
 | superclass_expression
 | closure_expression
 | parenthesized_expression
 | tuple_expression
 | implicit_member_expression
 | wildcard_expression
 | selector_expression
 | key_path_expression
 ;

implicit_member_expression : '.' identifier ;

// GRAMMAR OF A LITERAL EXPRESSION

literal_expression
 : literal
 | array_literal
 | dictionary_literal
 | playground_literal
 | '#file' | '#line' | '#cloumn' | '#function'
 ;

array_literal			 : '[' array_literal_items? ']'  ;
array_literal_items      : array_literal_item (',' array_literal_item)* ','?  ;
array_literal_item       : expression ;
dictionary_literal		 : '[' dictionary_literal_items ']' | '[' ':' ']'  ;
dictionary_literal_items : dictionary_literal_item (',' dictionary_literal_item)* ','? ;
dictionary_literal_item  : expression ':' expression  ;
playground_literal
  : '#colorLiteral' '(' 'red' ':'  expression ',' 'green' ':' expression ',' 'blue' ':' expression ',' 'alpha' ':' expression ')'
  | '#fileLiteral' '(' 'resourceName' ':' expression ')'
  | '#imageLiteral' '(' 'resourceName' ':' expression ')'
  ;


// GRAMMAR OF A SELF EXPRESSION

self_expression
 : 'self'
 | 'self' '.' identifier
 | 'self' '[' expression_list ']'
 | 'self' '.' 'init'
 ;

// GRAMMAR OF A SUPERCLASS EXPRESSION

superclass_expression
  : superclass_method_expression
  | superclass_subscript_expression
  | superclass_initializer_expression
  ;

superclass_method_expression	  : 'super' '.' identifier  ;
superclass_subscript_expression   : 'super' '[' expression_list ']'  ;
superclass_initializer_expression : 'super' '.' 'init'  ;

// GRAMMAR OF A CLOSURE EXPRESSION

closure_expression : '{' closure_signature? statements? '}'  ;
closure_signature
 : capture_list? closure_parameter_clause 'throws'? function_result? 'in'
 | capture_list 'in'
 ;

closure_parameter_clause
 : '(' ')'
 | '(' closure_parameter_list ')'
 | identifier_list
 ;

closure_parameter_list : closure_parameter (',' closure_parameter)* ;

closure_parameter
 : closure_parameter_name type_annotation?
 | closure_parameter_name type_annotation variadic_parameter_notation
 ;

closure_parameter_name : identifier;

capture_list : '[' capture_list_items ']'  ;
capture_list_items : capture_list_item (',' capture_list_item)* ;
capture_list_item : capture_specifier? expression ;

capture_specifier : 'weak' | 'unowned' | 'unowned(safe)' | 'unowned(unsafe)'  ;

// GRAMMAR OF A PARENTHESIZED EXPRESSION

parenthesized_expression : '(' expression ')'  ;

// GRAMMAR OF A TUPLE EXPRESSION

tuple_expression
 : '(' ')'
 | '(' tuple_element ',' tuple_element_list ')'
 ;

tuple_element_list : tuple_element (',' tuple_element)* ;

tuple_element : expression | identifier ':' expression ;

// GRAMMAR OF A WILDCARD EXPRESSION

wildcard_expression : '_'  ;

// GRAMMAR OF A SELECTOR EXPRESSION

selector_expression
 : '#selector' '(' expression ')'
 | '#selector' '(' 'getter:' expression ')'
 | '#selector' '(' 'setter:' expression ')'
 ;

// GRAMMAR OF A KEY-PATH EXPRESSION

key_path_expression : '#keyPath' '(' expression ')' ;

// GRAMMAR OF A POSTFIX EXPRESSION (inlined many rules from spec to avoid indirect left-recursion)

postfix_expression
 : primary_expression                                                   # primary
 | postfix_expression postfix_operator                                  # postfix_operation
 | postfix_expression function_call_argument_clause                     # function_call_expression
 | postfix_expression function_call_argument_clause? trailing_closure   # function_call_with_closure_expression
 | postfix_expression '.' 'init'                                        # initializer_expression
 | postfix_expression '.' 'init' '(' argument_names ')'                 # initializer_expression_with_args
 | postfix_expression '.' Decimal_literal                               # explicit_member_expression1
 | postfix_expression '.' identifier generic_argument_clause?           # explicit_member_expression2
 | postfix_expression '.' identifier '(' argument_names ')'             # explicit_member_expression3
 | postfix_expression '.' 'self'                                        # postfix_self_expression
// | 'type' '(' 'of' ':' expression ')'                                   # dynamic_type_expression TODO: parameter name conflict
 | postfix_expression '[' expression_list ']'                           # subscript_expression
// ! is a postfix operator already
// | postfix_expression '!'                                             # forced_value_expression
// ? is a postfix operator already
// | postfix_expression '?'                                             # optional_chaining_expression
 ;

function_call_argument_clause : '(' ')' | '(' function_call_argument_list ')' ;
function_call_argument_list : function_call_argument (',' function_call_argument)* ;
function_call_argument
 : expression
 | identifier ':' expression
 | operator
 | identifier ':' operator
 ;

argument_names : argument_name argument_names? ;

argument_name : identifier ':' ;

trailing_closure : closure_expression ;

// GRAMMAR OF A TYPE

// Not using child grammar because of Antlr can handle direct left-recursion.
type
 : '[' type ']'
 | '[' type ':' type ']'
 | type 'throws'? arrow_operator type
 | type 'rethrows' arrow_operator type
 | type_identifier
 | tuple_type
 | type '?'
 | type '!'
 | protocol_composition_type
 | type '.' 'Type'
 | type '.' 'Protocol'
 | 'Any'
 | 'Self'
 ;

// GRAMMAR OF A TYPE ANNOTATION

type_annotation : ':' attributes? 'inout'? type  ;

// GRAMMAR OF A TYPE IDENTIFIER

type_identifier
 : type_name generic_argument_clause?
 | type_name generic_argument_clause? '.' type_identifier
 ;

type_name : identifier ;

// GRAMMAR OF A TUPLE TYPE

tuple_type : '(' tuple_type_element_list? ')' ;
tuple_type_element_list : tuple_type_element | tuple_type_element ',' tuple_type_element_list ;
tuple_type_element : type | element_name type_annotation ;
element_name : identifier ;

// GRAMMAR OF A FUNCTION TYPE

//function_type
// : type 'throws'? arrow_operator type
// | type 'rethrows' arrow_operator type
// ;

// GRAMMAR OF AN ARRAY TYPE
//array_type : '[' type ']' ;

// GRAMMAR OF A DICTIONARY TYPE
//dictionary_type : '[' type ':' type ']' ;

// GRAMMAR OF AN OPTIONAL TYPE
//optional_type : type '?' ;

// GRAMMAR OF AN IMPLICITLY UNWRAPPED OPTIONAL TYPE
//implicitly_unwrapped_optional_type : type '!' ;

// GRAMMAR OF A PROTOCOL COMPOSITION TYPE

protocol_composition_type : 'protocol' '<' protocol_identifier_list? '>'  ;
protocol_identifier_list : protocol_identifier | (',' protocol_identifier)+ ;
protocol_identifier : type_identifier  ;

// GRAMMAR OF A METATYPE TYPE

//metatype_type : type '.' 'Type' | type '.' 'Protocol';

// GRAMMAR OF A TYPE INHERITANCE CLAUSE

type_inheritance_clause
 : ':' class_requirement ',' type_inheritance_list
 | ':' class_requirement
 | ':' type_inheritance_list
 ;

type_inheritance_list
 : type_identifier
 | type_identifier ',' type_inheritance_list
 ;

class_requirement : 'class' ;

// ---------- Lexical Structure -----------

// GRAMMAR OF AN IDENTIFIER

identifier : Identifier | context_sensitive_keyword ;

Identifier
 : Identifier_head Identifier_characters?
 | '`' Identifier_head Identifier_characters? '`'
 | Implicit_parameter_name
 ;

identifier_list : identifier (',' identifier)* ;

fragment Identifier_head
 : [a-zA-Z]
 | '_'
 | '\u00A8' | '\u00AA' | '\u00AD' | '\u00AF' | [\u00B2-\u00B5] | [\u00B7-\u00BA]
 | [\u00BC-\u00BE] | [\u00C0-\u00D6] | [\u00D8-\u00F6] | [\u00F8-\u00FF]
 | [\u0100-\u02FF] | [\u0370-\u167F] | [\u1681-\u180D] | [\u180F-\u1DBF]
 | [\u1E00-\u1FFF]
 | [\u200B-\u200D] | [\u202A-\u202E] | [\u203F-\u2040] | '\u2054' | [\u2060-\u206F]
 | [\u2070-\u20CF] | [\u2100-\u218F] | [\u2460-\u24FF] | [\u2776-\u2793]
 | [\u2C00-\u2DFF] | [\u2E80-\u2FFF]
 | [\u3004-\u3007] | [\u3021-\u302F] | [\u3031-\u303F] | [\u3040-\uD7FF]
 | [\uF900-\uFD3D] | [\uFD40-\uFDCF] | [\uFDF0-\uFE1F] | [\uFE30-\uFE44]
 | [\uFE47-\uFFFD]
 /*
 ANTLR can't handle char > 16bit.
 | [\u10000–\u1FFFD] | [\u20000–\u2FFFD] | [\u30000–\u3FFFD] | [\u40000–\u4FFFD]
 | [\u50000–\u5FFFD] | [\u60000–\u6FFFD] | [\u70000–\u7FFFD] | [\u80000–\u8FFFD]
 | [\u90000–\u9FFFD] | [\uA0000–\uAFFFD] | [\uB0000–\uBFFFD] | [\uC0000–\uCFFFD]
 | [\uD0000–\uDFFFD] | [\uE0000–\uEFFFD]
 */
 ;

fragment Identifier_character
 : [0-9]
 | '$' // dollars sign seems allowed as identifier character although it's not in grammar spec
 | [\u0300-\u036F] | [\u1DC0-\u1DFF] | [\u20D0-\u20FF] | [\uFE20-\uFE2F]
 | Identifier_head
 ;

fragment Identifier_characters : Identifier_character+ ;

context_sensitive_keyword :
 'associativity' | 'convenience' | 'dynamic' | 'didSet' |
 'final' | 'get' | 'infix' | 'indirect' | 'lazy' | 'left' | 'mutating' | 'none' |
 'nonmutating' | 'optional' | 'operator' | 'override' |
 'postfix' | 'precedence' | 'prefix' | 'Protocol' | 'required' | 'right' |
 'set' | 'Type' | 'unowned' | 'unowned' | 'weak' | 'willSet'
 ;

// GRAMMAR OF OPERATORS

/*
From doc on operators:
 The tokens =, ->, //, /*, *\/ [without the escape on \/], .,
 the prefix operators <, &, and ?, the infix
 operator ?, and the postfix operators >, !, and ? are reserved. These tokens
 can’t be overloaded, nor can they be used as custom operators.

 The whitespace around an operator is used to determine whether an operator
 is used as a prefix operator, a postfix operator, or a binary operator.

	* If an operator has whitespace around both sides or around neither
	  side, it is treated as a binary operator. As an example, the +
	  operator in a+b and a + b is treated as a binary operator.

	* If an operator has whitespace on the left side only, it is treated
	  as a prefix unary operator. As an example, the ++ operator in a ++b
	  is treated as a prefix unary operator.

	* If an operator has whitespace on the right side only, it is treated
	  as a postfix unary operator. As an example, the ++ operator in a++ b
	  is treated as a postfix unary operator.

	* If an operator has no whitespace on the left but is followed
	  immediately by a dot (.), it is treated as a postfix unary
	  operator. As an example, the ++ operator in a++.b is treated as a
	  postfix unary operator (a++ .b rather than a ++ .b).

 For the purposes of these rules, the characters (, [, and { before an operator,
 the characters ), ], and } after an operator, and the characters ,, ;, and :
 are also considered whitespace.

 There is one caveat to the rules above. If the ! or ? predefined operator has
 no whitespace on the left, it is treated as a postfix operator, regardless of
 whether it has whitespace on the right. To use the ? as the optional-chaining
 operator, it must not have whitespace on the left. To use it in the ternary
 conditional (? :) operator, it must have whitespace around both sides.

 In certain constructs, operators with a leading < or > may be split
 into two or more tokens. The remainder is treated the same way and may
 be split again. As a result, there is no need to use whitespace to
 disambiguate between the closing > characters in constructs like
 Dictionary<String, Array<Int>>. In this example, the closing >
 characters are not treated as a single token that may then be
 misinterpreted as a bit shift >> operator.
*/

//operator : Binary_operator | Prefix_operator | Postfix_operator ;

/* these following tokens are also a Binary_operator so much come first as special case */

assignment_operator : {SwiftSupport.isBinaryOp(_input)}? '=' ;

DOT    	: '.' ;
LCURLY 	: '{' ;
LPAREN 	: '(' ;
LBRACK 	: '[' ;
RCURLY 	: '}' ;
RPAREN 	: ')' ;
RBRACK 	: ']' ;
COMMA  	: ',' ;
COLON  	: ':' ;
SEMI   	: ';' ;
LT 		: '<' ;
GT 		: '>' ;
UNDERSCORE : '_' ;
BANG 	: '!' ;
QUESTION: '?' ;
AT 		: '@' ;
AND 	: '&' ;
SUB 	: '-' ;
EQUAL 	: '=' ;
OR 		: '|' ;
DIV 	: '/' ;
ADD 	: '+' ;
MUL 	: '*' ;
MOD 	: '%' ;
CARET 	: '^' ;
TILDE 	: '~' ;

/** Need to separate this out from Prefix_operator as it's referenced in numeric_literal
 *  as specifically a negation prefix op.
 */
negate_prefix_operator : {SwiftSupport.isPrefixOp(_input)}? '-';

arrow_operator	: {SwiftSupport.isOperator(_input,"->")}?  '-' '>' ;
same_type_equals: {SwiftSupport.isOperator(_input,"==")}? '=' '=' ;

// Need to differentiate variadic parameter notation with range operator
// when '...' is not a binary operator, it could signify variadic parameters.
variadic_parameter_notation: {!SwiftSupport.isBinaryOp(_input)}? '.' '.' '.' ;

/**
 "If an operator has whitespace around both sides or around neither side,
 it is treated as a binary operator. As an example, the + operator in a+b
  and a + b is treated as a binary operator."
*/
binary_operator : {SwiftSupport.isBinaryOp(_input)}? operator ;

/**
 "If an operator has whitespace on the left side only, it is treated as a
 prefix unary operator. As an example, the ++ operator in a ++b is treated
 as a prefix unary operator."
*/
prefix_operator : {SwiftSupport.isPrefixOp(_input)}? operator ;

/**
 "If an operator has whitespace on the right side only, it is treated as a
 postfix unary operator. As an example, the ++ operator in a++ b is treated
 as a postfix unary operator."

 "If an operator has no whitespace on the left but is followed immediately
 by a dot (.), it is treated as a postfix unary operator. As an example,
 the ++ operator in a++.b is treated as a postfix unary operator (a++ .b
 rather than a ++ .b)."
 */
postfix_operator : {SwiftSupport.isPostfixOp(_input)}? operator ;

operator
  : operator_head     ({_input.get(_input.index()-1).getType()!=WS}? operator_character)*
  | dot_operator_head ({_input.get(_input.index()-1).getType()!=WS}? dot_operator_character)+
  ;

operator_character
  : operator_head
  | Operator_following_character
  ;

operator_head
  : ('/' | '=' | '-' | '+' | '!' | '*' | '%' | '&' | '|' | '<' | '>' | '^' | '~' | '?') // wrapping in (..) makes it a fast set comparison
  | Operator_head_other
  ;

Operator_head_other // valid operator chars not used by Swift itself
  : [\u00A1-\u00A7]
  | [\u00A9\u00AB]
  | [\u00AC\u00AE]
  | [\u00B0-\u00B1\u00B6\u00BB\u00BF\u00D7\u00F7]
  | [\u2016-\u2017\u2020-\u2027]
  | [\u2030-\u203E]
  | [\u2041-\u2053]
  | [\u2055-\u205E]
  | [\u2190-\u23FF]
  | [\u2500-\u2775]
  | [\u2794-\u2BFF]
  | [\u2E00-\u2E7F]
  | [\u3001-\u3003]
  | [\u3008-\u3030]
  ;

Operator_following_character
  : [\u0300–\u036F]
  | [\u1DC0–\u1DFF]
  | [\u20D0–\u20FF]
  | [\uFE00–\uFE0F]
  | [\uFE20–\uFE2F]
  //| [\uE0100–\uE01EF]  ANTLR can't do >16bit char
  ;

dot_operator_head : '.' ;
dot_operator_character : '.' | operator_character ;

Implicit_parameter_name : '$' Decimal_digit+ ;

// GRAMMAR OF A LITERAL

literal : numeric_literal | string_literal | boolean_literal | nil_literal  ;

numeric_literal
 : negate_prefix_operator? integer_literal
 | negate_prefix_operator? Floating_point_literal
 ;

boolean_literal : 'true' | 'false' ;

nil_literal : 'nil' ;

// GRAMMAR OF AN INTEGER LITERAL

integer_literal
 : Binary_literal
 | Octal_literal
 | Decimal_literal
 | Hexadecimal_literal
 ;

Binary_literal : '0b' Binary_digit Binary_literal_characters? ;
fragment Binary_digit : [01] ;
fragment Binary_literal_character : Binary_digit | '_'  ;
fragment Binary_literal_characters : Binary_literal_character+ ;

Octal_literal : '0o' Octal_digit Octal_literal_characters? ;
fragment Octal_digit : [0-7] ;
fragment Octal_literal_character : Octal_digit | '_'  ;
fragment Octal_literal_characters : Octal_literal_character+ ;

Decimal_literal		: Decimal_digit Decimal_literal_characters? ;
fragment Decimal_digit : [0-9] ;
fragment Decimal_literal_character : Decimal_digit | '_'  ;
fragment Decimal_literal_characters : Decimal_literal_character+ ;

Hexadecimal_literal : '0x' Hexadecimal_digit Hexadecimal_literal_characters? ;
fragment Hexadecimal_digit : [0-9a-fA-F] ;
fragment Hexadecimal_literal_character : Hexadecimal_digit | '_'  ;
fragment Hexadecimal_literal_characters : Hexadecimal_literal_character+ ;

// GRAMMAR OF A FLOATING_POINT LITERAL

Floating_point_literal
 : Decimal_literal Decimal_fraction? Decimal_exponent?
 | Hexadecimal_literal Hexadecimal_fraction? Hexadecimal_exponent
 ;
fragment Decimal_fraction : '.' Decimal_literal ;
fragment Decimal_exponent : Floating_point_e Sign? Decimal_literal ;
fragment Hexadecimal_fraction : '.' Hexadecimal_digit Hexadecimal_literal_characters? ;
fragment Hexadecimal_exponent : Floating_point_p Sign? Decimal_literal ;
fragment Floating_point_e : [eE] ;
fragment Floating_point_p : [pP] ;
fragment Sign : [+\-] ;

// GRAMMAR OF A STRING LITERAL

string_literal
  : Static_string_literal
  | Interpolated_string_literal
  ;

Static_string_literal : '"' Quoted_text? '"' ;
fragment Quoted_text : Quoted_text_item+ ;
fragment Quoted_text_item
  : Escaped_character
  | ~["\n\r\\]
  ;

fragment
Escaped_character
  : '\\' [0\\tnr"']
  | '\\x' Hexadecimal_digit Hexadecimal_digit
  | '\\u' '{' Hexadecimal_digit '}'
  | '\\u' '{' Hexadecimal_digit Hexadecimal_digit  '}'
  | '\\u' '{' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit  '}'
  | '\\u' '{' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit '}'
  | '\\u' '{' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit '}'
  | '\\u' '{' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit '}'
  | '\\u' '{' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit '}'
  | '\\u' '{' Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit Hexadecimal_digit '}'
  ;

// TODO: This is a simulation of the original grammar.
Interpolated_string_literal : '"' Interpolated_text_item* '"' ;
fragment
Interpolated_text_item
  : '\\(' (Interpolated_string_literal | Interpolated_text_item)+ ')' // nested strings allowed
  | Quoted_text_item
  ;

WS : [ \n\r\t\u000B\u000C\u0000]+ -> channel(HIDDEN) ;

Block_comment : '/*' (Block_comment|.)*? '*/' -> channel(2) ; // nesting comments allowed

Line_comment : '//' .*? ('\n'|EOF) -> channel(3) ;
