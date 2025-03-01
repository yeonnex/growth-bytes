import collections
import random

Card = collections.namedtuple('Card', ['rank', 'suit'])

class FrenchDeck:
    ranks = [str(n) for n in range(2, 11)] + list("JQKA")
    suits = 'spades diamonds clubs hearts'.split()

    def __init__(self):
        self._cards = [Card(rank, suit) for suit in self.suits for rank in self.ranks]
    def __len__(self):
        return len(self._cards)
    def __getitem__(self, position):
        return self._cards[position]


# 카드 한 장을 표현 해보자
beer_card = Card('7', 'diamonds')

print(beer_card)

# 카드 한 벌을 생성 해보자
deck = FrenchDeck()
print(len(deck))

# 카드 한 벌(deck)에서 임의의 카드를 선택 해보자
print(deck[3])

# 임으의 카드를 골라내보자
random.choice(deck)

