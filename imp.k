m syntax FExp ::= Float
		| Id
		| "NormeCarre." PExp
		| "Distance." PExp PExp
		> FExp "*." FExp [strict]
		> FExp "-." FExp
		> FExp "+." FExp [strict]
		>  "Carre." FExp

  syntax PExp ::= "(" FExp "," FExp ")"
		| Id
		| PExp "+," PExp [prefer]
		| PExp "-," PExp [prefer]

  // Syntaxe des expressions booléennes : booléens, <=, ==, not, and, or, etc.
  syntax  BExp ::= Bool // true et false

  // Syntaxe des instructions : affectation, if-then-else, while, séquence et bloc.
  syntax Com ::= "(" Com ")" [bracket]
               | "if" BExp "then" Com "else" Com

  syntax Exp ::= AExp | FExp | PExp

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
  rule Carre I1 => I1 *Int I1

  // Définition de la sémantique des expressions flottantes
  rule F1 +. F2 => F1 +Float F2
  rule F1 -. F2 => F1 -Float F2
  rule F1 *. F2 => F1 *Float F2
  rule Carre. F1 => F1 *Float F1
  rule Distance. ( P1 , P2 ) ( P3 , P4 ) => Carre. ( P1 -. P3 ) +. Carre. ( P2 -. P4 )

  // Définition de la sémantique des expressions vectorielles
  rule ( P1 , P2 ) +, ( P3 , P4 ) => ( P1 +. P3 , P2 +. P4 )
  rule ( P1 , P2 ) -, ( P3 , P4 ) => ( P1 -. P3 , P2 -. P4 )

  // Définition de la sémantique des expressions booléennes

  // Définition de la sémantique des instructions


rule ( Exp ) => Exp

endmodule
