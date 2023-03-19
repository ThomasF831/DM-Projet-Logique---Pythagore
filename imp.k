module IMP-SYNTAX
  imports DOMAINS
  imports FLOAT

  // Syntaxe des expressions arithmétiques : entiers, variables, addition, soustraction, division, multiplication, etc.

  syntax AExp ::= Int
                | Id
		| "Distance" PAExp PAExp
     		| AExp "+" AExp
		| AExp "-" AExp
		| AExp "*" AExp
		| "Carré" AExp

  // Syntaxe des expressions flottantes : entiers, variables, addition, soustraction, division, multiplication, etc.

 syntax FExp ::= Float
		| Id
		| "Distance." PFExp PFExp
		> FExp "*." FExp [strict]
		> FExp "-." FExp [strict]
		> FExp "+." FExp [strict]
		>  "Carre." FExp [strict]

  // Syntaxe des couples d'entiers

  syntax PAExp ::= "(" AExp "," AExp ")"
		| Id

  // Syntaxe des couples de flottants

  syntax PFExp ::= "(" FExp "," FExp ")"
		| Id

  // Syntaxe des expressions booléennes : booléens, <=, ==, not, and, or, etc.
  syntax  BExp ::= Bool // true et false
		| AExp == AExp
		| AExp =/= AExp
		| FExp ==. FExp
		| FExp =/=. FExp
		> BExp || BExp [strict]
		| BExp && BExp [strict]
		| ~ BExp [strict]
		| Pythagore PAExp PAExp PAExp
		| Pythagore. PFExp PFExp PFExp

  // Syntaxe des instructions : affectation, if-then-else, while, séquence et bloc.
  syntax Com ::= "(" Com ")" [bracket]
               | "if" BExp "then" Com "else" Com

  syntax Exp ::= AExp | FExp | PAExp | PFExp

endmodule

module IMP
  imports IMP-SYNTAX

  // Définition de la configuration
  configuration <k> $PGM:Exp </k> // La variable $PGM sera remplacée par le programme parsé en entrée

  // Définition de la sémantique des expressions arithmétiques

  rule I1 + I2 => I1 +Int I2
  rule I1 - I2 => I1 -Int I2
  rule I1 * I2 => I1 *Int I2
  rule Carre I1 => I1 *Int I1
  rule Distance ( P1 , P2 ) ( P3 , P4 ) => Carre ( P1 - P3 ) + Carre ( P2 - P4 )

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
  rule I1 == I2 => I1 ==Int I2
  rule I1 =/= I2 => I1 =/=Int I2
  rule F1 ==. F2 => F1 ==Float F2
  rule F1 =/=. F2 => F1 =/=Float F2
  rule true || B2 => true
  rule false || B2 => B2
  rule true && B2 => B2
  rule false && B2 => false
  rule ~ true => false
  rule ~ false => true
  rule Pythagore P1 P2 P2 => ( Distance P1 P2 ) == ( ( Distance P1 P3 ) + ( Distance. P2 P3) ) || ( Distance P2 P3 ) == ( ( Distance P1 P2 ) + ( Distance P1 P3) ) ) || ( Distance P2 P3 ) == ( ( Distance P1 P2 ) + ( Distance P1 P3) ) )
  rule Pythagore. P1 P2 P2 => ( Distance. P1 P2 ) ==. ( ( Distance. P1 P3 ) +. ( Distance. P2 P3) ) || ( Distance. P2 P3 ) ==. ( ( Distance. P1 P2 ) +. ( Distance. P1 P3) ) ) || ( Distance. P2 P3 ) ==. ( ( Distance. P1 P2 ) +. ( Distance. P1 P3) ) )  

  // Définition de la sémantique des instructions

endmodule
