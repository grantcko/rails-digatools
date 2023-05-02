puts "Destroying Tools"
Tool.destroy_all
puts "Destroying Users\n\n"
User.destroy_all

grant = User.create!(email: "grant@gmail.com", password: "123123")
taka = User.create!(email: "taka@gmail.com", password: "123123")

puts "created #{User.all.count} Users"

Tool.create!(
  name: "Prompt Generator",
  note: "good key words:
    Nouns that can be used as characters, settings, or objects, such as: astronaut, castle, dragon, guitar, etc.
    Adjectives that can describe the mood, tone, or genre of the story, such as: mysterious, hilarious, romantic, dystopian, etc.
    Verbs that can indicate the action or conflict of the story, such as: escape, discover, betray, transform, etc.
    Adverbs that can modify the verbs or add more detail to the story, such as: suddenly, secretly, reluctantly, magically, etc.",
  user: grant,
  links: ["https://www.plot-generator.org.uk/movie-script/"],
  internals: ['prompt_generator']
)

Tool.create!(
  name: "EQ Checker",
  note: "allows you to upload your audio files and apply eq changes, you can use it to save eq presets fo other computers",
  user: grant,
  internals: ['auto_equalizer']
)
puts "created #{Tool.all.count} Tools"
