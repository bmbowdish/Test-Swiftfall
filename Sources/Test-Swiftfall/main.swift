import Swiftfall

struct ScryCounter: CustomStringConvertible{
    let card: Swiftfall.Card
    var counter: Int
    var description: String {
        return ("\(card.description)\n\(card.name!) has been reprinted \(counter) times.")
    }
}

var count = 0 // counter starts at zero.
var namesOfCards: [String:ScryCounter] = [:] // String: The name of the card
var key: String = "" // creates an empty key
do {
    var cardlist = try Swiftfall.getCardList(page: count).data // Gets a list of card from Scryfall
    do {
        while (!(cardlist.isEmpty)) {
            for card in cardlist {
                key = card.name!
                if namesOfCards.keys.contains(key){
                    namesOfCards[key]?.counter += 1
                } else {
                    let val = ScryCounter(card: card,counter: 1)
                    namesOfCards[key] = val
                }
            }
            print("Page count: \(count)")
            
            count += 1
            cardlist = try Swiftfall.getCardList(page: count).data // gets the next cardlist
        }
        
        var cardsSorted = namesOfCards.values.sorted { counter1, counter2 in
            counter1.counter < counter2.counter
        } // this sorts the card from least common to most common.
        
        for _ in 1...6 {
            print("\(cardsSorted.removeLast()) \n")
        }
    } catch {
        print("The last page to succesfully was: \(count - 1). \(error)\n")
    }
} catch {
    print(error)
    print("It seems I couldn't get the first page.")
}



