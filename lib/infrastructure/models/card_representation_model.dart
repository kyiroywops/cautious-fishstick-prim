import 'package:piramjuego/config/constants/cards_types.dart';

String getSuitEmoji(Suit suit) {
  switch (suit) {
    case Suit.spades:
      return '♠️';
    case Suit.hearts:
      return '♥️';
    case Suit.diamonds:
      return '♦️';
    case Suit.clubs:
      return '♣️';
    default:
      return ''; // Devuelve una cadena vacía para 'none' o puedes ajustar según tu necesidad
  }
}
String getCardValueText(CardValue value) {
  switch (value) {
    case CardValue.ace:
      return 'A';
    case CardValue.two:
      return '2';
    case CardValue.three:
      return '3';
    case CardValue.four:
      return '4';
    case CardValue.five:
      return '5';
    case CardValue.six:
      return '6';
    case CardValue.seven:
      return '7';
    case CardValue.eight:
      return '8';
    case CardValue.nine:
      return '9';
    case CardValue.ten:
      return '10';
    case CardValue.jack:
      return 'J';
    case CardValue.queen:
      return 'Q';
    case CardValue.king:
      return 'K';
    default:
      return ''; // Para jokers y 'none'
  }
}
