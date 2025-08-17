import '../../features/birthday/models/quote.dart';

class Quotes {
  static final List<Quote> all = [
    Quote(text: "Happy Birthday, my love. You make every day feel like a celebration.", category: QuoteCategory.romantic),
    Quote(text: "Another year of you is another year of magic. Happy Birthday!", category: QuoteCategory.birthday),
    Quote(text: "Blowing out the candle, making a wish—mine already came true: you.", category: QuoteCategory.romantic),
    Quote(text: "May your day be as sweet as this cake and as warm as your smile.", category: QuoteCategory.birthday),
    Quote(text: "You’re my today and all of my tomorrows. Happy Birthday.", category: QuoteCategory.romantic),
    Quote(text: "To the one who lights up my world—let me blow out your candle with love.", category: QuoteCategory.romantic),
    Quote(text: "Growing older with you is my favorite adventure. Happy Birthday.", category: QuoteCategory.birthday),
    // add hundreds more here easily...
  ];
}
