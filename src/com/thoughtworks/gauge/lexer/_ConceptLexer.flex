// Copyright 2015 ThoughtWorks, Inc.

// This file is part of getgauge/Intellij-plugin.

// getgauge/Intellij-plugin is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.

// getgauge/Intellij-plugin is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with getgauge/Intellij-plugin.  If not, see <http://www.gnu.org/licenses/>.

package com.thoughtworks.gauge.lexer;
import com.intellij.lexer.*;
import com.intellij.psi.tree.IElementType;
import static com.thoughtworks.gauge.language.token.ConceptTokenTypes.*;

%%

%{
  public _ConceptLexer() {
    this((java.io.Reader)null);
  }
%}

%public
%class _ConceptLexer
%implements FlexLexer
%function advance
%type IElementType
%unicode
%caseless
%state INSTEP,INARG,INDYNAMIC,INTABLEHEADER,INTABLEBODY,INTABLEBODYROW,INDYNAMICTABLEITEM,INCONCEPTHEADING,INDYNAMICCONCEPTARG,INTABLECELL

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
InputCharacterWithoutIdentifiers = [^\r\n#*|]
WhiteSpace = [ \t\f]
TableIdentifier = [|]
StepIdentifier = [*]
NonWhiteSpaceAndIdentifierCharacter = [^ \r\n\t\f#*|]
ConceptHeadingIdentifier = "#"

%%
<YYINITIAL> {
  {ConceptHeadingIdentifier}    {yybegin(INCONCEPTHEADING);return CONCEPT_HEADING_IDENTIFIER;}
  {StepIdentifier}              {yybegin(INSTEP);return STEP_IDENTIFIER;}
  {TableIdentifier}             {yybegin(INTABLEHEADER);return TABLE_BORDER;}
  {LineTerminator}? {WhiteSpace}* {NonWhiteSpaceAndIdentifierCharacter}+ {WhiteSpace}* ({StepIdentifier} | [##] | {TableIdentifier}) {InputCharacter}* {LineTerminator}? {return COMMENT;}
  {InputCharacterWithoutIdentifiers}+ {LineTerminator}[=]+ {LineTerminator} {yybegin(YYINITIAL);return CONCEPT_HEADING;}
  [^]                           {return COMMENT;}
}

<INCONCEPTHEADING> {
  [^<\"\r\n]*                   {yybegin(INCONCEPTHEADING); return CONCEPT_HEADING;}
  [<]                           {yybegin(INDYNAMICCONCEPTARG); return DYNAMIC_ARG_START;}
  {LineTerminator}?             {yybegin(YYINITIAL); return NEW_LINE;}
}

<INSTEP> {
  [^<\"\r\n]*                   {yybegin(INSTEP); return STEP;}
  [\"]                          {yybegin(INARG); return ARG_START; }
  [<]                           {yybegin(INDYNAMIC); return DYNAMIC_ARG_START;}
  {LineTerminator}?             {yybegin(YYINITIAL); return STEP;}
}

<INARG> {
  (\\\"|[^\"])*                 {return ARG; }
  [\"]                          {yybegin(INSTEP); return ARG_END;}
}

<INDYNAMIC> {
  (\\<|\\>|[^\>])*              {return DYNAMIC_ARG; }
  [>]                           {yybegin(INSTEP); return DYNAMIC_ARG_END;}
}

<INDYNAMICCONCEPTARG> {
  (\\<|\\>|[^\>])*              {return DYNAMIC_ARG; }
  [>]                           {yybegin(INCONCEPTHEADING); return DYNAMIC_ARG_END;}
}

<INDYNAMICTABLEITEM> {
  (\\<|\\>|[^\>|]|[\\\|])            {yybegin(INDYNAMICTABLEITEM); return DYNAMIC_ARG; }
  [>]                                {yybegin(INTABLEBODYROW); return DYNAMIC_ARG_END;}
  {TableIdentifier}                  {yybegin(INTABLEBODYROW); return TABLE_BORDER;}
  {LineTerminator}{WhiteSpace}*      {yybegin(INTABLEBODY);return NEW_LINE;}
}

<INTABLEHEADER> {
    (\\\||[^|\r\n])*                        {yybegin(INTABLEHEADER); return TABLE_HEADER;}
    {TableIdentifier}                       {yybegin(INTABLEHEADER); return TABLE_BORDER;}
    {LineTerminator}{WhiteSpace}*           {yybegin(INTABLEBODY);return NEW_LINE;}
}

<INTABLEBODY> {
    {TableIdentifier}                       {yybegin(INTABLEBODYROW); return TABLE_BORDER;}
    [^]                                     {yypushback(1); yybegin(YYINITIAL);}
}

<INTABLEBODYROW> {
    {WhiteSpace}*                          {yybegin(INTABLEBODYROW); return WHITESPACE;}
    (\\\||[^-<|\r\n])                      {yybegin(INTABLECELL); return TABLE_ROW_VALUE;}
    [-]*                                   {yybegin(INTABLEBODYROW); return TABLE_BORDER;}
    [<]                                    {yybegin(INDYNAMICTABLEITEM); return DYNAMIC_ARG_START;}
    {TableIdentifier}                      {yybegin(INTABLEBODYROW); return TABLE_BORDER;}
    {LineTerminator}{WhiteSpace}*          {yybegin(INTABLEBODY); return NEW_LINE;}
}

<INTABLECELL> {
    (\\\||[^|\r\n])*                {yybegin(INTABLECELL); return TABLE_ROW_VALUE;}
    {TableIdentifier}               {yybegin(INTABLEBODYROW); return TABLE_BORDER;}
    {LineTerminator}{WhiteSpace}*   {yybegin(INTABLEBODY); return NEW_LINE;}
}