# Suggested Model Objects

From my observations listening to your questions at office hours, here is a few model objects that can help you get started.

## User Struct

## Artist Struct

```swift
class Author {
    var name: String
}
```

This can be some journal entry made by some arbitrary person (maybe it's not necessarily the Logged in User)

Add whatever properties you need to know about the Artist.  Other suggested properties
* `uuid`
* `userName`

## Journal Entry Struct

```swift
class JournalEntry {
    var author: Author
    var title: String
    var body: String
    var date: NSDate
}
```

Some other properties you might want to add
* `tags`
* `lastEditedDate`

## Journal Log 

```swift
class JournalEntryCollection {
    var entries: [JournalEntry]
}
```

This can be a list of all your journal entries you've ever written
