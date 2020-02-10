#where to create seed data to work with and test associations

#create 2 users

jane = User.create(email: "jane.wysoki@gmail.com", username: "janewysoki", password: "1234")
frank = User.create(email: "sinatra@aol.com", username: "franksinatra", password: "password")

#create some books

janes_entry = Book.create(title: "How to be Good", author: "Nick Hornby", comments: "Marvelous writing and witty humor", user_id: 1)
franks_entry = Book.create(title: "One Flew Over the Cuckoo's Nest", author: "Ken Kesey", comments: "Superb writing and imagery. Down with tyrannical overlords, generic living and medicalization!", user_id: 2)

janes_entry.save
franks_entry.save