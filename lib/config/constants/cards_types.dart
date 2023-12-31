// Este archivo contiene las definiciones de los palos y los valores de las cartas.

enum Suit {
  spades,
  hearts,
  diamonds,
  clubs,
  none  // Añadido para representar la ausencia de un palo, utilizado para comodines.
}

enum CardValue {
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  ace,
  joker_1, // Añadido para representar el primer comodín.
  joker_2  // Añadido para representar el segundo comodín.
}
