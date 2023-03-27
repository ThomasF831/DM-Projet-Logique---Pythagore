module IMP-SYNTAX
  imports DOMAINS
  imports FLOAT

  syntax KResult ::= Bool | Int | Float | "(" Int "," Int ")" | "(" Float "," Float ")"

  // Syntaxe des expressions arithmétiques : entiers, variables, addition, soustraction, division, multiplication, etc.

  syntax AExp ::= Int
                | Id
		> "{" AExp "}" [strict]
		> "Carre" AExp [strict]
		| "Distance" PAExp PAExp [function]
     		> AExp "*" AExp [strict]
		> AExp "+" AExp [strict]
		| AExp "-" AExp [strict]

  // Syntaxe des expressions flottantes : entiers, variables, addition, soustraction, division, multiplication, etc.

 syntax FExp ::= Float
		| Id
		> "{{" FExp "}}" [strict]
		| "Distance." PFExp PFExp [function]
		>  "Carre." FExp [strict]
		> FExp "*." FExp [strict]
		| FExp "-." FExp [strict]
		> FExp "+." FExp [strict]

  // Syntaxe des couples d'entiers

  syntax PAExp ::= "(" AExp "," AExp ")" [strict]
		| Id
		> PAExp "+," PAExp [strict]
		| PAExp "-," PAExp [strict]

  // Syntaxe des couples de flottants

  syntax PFExp ::= "(" FExp "," FExp ")" [strict]
		| Id
		| PFExp "+,." PFExp [strict]
		| PFExp "-,." PFExp [strict]

  // Syntaxe des expressions booléennes : booléens, <=, ==, not, and, or, etc.
  syntax  BExp ::= Bool // true et false
		> "{{{" BExp "}}}" [strict]
		| AExp "==" AExp [strict]
		| AExp "=/=" AExp [strict]
		| FExp "==." FExp [strict]
		| FExp "=/=." FExp [strict]
		> BExp "||" BExp [strict(1)]
		| BExp "&&" BExp [strict(1)]
		| "~" BExp [strict]
		| "Pythagore" PAExp PAExp PAExp [function]
		| "Pythagore." PFExp PFExp PFExp [function]

  // Syntaxe des instructions : affectation, if-then-else, while, séquence et bloc.
  syntax Com ::= "(" Com ")" [bracket]
               | "if" BExp "then" Com "else" Com

  syntax Exp ::= AExp | FExp | PAExp | PFExp | BExp

endmodule

module IMP
  imports IMP-SYNTAX

  // Définition de la configuration
  configuration <k> $PGM:Exp </k> // La variable $PGM sera remplacée par le programme parsé en entrée

  // Définition de la sémantique des expressions arithmétiques

  rule { I1 } => I1
  rule I1 + I2 => I1 +Int I2
  rule I1 - I2 => I1 -Int I2
  rule I1 * I2 => I1 *Int I2
  rule Carre I1 => I1 *Int I1
  rule Distance ( P1 , P2 ) ( P3 , P4 ) => Carre { P1 - P3 } + Carre { P2 - P4 }
  rule Pythagore P1 P2 P3 => {{{ { Distance P1 P2 } == { { Distance P1 P3 } + { Distance P2 P3 } } || { Distance P1 P3 } == { { Distance P1 P2 } + { Distance P1 P2 } } }}} || { Distance P2 P3 } == { { Distance P1 P2 } + { Distance P2 P3 } } 

  // Définition de la sémantique des expressions flottantes
  rule {{ F1 }} => F1
  rule F1 +. F2 => F1 +Float F2
  rule F1 -. F2 => F1 -Float F2
  rule F1 *. F2 => F1 *Float F2
  rule Carre. F1 => F1 *Float F1
  rule Distance. ( P1 , P2 ) ( P3 , P4 ) => Carre. {{ P1 -. P3 }} +. Carre. {{ P2 -. P4 }}
  rule Pythagore. P1 P2 P3 => {{{ {{ Distance. P1 P2 }} ==. {{ {{ Distance. P1 P3 }} +. {{ Distance. P2 P3 }} }} || {{ Distance. P1 P3 }} ==. {{ {{ Distance. P1 P2 }} +. {{ Distance. P1 P2 }} }} }}} || {{ Distance. P2 P3 }} ==. {{ {{ Distance. P1 P2 }} +. {{ Distance. P2 P3 }} }} 

  // Définition de la sémantique des expressions vectorielles
  rule ( P1 , P2 ) +, ( P3 , P4 ) => ( P1 + P3 , P2 + P4 )
  rule ( P1 , P2 ) -, ( P3 , P4 ) => ( P1 - P3 , P2 - P4 )
  rule ( P1 , P2 ) +,. ( P3 , P4 ) => ( P1 +. P3 , P2 +. P4 )
  rule ( P1 , P2 ) -,. ( P3 , P4 ) => ( P1 -. P3 , P2 -. P4 )

  // Définition de la sémantique des expressions booléennes
  rule {{{ I1 }}} => I1
  rule I1 == I2 => I1 ==Int I2
  rule I1 =/= I2 => I1 =/=Int I2
  rule F1 ==. F2 => F1 ==Float F2
  rule F1 =/=. F2 => F1 =/=Float F2
  rule true || _ => true
  rule false || B2 => B2
  rule true && B2 => B2
  rule false && _ => false
  rule ~ true => false
  rule ~ false => true


endmodule
