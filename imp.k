module IMP-SYNTAX
  imports DOMAINS
  imports FLOAT

  // Syntaxe des expressions arithmétiques : entiers, variables, addition, soustraction, division, multiplication, etc.
  syntax AExp ::= Int
                | Id
     		| AExp "+" AExp
		| AExp "-" AExp
		| AExp "*" AExp
		| "Carré" AExp

  syntax FExp ::= Float
		| Id
		| FExp "+." FExp
		| FExp "-." FExp
		| FExp "*." FExp
		| "Carré" FExp
		| "Norme" 

  syntax TExp ::= "< (" PExp "), (" PExp "), (" PExp ") >"

  syntax PExp ::= FExp
		       | Fexp "," Liste_coord

  syntax Exp ::= AExp | FExp | TExp | PExp | Liste_coord

  // Syntaxe des expressions booléennes : booléens, <=, ==, not, and, or, etc.
  syntax  BExp ::= Bool // true et false
		 | BExp "||" BExp
		 | BExp "&&" BExp
		 | "~" BExp
		 | "Rect" TExp

  // Syntaxe des instructions : affectation, if-then-else, while, séquence et bloc.
  syntax Com ::= "(" Com ")" [bracket]
               | "if" BExp "then" Com "else" Com

endmodule

module IMP
  imports IMP-SYNTAX

  // Définition de la configuration
  configuration <k> $PGM:Exp </k> // La variable $PGM sera remplacée par le programme parsé en entrée

  // Définition du type des valeurs
  syntax KResult ::= Com

  // Définition de la sémantique des expressions arithmétiques
  rule I1 + I2 => I1 +Int I2
  rule I1 - I2 => I1 -Int I2
  rule I1 * I2 => I1 *Int I2

  // Définition de la sémantique des expressions flottantes
  rule F1 +. F2 => F1 +Float F2
  rule F1 -. F2 => F1 -Float F2
  rule F1 *. F2 => F1 *Float F2

  // Définition de la sémantique des expressions booléennes

  // Définition de la sémantique des instructions

endmodule
