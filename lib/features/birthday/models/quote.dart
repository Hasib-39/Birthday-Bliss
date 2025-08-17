enum QuoteCategory { romantic, birthday }

class Quote {
  final String text;
  final QuoteCategory category;
  const Quote({required this.text, required this.category});
}
