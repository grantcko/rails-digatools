user = User.create(email: "grant@gmail.com", password: "123123")

Tool.new(
  name: "ChatGPT Inspo Machine",
  note: "this is a machine that gives you AI generated promts for any art piece you want",
  links: ["https://openai.com/blog/chatgpt"],
  user: user,
  internals: ['custom']
)
